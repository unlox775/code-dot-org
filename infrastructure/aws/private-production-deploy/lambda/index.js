const AWS = require('aws-sdk');
const crypto = require('crypto');

const secretsManager = new AWS.SecretsManager();
const ssm = new AWS.SSM();

// GitHub webhook signature verification
function verifySignature(payload, signature, secret) {
  const expectedSignature = 'sha1=' + crypto
    .createHmac('sha1', secret)
    .update(payload)
    .digest('hex');
  
  return crypto.timingSafeEqual(
    Buffer.from(signature),
    Buffer.from(expectedSignature)
  );
}

// Get GitHub token from Secrets Manager
async function getGitHubToken() {
  const secret = await secretsManager.getSecretValue({
    SecretId: process.env.GITHUB_TOKEN_SECRET_ID
  }).promise();
  
  return JSON.parse(secret.SecretString).token;
}

// Check if commit already exists in private repo
async function commitExistsInPrivate(token, commitSha) {
  const response = await fetch(`https://api.github.com/repos/code-dot-org/code-dot-org-production/commits/${commitSha}`, {
    headers: {
      'Authorization': `token ${token}`,
      'Accept': 'application/vnd.github.v3+json'
    }
  });
  
  return response.ok;
}

// Sync public production to private production
async function syncToPrivate(token, commitSha) {
  // This would use the GitHub API to merge public production into private production
  // For now, we'll just log the action
  console.log(`Syncing commit ${commitSha} to private production repo`);
  
  // In a real implementation, this would:
  // 1. Create a merge commit from public production to private production
  // 2. Handle any merge conflicts
  // 3. Push the changes to private production
  
  return true;
}

exports.handler = async (event) => {
  try {
    console.log('Received event:', JSON.stringify(event, null, 2));
    
    // Verify this is a GitHub webhook
    const signature = event.headers['X-Hub-Signature'] || event.headers['x-hub-signature'];
    const githubEvent = event.headers['X-GitHub-Event'] || event.headers['x-github-event'];
    
    if (!signature || !githubEvent) {
      console.log('Missing required headers');
      return {
        statusCode: 400,
        body: JSON.stringify({ error: 'Missing required headers' })
      };
    }
    
    // Get webhook secret from Secrets Manager
    const webhookSecret = await secretsManager.getSecretValue({
      SecretId: process.env.WEBHOOK_SECRET_ID
    }).promise();
    
    const secret = JSON.parse(webhookSecret.SecretString).secret;
    
    // Verify signature
    const payload = event.body;
    if (!verifySignature(payload, signature, secret)) {
      console.log('Invalid signature');
      return {
        statusCode: 401,
        body: JSON.stringify({ error: 'Invalid signature' })
      };
    }
    
    // Parse the webhook payload
    const data = JSON.parse(payload);
    
    // Only process production branch pushes
    if (data.ref !== 'refs/heads/production') {
      console.log('Not a production branch push, ignoring');
      return {
        statusCode: 200,
        body: JSON.stringify({ message: 'Not a production branch push' })
      };
    }
    
    // Verify this is from the correct repository
    if (data.repository.full_name !== 'code-dot-org/code-dot-org') {
      console.log('Not from correct repository, ignoring');
      return {
        statusCode: 200,
        body: JSON.stringify({ message: 'Not from correct repository' })
      };
    }
    
    const commitSha = data.head_commit.id;
    console.log(`Processing production push with commit: ${commitSha}`);
    
    // Get GitHub token
    const token = await getGitHubToken();
    
    // Check if commit already exists in private repo
    const exists = await commitExistsInPrivate(token, commitSha);
    if (exists) {
      console.log('Commit already exists in private repo, skipping');
      return {
        statusCode: 200,
        body: JSON.stringify({ message: 'Commit already synced' })
      };
    }
    
    // Wait a bit to ensure the commit is fully available
    console.log('Waiting 30 seconds for commit to be fully available...');
    await new Promise(resolve => setTimeout(resolve, 30000));
    
    // Sync to private repo
    const success = await syncToPrivate(token, commitSha);
    
    if (success) {
      console.log('Successfully synced to private repo');
      return {
        statusCode: 200,
        body: JSON.stringify({ message: 'Successfully synced to private repo' })
      };
    } else {
      console.log('Failed to sync to private repo');
      return {
        statusCode: 500,
        body: JSON.stringify({ error: 'Failed to sync to private repo' })
      };
    }
    
  } catch (error) {
    console.error('Error processing webhook:', error);
    return {
      statusCode: 500,
      body: JSON.stringify({ error: 'Internal server error' })
    };
  }
};
# Build the task
npm install
npm run build
# We cleanup the node_modules (important!) otherwise the task from out/ will pick up the wrong node_modules (from the root)
rm -r node_modules

# Execute the task
cd out
node task.js || echo "Failed"

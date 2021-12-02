# Cloudflare DDNS for Padavan

The `cloudflare_ddns.sh` is a command-line tool for Cloudflare DDNS (Dynamic Domain Name Server). It is written in the shell and has very few dependencies.

### Usage:
1. Download the shell script then upload it to a folder on your Padavan router, e.g. `/usr/bin`.
2. Give the shell script executable permissions.
```bash
chmod +x /usr/bin/cloudflare_ddns.sh
```
3. Modify the variables in the shell script according to the comments.
4. Run the shell script and view the results.
5. After confirming that it is correct, you can also add it to the crontab for automatic execution.
```bash
# e.g.
# Run every five minutes
*/5 * * * * /usr/bin/cloudflare_ddns.sh > /dev/null 2>&1
```

### Changelog:
1. 2021/12/2 - Optimize the way to obtain execution results.
1. install ArgoCD-notification with `kubectl apply -k .`
2. add your Slack token to `argcd-notifications-secret`:
```yaml
# kubectl edit secrets -n argocd argocd-notifications-secret

...
stringData:
  slack-token: <token>
...
```
3. configure `argocd-notifications-cm` to use token:
```yaml
# kubectl patch cm argocd-notifications-cm -n argocd --type merge -p '{"data": {"service.slack": "{ token: $slack-token }" }}'


apiVersion: v1
kind: ConfigMap
metadata:
  name: argocd-notifications-cm
data:
  service.slack: |
    apiURL: <url>                 # optional URL, e.g. https://example.com/api
    token: $slack-token
    username: <override-username> # optional username
    icon: <override-icon>         # optional icon for the message (supports both emoji and url notation)
```
4. create a subscription for your Slack integration:
```
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  annotations:
    notifications.argoproj.io/subscribe.on-sync-succeeded.slack: <channel_name>
    notifications.argoproj.io/subscribe.on-sync-failed.slack: <channel_name>
    notifications.argoproj.io/subscribe.on-sync-running.slack: <channel_name>
    notifications.argoproj.io/subscribe.on-deployed.slack: <channel_name>
    notifications.argoproj.io/subscribe.on-health-degraded.slack: <channel_name>
```

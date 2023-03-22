
```yaml
# trigger.yaml
apiVersion: triggers.tekton.dev/v1beta1
kind: Trigger
metadata:
  name: trigger # Kustomize here
  namespace: tektonci
...
        - key: "MODULE_PATH"
          expression: "string('backend/dummy')" # Kustomize here
```
> 템플릿이 되는 기본 트리거
> 템플릿이 되는 트리거는 `backend/dummy`를 `MODULE_PATH` 로 두고 있습니다.

  
```yaml
# webhook-listener.yaml
apiVersion: triggers.tekton.dev/v1beta1
kind: EventListener
metadata:
  name: webhook-listener
...
  triggers:
    - triggerRef: trigger
    # Add new triggers
```
> 기본 웹훅 리스너
> 웹훅 리스너의 기본 설정은 상기 dummy trigger만 참조합니다.



클러스터를 `bootstrap/ovelays/default`로 구성했다면,
`MODULE_PATH` 가 `backend/demo`인 **demo-trigger** 가 배포되어 있습니다.  
```bash
$ kubectl describe el -n tektonci | grep "Trigger Ref"
>    Trigger Ref:  trigger
>    Trigger Ref:  demo-trigger
```
> 웹훅 리스너 yaml에는 `demo-trigger`가 없었는데, 어떻게 참조하는 것일까요?


```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
namespace: tektonci
resources:
  - webhook-listener.yaml
patches:
  - target:
      group: triggers.tekton.dev
      version: v1beta1
      kind: EventListener
      name: webhook-listener
    path: listener-patch.json
```


kustomize로 패치가 적용되고 있습니다.   
웹훅 리스너가 `demo-trigger`를 참조할 수 있도록, 
아래의 `listener-patch.json`가 적용됩니다.  


```json
[
  {
    "op": "add",
    "path": "/spec/triggers/-",
    "value": {
      "triggerRef": "demo-trigger"
    }
  }
]
```
> 해당 파일을 편집하여 새로운 트리거도 등록할 수 있습니다.
> 이제 웹훅 리스너는 `backend/dummy`, `backend/demo`에 대한 트리거를 참조합니다!

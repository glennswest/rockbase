oc delete bc rockbase -n gsw
oc delete dc rockbase -n gsw
oc delete po rockbase -n gsw
oc delete svc rockbase -n gsw
oc delete is rockbase -n gsw
oc new-app https://github.com/glennswest/rockbase

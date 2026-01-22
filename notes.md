recommended helm chart

helm/
├── platform/
│   ├── Chart.yaml
│   └── templates/
│       └── gatewayclass.yaml
│
├── app/
│   ├── Chart.yaml
│   ├── env/
│   │   └── dev/values.yaml
│   └── templates/
│       ├── fastapi/
│       └── react-recoil/
│
└── db/
    ├── Chart.yaml
    ├── env/
    │   └── dev/values.yaml
    └── templates/
        └── postgres/

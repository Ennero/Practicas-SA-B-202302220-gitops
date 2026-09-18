# Repositorio GitOps — Práctica 8: Software Avanzado

Este repositorio es la **única fuente de verdad** declarativa para el despliegue del ecosistema de microservicios bancarios sobre Kubernetes (GKE) mediante **ArgoCD**.

## Estructura del Repositorio

```text
.
├── argocd/
│   ├── application-prod.yaml       # Definición de la App en ArgoCD para Producción
│   └── application-staging.yaml    # Definición de la App en ArgoCD para Staging
├── charts/
│   ├── mariadb/                    # Chart de base de datos
│   └── sa-platform/                # Chart principal de microservicios
│       ├── Chart.yaml
│       ├── values.yaml             # Valores base compartidos
│       ├── values-staging.yaml     # Parametrización para Staging
│       ├── values-prod.yaml        # Parametrización para Producción
│       └── templates/
│           ├── analysistemplate.yaml # Puerta de calidad para Argo Rollouts
│           ├── deployments.yaml      # Rollout Canary para Gateway y Deployments backend
│           ├── services.yaml         # Servicios Stable y Canary
│           └── ...
└── secrets/
    ├── sealed-secrets-prod.yaml    # Secretos cifrados para Producción
    └── sealed-secrets-staging.yaml # Secretos cifrados para Staging
```

## Flujo Operativo GitOps
1. El pipeline de CI/CD del repositorio de código compila, ejecuta pruebas, escanea vulnerabilidades (Trivy), firma imágenes (Cosign) y crea un **Pull Request** a este repositorio actualizando las versiones de las imágenes en los archivos de `values`.
2. Al fusionarse el Pull Request en la rama `main`, **ArgoCD** detecta la divergencia y reconcilia el clúster automáticamente (`selfHeal: true`).
3. **Argo Rollouts** ejecuta la entrega progresiva Canary (20% -> Análisis -> 50% -> Análisis -> 100%) validando cada fase contra el `AnalysisTemplate`.

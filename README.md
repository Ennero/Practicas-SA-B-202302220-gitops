# Despliegue bancario con Helm, ArgoCD y Argo Rollouts

Repositorio declarativo de despliegue de una plataforma bancaria: charts Helm, aplicaciones ArgoCD, entrega progresiva y configuración de entornos.

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


## Preparación y validación local

Requiere Helm 3, kubectl y, para desplegar, un clúster con ArgoCD, Argo Rollouts y Sealed Secrets instalados. Los manifiestos no instalan esos controladores. La aplicación bancaria proviene del repositorio [Practicas-SA-B-202302220](https://github.com/Ennero/Practicas-SA-B-202302220).

Desde la raíz, sin aplicar recursos al clúster:

```bash
helm dependency build charts/sa-platform
helm lint charts/sa-platform -f charts/sa-platform/values-staging.yaml
helm template sa-platform charts/sa-platform -f charts/sa-platform/values-staging.yaml > staging-rendered.yaml
```

Revisar imágenes, dominios, namespaces y referencias de secretos en el YAML generado. Los SealedSecrets existentes solo pueden descifrarse con el controlador que conserva la clave correspondiente: para un clúster nuevo, crear y sellar secretos propios. No distribuir esa clave privada en el repositorio.

Después de preparar y revisar un clúster de pruebas, `argocd/application-staging.yaml` define la aplicación staging. Su política automatizada incluye `prune` y `selfHeal`; aplicarla únicamente al entorno previsto. Producción usa un manifiesto independiente.

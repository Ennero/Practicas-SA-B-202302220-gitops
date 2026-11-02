<div align="center">

# ☸️ GitOps Deployment Pipeline & Kubernetes Manifests (SA)

**Configuración de pipelines GitOps con Kubernetes, ArgoCD/Helm y despliegues declarativos automatizados.**

[![Language](https://img.shields.io/badge/Language-YAML,%20Kubernetes,%20Go%20Template-blue?style=for-the-badge)](https://github.com/Ennero/Practicas-SA-B-202302220-gitops)
[![Course](https://img.shields.io/badge/Course-Software%20Avanzado-003366?style=for-the-badge)](https://ingenieria.usac.edu.gt/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](LICENSE)

</div>

---


## 📌 Contexto Académico

Proyecto desarrollado en el marco del curso **Software Avanzado** de la carrera de Ingeniería en Ciencias y Sistemas en la Universidad de San Carlos de Guatemala (USAC).

---

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

---

## 📄 Licencia

Este proyecto está bajo la Licencia **MIT**. Consulta el archivo [LICENSE](LICENSE) para más detalles.

---

## 👨‍💻 Autor

- **Enner Mendizabal** - [@Ennero](https://github.com/Ennero)  
- *Facultad de Ingeniería, Universidad de San Carlos de Guatemala.*

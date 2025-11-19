.PHONY: init

init:
	@echo "🚀 Creating ShopFast production-grade project structure..."

	@mkdir -p app/routers app/models app/schemas app/core app/utils
	@mkdir -p tests/unit tests/integration
	@mkdir -p terraform/modules/eks terraform/modules/vpc terraform/modules/rds terraform/modules/redis
	@mkdir -p helm-chart/templates helm-chart/charts
	@mkdir -p .github/workflows

	@touch app/__init__.py
	@touch app/main.py
	@touch app/database.py
	@touch app/dependencies.py
	@touch app/core/config.py
	@touch app/core/security.py
	@touch app/routers/__init__.py
	@touch app/routers/items.py
	@touch app/routers/users.py
	@touch app/models/__init__.py
	@touch app/schemas/__init__.py

	@touch tests/__init__.py
	@touch tests/conftest.py
	@touch tests/unit/test_main.py

	@touch Dockerfile
	@touch requirements.txt
	@touch pyproject.toml
	@touch .dockerignore
	@touch .gitignore
	@touch README.md

	@touch terraform/main.tf
	@touch terraform/variables.tf
	@touch terraform/outputs.tf
	@touch terraform/backend.tf
	@touch terraform/provider.tf
	@touch terraform/terraform.tfvars.example

	@touch helm-chart/Chart.yaml
	@touch helm-chart/values.yaml
	@touch helm-chart/templates/deployment.yaml
	@touch helm-chart/templates/service.yaml
	@touch helm-chart/templates/ingress.yaml
	@touch helm-chart/templates/_helpers.tpl

	@touch .github/workflows/ci-cd.yml

	@echo "✅ ShopFast folder structure created successfully!"
	@echo "Next: git init && git add . && git commit -m 'feat: initial project structure'"

# Evaluation AI SDK Notebooks

This folder contains hands-on exercises for exploring the [Azure AI Evaluations SDK](https://pypi.org/project/azure-ai-evaluation/). Before getting started on the notebooks, please make sure you have completed the [pre-requisites and setup](#1-setup-ai-project) steps below.

## 1. Setup AI Project

<details>
<summary>🚨 | COMPLETE SETUP BEFORE RUNNING NOTEBOOKS </summary>
<br/>

> By the end of this section, you will have a working Azure AI project (backend) and a configured dev container environment (local development).

**Step 1: Launch Dev Container**

This repository is configured with a `.devcontainer` with all requirements for your development environment. 

1. _Recommended Option_ - Use GitHub Codespaces to launch the dev container in the cloud, with a Visual Studio Code editor in the browser.
1. _Alternative Option_ - Use Docker Desktop to launch the dev container locally, with a Visual Studio Code editor on your desktop.

By the end of this step, you should have a development enviroment with all dependencies pre-installed - and a Visual Studio Code editor open with an active terminal.

**Step 2: Authenticate with Azure**

Let's connect our development environment to our Azure subscription so we can access provisioned resources. 

1. Run this command in the VS Code terminal:

    ```bash
    az login --use-device-code
    ```

1. Follow the instructions in the terminal and complete the authentication flow via the browser. On completion, you should be redirected to the Visual Studio Code editor. You are now authenticated!

**Step 3: Provision Azure AI project**

For this lab, we need an Azure AI Foundry project with the following resources deployed:

1. Azure AI project and hub resources - to manage our generative AI application.
1. Azure OpenAI model deployments - specifically these 3 models:
    1. `gpt-4o` - as our evaluation model 
    1. `gpt-4o-mini` - as our chat model 
    1. `text-embedded-ada-002` - as our embedding model
1. Azure AI search service - to host our product index.

You have two options for provisioning the project - _pick one_:

1. **Deploy [Contoso Chat](https://aka.ms/aitour/contoso-chat)** - this is an AI app template that deploys all the resources needed with a single `azd up` command.
1. **Complete the [RAG Chat Tutorial](https://aka.ms/rag/azure-ai-foundry)** - this is a step-by-step tutorial to deploy resources manually, using the Azure AI Foundry portal.

**Step 4: Populate Search Index**

Your Azure infrastructure is ready. To build the RAG app, we need a search index. Let's create it now in two steps:

1. **Update access roles** - Run this command to give your user identity permissions to update the search resource.

    ```bash
    ./scripts/update-search-roles.sh
    ```
1. **Create search index** - Open the `data/product_info/create-azure-search.ipynb` notebook in the VS Code editor. d
    - Click "Select Kernel" - choose default Python environment
    - Click "Clear All Outputs" - then "Run All" to execute code.
    - This takes a couple of minutes to complete. You now have a `contoso-products` index in your Azure Search service.

**Step 5: Configure Environment Variables**

Our development environment is connected to Azure. To work with the Azure AI project, we need to configure local environment variables.

1. Create a `.env` file and copy this over.
    ```bash
    AZURE_OPENAI_ENDPOINT=
    AZURE_OPENAI_API_KEY=
    AZURE_OPENAI_CHAT_DEPLOYMENT="gpt-4o-mini"
    AZURE_OPENAI_EVAL_DEPLOYMENT="gpt4"
    AZURE_OPENAI_API_VERSION="2025-01-01-preview"

    AZURE_AI_CONNECTION_STRING=
    AZURE_SEARCH_ENDPOINT=

    GITHUB_TOKEN
    ```
1. Update the `OPENAI` environment variable values from the Azure AI project page in Azure AI Foundry portal.
1. Update hte `SEARCH` endpoint from the Azure AI Search resource "Essentials" panel in Azure Portal.

**YOU ARE READY TO RUN NOTEBOOKS**

</details>

---

## 2. Run Notebooks in Order

You must have completed the setup by now.
- [X] You are running in a dev container
- [X] You are logged into Azure
- [X] You have a `.env` file with the required variables set.

**Recommended Approach:**

1. **Open it in VS Code and run it.** 
    - [X] Click "Select Kernel", choose default Python 3 kernel.
    - [X] Click "Clear All Outputs" to clear previous runs
    - [X] Click "Run All Cells" to run the notebook from start to finish.
1. **Review results cell-by-cell** 
    - [X] Read the explainers first
    - [X] Review the code and outputs
1. **Learn more by experimenting** 
    - [X] Try making a change to a code cell - rerun it to see impact
    - [X] Add a markdown cell to explain change & what you learned

## 3. Explore the Notebooks

This repository contains a set of Jupyter notebooks that demonstrate how to use the Azure AI Evaluations SDK. The notebooks are organized in this sequence, to mimic the narrative of a real-world project.

| Seq | Notebook | Description | 
| :-- |:-- | :--|
| 01 | [01-first-evaluate.ipynb](01-first-evaluate.ipynb) | Run _evaluate()_ with built-in evaluator and view results in portal. **Validate setup**. |
| 02 | [02-quality-evaluators.ipynb](02-quality-evaluators.ipynb) | Explore built-in quality evaluators with test prompts. **Think: core QA metrics**.|
| 03 | [03-safety-evaluators.ipynb](03-safety-evaluators.ipynb) | Explore built-in safety evaluators with test prompts. **Think: experimental metrics**.|
| 04 | [04-nlp-evaluators.ipynb](04-nlp-evaluators.ipynb) | Explore built-in NLP evaluators with test prompts. **Think: Mathematical metrics**.|
| 05 | [05-custom-evaluators.ipynb](05-custom-evaluators.ipynb) | Create and use custom evaluators. **Think: Bring your own template or function**|
| 06 | [06-evaluate-data.ipynb](06-evaluate-data.ipynb) | Run composite evaluator on bulk dataset of responses. **Think: Bring your dataset**|
| 07 | [07-simulate-data.ipynb](07-simulate-data.ipynb) | Create test dataset directly from search index. **Think: Contextual test dataset**|
| 08 | [08-select-model.ipynb](08-select-model.ipynb) | Compare GitHub models using evaluate() - and pick one. **Think: Model evaluation** |
| 09 | [09-manual-evaluation.ipynb](09-manual-evaluation.ipynb) | Use manual evaluation to explore and rate models interactively. **Think: Low-Code** |
| 10 | [10-evaluate-target.ipynb](10-evaluate-target.ipynb) | Run composite evaluator on live app endpoint. **Think: evaluate real usage.** |
| | | |

## 4. Explore Azure AI Samples

This repository has a simplified and curated subset of the [official samples](https://github.com/Azure-Samples/azureai-samples/tree/main/scenarios/evaluate) for the Azure AI Evaluations SDK. Once you complete the notebooks in this repo, consider copying over one of those samples and running it, to learn additional features and scenarios.

_Each notebook will showcase some subset of core features from the Azure AI evaluation SDK_. Here is a brief explainer for what each does:

| Feature | Description | 
| ------- | ----------- | 
| adversarial | Shows adversarial evaluation of LLMs |  
| simulator | Simulator generation of test data |
| conversation starter | Simulator generation from conversation | 
| index | Simulator generation from search index| 
| raw text |Simulator generation from input text |
| against model endpoint | Evaluate directly against base model |
| against app| Evaluate directly against deployed app |
| qualitative metrics | Evaluates AI-Assisted quality & safety metrics  | 
| custom metrics | Evaluates AI-Assisted custom metrics |
| qualitative NLP metrics| Evaluates NLP-based quality metrics | 
| | | |
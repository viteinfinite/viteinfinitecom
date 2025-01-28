---
id: 2025-01-28-on-device-inference-challenges
title: '8 On-Device Inference Challenges'
date: 2025-01-28T08:43:43+01:00
layout: post
permalink: /2025/01/on-device-inference-challenges
always_show_full: false
categories:
  - Generative AI
  - Mobile Development
---

One of the trends I find the most exciting these days, is the local inference of LLMs on mobile. That's for sure related to my time as a mobile- (or, rather iOS-) developer. Yet, the domain brings so many compelling technical challenges that it's hard not be fascinated about.

As I wrote in a [previous LinkedIn post](https://www.linkedin.com/posts/simonecivetta_with-traditional-cloud-served-models-apparently-activity-7285196580058529792-MTla?utm_source=share), local inference offers many benefits for AI, especially generative AI, primarily in terms of distributed resource consumption, privacy, and offline usage. However, it is clear that we are still in the very early days, with numerous obstacles to overcome before this becomes a fully viable option.

That said, with the field of generative AI evolving rapidly, this approach—particularly within a vision where intelligent agents play a central role—could quickly become a key technological element.

Today, we will examine the main challenges that developers, researchers, and companies are likely to face when bringing LLM inference to mobile devices. We've identified 8 challenges, which we will dive into right away.

<!--more-->

## 1. **The Fragmentation Challenge**

In 2025, creating mobile applications still means supporting the two dominant ecosystems: Android and iOS. Each platform has its own peculiarities, and solutions that work well on one may fail on the other.

Even within the same system, differences in chips and hardware architectures can pose challenges. For instance, on Android, the diversity of manufacturers leads to variability in processor characteristics across devices.

As with traditional mobile development, ensuring consistency across all systems requires additional effort and testing, especially when porting models or adapting them for platform-specific tools.

Furthermore, not all inference frameworks are compatible with both Android and iOS. The fastest ones, like [MLX](https://github.com/ml-explore/mlx), are specifically designed for Apple Silicon chips to leverage their advantages. Your model may need to be *ported*, potentially introducing discrepancies in behavior or performance. Engineers will therefore need to constantly validate compatibility and performance to avoid these pitfalls.

## 2. **Balancing Quality, Speed, and Model Size**

Technical factors like inference speed, model size, and memory footprint are critical for a satisfying UX and, ultimately, for adoption. Delivering a slow model, forcing users to wait minutes while gigabytes of weights are downloaded, or crashing your app will result in an unusable experience.

Achieving a smaller, faster, and lighter model often involves compressing larger models using techniques like [quantization](https://huggingface.co/docs/optimum/concept_guides/quantization), [pruning](https://en.wikipedia.org/wiki/Pruning_(artificial_neural_network)), or [distillation](https://en.wikipedia.org/wiki/Knowledge_distillation). However, while research is progressing rapidly, these compression techniques can reduce inference quality and precision.

Additionally, as users become more accustomed to LLM chatbot services, they will likely expect your service to support long context windows. This requires advanced compression and memory management techniques, as memory constraints typically limit context windows to around 8k tokens.

It’s essential to weigh each trade-off against your use case to find the right balance between output quality and user experience. This is no simple task.

## 3. **Limited or Nonexistent System APIs**

Building your own solution is currently the only viable option, as OS SDKs lack first-party APIs for using foundational models installed with the OS itself.

For example, on iOS, Apple Intelligence offers limited AI features for your app. While supporting it via App Intents contributes to enhancing the OS's overall intelligence—which is great—it likely won’t meet your needs in terms of specific features.

## 4. **Choosing the Right Inference Engine**

Choosing the right inference engine is a structural decision. However, as the field is still relatively new, no inference engine today guarantees a robust developer base and sufficient feedback to comfortably build your product.

Some engines, like [PyTorch ExecuTorch](https://pytorch.org/executorch-overview), are cross-platform, while others, like MLX, are not but deliver faster execution on Apple chips. Additionally, models are rarely available for all engines, and porting models from one engine to another can lead to differences in behavior.

## 5. **Observability and Control**

Local inference significantly limits developers' ability to monitor models in real time. Unlike server-side inference, which benefits from established observability libraries like LangSmith, local inference offers few ready-made tools, often forcing developers to build their own solutions.

The lack of observability poses a significant risk for your product and users, as LLMs can hallucinate or confabulate without your awareness.

## 6. **Intellectual Property Protection**

Once a model is deployed locally, protecting it becomes a complex task. While solutions like encrypting weights or obfuscating inference code can be considered, these methods remain underexplored.

Without adequate protections, competitors may analyze and replicate your model, significantly reducing your competitive edge. This risk is particularly high in an environment where innovation and intellectual property are crucial assets.

## 7. **Security and Guardrails**

Server-side inference benefits from *guardrails*, mechanisms based on language models that analyze LLM inputs and outputs in real time to detect sensitive information, such as harmful content for users or personal data.

In a local context, implementing guardrails is possible but more challenging, as it requires running additional models in an already resource-constrained environment. This would negatively impact memory and latency, creating a difficult trade-off between performance and security.

## 8. **Tooling**

LangChain, vector databases, and LlamaIndex: server-side inference has a wide range of tools to build complex solutions relatively easily. While some of these tools exist in mobile-compatible versions (e.g., LangChain.swift—last commit 8 months ago), they lack the necessary support to make them truly robust options. Building your own tools, on the other hand, is ambitious, to say the least.

---

Despite the challenges, achieving local LLM inference is far from impossible. [PrivateLLM](https://privatellm.app/en), a third-party app available on the App Store, demonstrates that impressive results can be achieved with small 1B models whose weights do not exceed 500MB, using the [MLC LLM](https://llm.mlc.ai) inference engine. The speed is remarkable, and the quality, while not perfect, is more than sufficient for basic reasoning, summarization, and text-based interactions.

As mentioned in the introduction, the field is evolving rapidly, and we can expect these challenges to be addressed one by one in the coming months.

Even so—or perhaps for this very reason—this domain is incredibly exciting and captivating, unlike many recent technologies.

---

### For Further Exploration:

- [Awesome LLMs on Device](https://github.com/NexaAI/Awesome-LLMs-on-device), a valuable catalog of research papers, models, and on-device inference engines.  
- [Introduction to On-Device AI](https://www.deeplearning.ai/short-courses/introduction-to-on-device-ai/) by DeepLearning.AI, a resource to discover the basics of embedded AI, though not specific to LLMs.  
- [**Grab a coffee with Hymaïa!**](https://www.hymaia.com/pages-contact/contact) Let’s discuss your projects, share ideas, or explore tailored training solutions.
- Our book [🇫🇷 LLM & IA - La voie de la raison](https://www.hymaia.com/blog/llm-ia-generative-la-voie-de-la-raison), covering some of the topics of this post.

---

### Credits

A special thanks to [Lounis](https://www.linkedin.com/in/lounis-ould-bouali-a0a38a112/) and [Yoann](https://www.linkedin.com/in/yoann-benoit/) for their valuable feedback on this post.

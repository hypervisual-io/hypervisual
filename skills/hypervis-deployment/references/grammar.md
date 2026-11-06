# HyperVisual Deployment Grammar

## Declaration

```yaml
ProductionDeployment[deployment]:
  - Internet[external-system]:
      description: "Clients"
  - Cloud[cloud]:
      - AppRegion[region]:
          - AppCluster[cluster]:
              - platform: kubernetes
              - WebNamespace[namespace]:
                  - PublicIngress[ingress]:
                      public: true
  - Internet --> PublicIngress:
      type: routes-to
      protocol: HTTPS
```

## Shared HyperVisual Grammar

All HyperVisual diagrams are YAML. A file contains exactly one top-level mapping key with a bracketed diagram type. The top-level value is a YAML list. Node types use bracket annotations. Edges use `-->`, `<--`, or `<-->`.

## Type-Specific Notes

- Nest physical scope by indenting cloud, region, network, cluster, namespace, workload, pod, and container nodes as list items under their parent.
- Use placement edges (`hosts`, `runs`, `deploys-to`, `contains`, `scheduled-on`) for where things run.
- Use traffic edges (`routes-to`, `calls`, `connects-to`, `exposes`, `forwards-to`) and data edges (`reads-from`, `writes-to`, `publishes-to`, `subscribes-to`) for runtime interaction.
- Mark Kubernetes clusters with `platform: kubernetes`; mark cloud provider with `provider:`.

## Nesting

Nest resources as list items under their parent container nodes. Do not use `children:` (removed in v0.1.0); nest with `-` list items only.

## Labels and Properties

A scalar string after a node colon becomes a node description. A scalar string after an edge colon becomes an edge label. Mapping values become structured properties and should be preferred for detailed diagrams.

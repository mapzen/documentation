# Versioning

When a new version of a Mapzen basemap or icon pack is released, developers should be able to tell from the version increment how much effort it will take them to integrate the new basemap with their map. We use semantic versioning to communicate this.

## What is Semantic Versioning?

Semantic versioning (or [SemVer](http://semver.org/)) is a formalized way of making promises with an X.Y.Z version indicator.

### Version components

- `MAJOR`.`MINOR`.`PATCH`, example: `-0.0`

### Version parts:

- **MAJOR** version **X** for incompatible API changes.
- **MINOR** version **Y** when adding functionality in a backwards-compatible manner, and
- **PATCH** version **Z** when fixing backwards-compatible bugs

### Developer level of effort:

- Major version X: **high** – significant integration challenges, read the changelog closely
- Minor version Y: **low** – some integration challenges, read the changelog
- Bug fixes Z: **none** – simply use the new tiles, skim or ignore the changelog

## Import strategy

**MAJOR versions**

As Mapzen's basemap styles are still in active development we recommend peggging an import to a specific major version, eg: `5`, so you enjoy any minor and patch updates but are ensured of stable named scene elements.

```
import: https://mapzen.com/carto/refill-style-more-labels/5/refill-style-more-labels.yaml
```

**LATEST versions**

We only recommend pegging to the **latest** vesion if you are not modifying documented API scene elements.

```
import: https://mapzen.com/carto/refill-style-more-labels/refill-style-more-labels.yaml
```

**MINOR versions**

We don't recommend pegging to a **minor** vesion.

**PATCH versions**

We don't recommend pegging to a **patch** vesion.


## Promises

### MAJOR version increments:

- **Remove** global `property`
- **Change** global `property` **name** or default value
- **Remove** draw `layer`
- **Change** draw `layer` **name**
- **Remove** draw  `style`
- **Change** draw `style` **name**
- **Remove** `sprite` icon
- **Change** `sprite` icon **name**
- Requires new **major** version of **Tangram** (or minor version if before -0)
- Requires new **major** version of **Mapzen Vector Tiles**
- Requires new **minor** version of **Mapzen Vector Tiles** when recommended map sandwich feature order values change.

### MINOR version increments:

- **Add** global `property`
- **Add** draw `layer`
- **Add** draw `style`
- **Add** `sprite` icon
- **Change** draw `style` default visual appearance
- **Remove** `sprite` icon
- **Change** `sprite` icon **name**
- **Change** `sprite` icon asset
- **Change** to scene elements not documented by API reference
- Requires new **minor** version of **Tangram** (or patch version if before -0)
- Requires new **minor** version of **Mapzen Vector Tiles**

### PATCH version increments

- **Correct** a regression in a documented scene element (to the last good version)
- **Correct** a newly added global `property` **name** or default value
- **Correct** a newly added draw `layer` **name**
- **Correct** a newly added draw `style` **name** or default visual appearance
- **Correct** a newly added `sprite` icon **name** or asset
- Bug fix **change** to scene elements not documented by API reference
- Requires new **patch** version of **Mapzen Vector Tiles**

## See also

- [semver.org](http://semver.org)
- [Tilezen versioning](https://github.com/tilezen/vector-datasource/blob/master/SEMANTIC-VERSIONING.md)
- [Natural Earth versioning](https://github.com/nvkelso/natural-earth-vector/blob/master/README.md)
- [Who's On First](https://github.com/whosonfirst/whosonfirst-placetypes#roles)

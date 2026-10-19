# TypeScript starter style

A small, Google-inspired baseline for new projects, not full enforcement of the
[Google TypeScript style guide](https://google.github.io/styleguide/tsguide.html).
Copy these files into the project and commit them there; they don't depend on a
machine-local dotfiles path.

```sh
cp ~/dotfiles/templates/typescript/.oxlintrc.json .
cp ~/dotfiles/templates/typescript/.oxfmtrc.json .
pnpm add -D --save-exact oxlint@1.88.0 oxfmt@0.72.0
```

These are the versions used to validate this starter. Update them deliberately
and commit the project's lockfile. Use the project's package manager if it isn't
pnpm. Merge with existing configuration rather than overwriting it.

Add scripts to `package.json`:

```json
{
  "scripts": {
    "lint": "oxlint",
    "format": "oxfmt",
    "format:check": "oxfmt --check"
  }
}
```

## What's enforced

- Oxlint correctness rules report errors.
- Prefer `const`; don't use `var`.
- Use strict equality, except `== null` / `!= null` for null-or-undefined checks.
- Require braces around multiline control-flow bodies; single-line bodies are allowed.
- No `eval`, primitive wrapper constructors, or throwing literals instead of errors.
- Use `T[]` for simple array types and `Array<T>` for complex types.
- Prefer interfaces for object type declarations.
- Explicit `any` produces a warning, leaving necessary exceptions visible for review.
- Formatting uses two spaces, single quotes, semicolons, trailing commas, and an
  80-column target. Oxfmt can exceed that target where it cannot wrap a construct.

The guide allows some single-line `if` bodies; the `curly` rule's `multi-line`
option also permits other single-line control-flow bodies, so this is an
approximation. Likewise, formatting choices follow a Prettier-compatible layout,
not Google's formatter byte-for-byte.

Import sorting and package.json sorting are disabled to keep formatting from
also reorganizing code. Default exports are allowed because frameworks often
require them. Naming quality, abstraction choices, documentation, and the rest
of the written guide still need human judgment. This is intentionally not a
complete Google preset.

## Project-specific checks

Keep tsgo for language features and type checking, using the project's own
`tsconfig.json`. This starter doesn't set compiler options or enable Oxlint's
separate type-aware engine. Add framework/test plugins and generated-file ignores
in the consuming project as needed; none are assumed here.

Neovim uses Conform for Oxfmt and nvim-lint for Oxlint on save. Project-local
binaries take precedence where found; Mason provides fallback executables.
Install the pinned tools in each project so the editor and CI use the same
versions. The configs here are templates, not global defaults automatically
applied to every repository.

## Check a new project

Run `pnpm lint` and `pnpm format:check`, plus the project's existing typecheck and
tests. In Neovim, use `:ConformInfo` to confirm Oxfmt and save a temporary TS file
with `var` to confirm an Oxlint diagnostic. Remove the temporary example afterward.

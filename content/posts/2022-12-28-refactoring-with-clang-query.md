---
title: "Refactoring With Clang Query"
date: "2022-12-28"
tags: 
- clang
- programming
---

Have you ever wanted to identify a list of files that would need modifications to adopt a new API?
Clang-Query can make this much easier.
I recently wanted to introduce a set of helper functions to simplfy an aspect of compressor configuation in LibPressio.
But first, I needed to know what modules were effected.

Clang-query needs a compilation database which can be produced by tools such as `bear` (if you have a Autotools or Makefile based project) or more sophisticated build systems such as `cmake`, `meson` or `bazel`.
After we have these, the files are just JSON, so we can produce a list of files that are effected using `jq` and reduce the set considered using the `select` function.

```bash
jq '.[].file | select(test("src/plugins/"))' ./build/compile_commands.json
```

However `clang-query` needs relative paths (This seems like a bug to me, but 🤷) so we can convert them using `| xargs realpath --relative-to .`

```bash
clang-query -p ./build/compile_commands.json $( jq '.[].file | select(test("src/plugins/"))' ./build/compile_commands.json | xargs realpath --relative-to . )
```

Clang-query will then construct a C++ AST for each of the files which we can then query.

I knew that the effected modules would provide a definition of a method called `set_name_impl` and would exist in a certain source directory.  The corresponding match expression is

```cpp
cxxMethodDecl(hasName("set_name_impl"), isExpansionInMainFile())
```

which in turn returns all of the files that should be effected.  However, the method that needs to be actually needs to be modified is `get_configuration_impl` and we want to see if we missed any places that need to be modified, so we can look for the old pattern:

```cpp
set traversal IgnoreUnlessSpelledInSource
set bind-root false
match cxxMethodDecl(hasName("get_configuration_impl"), hasDescendant(cxxMemberCallExpr(hasArgument(0, unless(cxxMemberCallExpr(on(memberExpr())))), hasDeclaration(cxxMethodDecl(hasName("copy_from")))).bind("r")), isExpansionInMainFile())
```

Determing the appropriate matcher can be done iteratively using tab completion, binding, and the `dump` output mode.


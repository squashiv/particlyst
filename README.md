# Particlyst
Particlyst is a addon for for Godot 4.3+, designed as an alternative to the built-in ParticleProcessMaterial. If you find ParticleProcessMaterial lacking for your 3D VFX needs, Particlyst is for you!

https://github.com/user-attachments/assets/0e120f67-febb-4b3e-88d0-42d7c82a67e5

# Features
- Modifier stack based approach for flexibility 
- More emitter shapes with hollowness parameter
- 3D rotation and 3D scale
- Local rotation for particles
- Custom seed support for persistent randomness
- Selectable operations (Add, multiply, power, etc.)

# How to install / use
- Download this repo as zip
- Copy addons folder to your project and enable addon
- Create new ParticlystProcessMaterial3D within your GPUParticles3D > process_material
- Add a modifier

# Caveats
- Early in development / experimental
- 3D, GPUParticles3D, Godot 4.3+ only
- Performance is not the primary focus

# Roadmap
- Collision and sub-emitter support
- Editor undo redo
- Mesh based shape
- Editor (sub?) resource inspector
- Gizmo handles
- Better velocity workflow
- Editor tooltips
- Animatable uniforms (?)

| **Property Types** | **Value Modifiers** | **Shape Modifiers** | **Special Modifiers** | **Operation Types** |
|--------------------|---------------------|---------------------|-----------------------|---------------------|
| Color              | Uniform             | Sphere              | Lifetime              | Multiply            |
| Alpha              | Random              | Box                 | Seed                  | Divide              |
| Position           | Blend               | Cone                | Apply Rotation        | Add                 |
| Rotation           | Texture             | Torus               | TODO Collision        | Subtract            |
| Scale              |                     | Plane               | TODO Sub Emitter      | Power               |
| Velocity           |                     | TODO Mesh           |                       | TODO Min            |
| Custom             |                     |                     |                       | TODO Max            |

# License
This project is licensed under the MIT License. See the LICENSE file for details.

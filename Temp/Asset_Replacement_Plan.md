# 资产替换任务计划 (Asset Replacement Plan)

> 目标：将现有的测试用资产（Assets 根目录下文件）替换为正式资产（Animation 和 Textures 子目录下文件）。

---

## 1. 玩家 (Player)
*   **当前状态**: 使用 `Assets/womanGreen_stand.png` (静态图)。
*   **目标资源**:
    *   待机: `Assets/Animation/bubble_idle(64x64).png`
    *   死亡: `Assets/Animation/bubble_died(64x64).png`
    *   护盾/血量: `Assets/Animation/shield_*.png`
*   **任务步骤**:
    1.  **修改节点**: 在 `Scenes/Player.tscn` 中，将 `Sprite2D` 节点替换为 `AnimatedSprite2D`。
    2.  **制作动画**: 创建新的 `SpriteFrames` 资源。
        *   新建动画 `idle`: 导入 `bubble_idle(64x64).png`，设置网格为 64x64，添加所有帧。
        *   新建动画 `die`: 导入 `bubble_died(64x64).png`。
    3.  **代码适配**: 修改 `Scripts/Player.gd`，在 `_ready` 中播放 `play("idle")`，在死亡逻辑中播放 `play("die")`。
    4.  **护盾表现**: 添加一个子节点 `AnimatedSprite2D` (命名为 `ShieldSprite`)，用于播放 `shield` 相关动画（根据血量层数切换动画状态，或者叠加显示）。

## 2. 敌人 (Enemies)

### 近战敌人 (EnemyMelee)
*   **当前状态**: 使用 `Assets/robot1_stand.png`。
*   **目标资源**:
    *   待机/移动: `Assets/Animation/enemy1_idle(64x64).png`
    *   死亡: `Assets/Animation/enemy1_die(64x64).png`
*   **任务步骤**:
    1.  **修改节点**: 在 `Scenes/EnemyMelee.tscn` 中，将 `Sprite2D` 换为 `AnimatedSprite2D`。
    2.  **制作动画**: 创建 `SpriteFrames`，导入 `enemy1` 相关图片。
    3.  **代码适配**: 确保 `EnemyBase.gd` 或 `EnemyMelee.gd` 在生成时播放动画。

### 远程敌人 (EnemyRanged)
*   **当前状态**: 使用 `Assets/robot1_stand.png`。
*   **目标资源**: *缺失*。目前正式资源中只有 `enemy1`（看起来是近战）。
*   **建议**: 暂时复用近战敌人的素材，或者将颜色调为红色/绿色以示区分（使用 `modulate` 属性）。

## 3. 子弹 (Bullets)
*   **当前状态**: 使用 `Assets/tile_506.png`。
*   **目标资源**: `Assets/Textures/bullet.png`。
*   **任务步骤**:
    1.  打开 `Scenes/BulletPlayer.tscn` 和 `Scenes/BulletEnemy.tscn`。
    2.  将 `Sprite2D` 的 `Texture` 属性替换为 `Assets/Textures/bullet.png`。
    3.  调整碰撞体大小（如果新图尺寸不同）。

## 4. 掉落物 (Drops/Shards)
*   **当前状态**: 使用 `Assets/KenneyAnimatedCoinsV3.png`。
*   **目标资源**: *缺失*。正式目录无对应图片。
*   **建议**: 暂时保留原状，或使用 `Assets/Textures/bubble.png` 的缩小版/变色版代替。

## 5. 背景 (Background)
*   **当前状态**: 使用 `Assets/99700ae5-a2f3-45d2-840c-be6b29a5a9ea.png` (乱码名图片)。
*   **目标资源**: *缺失*。正式目录无背景图。
*   **建议**: 暂时保留原状，或设置一个纯色背景。

---

## 需确认事项
1.  远程敌人是否有独立美术资源？
2.  掉落物（经验球）是否有独立美术资源？
3.  背景是否有新图？

## AI 辅助提示词
如果你需要我协助代码部分的修改（如 Player 动画状态机逻辑），可以使用如下提示词：
> "执行任务 1: 修改 Player.gd 以支持动画播放。"

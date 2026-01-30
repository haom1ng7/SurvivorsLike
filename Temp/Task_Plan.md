# 开发任务分解清单 (Task Breakdown)

> 目标：在半天内快速落实策划需求。
> 策略：优先由 AI 处理纯代码逻辑、数值运算和系统交互；将涉及场景编辑、动画配置、节点连线的工作留给用户手动操作。

---

## 阶段一：核心战斗数值与机制 (AI 优先)
此阶段主要完善代码逻辑，无需复杂的编辑器操作。

### 任务 1.1: 玩家无敌帧与生命层数机制
*   **说明**: 策划要求玩家受伤后有 1 秒无敌，且生命值表现为“层数”（虽然 UI 可能还是条，但逻辑上要支持单次扣血机制）。
*   **状态**: 待执行
*   **AI 提示词**:
    ```text
    修改 Scripts/Player.gd，实现以下功能：
    1. 添加无敌帧逻辑：变量 `is_invincible`，受伤后设置为 true 并开启 1.0 秒计时器，计时结束重置。
    2. 修改 `take_damage`：如果在无敌状态下则不扣血；扣血后立即触发无敌。
    3. 确保生命值扣除逻辑符合“爆一层”的概念（如果策划指的一次掉一血，请确认数值，目前保持 float 即可，但要加无敌判定）。
    ```

### 任务 1.2: 玩家子弹逻辑 (穿透与射程)
*   **说明**: 子弹目前逻辑简单，需要支持“穿透数”(初始1) 和“最大飞行距离/时间”。
*   **状态**: 待执行
*   **AI 提示词**:
    ```text
    修改 Scripts/Bullet.gd (需确认文件名，可能是 BulletPlayer.gd 或共用 Bullet.gd):
    1. 添加 `pierce_count` (int, 默认 1) 和 `max_distance` (float) 属性。
    2. 在 `_physics_process` 或 `_process` 中计算飞行距离，超过 `max_distance` 则 `queue_free()`。
    3. 处理碰撞逻辑：击中敌人后 `pierce_count -= 1`，如果 `pierce_count <= 0` 则销毁子弹，否则继续飞行。
    ```

### 任务 1.3: 子弹互相抵消机制
*   **说明**: 策划要求“敌人子弹和玩家子弹碰撞会消失”。
*   **状态**: 待执行
*   **AI 提示词**:
    ```text
    请编写或修改子弹脚本以实现“子弹抵消”：
    1. 确保玩家子弹和敌人子弹能互相检测到碰撞 (Area2D entered)。
    2. 当 PlayerBullet 碰到 EnemyBullet 时，双方都执行销毁逻辑。
    3. 请在脚本中通过 `class_name` 或组名 (`is_in_group`) 来区分阵营，避免同类子弹互撞消失。
    ```

---

## 阶段二：敌人行为逻辑 (AI 优先)
需要重写部分 AI 逻辑，特别是远程敌人。

### 任务 2.1: 远程敌人 (EnemyRanged) AI
*   **说明**: 远程敌人需“靠近玩家一定距离后停止移动，发射直线子弹”。
*   **状态**: 待执行
*   **AI 提示词**:
    ```text
    重写 Scripts/EnemyRanged.gd：
    1. 继承自 EnemyBase。
    2. 逻辑修改：当与 Target 距离大于 `stop_range` (如 250) 时移动；小于该距离时停止移动。
    3. 添加攻击计时器：停止移动时开始计时，每隔 `attack_interval` 秒实例化一个 `BulletEnemy` 指向玩家方向。
    4. 确保生成的子弹添加到世界节点，而不是作为敌人的子节点（避免随敌人移动）。
    ```

### 任务 2.2: 经验球吸附逻辑
*   **说明**: 经验球（掉落物）静止，进入范围后飞向玩家。
*   **状态**: 待执行
*   **AI 提示词**:
    ```text
    检查并修改经验掉落物脚本 (可能是 Shared.gd 实例化的 Shard 或专门的脚本)：
    1. 增加状态机：`Idle` (静止), `Magnet` (被吸附)。
    2. 在 `_process` 中检测与 Player 的距离。如果小于 `player.pickup_range`，切换到 `Magnet` 状态。
    3. `Magnet` 状态下，使用插值 (`lerp`) 或向玩家移动向量快速飞向玩家，接触后调用 `player.add_exp()` 并销毁自己。
    ```

---

## 阶段三：游戏流程与数值 (AI 优先)

### 任务 3.1: 升级数值配置 (多发子弹/散布)
*   **说明**: 策划提到“单次发射数量”和“角度”。现有的 Relics 系统可能需要扩展。
*   **状态**: 待执行
*   **AI 提示词**:
    ```text
    修改 Scripts/Relics.gd 和 Scripts/Player.gd：
    1. 在 Player 中添加 `projectile_count` (默认 1) 和 `spread_arc` (默认 0，或 15 度)。
    2. 修改 Scripts/Weapon.gd：射击时根据 `projectile_count` 进行循环，根据 `spread_arc` 计算每发子弹的旋转偏移。
    3. 在 Relics.gd 中添加新的升级条目，例如 "Double Shot" (增加发射数量) 或 "Shotgun" (增加数量和散布)。
    ```

### 任务 3.2: 胜负判定逻辑连接
*   **说明**: 确保倒计时结束触发胜利，血量归零触发失败，并弹出对应 UI。
*   **状态**: 待执行
*   **AI 提示词**:
    ```text
    完善 Scripts/Main.gd 和 Scripts/GameState.gd：
    1. 确保 GameState 的倒计时结束信号 `game_over(true)` 连接到 Main 的胜利处理函数。
    2. 确保 Player 的死亡信号 `died` 连接到 Main 的失败处理函数。
    3. 简单的实现：收到信号后，实例化或显示 `DeathMenu` (或者新建一个 WinMenu)，并暂停游戏树 `get_tree().paused = true`。
    ```

---

## 阶段四：场景、动画与碰撞设置 (用户手动操作)
**注意**：这部分工作 AI 难以直接操作编辑器文件 (`.tscn`)，需要你在 Godot 编辑器中手动完成。

### 任务 4.1: 碰撞层 (Collision Layers) 设置
*   **操作**: 在 Project Settings -> Layer Names -> 2D Physics 中定义层：
    *   Layer 1: Player
    *   Layer 2: Enemy
    *   Layer 3: PlayerBullet
    *   Layer 4: EnemyBullet
    *   Layer 5: Drops (经验球)
*   **设置节点**:
    *   **Player 节点**: Layer=1, Mask=2,4,5 (撞敌人、撞敌人子弹、撞掉落物)
    *   **Enemy 节点**: Layer=2, Mask=1,3 (撞玩家、撞玩家子弹)
    *   **PlayerBullet**: Layer=3, Mask=2,4 (撞敌人、**撞敌人子弹**)
    *   **EnemyBullet**: Layer=4, Mask=1,3 (撞玩家、**撞玩家子弹**)
    *   **Drops**: Layer=5, Mask=0 (通常用 Area2D 检测 Layer 1)

### 4.2: 场景组装 (Scene Assembly)
*   **操作**:
    *   创建/编辑 `BulletEnemy.tscn`：确保挂载了 Area2D，且 Collision Mask 设置正确。
    *   编辑 `EnemyRanged.tscn`：确保挂载了 `EnemyRanged.gd` 脚本，并拖入子弹预制体到脚本变量中。
    *   编辑 `Main.tscn`：确保 UI 节点层级覆盖在游戏世界之上。

### 4.3: 动画状态机 (Animation)
*   **操作**:
    *   在 `Player` 和 `Enemy` 的 `AnimatedSprite2D` 中配置 `Run`, `Idle`, `Hurt` 等动画帧。
    *   代码中虽然会调用 `play("run")`，但必须保证编辑器里有这个动画名，否则会报错。

---

## 建议执行顺序
1.  **AI 执行** 任务 1.1 (玩家无敌) & 1.2 (玩家子弹)。
2.  **AI 执行** 任务 2.1 (远程敌人) & 1.3 (子弹抵消，依赖远程敌人子弹存在)。
3.  **用户操作** 任务 4.1 (碰撞层设置) —— **这一点至关重要，否则子弹抵消和伤害判定无法工作。**
4.  **AI 执行** 任务 2.2 (经验球) & 3.1 (多重射击)。
5.  **AI 执行** 任务 3.2 (流程收尾)。
6.  **用户操作** 任务 4.2 & 4.3 (完善画面表现)。

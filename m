From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] updated dm-switch
Date: Wed, 22 May 2013 17:14:18 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1305221709160.22686@file.rdu.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="185242623-490532849-1369257258=:22686"
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Alasdair G. Kergon" <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--185242623-490532849-1369257258=:22686
Content-Type: TEXT/PLAIN; charset=X-UNKNOWN
Content-Transfer-Encoding: QUOTED-PRINTABLE

Hi

This is updated dm-switch. It has better documentation and better error=20
reporting in message function.

It also fixes bugs introduced when someone reworked my original the code.=
=20
The code placed here=20
http://people.redhat.com/agk/patches/linux/editing/dm-add-switch-target.pat=
ch=20
is very buggy - it has argument parsing bugs that prevent it from being=20
loaded at all and uninitialized sctx->nr_paths variable that results in=20
memory corruption.

Mikulas

---

From: Jim Ramsay <jim_ramsay@dell.com>

dm-switch is a new target that maps IO to underlying block devices
efficiently when there are a large number of fixed-sized address regions
but there is no simple pattern to allow for a compact mapping
representation such as dm-stripe.

Motivation
----------

Dell EqualLogic and some other iSCSI storage arrays use a distributed
frameless architecture.  In this architecture, the storage group
consists of a number of distinct storage arrays ("members"), each having
independent controllers, disk storage and network adapters.  When a LUN
is created it is spread across multiple members.  The details of the
spreading are hidden from initiators connected to this storage system.
The storage group exposes a single target discovery portal, no matter
how many members are being used.  When iSCSI sessions are created, each
session is connected to an eth port on a single member.  Data to a LUN
can be sent on any iSCSI session, and if the blocks being accessed are
stored on another member the IO will be forwarded as required.  This
forwarding is invisible to the initiator.  The storage layout is also
dynamic, and the blocks stored on disk may be moved from member to
member as needed to balance the load.

This architecture simplifies the management and configuration of both
the storage group and initiators.  In a multipathing configuration, it
is possible to set up multiple iSCSI sessions to use multiple network
interfaces on both the host and target to take advantage of the
increased network bandwidth.  An initiator could use a simple round robin
algorithm to send IO across all paths and let the storage array members
forward it as necessary, but there is a performance advantage to
sending data directly to the correct member. =20

The Device Mapper table architecture already supports designating different
address regions with different targets, but in our architecture the LUN
is spread with an address region size on the order of 10s of MBs, which
means the resulting DM table could have more than a million entries
and consume far too much memory.

Solution
--------
Based on earlier discussion with the dm-devel contributors, we have
solved this problem by using Device Mapper to build a two-layer device
hierarchy:

    Upper Tier =E2=80=93 Determine which array member the IO should be sent=
 to.
    Lower Tier =E2=80=93 Load balance amongst paths to a particular member.

The lower tier consists of a single dm multipath device for each member.
Each of these multipath devices contains the set of paths directly to
the array member in one priority group, and leverages existing path
selectors to load balance amongst these paths.  We also build a
non-preferred priority group containing paths to other array members for
failover reasons.

The upper tier consists of a single dm switch device, using the new DM
target module.  This device uses a bitmap to look up the location of the
IO and choose the appropriate lower tier device to route the IO.  By
using a bitmap we are able to use 4 bits for each address range in a 16
member group (which is very large for us).  This is a much denser
representation than the DM table B-tree can achieve.

Though we have developed this target for a specific storage device, we
have made an effort to keep it as general purpose as possible in the hope
that others may benefit.

Originally developed by Jim Ramsay. Simplified by Mikulas Patocka.

Signed-off-by: Jim Ramsay <jim_ramsay@dell.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

FIXME reformatted new-style documentation file, complete code review (table=
 storage/message parsing), finish variable/fn naming review

---
 Documentation/device-mapper/switch.txt |   83 +++++
 drivers/md/Kconfig                     |   14=20
 drivers/md/Makefile                    |    1=20
 drivers/md/dm-switch.c                 |  539 ++++++++++++++++++++++++++++=
+++++
 4 files changed, 637 insertions(+)

Index: linux-3.9.3-fast/Documentation/device-mapper/switch.txt
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null=091970-01-01 00:00:00.000000000 +0000
+++ linux-3.9.3-fast/Documentation/device-mapper/switch.txt=092013-05-22 22=
:42:57.000000000 +0200
@@ -0,0 +1,83 @@
+dm-switch
+=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+dm-switch target is suitable for Dell EqualLogic storage system.
+
+The EqualLogic storage consists of several nodes. Each host is connected
+to each node. The host may send I/O requests to any node, the node that
+received the requests forwards it to the node where the data is stored.
+
+However, there is a performance advantage of sending I/O requests to the
+node where the data is stored to avoid forwarding. The dm-switch targets
+is created to use this performance advantage.
+
+The dm-switch target splits the device to fixed-size regions. It maintains
+a redirection table that maps regions to storage nodes. Every request is
+forwarded to the corresponding storage node specified in the redirection
+table. The table may be changed with messages while the dm-switch target
+is running.
+
+
+Construction Parameters
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+    <num_nodes> <region_size> <num_optional_arguments>
+    for each node: <device_name> <offset>
+
+<num_nodes>
+    The number of nodes in the EqualLogic storage.
+
+<region_size>
+    The number of 512-byte sectors in a page. Each page can be redirected
+    to a specified node.
+
+<num_optional_arguments>
+    The number of optional arguments. Currently, there are no optional
+    arguments possible and it must be zero.
+
+<device_name>
+    The block device that is used to access the specific node.
+
+<offset>
+    The offset of data start on the specific node (in the unit of
+    512-byte sectors). This number is added to the sector number when
+    forwarding the request to the specific node. Typically, it is zero.
+
+
+Messages
+=3D=3D=3D=3D=3D=3D=3D=3D
+
+set_region_mappings <index>:<node> [<index>]:<node> [<index>]:<node>...
+
+Modify the region table - set which regions are redirected to which nodes.
+
+<index>
+    Hexadecimal argument.
+    The region number (region size was specified in constructor parameters=
).
+    If index is omitted, a next region (previous index + 1) is used
+
+<node>
+    Hexadecimal argument.
+    The number number (in the range 0 ... <num_nodes> - 1)
+
+
+Status
+=3D=3D=3D=3D=3D=3D
+
+There is no status line.
+
+
+Example
+=3D=3D=3D=3D=3D=3D=3D
+
+Assume that you have volumes vg1/switch0 vg1/switch1 vg1/switch2 with
+the same size.
+
+Create a switch device with 64kB region size:
+    dmsetup create switch --table "0 `blockdev --getsize /dev/vg1/switch0`
+=09switch 3 128 0 /dev/vg1/switch0 0 /dev/vg1/switch1 0 /dev/vg1/switch2 0=
"
+
+Set mappings for the first 7 entries to point to devices switch0, switch1,
+switch2, switch0, switch1, switch2, switch1:
+    dmsetup message switch 0 set_region_mappings 0:1 :2 :0 :1 :2 :0 :1
+
Index: linux-3.9.3-fast/drivers/md/Kconfig
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-3.9.3-fast.orig/drivers/md/Kconfig=092013-05-22 22:27:40.00000000=
0 +0200
+++ linux-3.9.3-fast/drivers/md/Kconfig=092013-05-22 22:28:28.000000000 +02=
00
@@ -428,4 +428,18 @@ config DM_VERITY
=20
 =09  If unsure, say N.
=20
+config DM_SWITCH
+=09tristate "Switch target support (EXPERIMENTAL)"
+=09depends on BLK_DEV_DM
+=09---help---
+=09  This device-mapper target creates a device that supports an arbitrary
+=09  mapping of fixed-size regions of I/O across a fixed set of paths.
+=09  The path uses for any specific region can be switched dynamically
+=09  by sending the target a message.
+
+=09  To compile this code as a module, choose M here: the module will
+=09  be called dm-switch.
+
+=09  If unsure, say N.
+
 endif # MD
Index: linux-3.9.3-fast/drivers/md/Makefile
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-3.9.3-fast.orig/drivers/md/Makefile=092013-05-22 22:27:40.0000000=
00 +0200
+++ linux-3.9.3-fast/drivers/md/Makefile=092013-05-22 22:28:28.000000000 +0=
200
@@ -53,6 +53,7 @@ obj-$(CONFIG_DM_CACHE)=09=09+=3D dm-cache.o
 obj-$(CONFIG_DM_CACHE_MQ)=09+=3D dm-cache-mq.o
 obj-$(CONFIG_DM_CACHE_CLEANER)=09+=3D dm-cache-cleaner.o
 obj-$(CONFIG_DM_ZEROED)=09=09+=3D dm-zeroed.o
+obj-$(CONFIG_DM_SWITCH)=09=09+=3D dm-switch.o
=20
 ifeq ($(CONFIG_DM_UEVENT),y)
 dm-mod-objs=09=09=09+=3D dm-uevent.o
Index: linux-3.9.3-fast/drivers/md/dm-switch.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null=091970-01-01 00:00:00.000000000 +0000
+++ linux-3.9.3-fast/drivers/md/dm-switch.c=092013-05-22 23:04:00.000000000=
 +0200
@@ -0,0 +1,539 @@
+/*
+ * Copyright (C) 2010-2012 by Dell Inc.  All rights reserved.
+ * Copyright (C) 2011-2012 Red Hat, Inc.
+ *
+ * This file is released under the GPL.
+ *
+ * dm-switch is a device-mapper target that maps IO to underlying block de=
vices
+ * efficiently when there are a large number of fixed-sized address region=
s
+ * but there is no simple pattern to allow for a compact mapping
+ * representation such as dm-stripe.
+ */
+
+#include <linux/device-mapper.h>
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/vmalloc.h>
+
+#define DM_MSG_PREFIX "switch"
+
+/*
+ * One region_table_slot holds <region_entries_per_slot> region table
+ * entries each of which is <region_table_entry_bits> in size.
+ */
+typedef unsigned long region_table_slot;
+
+/*
+ * A device with the offset to its start sector.
+ */
+struct switch_path {
+=09struct dm_dev *dmdev;
+=09sector_t start;
+};
+
+/*
+ * Context block for a dm switch device.
+ */
+struct switch_ctx {
+=09struct dm_target *ti;
+
+=09unsigned nr_paths;=09=09/* Number of paths in path_list. */
+
+=09unsigned region_size;=09=09/* Region size in 512-byte sectors */
+=09unsigned long nr_regions;=09/* Number of regions making up the device *=
/
+=09signed char region_size_bits;=09/* log2 of region_size or -1 */
+
+=09unsigned char region_table_entry_bits;=09/* Number of bits in one regio=
n table entry */
+=09unsigned char region_entries_per_slot;=09/* Number of entries in one re=
gion table slot */
+=09signed char region_entries_per_slot_bits;=09/* log2 of region_entries_p=
er_slot or -1 */
+
+=09region_table_slot *region_table;=09/* Region table */
+
+=09/*
+=09 * Array of dm devices to switch between.
+=09 */
+=09struct switch_path path_list[0];
+};
+
+static struct switch_ctx *alloc_switch_ctx(struct dm_target *ti, unsigned =
nr_paths,
+=09=09=09=09=09   unsigned region_size)
+{
+=09struct switch_ctx *sctx;
+
+=09sctx =3D kzalloc(sizeof(struct switch_ctx) + nr_paths * sizeof(struct s=
witch_path),
+=09=09       GFP_KERNEL);
+=09if (!sctx)
+=09=09return NULL;
+
+=09sctx->ti =3D ti;
+=09sctx->region_size =3D region_size;
+
+=09ti->private =3D sctx;
+
+=09return sctx;
+}
+
+static int alloc_region_table(struct dm_target *ti, unsigned nr_paths)
+{
+=09struct switch_ctx *sctx =3D ti->private;
+=09sector_t nr_regions =3D ti->len;
+=09sector_t nr_slots;
+
+// still to review table construction/usage
+=09if (!(sctx->region_size & (sctx->region_size - 1)))
+=09=09sctx->region_size_bits =3D __ffs(sctx->region_size);
+=09else
+=09=09sctx->region_size_bits =3D -1;
+
+=09sctx->region_table_entry_bits =3D 1;
+=09while (sctx->region_table_entry_bits < sizeof(region_table_slot) * 8 &&
+=09       (region_table_slot)1 << sctx->region_table_entry_bits < nr_paths=
)
+=09=09sctx->region_table_entry_bits++;
+
+=09sctx->region_entries_per_slot =3D (sizeof(region_table_slot) * 8) / sct=
x->region_table_entry_bits;
+=09if (!(sctx->region_entries_per_slot & (sctx->region_entries_per_slot - =
1)))
+=09=09sctx->region_entries_per_slot_bits =3D __ffs(sctx->region_entries_pe=
r_slot);
+=09else
+=09=09sctx->region_entries_per_slot_bits =3D -1;
+
+=09if (sector_div(nr_regions, sctx->region_size))
+=09=09nr_regions++;
+
+=09sctx->nr_regions =3D nr_regions;
+=09if (sctx->nr_regions !=3D nr_regions || sctx->nr_regions >=3D ULONG_MAX=
) {
+=09=09ti->error =3D "Region table too large";
+=09=09return -EINVAL;
+=09}
+
+=09nr_slots =3D nr_regions;
+=09if (sector_div(nr_slots, sctx->region_entries_per_slot))
+=09=09nr_slots++;
+
+=09if (nr_slots > ULONG_MAX / sizeof(region_table_slot)) {
+=09=09ti->error =3D "Region table too large";
+=09=09return -EINVAL;
+=09}
+
+=09sctx->region_table =3D vmalloc(nr_slots * sizeof(region_table_slot));
+=09if (!sctx->region_table) {
+=09=09ti->error =3D "Cannot allocate region table";
+=09=09return -ENOMEM;
+=09}
+
+=09return 0;
+}
+
+static void switch_get_position(struct switch_ctx *sctx, unsigned long reg=
ion_nr,
+=09=09=09=09unsigned long *region_index, unsigned *bit)
+{
+=09if (sctx->region_entries_per_slot_bits >=3D 0) {
+=09=09*region_index =3D region_nr >> sctx->region_entries_per_slot_bits;
+=09=09*bit =3D region_nr & (sctx->region_entries_per_slot - 1);
+=09} else {
+=09=09*region_index =3D region_nr / sctx->region_entries_per_slot;
+=09=09*bit =3D region_nr % sctx->region_entries_per_slot;
+=09}
+
+=09*bit *=3D sctx->region_table_entry_bits;
+}
+
+/*
+ * Find which path to use at given offset.
+ */
+static unsigned switch_get_path_nr(struct switch_ctx *sctx, sector_t offse=
t)
+{
+=09unsigned long region_index;
+=09unsigned bit, path_nr;
+=09sector_t p;
+
+=09p =3D offset;
+=09if (sctx->region_size_bits >=3D 0)
+=09=09p >>=3D sctx->region_size_bits;
+=09else
+=09=09sector_div(p, sctx->region_size);
+
+=09switch_get_position(sctx, p, &region_index, &bit);
+=09path_nr =3D (ACCESS_ONCE(sctx->region_table[region_index]) >> bit) &
+=09       ((1 << sctx->region_table_entry_bits) - 1);
+
+=09/* This can only happen if the processor uses non-atomic stores. */
+=09if (unlikely(path_nr >=3D sctx->nr_paths))
+=09=09path_nr =3D 0;
+
+=09return path_nr;
+}
+
+static void switch_region_table_write(struct switch_ctx *sctx, unsigned lo=
ng region_nr,
+=09=09=09=09      unsigned value)
+{
+=09unsigned long region_index;
+=09unsigned bit;
+=09region_table_slot pte;
+
+=09switch_get_position(sctx, region_nr, &region_index, &bit);
+
+=09pte =3D sctx->region_table[region_index];
+=09pte &=3D ~((((region_table_slot)1 << sctx->region_table_entry_bits) - 1=
) << bit);
+=09pte |=3D (region_table_slot)value << bit;
+=09sctx->region_table[region_index] =3D pte;
+}
+
+/*
+ * Fill the region table with an initial round robin pattern.
+ */
+static void initialise_region_table(struct switch_ctx *sctx)
+{
+=09unsigned path_nr =3D 0;
+=09unsigned long region_nr;
+
+=09for (region_nr =3D 0; region_nr < sctx->nr_regions; region_nr++) {
+=09=09switch_region_table_write(sctx, region_nr, path_nr);
+=09=09if (++path_nr >=3D sctx->nr_paths)
+=09=09=09path_nr =3D 0;
+=09}
+}
+
+static int parse_path(struct dm_arg_set *as, struct dm_target *ti)
+{
+=09struct switch_ctx *sctx =3D ti->private;
+=09unsigned long long start;
+=09int r;
+
+=09r =3D dm_get_device(ti, dm_shift_arg(as), dm_table_get_mode(ti->table),
+=09=09=09  &sctx->path_list[sctx->nr_paths].dmdev);
+=09if (r) {
+=09=09ti->error =3D "Device lookup failed";
+=09=09return r;
+=09}
+
+=09if (kstrtoull(dm_shift_arg(as), 10, &start) || start !=3D (sector_t)sta=
rt) {
+=09=09ti->error =3D "Invalid device starting offset";
+=09=09dm_put_device(ti, sctx->path_list[sctx->nr_paths].dmdev);
+=09=09return -EINVAL;
+=09}
+
+=09sctx->path_list[sctx->nr_paths].start =3D start;
+
+=09sctx->nr_paths++;
+
+=09return 0;
+}
+
+/*
+ * Destructor: Don't free the dm_target, just the ti->private data (if any=
).
+ */
+static void switch_dtr(struct dm_target *ti)
+{
+=09struct switch_ctx *sctx =3D ti->private;
+
+=09while (sctx->nr_paths--)
+=09=09dm_put_device(ti, sctx->path_list[sctx->nr_paths].dmdev);
+
+=09vfree(sctx->region_table);
+=09kfree(sctx);
+}
+
+/*
+ * Constructor arguments:
+ *   <num paths> <region size> <num optional args> [<optional args>...]
+ *   [<dev_path> <offset>]+
+ *
+ * Optional args are to allow for future extension: currently this
+ * parameter must be 0.
+ */
+static int switch_ctr(struct dm_target *ti, unsigned argc, char **argv)
+{
+=09static struct dm_arg _args[] =3D {
+=09=09{1, (KMALLOC_MAX_SIZE - sizeof(struct switch_ctx)) / sizeof(struct s=
witch_path), "Invalid number of paths"},
+=09=09{1, UINT_MAX, "Invalid region size"},
+=09=09{0, 0, "Invalid number of optional args"},
+=09};
+
+=09struct switch_ctx *sctx;
+=09struct dm_arg_set as;
+=09unsigned nr_paths, region_size, nr_optional_args;
+=09int r;
+
+=09as.argc =3D argc;
+=09as.argv =3D argv;
+
+=09r =3D dm_read_arg(_args, &as, &nr_paths, &ti->error);
+=09if (r)
+=09=09return -EINVAL;
+
+=09r =3D dm_read_arg(_args + 1, &as, &region_size, &ti->error);
+=09if (r)
+=09=09return r;
+
+=09r =3D dm_read_arg_group(_args + 2, &as, &nr_optional_args, &ti->error);
+=09if (r)
+=09=09return r;
+=09/* parse optional arguments here, if we add any */
+
+=09if (as.argc !=3D nr_paths * 2) {
+=09=09ti->error =3D "Incorrect number of path arguments";
+=09=09return -EINVAL;
+=09}
+
+=09sctx =3D alloc_switch_ctx(ti, nr_paths, region_size);
+=09if (!sctx) {
+=09=09ti->error =3D "Cannot allocate redirection context";
+=09=09return -ENOMEM;
+=09}
+
+=09r =3D dm_set_target_max_io_len(ti, region_size);
+=09if (r)
+=09=09goto error;
+
+=09while (as.argc) {
+=09=09r =3D parse_path(&as, ti);
+=09=09if (r)
+=09=09=09goto error;
+=09}
+
+=09r =3D alloc_region_table(ti, nr_paths);
+=09if (r)
+=09=09goto error;
+
+=09initialise_region_table(sctx);
+
+=09/* For UNMAP, sending the request down any path is sufficient */
+=09ti->num_discard_bios =3D 1;
+
+=09return 0;
+
+error:
+=09switch_dtr(ti);
+
+=09return r;
+}
+
+static int switch_map(struct dm_target *ti, struct bio *bio)
+{
+=09struct switch_ctx *sctx =3D ti->private;
+=09sector_t offset =3D dm_target_offset(ti, bio->bi_sector);
+=09unsigned path_nr =3D switch_get_path_nr(sctx, offset);
+
+=09bio->bi_bdev =3D sctx->path_list[path_nr].dmdev->bdev;
+=09bio->bi_sector =3D sctx->path_list[path_nr].start + offset;
+
+=09return DM_MAPIO_REMAPPED;
+}
+
+/*
+ * We need to parse hex numbers in the message as quickly as possible.
+ *
+ * This table-based hex parser improves performance.
+ * It improves a time to load 1000000 entries compared to the condition-ba=
sed
+ * parser.
+ *=09=09table-based parser=09condition-based parser
+ * PA-RISC=090.29s=09=09=090.31s
+ * Opteron=090.0495s=09=09=090.0498s
+ */
+static const unsigned char hex_table[256] =3D {
+255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,=
 255,
+255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,=
 255,
+255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,=
 255,
+0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 255, 255, 255, 255, 255, 255,
+255, 10, 11, 12, 13, 14, 15, 255, 255, 255, 255, 255, 255, 255, 255, 255,
+255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,=
 255,
+255, 10, 11, 12, 13, 14, 15, 255, 255, 255, 255, 255, 255, 255, 255, 255,
+255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,=
 255,
+255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,=
 255,
+255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,=
 255,
+255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,=
 255,
+255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,=
 255,
+255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,=
 255,
+255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,=
 255,
+255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,=
 255,
+255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,=
 255
+};
+
+static __always_inline unsigned long parse_hex(const char **string)
+{
+=09unsigned char d;
+=09unsigned long r =3D 0;
+
+=09while ((d =3D hex_table[(unsigned char)**string]) < 16) {
+=09=09r =3D (r << 4) | d;
+=09=09(*string)++;
+=09}
+
+=09return r;
+}
+
+static int process_set_region_mappings(struct switch_ctx *sctx,
+=09=09=09     unsigned argc, char **argv)
+{
+=09unsigned i;
+=09unsigned long region_index =3D 0;
+
+=09for (i =3D 1; i < argc; i++) {
+=09=09unsigned long path_nr;
+=09=09const char *string =3D argv[i];
+
+=09=09if (*string =3D=3D ':')
+=09=09=09region_index++;
+=09=09else {
+=09=09=09region_index =3D parse_hex(&string);
+=09=09=09if (unlikely(*string !=3D ':')) {
+=09=09=09=09DMWARN("invalid set_region_mappings argument: '%s'", argv[i]);
+=09=09=09=09return -EINVAL;
+=09=09=09}
+=09=09}
+
+=09=09string++;
+=09=09if (unlikely(!*string)) {
+=09=09=09DMWARN("invalid set_region_mappings argument: '%s'", argv[i]);
+=09=09=09return -EINVAL;
+=09=09}
+
+=09=09path_nr =3D parse_hex(&string);
+=09=09if (unlikely(*string)) {
+=09=09=09DMWARN("invalid set_region_mappings argument: '%s'", argv[i]);
+=09=09=09return -EINVAL;
+=09=09}
+=09=09if (unlikely(region_index >=3D sctx->nr_regions)) {
+=09=09=09DMWARN("invalid set_region_mappings region number: %lu >=3D %lu",=
 region_index, sctx->nr_regions);
+=09=09=09return -EINVAL;
+=09=09}
+=09=09if (unlikely(path_nr >=3D sctx->nr_paths)) {
+=09=09=09DMWARN("invalid set_region_mappings device: %lu >=3D %u", path_nr=
, sctx->nr_paths);
+=09=09=09return -EINVAL;
+=09=09}
+
+=09=09switch_region_table_write(sctx, region_index, path_nr);
+=09}
+
+=09return 0;
+}
+
+/*
+ * Messages are processed one-at-a-time.
+ *
+ * Only set_region_mappings is supported.
+ */
+static int switch_message(struct dm_target *ti, unsigned argc, char **argv=
)
+{
+=09static DEFINE_MUTEX(message_mutex);
+
+=09struct switch_ctx *sctx =3D ti->private;
+=09int r =3D -EINVAL;
+
+=09mutex_lock(&message_mutex);
+
+=09if (!strcasecmp(argv[0], "set_region_mappings"))
+=09=09r =3D process_set_region_mappings(sctx, argc, argv);
+=09else
+=09=09DMWARN("Unrecognised message received.");
+
+=09mutex_unlock(&message_mutex);
+
+=09return r;
+}
+
+static void switch_status(struct dm_target *ti, status_type_t type,
+=09=09=09  unsigned status_flags, char *result, unsigned maxlen)
+{
+=09struct switch_ctx *sctx =3D ti->private;
+=09unsigned sz =3D 0;
+=09int path_nr;
+
+=09switch (type) {
+=09case STATUSTYPE_INFO:
+=09=09result[0] =3D '\0';
+=09=09break;
+
+=09case STATUSTYPE_TABLE:
+=09=09DMEMIT("%u %u 0", sctx->nr_paths, sctx->region_size);
+=09=09for (path_nr =3D 0; path_nr < sctx->nr_paths; path_nr++)
+=09=09=09DMEMIT(" %s %llu", sctx->path_list[path_nr].dmdev->name,
+=09=09=09       (unsigned long long)sctx->path_list[path_nr].start);
+=09=09break;
+=09}
+}
+
+/*
+ * Switch ioctl:
+ *
+ * Passthrough all ioctls to the path for sector 0
+ */
+static int switch_ioctl(struct dm_target *ti, unsigned cmd,
+=09=09=09unsigned long arg)
+{
+=09struct switch_ctx *sctx =3D ti->private;
+=09struct block_device *bdev;
+=09fmode_t mode;
+=09unsigned path_nr;
+=09int r =3D 0;
+
+=09path_nr =3D switch_get_path_nr(sctx, 0);
+
+=09bdev =3D sctx->path_list[path_nr].dmdev->bdev;
+=09mode =3D sctx->path_list[path_nr].dmdev->mode;
+
+=09/*
+=09 * Only pass ioctls through if the device sizes match exactly.
+=09 */
+=09if (ti->len + sctx->path_list[path_nr].start !=3D i_size_read(bdev->bd_=
inode) >> SECTOR_SHIFT)
+=09=09r =3D scsi_verify_blk_ioctl(NULL, cmd);
+
+=09return r ? : __blkdev_driver_ioctl(bdev, mode, cmd, arg);
+}
+
+static int switch_iterate_devices(struct dm_target *ti,
+=09=09=09=09  iterate_devices_callout_fn fn, void *data)
+{
+=09struct switch_ctx *sctx =3D ti->private;
+=09int path_nr;
+=09int r;
+
+=09for (path_nr =3D 0; path_nr < sctx->nr_paths; path_nr++) {
+=09=09r =3D fn(ti, sctx->path_list[path_nr].dmdev,
+=09=09=09 sctx->path_list[path_nr].start, ti->len, data);
+=09=09if (r)
+=09=09=09return r;
+=09}
+
+=09return 0;
+}
+
+static struct target_type switch_target =3D {
+=09.name =3D "switch",
+=09.version =3D {1, 0, 0},
+=09.module =3D THIS_MODULE,
+=09.ctr =3D switch_ctr,
+=09.dtr =3D switch_dtr,
+=09.map =3D switch_map,
+=09.message =3D switch_message,
+=09.status =3D switch_status,
+=09.ioctl =3D switch_ioctl,
+=09.iterate_devices =3D switch_iterate_devices,
+};
+
+static int __init dm_switch_init(void)
+{
+=09int r;
+
+=09r =3D dm_register_target(&switch_target);
+=09if (r < 0)
+=09=09DMERR("dm_register_target() failed %d", r);
+
+=09return r;
+}
+
+static void __exit dm_switch_exit(void)
+{
+=09dm_unregister_target(&switch_target);
+}
+
+module_init(dm_switch_init);
+module_exit(dm_switch_exit);
+
+MODULE_DESCRIPTION(DM_NAME " fixed-size address-region-mapping throughput-=
oriented path selector");
+MODULE_AUTHOR("Kevin D. O'Kelley <Kevin_OKelley@dell.com>");
+MODULE_AUTHOR("Narendran Ganapathy <Narendran_Ganapathy@dell.com>");
+MODULE_AUTHOR("Jim Ramsay <Jim_Ramsay@dell.com>");
+MODULE_AUTHOR("Mikulas Patocka <mpatocka@redhat.com>");
+MODULE_LICENSE("GPL");
--185242623-490532849-1369257258=:22686
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--185242623-490532849-1369257258=:22686--

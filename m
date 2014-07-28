From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 2/2 v2] dm-switch: allow repetitive patterns
Date: Mon, 28 Jul 2014 18:11:25 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1407281806140.26574@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1407281743120.26574@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1407281747450.26574@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1407281747450.26574@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <msnitzer@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>, dm-devel@redhat.com
Cc: Jay Wang <jwang@nimblestorage.com>
List-Id: dm-devel.ids

[ version 2 of the patch - incremented target version and added 
documentation ]

From: Mikulas Patocka <mpatocka@redhat.com>

This patch allows repetitive patterns in dm-switch. In
set_regions_mappings message, the user may use "Rn,m" as one of the
arguments. "n" and "m" are hexadecimal numbers. The "Rn,m" argument
repeats the last "n" arguments in the following "m" slots.

For example:
dmsetup message switch 0 set_region_mappings 1000:1 :2 R2,10
is equivalent to
dmsetup message switch 0 set_region_mappings 1000:1 :2 :1 :2 :1 :2 :1 :2 \
:1 :2 :1 :2 :1 :2 :1 :2 :1 :2

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 Documentation/device-mapper/switch.txt |   12 ++++++++
 drivers/md/dm-switch.c                 |   45 ++++++++++++++++++++++++++++++++-
 2 files changed, 56 insertions(+), 1 deletion(-)

Index: linux-3.16-rc5/drivers/md/dm-switch.c
===================================================================
--- linux-3.16-rc5.orig/drivers/md/dm-switch.c	2014-07-14 16:26:23.000000000 +0200
+++ linux-3.16-rc5/drivers/md/dm-switch.c	2014-07-28 23:55:27.000000000 +0200
@@ -380,6 +380,49 @@ static int process_set_region_mappings(s
 		unsigned long path_nr;
 		const char *string = argv[i];
 
+		if ((*string & 0xdf) == 'R') {
+			unsigned long cycle_length, num_write;
+
+			string++;
+			if (unlikely(*string == ',')) {
+				DMWARN("invalid set_region_mappings argument: '%s'", argv[i]);
+				return -EINVAL;
+			}
+			cycle_length = parse_hex(&string);
+			if (unlikely(*string != ',')) {
+				DMWARN("invalid set_region_mappings argument: '%s'", argv[i]);
+				return -EINVAL;
+			}
+			string++;
+			if (unlikely(!*string)) {
+				DMWARN("invalid set_region_mappings argument: '%s'", argv[i]);
+				return -EINVAL;
+			}
+			num_write = parse_hex(&string);
+			if (unlikely(*string)) {
+				DMWARN("invalid set_region_mappings argument: '%s'", argv[i]);
+				return -EINVAL;
+			}
+
+			if (unlikely(!cycle_length) || unlikely(cycle_length - 1 > region_index)) {
+				DMWARN("invalid set_region_mappings cycle length: %lu > %lu", cycle_length - 1, region_index);
+				return -EINVAL;
+			}
+			if (unlikely(region_index + num_write < region_index) ||
+			    unlikely(region_index + num_write >= sctx->nr_regions)) {
+				DMWARN("invalid set_region_mappings region number: %lu + %lu >= %lu", region_index, num_write, sctx->nr_regions);
+				return -EINVAL;
+			}
+
+			while (num_write--) {
+				region_index++;
+				path_nr = switch_region_table_read(sctx, region_index - cycle_length);
+				switch_region_table_write(sctx, region_index, path_nr);
+			}
+
+			continue;
+		}
+
 		if (*string == ':')
 			region_index++;
 		else {
@@ -508,7 +551,7 @@ static int switch_iterate_devices(struct
 
 static struct target_type switch_target = {
 	.name = "switch",
-	.version = {1, 0, 0},
+	.version = {1, 1, 0},
 	.module = THIS_MODULE,
 	.ctr = switch_ctr,
 	.dtr = switch_dtr,
Index: linux-3.16-rc5/Documentation/device-mapper/switch.txt
===================================================================
--- linux-3.16-rc5.orig/Documentation/device-mapper/switch.txt	2014-07-28 23:55:45.000000000 +0200
+++ linux-3.16-rc5/Documentation/device-mapper/switch.txt	2014-07-29 00:07:59.000000000 +0200
@@ -106,6 +106,11 @@ which paths.
     The path number in the range 0 ... (<num_paths> - 1).
     Expressed in hexadecimal (WITHOUT any prefix like 0x).
 
+R<n>,<m>
+    This parameter allows to quickly load repetitive patterns. <n> and <m> are
+    hexadecimal numbers. The last <n> mappings are repeated in the next <m>
+    slots.
+
 Status
 ======
 
@@ -124,3 +129,10 @@ Create a switch device with 64kB region 
 Set mappings for the first 7 entries to point to devices switch0, switch1,
 switch2, switch0, switch1, switch2, switch1:
     dmsetup message switch 0 set_region_mappings 0:0 :1 :2 :0 :1 :2 :1
+
+Set repetitive mapping. This command:
+    dmsetup message switch 0 set_region_mappings 1000:1 :2 R2,10
+is equivalent to:
+    dmsetup message switch 0 set_region_mappings 1000:1 :2 :1 :2 :1 :2 :1 :2 \
+	:1 :2 :1 :2 :1 :2 :1 :2 :1 :2
+

From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 2/2] dm-switch: allow repetitive patterns
Date: Mon, 28 Jul 2014 17:48:09 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1407281747450.26574@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1407281743120.26574@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1407281743120.26574@file01.intranet.prod.int.rdu2.redhat.com>
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
 drivers/md/dm-switch.c |   43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

Index: linux-3.15/drivers/md/dm-switch.c
===================================================================
--- linux-3.15.orig/drivers/md/dm-switch.c	2014-06-27 14:09:39.000000000 +0200
+++ linux-3.15/drivers/md/dm-switch.c	2014-06-27 22:36:42.000000000 +0200
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

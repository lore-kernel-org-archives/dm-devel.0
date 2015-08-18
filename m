From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-statistics: report precise timestamps and
	histogram
Date: Tue, 18 Aug 2015 16:26:16 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1508181618100.19666@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
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
To: "Alasdair G. Kergon" <agk@redhat.com>, Bryn Reeves <breeves@redhat.com>, Mike Snitzer <msnitzer@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Mike, please submit this patch to the upstream kernel before 4.2 is 
released, so that the all the kernels that support the options 
"precise_timestamps" and "histogram" also report these values back.


From: Mikulas Patocka <mpatocka@redhat.com>

If the user selected precise timestamps or histogram, report it in the
output of the @stats_list message.

If the user didn't select these options, no extra tokens are reported,
thus it is backward compatible with old software that doesn't know about
precise timestamps and histogram.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

Index: linux-4.1.5/Documentation/device-mapper/statistics.txt
===================================================================
--- linux-4.1.5.orig/Documentation/device-mapper/statistics.txt
+++ linux-4.1.5/Documentation/device-mapper/statistics.txt
@@ -118,6 +118,10 @@ Messages
 
 	Output format:
 	  <region_id>: <start_sector>+<length> <step> <program_id> <aux_data>
+	  	precise_timestamps histogram:n1,n2,n3,...
+
+	The strings "precise_timestamps" and "histogram" are printed only
+	if they were specified when creating the region.
 
     @stats_print <region_id> [<starting_line> <number_of_lines>]
 
Index: linux-4.1.5/drivers/md/dm-stats.c
===================================================================
--- linux-4.1.5.orig/drivers/md/dm-stats.c
+++ linux-4.1.5/drivers/md/dm-stats.c
@@ -453,12 +453,24 @@ static int dm_stats_list(struct dm_stats
 	list_for_each_entry(s, &stats->list, list_entry) {
 		if (!program || !strcmp(program, s->program_id)) {
 			len = s->end - s->start;
-			DMEMIT("%d: %llu+%llu %llu %s %s\n", s->id,
+			DMEMIT("%d: %llu+%llu %llu %s %s", s->id,
 				(unsigned long long)s->start,
 				(unsigned long long)len,
 				(unsigned long long)s->step,
 				s->program_id,
 				s->aux_data);
+			if (s->stat_flags & STAT_PRECISE_TIMESTAMPS)
+				DMEMIT(" precise_timestamps");
+			if (s->n_histogram_entries) {
+				unsigned i;
+				DMEMIT(" histogram:");
+				for (i = 0; i < s->n_histogram_entries; i++) {
+					if (i)
+						DMEMIT(",");
+					DMEMIT("%llu", s->histogram_boundaries[i]);
+				}
+			}
+			DMEMIT("\n");
 		}
 	}
 	mutex_unlock(&stats->mutex);

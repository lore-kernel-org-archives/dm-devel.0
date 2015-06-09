From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 1/4] dm-statistics: better argument validation
Date: Tue, 9 Jun 2015 17:21:13 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1506091720530.1545@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1506091705160.1545@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1506091705160.1545@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, Coly Li <colyli@gmail.com>
Cc: Tao Ma <boyu.mt@taobao.com>, dm-devel@redhat.com, Laurence Oberman <loberman@redhat.com>, Robin Dong <sanbai@alibaba-inc.com>
List-Id: dm-devel.ids

If the number_of_areas argument was zero, the kernel would crash on
div-by-zero. This patch fixes it.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org	# v3.12+

---
 drivers/md/dm-stats.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-4.1-rc6/drivers/md/dm-stats.c
===================================================================
--- linux-4.1-rc6.orig/drivers/md/dm-stats.c	2015-06-05 15:39:58.000000000 +0200
+++ linux-4.1-rc6/drivers/md/dm-stats.c	2015-06-05 15:42:09.000000000 +0200
@@ -795,6 +795,8 @@ static int message_stats_create(struct m
 		return -EINVAL;
 
 	if (sscanf(argv[2], "/%u%c", &divisor, &dummy) == 1) {
+		if (!divisor)
+			return -EINVAL;
 		step = end - start;
 		if (do_div(step, divisor))
 			step++;

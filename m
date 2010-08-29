From: Malahal Naineni <malahal@us.ibm.com>
Subject: [PATCH] block: blk_phys_contig_segment() doesn't account
	for bounce	pages
Date: Sun, 29 Aug 2010 11:01:18 -0700
Message-ID: <5d97698a7bc5094f21f7.1283104878@malahal>
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
To: jaxboe@fusionio.com, dm-devel@redhat.com
List-Id: dm-devel.ids

blk_phys_contig_segment() doesn't account for bouce pages and a later
recalculation that accounts for bounce pages, in blk_rq_check_limits()
while dispatching the request, fails with "over max segments limit".

Signed-off-by: Malahal Naineni (malahal@us.ibm.com)

diff -r 528f6f2c7e80 -r 5d97698a7bc5 block/blk-merge.c
--- a/block/blk-merge.c	Fri Aug 20 01:33:12 2010 -0700
+++ b/block/blk-merge.c	Wed Aug 25 13:44:33 2010 -0700
@@ -101,6 +101,13 @@ static int blk_phys_contig_segment(struc
 		return 0;
 
 	/*
+	 * A high page is never considered part of another segment,
+	 * since that might change with the bounce page.
+	 */
+	if (page_to_pfn(__BVEC_END(bio)->bv_page) > queue_bounce_pfn(q) ||
+	    page_to_pfn(__BVEC_START(nxt)->bv_page) > queue_bounce_pfn(q))
+		return 0;
+	/*
 	 * bio and nxt are contiguous in memory; check if the queue allows
 	 * these two to be merged into one
 	 */

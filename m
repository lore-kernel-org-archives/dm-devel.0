From: Jonathan Brassow <jbrassow@redhat.com>
Subject: RFC: switch rh_in_sync to blocking in do_reads
Date: Thu, 05 Apr 2007 10:22:27 -0500
Message-ID: <1175786547.23622.5.camel@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

I think this was an oversight and the rh_in_sync call should be allowed
to block in do_reads.  Any reason why it is not coded that way?

 brassow

do_reads happens in the mirror worker thread and operations there are
allowed to block.  The call to rh_in_sync should be allowed to block.

This is especially important for cluster mirroring.  Since the
cluster log must ensure the region is in_sync cluster-wide and
must do network operations to ensure that, it will always return
-EWOULDBLOCK if 0 is given for the blocking argument.  The way
the code is written, a cluster mirror would never be allowed to
'choose_mirror'.

Index: linux-2.6.21-rc5-mm4/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.21-rc5-mm4.orig/drivers/md/dm-raid1.c
+++ linux-2.6.21-rc5-mm4/drivers/md/dm-raid1.c
@@ -741,7 +741,7 @@ static void do_reads(struct mirror_set *
 		/*
 		 * We can only read balance if the region is in sync.
 		 */
-		if (rh_in_sync(&ms->rh, region, 0))
+		if (rh_in_sync(&ms->rh, region, 1))
 			m = choose_mirror(ms, bio->bi_sector);
 		else
 			m = ms->default_mirror;

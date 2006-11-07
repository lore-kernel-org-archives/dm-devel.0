From: Alasdair G Kergon <agk@redhat.com>
Subject: [PATCH 2.6.19 3/5] dm: multipath: fix rr_add_path order
Date: Tue, 7 Nov 2006 18:31:36 +0000
Message-ID: <20061107183136.GE6993@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Andrew Morton <akpm@osdl.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

From: Jonathan E Brassow <jbrassow@redhat.com>

When adding paths to the round-robin path selector, their order gets
inverted, which is not desirable.

Fix by replacing list_add() with list_add_tail().

Signed-off-by: Jonathan E Brassow <jbrassow@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com

Index: linux-2.6.19-rc4/drivers/md/dm-round-robin.c
===================================================================
--- linux-2.6.19-rc4.orig/drivers/md/dm-round-robin.c	2006-11-07 17:06:19.000000000 +0000
+++ linux-2.6.19-rc4/drivers/md/dm-round-robin.c	2006-11-07 17:07:59.000000000 +0000
@@ -136,7 +136,7 @@ static int rr_add_path(struct path_selec
 
 	path->pscontext = pi;
 
-	list_add(&pi->list, &s->valid_paths);
+	list_add_tail(&pi->list, &s->valid_paths);
 
 	return 0;
 }

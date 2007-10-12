From: Alasdair G Kergon <agk@redhat.com>
Subject: [2.6.24 PATCH 15/25] dm mpath: emc fix an error message
Date: Fri, 12 Oct 2007 18:19:45 +0100
Message-ID: <20071012171945.GA24157@agk.fab.redhat.com>
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

From: Alasdair G Kergon <agk@redhat.com>

Correct an error message, reported by Michael Wood <michael@frogfoot.com>.

Signed-off-by: Alasdair G Kergon <agk@redhat.com>

---
 drivers/md/dm-emc.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.23/drivers/md/dm-emc.c
===================================================================
--- linux-2.6.23.orig/drivers/md/dm-emc.c	2007-10-12 13:15:40.000000000 +0100
+++ linux-2.6.23/drivers/md/dm-emc.c	2007-10-12 13:18:14.000000000 +0100
@@ -83,7 +83,7 @@ static struct bio *get_failover_bio(stru
 	}
 
 	if (bio_add_page(bio, page, data_size, 0) != data_size) {
-		DMERR("get_failover_bio: alloc_page() failed.");
+		DMERR("get_failover_bio: bio_add_page() failed.");
 		__free_page(page);
 		bio_put(bio);
 		return NULL;

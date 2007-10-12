From: Alasdair G Kergon <agk@redhat.com>
Subject: [2.6.24 PATCH 25/25] dm raid1: add mirror_set to struct mirror
Date: Fri, 12 Oct 2007 18:23:59 +0100
Message-ID: <20071012172359.GK24157@agk.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1763437AbXJLR1S@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, Jonathan Brassow <jbrassow@redhat.com>
List-Id: dm-devel.ids

From: Jonathan Brassow <jbrassow@redhat.com>

Store a pointer to the owning mirror_set structure within each mirror
structure for a subsequent patch to use.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>

---
 drivers/md/dm-raid1.c |    2 ++
 1 files changed, 2 insertions(+)

Index: linux-2.6.23/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.23.orig/drivers/md/dm-raid1.c	2007-10-12 15:03:32.000000000 +0100
+++ linux-2.6.23/drivers/md/dm-raid1.c	2007-10-12 15:03:33.000000000 +0100
@@ -114,6 +114,7 @@ struct region {
  * Mirror set structures.
  *---------------------------------------------------------------*/
 struct mirror {
+	struct mirror_set *ms;
 	atomic_t error_count;
 	struct dm_dev *dev;
 	sector_t offset;
@@ -1017,6 +1018,7 @@ static int get_mirror(struct mirror_set 
 		return -ENXIO;
 	}
 
+	ms->mirror[mirror].ms = ms;
 	ms->mirror[mirror].offset = offset;
 
 	return 0;

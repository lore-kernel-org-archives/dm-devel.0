From: Alasdair G Kergon <agk@redhat.com>
Subject: [2.6.24 PATCH 07/25] dm delay: fix status
Date: Fri, 12 Oct 2007 18:14:55 +0100
Message-ID: <20071012171455.GR24157@agk.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1760018AbXJLRP1@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, Milan Broz <mbroz@redhat.com>, stable@kernel.org
List-Id: dm-devel.ids

From: Milan Broz <mbroz@redhat.com>

Fix missing space in dm-delay target status output
if separate read and write delay are configured.

Signed-off-by: Milan Broz <mbroz@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>

---
 drivers/md/dm-delay.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.23/drivers/md/dm-delay.c
===================================================================
--- linux-2.6.23.orig/drivers/md/dm-delay.c	2007-10-12 13:15:33.000000000 +0100
+++ linux-2.6.23/drivers/md/dm-delay.c	2007-10-12 13:15:34.000000000 +0100
@@ -308,7 +308,7 @@ static int delay_status(struct dm_target
 		       (unsigned long long) dc->start_read,
 		       dc->read_delay);
 		if (dc->dev_write)
-			DMEMIT("%s %llu %u", dc->dev_write->name,
+			DMEMIT(" %s %llu %u", dc->dev_write->name,
 			       (unsigned long long) dc->start_write,
 			       dc->write_delay);
 		break;

From: Alasdair G Kergon <agk@redhat.com>
Subject: [2.6.24 PATCH 03/25] dm crypt: drop device ref in ctr error path
Date: Fri, 12 Oct 2007 18:05:41 +0100
Message-ID: <20071012170541.GN24157@agk.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932630AbXJLRGv@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, Dmitry Monakhov <dmonakhov@openvz.org>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

From: Dmitry Monakhov <dmonakhov@openvz.org>

Add a missing 'dm_put_device' in an error path in crypt target constructor.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Signed-off-by: Milan Broz <mbroz@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm-crypt.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6.23/drivers/md/dm-crypt.c
===================================================================
--- linux-2.6.23.orig/drivers/md/dm-crypt.c	2007-10-12 13:15:20.000000000 +0100
+++ linux-2.6.23/drivers/md/dm-crypt.c	2007-10-12 13:15:30.000000000 +0100
@@ -882,7 +882,7 @@ static int crypt_ctr(struct dm_target *t
 		cc->iv_mode = kmalloc(strlen(ivmode) + 1, GFP_KERNEL);
 		if (!cc->iv_mode) {
 			ti->error = "Error kmallocing iv_mode string";
-			goto bad5;
+			goto bad_iv_mode;
 		}
 		strcpy(cc->iv_mode, ivmode);
 	} else
@@ -891,6 +891,8 @@ static int crypt_ctr(struct dm_target *t
 	ti->private = cc;
 	return 0;
 
+bad_iv_mode:
+	dm_put_device(ti, cc->dev);
 bad5:
 	bioset_free(cc->bs);
 bad_bs:

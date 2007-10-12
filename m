From: Alasdair G Kergon <agk@redhat.com>
Subject: [2.6.24 PATCH 04/25] dm crypt: missing kfree in ctr
	error path
Date: Fri, 12 Oct 2007 18:06:42 +0100
Message-ID: <20071012170642.GO24157@agk.fab.redhat.com>
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
Cc: dm-devel@redhat.com, Dmitry Monakhov <dmonakhov@openvz.org>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

From: Dmitry Monakhov <dmonakhov@openvz.org>

Insert missing kfree() in crypt_iv_essiv_ctr() error path.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm-crypt.c |    1 +
 1 files changed, 1 insertion(+)

Index: linux-2.6.23/drivers/md/dm-crypt.c
===================================================================
--- linux-2.6.23.orig/drivers/md/dm-crypt.c	2007-10-12 13:15:30.000000000 +0100
+++ linux-2.6.23/drivers/md/dm-crypt.c	2007-10-12 13:15:31.000000000 +0100
@@ -175,6 +175,7 @@ static int crypt_iv_essiv_ctr(struct cry
 
 	if (err) {
 		ti->error = "Error calculating hash in ESSIV";
+		kfree(salt);
 		return err;
 	}
 

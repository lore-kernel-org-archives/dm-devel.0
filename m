From: Jesper Juhl <jesper.juhl@gmail.com>
Subject: [PATCH] Fix memory leak in dm_create_persistent() when starting metadata update thread fails.
Date: Mon, 16 Jul 2007 21:41:43 +0200
Message-ID: <200707162141.44229.jesper.juhl@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758450AbXGPTms@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: dm-devel@redhat.com
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Alasdair G Kergon <agk@redhat.com>, Jesper Juhl <jesper.juhl@gmail.com>
List-Id: dm-devel.ids

If, in dm_create_persistent(), the call to 
create_singlethread_workqueue() fails then we'll return without 
freeing the memory allocated to 'ps', thus leaking 
sizeof(struct pstore) bytes.
This patch fixes the leak.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com
---

diff --git a/drivers/md/dm-exception-store.c b/drivers/md/dm-exception-store.c
index 3d65917..8fe81e1 100644
--- a/drivers/md/dm-exception-store.c
+++ b/drivers/md/dm-exception-store.c
@@ -623,6 +623,7 @@ int dm_create_persistent(struct exception_store *store)
 
 	ps->metadata_wq = create_singlethread_workqueue("ksnaphd");
 	if (!ps->metadata_wq) {
+		kfree(ps);
 		DMERR("couldn't start header metadata update thread");
 		return -ENOMEM;
 	}

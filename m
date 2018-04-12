From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: remove emacs autoconfig of
	kpartx/gpt.h
Date: Thu, 12 Apr 2018 18:17:13 +0200
Message-ID: <20180412161713.6447-1-xose.vazquez@gmail.com>
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
Cc: DM ML <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 kpartx/gpt.h | 19 -------------------
 1 file changed, 19 deletions(-)

diff --git a/kpartx/gpt.h b/kpartx/gpt.h
index 66ce8f1..7bb54b7 100644
--- a/kpartx/gpt.h
+++ b/kpartx/gpt.h
@@ -109,22 +109,3 @@ int read_gpt_pt (int fd, struct slice all, struct slice *sp, int ns);
 
 
 #endif
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-indent-level: 4
- * c-brace-imaginary-offset: 0
- * c-brace-offset: -4
- * c-argdecl-indent: 4
- * c-label-offset: -4
- * c-continued-statement-offset: 4
- * c-continued-brace-offset: 0
- * indent-tabs-mode: nil
- * tab-width: 8
- * End:
- */
-- 
2.17.0

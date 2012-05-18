From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] multipath: fix select_no_path_retry for flushing
	devices.
Date: Fri, 18 May 2012 17:33:26 -0500
Message-ID: <20120518223326.GI3343@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

The select_no_path_retry code was falling through if a flush was
in progress, and so it wasn't honoring flush_on_last_del.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/propsel.c |    1 +
 1 file changed, 1 insertion(+)

Index: multipath-tools-120403/libmultipath/propsel.c
===================================================================
--- multipath-tools-120403.orig/libmultipath/propsel.c
+++ multipath-tools-120403/libmultipath/propsel.c
@@ -415,6 +415,7 @@ select_no_path_retry(struct multipath *m
 	if (mp->flush_on_last_del == FLUSH_IN_PROGRESS) {
 		condlog(0, "flush_on_last_del in progress");
 		mp->no_path_retry = NO_PATH_RETRY_FAIL;
+		return 0;
 	}
 	if (mp->mpe && mp->mpe->no_path_retry != NO_PATH_RETRY_UNDEF) {
 		mp->no_path_retry = mp->mpe->no_path_retry;

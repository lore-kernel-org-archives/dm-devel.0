From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 06/10] multipath: set cookie before using it.
Date: Fri, 28 Oct 2016 21:55:22 -0500
Message-ID: <1477709726-5442-7-git-send-email-bmarzins@redhat.com>
References: <1477709726-5442-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1477709726-5442-1-git-send-email-bmarzins@redhat.com>
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
List-Id: dm-devel.ids

dm_task_set_cookie() expects the cookie to be initialized when it is
called, but dm_rename() didn't initialized it, causing renames to fail
some of the time.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/devmapper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index ee61ff0..546e227 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -1424,7 +1424,7 @@ dm_rename (const char * old, char * new, char *delim, int skip_kpartx)
 {
 	int r = 0;
 	struct dm_task *dmt;
-	uint32_t cookie;
+	uint32_t cookie = 0;
 	uint16_t udev_flags = DM_UDEV_DISABLE_LIBRARY_FALLBACK | ((skip_kpartx == SKIP_KPARTX_ON)? MPATH_UDEV_NO_KPARTX_FLAG : 0);
 
 	if (dm_rename_partmaps(old, new, delim))
-- 
1.8.3.1

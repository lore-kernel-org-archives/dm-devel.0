From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 01/78] libmultipath: remove compilation warning
	in devmapper.c
Date: Mon, 16 Mar 2015 13:35:48 +0100
Message-ID: <1426509425-15978-2-git-send-email-hare@suse.de>
References: <1426509425-15978-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1426509425-15978-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

When LIBDM_API_DEFERRED is not defined the compiler would warn
about 'dm_cancel_remove_partmaps' being defined but never used.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/devmapper.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 69491a3..5e68aeb 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -32,7 +32,9 @@
 #define UUID_PREFIX "mpath-"
 #define UUID_PREFIX_LEN 6
 
+#ifdef LIBDM_API_DEFERRED
 static int dm_cancel_remove_partmaps(const char * mapname);
+#endif
 
 #ifndef LIBDM_API_COOKIE
 static inline int dm_task_set_cookie(struct dm_task *dmt, uint32_t *c, int a)
-- 
1.8.4.5

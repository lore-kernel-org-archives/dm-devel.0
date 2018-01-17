From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 5/7] libmultipath: move UUID_PREFIX to devmapper.h
Date: Wed, 17 Jan 2018 08:49:37 +0100
Message-ID: <20180117074939.7795-6-mwilck@suse.com>
References: <20180117074939.7795-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180117074939.7795-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel@redhat.com
Cc: Ritika Srivastava <ritika.srivastava@oracle.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

This constant is useful elsewhere, too.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/devmapper.c | 3 ---
 libmultipath/devmapper.h | 3 +++
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 573fc75cfa54..f112e1cb0e66 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -30,9 +30,6 @@
 #define MAX_WAIT 5
 #define LOOPS_PER_SEC 5
 
-#define UUID_PREFIX "mpath-"
-#define UUID_PREFIX_LEN 6
-
 static int dm_conf_verbosity;
 
 #ifdef LIBDM_API_DEFERRED
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index 62e14d1c0b97..558e6914074f 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -24,6 +24,9 @@
 #define MPATH_UDEV_NO_PATHS_FLAG 0
 #endif
 
+#define UUID_PREFIX "mpath-"
+#define UUID_PREFIX_LEN (sizeof(UUID_PREFIX) - 1)
+
 void dm_init(int verbosity);
 void libmp_dm_init(void);
 void libmp_udev_set_sync_support(int on);
-- 
2.15.1

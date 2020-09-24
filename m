From: mwilck@suse.com
Subject: [PATCH v2 18/21] multipath: remove logsink and udev
Date: Thu, 24 Sep 2020 15:37:13 +0200
Message-ID: <20200924133716.14120-19-mwilck@suse.com>
References: <20200924133716.14120-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200924133716.14120-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

We can use libmultipath's symbols now.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/main.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/multipath/main.c b/multipath/main.c
index 4bbfce9..9ae46ed 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -66,9 +66,6 @@
 #include "valid.h"
 #include "alias.h"
 
-int logsink;
-struct udev *udev;
-
 /*
  * Return values of configure(), check_path_valid(), and main().
  */
@@ -810,7 +807,7 @@ main (int argc, char *argv[])
 	int retries = -1;
 	bool enable_foreign = false;
 
-	udev = udev_new();
+	libmultipath_init();
 	logsink = 0;
 	if (init_config(DEFAULT_CONFIGFILE))
 		exit(RTVL_FAIL);
@@ -1068,7 +1065,7 @@ out_free_config:
 	 */
 	put_multipath_config(conf);
 	uninit_config();
-	udev_unref(udev);
+	libmultipath_exit();
 	if (dev)
 		FREE(dev);
 #ifdef _DEBUG_
-- 
2.28.0

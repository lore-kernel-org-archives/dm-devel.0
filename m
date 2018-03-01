From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 3/6] libmultipath,
	alloc_path_with_pathinfo(): Declare third argument const
Date: Thu,  1 Mar 2018 11:29:32 -0800
Message-ID: <20180301192935.14643-4-bart.vanassche@wdc.com>
References: <20180301192935.14643-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180301192935.14643-1-bart.vanassche@wdc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: Bart Van Assche <bart.vanassche@wdc.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Since the third argument of this function is not modified inside that
function, declare it const.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
---
 libmultipath/discovery.c | 2 +-
 libmultipath/discovery.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index fe50ce5062ea..d84715e15db1 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -34,7 +34,7 @@
 
 int
 alloc_path_with_pathinfo (struct config *conf, struct udev_device *udevice,
-			  char *wwid, int flag, struct path **pp_ptr)
+			  const char *wwid, int flag, struct path **pp_ptr)
 {
 	int err = PATHINFO_FAILED;
 	struct path * pp;
diff --git a/libmultipath/discovery.h b/libmultipath/discovery.h
index b151cc7a39a8..bd5e6678a26d 100644
--- a/libmultipath/discovery.h
+++ b/libmultipath/discovery.h
@@ -38,7 +38,7 @@ int get_state (struct path * pp, struct config * conf, int daemon, int state);
 int get_vpd_sgio (int fd, int pg, char * str, int maxlen);
 int pathinfo (struct path * pp, struct config * conf, int mask);
 int alloc_path_with_pathinfo (struct config *conf, struct udev_device *udevice,
-			      char *wwid, int flag, struct path **pp_ptr);
+			      const char *wwid, int flag, struct path **pp_ptr);
 int store_pathinfo (vector pathvec, struct config *conf,
 		    struct udev_device *udevice, int flag,
 		    struct path **pp_ptr);
-- 
2.16.2

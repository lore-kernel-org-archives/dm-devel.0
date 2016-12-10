From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: [PATCH 1/2] libmultipath: export path_discover()
Date: Sat, 10 Dec 2016 14:05:22 -0200
Message-ID: <1481385923-12407-1-git-send-email-mauricfo@linux.vnet.ibm.com>
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
To: dm-devel@redhat.com, christophe.varoqui@opensvc.com
List-Id: dm-devel.ids

In order to call path_discover() from multipathd (for the next patch),
make it visible to other units (header declaration, static modifier).

Signed-off-by: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
---
 libmultipath/discovery.c | 2 +-
 libmultipath/discovery.h | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 7b5b434..865b53b 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -106,7 +106,7 @@ out:
 	return err;
 }
 
-static int
+int
 path_discover (vector pathvec, struct config * conf,
 	       struct udev_device *udevice, int flag)
 {
diff --git a/libmultipath/discovery.h b/libmultipath/discovery.h
index 3039268..34a41d4 100644
--- a/libmultipath/discovery.h
+++ b/libmultipath/discovery.h
@@ -31,6 +31,8 @@
 struct config;
 
 int path_discovery (vector pathvec, int flag);
+int path_discover (vector pathvec, struct config * conf,
+		   struct udev_device *udevice, int flag);
 
 int do_tur (char *);
 int path_offline (struct path *);
-- 
2.7.4

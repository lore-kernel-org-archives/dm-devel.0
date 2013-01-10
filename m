From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v2] multipath: make path devices readonly again.
Date: Thu, 10 Jan 2013 15:02:06 -0600
Message-ID: <20130110210206.GD19059@ether.msp.redhat.com>
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
Cc: "Chauhan, Vijay" <Vijay.Chauhan@netapp.com>, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

Path device fds were changed to be opened read/write when the
mpathpersist code was added. However, I have talked with Vijay, and
this doesn't appear to be necessary for mpathpersist to work correctly.
If the path fds are opened read/write, when the are closed a change
uevent is triggered, which was causing problems during shutdown with
LVM on top of multipath devices. This patch reverts them to being read-only
again.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/discovery.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: multipath-tools-130109/libmultipath/discovery.c
===================================================================
--- multipath-tools-130109.orig/libmultipath/discovery.c
+++ multipath-tools-130109/libmultipath/discovery.c
@@ -886,7 +886,7 @@ pathinfo (struct path *pp, vector hwtabl
 	 * fetch info not available through sysfs
 	 */
 	if (pp->fd < 0)
-		pp->fd = open(udev_device_get_devnode(pp->udev), O_RDWR);
+		pp->fd = open(udev_device_get_devnode(pp->udev), O_RDONLY);
 
 	if (pp->fd < 0) {
 		condlog(4, "Couldn't open node for %s: %s",

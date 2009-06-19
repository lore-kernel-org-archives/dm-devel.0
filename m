From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH -next] dm: dm-log-userspace depends on NET
Date: Fri, 19 Jun 2009 10:38:21 -0700
Message-ID: <4A3BCD0D.3010801@oracle.com>
References: <20090619172622.05adb236.sfr@canb.auug.org.au>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090619172622.05adb236.sfr@canb.auug.org.au>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: dm-devel@redhat.com, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-Id: dm-devel.ids

From: Randy Dunlap <randy.dunlap@oracle.com>

DM_LOG_USERSPACE selects CONNECTOR, but when NET is not enabled, this is
useless and the build fails, so make DM_LOG_USERSPACE depend on NET.

ERROR: "netlink_has_listeners" [drivers/connector/cn.ko] undefined!
ERROR: "proc_net_fops_create" [drivers/connector/cn.ko] undefined!
ERROR: "netlink_kernel_create" [drivers/connector/cn.ko] undefined!
ERROR: "proc_net_remove" [drivers/connector/cn.ko] undefined!
ERROR: "netlink_kernel_release" [drivers/connector/cn.ko] undefined!
ERROR: "init_net" [drivers/connector/cn.ko] undefined!
ERROR: "__alloc_skb" [drivers/connector/cn.ko] undefined!
ERROR: "netlink_broadcast" [drivers/connector/cn.ko] undefined!
ERROR: "kfree_skb" [drivers/connector/cn.ko] undefined!
ERROR: "skb_put" [drivers/connector/cn.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jonathan Brassow <dm-devel@redhat.com>
Cc: dm-devel@redhat.com
---
 drivers/md/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20090619.orig/drivers/md/Kconfig
+++ linux-next-20090619/drivers/md/Kconfig
@@ -233,7 +233,7 @@ config DM_MIRROR
 
 config DM_LOG_USERSPACE
 	tristate "Mirror userspace logging (EXPERIMENTAL)"
-	depends on DM_MIRROR && EXPERIMENTAL
+	depends on DM_MIRROR && EXPERIMENTAL && NET
 	select CONNECTOR
 	---help---
 	  The userspace logging module provides a mechanism for



-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/

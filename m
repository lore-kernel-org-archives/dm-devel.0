From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] multipath: make multipathd work with new dm/lvm
	systemd	activation method
Date: Mon, 7 Jan 2013 23:50:34 -0600
Message-ID: <20130108055034.GD19059@ether.msp.redhat.com>
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
Cc: Peter Rajnoha <prajnoha@redhat.com>, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

multipathd needs to get setup before lvm (lvm2-activation-early.service).
To do this, it needs to get started in sysinit.target like the other
dm services.

Signed-off-by: Peter Rajnoha <prajnoha@redhat.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/multipathd.service |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: multipath-tools-120821/multipathd/multipathd.service
===================================================================
--- multipath-tools-120821.orig/multipathd/multipathd.service
+++ multipath-tools-120821/multipathd/multipathd.service
@@ -1,7 +1,9 @@
 [Unit]
 Description=Device-Mapper Multipath Device Controller
-Before=iscsi.service iscsid.service
+Before=iscsi.service iscsid.service lvm2-activation-early.service
 After=syslog.target
+DefaultDependencies=no
+Conflicts=shutdown.target
 
 [Service]
 Type=forking
@@ -11,4 +13,4 @@ ExecReload=/sbin/multipathd reconfigure
 #ExecStop=/path/to/scrip delete-me if not necessary
 
 [Install]
-WantedBy=multi-user.target
+WantedBy=sysinit.target

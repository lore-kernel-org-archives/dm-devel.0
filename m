From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 10/78] Fixup multipathd.socket to resolve
	ordering dependeny
Date: Mon, 16 Mar 2015 13:35:57 +0100
Message-ID: <1426509425-15978-11-git-send-email-hare@suse.de>
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

Per default any socket file is started after /run is available,
as the socket might be placed there.
This results in a dependency cycle as multipathd requires the
socket, but the daemon should be started as early as possible,
and certainly before /run is mounted.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 multipathd/multipathd.service | 3 ++-
 multipathd/multipathd.socket  | 8 +++++---
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/multipathd/multipathd.service b/multipathd/multipathd.service
index be3ba3f..1ecc151 100644
--- a/multipathd/multipathd.service
+++ b/multipathd/multipathd.service
@@ -1,8 +1,9 @@
 [Unit]
 Description=Device-Mapper Multipath Device Controller
 Before=iscsi.service iscsid.service lvm2-activation-early.service
-After=syslog.target
+Before=local-fs-pre.target
 DefaultDependencies=no
+Wants=multipathd.socket
 Conflicts=shutdown.target
 
 [Service]
diff --git a/multipathd/multipathd.socket b/multipathd/multipathd.socket
index 3d4b6da..921706d 100644
--- a/multipathd/multipathd.socket
+++ b/multipathd/multipathd.socket
@@ -1,5 +1,7 @@
+[Unit]
+Description=multipathd control socket
+DefaultDependencies=no
+Before=sockets.target
+
 [Socket]
 ListenStream=@/org/kernel/linux/storage/multipathd
-
-[Install]
-WantedBy=sockets.target
-- 
1.8.4.5

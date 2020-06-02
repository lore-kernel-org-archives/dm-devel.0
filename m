From: mwilck@suse.com
Subject: [PATCH] 11-dm-mpath.rules: Fix udev rule processing
	during coldplug
Date: Tue,  2 Jun 2020 17:54:43 +0200
Message-ID: <20200602155443.14072-1-mwilck@suse.com>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

DM_SUBSYSTEM_UDEV_FLAG0 is used to indicate that upper layer
udev rules don't need to be processed for multipath maps, e.g.
for map reloads.

However, this can fail if maps were created during initrd processing,
but udev processing for the change events of these maps didn't
complete because udevd was killed to switch root. So, in the coldplug
case, play safe and process the rules once more.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/11-dm-mpath.rules | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/multipath/11-dm-mpath.rules b/multipath/11-dm-mpath.rules
index cd522e8c..34c21fd1 100644
--- a/multipath/11-dm-mpath.rules
+++ b/multipath/11-dm-mpath.rules
@@ -52,8 +52,13 @@ LABEL="mpath_action"
 # something that should be reacted upon since it would be useless extra work.
 # It's exactly mpath's job to provide *seamless* device access to any of the
 # paths that are available underneath.
+# Exception: On cold-plug, if the map had already been set up before,
+# do process upper layers, because rule processing may not necessarily have
+# completed during initrd processing.
+ACTION=="add", ENV{.MPATH_DEVICE_READY_OLD}=="1", GOTO="process_reload"
 ENV{DM_SUBSYSTEM_UDEV_FLAG0}=="1", \
 	ENV{DM_ACTIVATION}="0", ENV{MPATH_UNCHANGED}="1"
+LABEL="process_reload"
 
 # For path failed or reinstated events, unset DM_ACTIVATION.
 # This is similar to the DM_SUBSYSTEM_UDEV_FLAG0 case above.
-- 
2.26.2

From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 6/7] multipath: delegate flushing maps to
	multipathd
Date: Wed, 17 Jun 2020 19:24:26 -0500
Message-ID: <1592439867-18427-7-git-send-email-bmarzins@redhat.com>
References: <1592439867-18427-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1592439867-18427-1-git-send-email-bmarzins@redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

Since there can be problems with removing maps outside of multipathd,
multipath should attempt to delegate this command to multipathd.
However, multipathd doesn't attempt to suspend the device, in order
to avoid potential hangs. If delegating to multipathd fails, multipath
should try the remove itself.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipath/main.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/multipath/main.c b/multipath/main.c
index 101fd656..6a24e483 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -820,6 +820,20 @@ int delegate_to_multipathd(enum mpath_cmds cmd,
 	if (cmd == CMD_CREATE && conf->force_reload == FORCE_RELOAD_YES) {
 		p += snprintf(p, n, "reconfigure");
 	}
+	else if (cmd == CMD_FLUSH_ONE && dev && dev_type == DEV_DEVMAP) {
+		p += snprintf(p, n, "del map %s", dev);
+		/* multipathd doesn't try as hard, to avoid potentially
+		 * hanging. If it fails, retry with the regular multipath
+		 * command */
+		r = NOT_DELEGATED;
+	}
+	else if (cmd == CMD_FLUSH_ALL) {
+		p += snprintf(p, n, "del maps");
+		/* multipathd doesn't try as hard, to avoid potentially
+		 * hanging. If it fails, retry with the regular multipath
+		 * command */
+		r = NOT_DELEGATED;
+	}
 	/* Add other translations here */
 
 	if (strlen(command) == 0)
-- 
2.17.2

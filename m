From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH 7/21] [multipathd] Fix handling of device-mapper
	devices
Date: Mon, 21 May 2007 11:23:39 +0200
Message-ID: <20070521092339.C78AED44CB@pentland.suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <cvaroqui@free.fr>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


Device-mapper devices are available only after a 'change' event,
so it's quite pointless to check for the 'add' event.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 multipathd/main.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 9975dd8..94b0b95 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -648,10 +648,12 @@ uev_trigger (struct uevent * uev, void *
 	lock(vecs->lock);
 
 	/*
-	 * device map add/remove event
+	 * device map event
+	 * Add events are ignored here as the tables
+	 * are not fully initialised then.
 	 */
 	if (!strncmp(devname, "dm-", 3)) {
-		if (!strncmp(uev->action, "add", 3)) {
+		if (!strncmp(uev->action, "change", 6)) {
 			r = uev_add_map(devname, vecs);
 			goto out;
 		}
-- 
1.4.3.4

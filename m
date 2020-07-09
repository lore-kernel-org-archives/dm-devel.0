From: mwilck@suse.com
Subject: [PATCH 75/80] multipathd: uev_trigger(): handle
	incomplete ADD events
Date: Thu,  9 Jul 2020 13:03:25 +0200
Message-ID: <20200709110330.9917-2-mwilck@suse.com>
References: <20200709110330.9917-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200709110330.9917-1-mwilck@suse.com>
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

Udev may be killed after handling the ADD event for a multipath map,
but before handling the subsequent CHANGE event that populates the
udev data base with the device properties (e.g. during initrd processing).
If this happens, the ADD uevent sent during coldplug will only provide a
subset of the device properties. We need another CHANGE event to make the map
available to the system.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/multipathd/main.c b/multipathd/main.c
index 66ca4e3..29227cd 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1508,6 +1508,31 @@ uev_trigger (struct uevent * uev, void * trigger_data)
 			uev_pathfail_check(uev, vecs);
 		} else if (!strncmp(uev->action, "remove", 6)) {
 			r = uev_remove_map(uev, vecs);
+		} else if (!strncmp(uev->action, "add", 3)) {
+			const char *ev_name;
+			char *dm_name;
+			int major = -1, minor = -1;
+
+			/*
+			 * If DM_NAME is not set for a valid map, trigger a
+			 * change event. This can happen during coldplug
+			 * if udev was killed between handling the 'add' and
+			 * 'change' events before.
+			 */
+			ev_name = uevent_get_dm_name(uev);
+			if (!ev_name) {
+				major = uevent_get_major(uev);
+				minor = uevent_get_minor(uev);
+				dm_name = dm_mapname(major, minor);
+				if (dm_name && *dm_name) {
+					condlog(2, "%s: received incomplete 'add' uevent, triggering change",
+						dm_name);
+					udev_device_set_sysattr_value(uev->udev,
+								      "uevent",
+								      "change");
+					free(dm_name);
+				}
+			}
 		}
 		goto out;
 	}
-- 
2.26.2

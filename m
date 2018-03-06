From: Chongyun Wu <wu.chongyun@h3c.com>
Subject: [PATCH RESEND] multipathd: check and cleanup zombie paths
Date: Tue, 6 Mar 2018 01:26:35 +0000
Message-ID: <CEB9978CF3252343BE3C67AC9F0086A34295C7AB@H3CMLB14-EX.srv.huawei-3com.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: zh-CN
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>, 'Christophe Varoqui' <christophe.varoqui@opensvc.com>, 'Hannes Reinecke' <hare@suse.de>, 'Xose Vazquez Perez' <xose.vazquez@gmail.com>
Cc: Guozhonghua <guozhonghua@h3c.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Changlimin <changlimin@h3c.com>, Changwei Ge <ge.changwei@h3c.com>
List-Id: dm-devel.ids

The same LUN have been exported to the host from different lun
number twice, each time create multipath for this lun, after
second time the multipath might have zombie paths which devices
doesn't actually exist.

Check zombie paths:
If a failed path have the same wwid with an active path, but its
sg_id.lun are not equal to this active path. This failed path
might be a zombie path(a lun can't be exported from a different
lun number to a host at the same time).

cleanup zombie paths:
delete the zombie paths' device from sysfs, which will clean up
the zombie paths both in kernel and userspace.

Signed-off-by: Chongyun Wu <wu.chongyun@h3c.com>
---
   multipathd/main.c |   42 ++++++++++++++++++++++++++++++++++++++++++
   1 file changed, 42 insertions(+)

diff --git a/multipathd/main.c b/multipathd/main.c
index 27cf234..e74a448 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1511,6 +1511,44 @@ void repair_path(struct path * pp)
   	LOG_MSG(1, checker_message(&pp->checker));
   }

+void try_cleanup_zombie_path(struct vectors *vecs, struct path *pp)
+{
+	struct path *pp_tmp;
+	unsigned int i;
+	struct config *conf;
+	int path_state;
+	const char delete[] = "1";
+
+	/*check if this given path is a zombie path*/
+	vector_foreach_slot(vecs->pathvec, pp_tmp, i) {
+		if ((strcmp(pp_tmp->wwid, pp->wwid) == 0) &&
+			(pp_tmp->state == PATH_UP)) {
+			/*to get the state again to avoid getting
+			 *the old state
+			 */
+			conf = get_multipath_config();
+			path_state = get_state(pp_tmp, conf, 1);
+			put_multipath_config(conf);
+
+			if ((path_state == PATH_UP) &&
+				(pp_tmp->sg_id.lun != pp->sg_id.lun)) {
+				/*
+				 * The given path is a failed path,
+				 * found a active path with the same wwid and
+				 * it's sg_id.lun isn't equal to the given path,
+				 * that means that the given is a zombie path!
+				 * Clean up zombie path then.
+				 */
+				condlog(2, "clean up zombie path %s(%s)",
+					pp->dev, pp->wwid);
+				sysfs_attr_set_value(pp->udev, "device/delete",
+						delete, strlen(delete));
+				break;
+			}
+		}
+	}
+}
+
   /*
    * Returns '1' if the path has been checked, '-1' if it was blacklisted
    * and '0' otherwise
@@ -1580,6 +1618,10 @@ check_path (struct vectors * vecs, struct path *
pp, int ticks)
   		newstate = PATH_DOWN;
   	}

+	if (newstate == PATH_DOWN) {
+		try_cleanup_zombie_path(vecs, pp);
+	}
+
   	if (newstate == PATH_WILD || newstate == PATH_UNCHECKED) {
   		condlog(2, "%s: unusable path", pp->dev);
   		conf = get_multipath_config();
-- 
1.7.9.5

From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/3] libmultipath: call get_vpd_uid() if no
	uid_attribute is set
Date: Fri, 15 Jul 2016 08:48:55 +0200
Message-ID: <1468565337-5178-2-git-send-email-hare@suse.de>
References: <1468565337-5178-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1468565337-5178-1-git-send-email-hare@suse.de>
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
Cc: Hannes Reinecke <hare@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

If the uid_attribute is unset we should be calling get_vpd_uid()
directly without waiting for retrigger udev events.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmultipath/discovery.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 9fcede7..e9e0313 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1569,6 +1569,9 @@ get_uid (struct path * pp, int path_state)
 					"%s: failed to get udev uid: %s",
 					pp->dev, strerror(-len));
 
+		} else {
+			len = get_vpd_uid(pp);
+			origin = "sysfs";
 		}
 		conf = get_multipath_config();
 		retrigger = conf->retrigger_tries;
-- 
2.6.6

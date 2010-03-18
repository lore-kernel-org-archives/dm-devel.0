From: Milan Broz <mbroz@redhat.com>
Subject: [PATCH 3/3] Do not send multiple REMOVE events for
	kobjects.
Date: Thu, 18 Mar 2010 14:58:14 +0100
Message-ID: <1268920694-10960-3-git-send-email-mbroz@redhat.com>
References: <1268920694-10960-1-git-send-email-mbroz@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1268920694-10960-1-git-send-email-mbroz@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, kay.sievers@vrfy.org
Cc: Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

If the KOBJ_REMOVE was sent already there is no need
to send it again.

One example is when device-mapper device send explicit REMOVE
event with additional DM environment values (cookie) when mapping
table is being destroyed (device is unusable after that) and
underlying block device sends another REMOVE event unconditionally
in its destructor.

Signed-off-by: Milan Broz <mbroz@redhat.com>
---
 lib/kobject_uevent.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/lib/kobject_uevent.c b/lib/kobject_uevent.c
index c9d3a3e..c7881bd 100644
--- a/lib/kobject_uevent.c
+++ b/lib/kobject_uevent.c
@@ -125,6 +125,15 @@ int kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
 				 kobject_name(kobj), kobj, __func__);
 		return 0;
 	}
+
+	/* skip remove event, if already sent*/
+	if (action == KOBJ_REMOVE && kobj->state_remove_uevent_sent) {
+		pr_debug("kobject: '%s' (%p): %s: ignoring "
+				 "already sent remove event!\n",
+				 kobject_name(kobj), kobj, __func__);
+		return 0;
+	}
+
 	/* skip the event, if the filter returns zero. */
 	if (uevent_ops && uevent_ops->filter)
 		if (!uevent_ops->filter(kset, kobj)) {
-- 
1.7.0

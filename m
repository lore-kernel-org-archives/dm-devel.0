From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH v2 12/17] libmutipath: don't use malformed uevents
Date: Wed,  8 Aug 2018 17:21:30 -0500
Message-ID: <1533766895-28605-13-git-send-email-bmarzins@redhat.com>
References: <1533766895-28605-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1533766895-28605-1-git-send-email-bmarzins@redhat.com>
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
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

A uevent that doesn't include the ACTION and DEVPATH fields is
malformed. It should be ignored, instead of used with those fields being
NULL.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/uevent.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index fd8ca35..5f910e6 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -729,6 +729,12 @@ struct uevent *uevent_from_udev_device(struct udev_device *dev)
 		if (i == HOTPLUG_NUM_ENVP - 1)
 			break;
 	}
+	if (!uev->devpath || ! uev->action) {
+		udev_device_unref(dev);
+		condlog(1, "uevent missing necessary fields");
+		FREE(uev);
+		return NULL;
+	}
 	uev->udev = dev;
 	uev->envp[i] = NULL;
 
-- 
2.7.4

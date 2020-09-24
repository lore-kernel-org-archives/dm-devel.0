From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [RFC PATCH v2 3/3] libmultipath: change log level for
	null uid_attribute
Date: Wed, 23 Sep 2020 23:59:29 -0500
Message-ID: <1600923569-17412-4-git-send-email-bmarzins@redhat.com>
References: <1600923569-17412-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1600923569-17412-1-git-send-email-bmarzins@redhat.com>
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

If uid_attribute is explicitly set to an empty string, multipath should
log the uid at the default log level, since using the fallback code is
the expected behavior.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/discovery.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index f650534f..435f2639 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -2091,7 +2091,8 @@ get_uid (struct path * pp, int path_state, struct udev_device *udev,
 		}
 		if ((!udev_available || (len <= 0 && allow_fallback))
 		    && has_uid_fallback(pp)) {
-			used_fallback = 1;
+			if (udev_available || !(udev && pp->uid_attribute))
+				used_fallback = 1;
 			len = uid_fallback(pp, path_state, &origin);
 		}
 	}
-- 
2.17.2

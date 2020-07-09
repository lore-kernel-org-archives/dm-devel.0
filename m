From: mwilck@suse.com
Subject: [PATCH 21/35] libmultipath: get_udev_uid(): more
	appropriate error code
Date: Thu,  9 Jul 2020 12:16:06 +0200
Message-ID: <20200709101620.6786-22-mwilck@suse.com>
References: <20200709101620.6786-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200709101620.6786-1-mwilck@suse.com>
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

An uid_attribute that is not found is not necessarily invalid
input. "No data available" seems more appropriate.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 1039fc4..81c78d3 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1897,7 +1897,7 @@ get_udev_uid(struct path * pp, char *uid_attribute, struct udev_device *udev)
 	} else {
 		condlog(3, "%s: no %s attribute", pp->dev,
 			uid_attribute);
-		len = -EINVAL;
+		len = -ENODATA;
 	}
 	return len;
 }
-- 
2.26.2

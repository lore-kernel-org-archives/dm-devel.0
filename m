From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 5/6] libmultipath: deal with flushing no maps
Date: Mon, 27 Jul 2020 14:24:27 -0500
Message-ID: <1595877868-5595-6-git-send-email-bmarzins@redhat.com>
References: <1595877868-5595-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1595877868-5595-1-git-send-email-bmarzins@redhat.com>
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

dm_flush_maps() was failing if there were no device-mapper devices at
all, instead of returning success, since there is nothing to do.

Fixes: "libmultipath: make dm_flush_maps only return 0 on success"
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/devmapper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 126cd728..b8199cb5 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -1024,10 +1024,10 @@ int dm_flush_maps (int need_suspend, int retries)
 	if (!(names = dm_task_get_names (dmt)))
 		goto out;
 
+	r = 0;
 	if (!names->dev)
 		goto out;
 
-	r = 0;
 	do {
 		if (need_suspend)
 			r |= dm_suspend_and_flush_map(names->name, retries);
-- 
2.17.2

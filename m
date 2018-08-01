From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 14/32] kpartx: fix bad dm_devn return
Date: Wed,  1 Aug 2018 15:57:00 -0500
Message-ID: <1533157038-3924-15-git-send-email-bmarzins@redhat.com>
References: <1533157038-3924-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1533157038-3924-1-git-send-email-bmarzins@redhat.com>
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

dm_devn shouldn't be returning success if you can't create a dm task to
find the device info. Found by coverity.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 kpartx/devmapper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kpartx/devmapper.c b/kpartx/devmapper.c
index cd33449..8db1eb5 100644
--- a/kpartx/devmapper.c
+++ b/kpartx/devmapper.c
@@ -365,7 +365,7 @@ dm_devn (const char * mapname, int *major, int *minor)
 	struct dm_info info;
 
 	if (!(dmt = dm_task_create(DM_DEVICE_INFO)))
-		return 0;
+		return 1;
 
 	if (!dm_task_set_name(dmt, mapname))
 		goto out;
-- 
2.7.4

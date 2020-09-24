From: mwilck@suse.com
Subject: [PATCH 03/11] libmultipath: dm_map_present_by_uuid():
	fix dm_task_create() call
Date: Thu, 24 Sep 2020 15:36:36 +0200
Message-ID: <20200924133644.14034-4-mwilck@suse.com>
References: <20200924133644.14034-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200924133644.14034-1-mwilck@suse.com>
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

libmultipath shouldn't call dm_task_create() directly any more.

Fixes: 90535a3 ("multipath: centralize validation code")
---
 libmultipath/devmapper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index b4d77cb..7394796 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -834,7 +834,7 @@ dm_map_present_by_uuid(const char *uuid)
 	if (safe_sprintf(prefixed_uuid, UUID_PREFIX "%s", uuid))
 		goto out;
 
-	if (!(dmt = dm_task_create(DM_DEVICE_INFO)))
+	if (!(dmt = libmp_dm_task_create(DM_DEVICE_INFO)))
 		goto out;
 
 	dm_task_no_open_count(dmt);
-- 
2.28.0

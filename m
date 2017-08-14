From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 1/3] kpartx/devmapper.h: remove dm_no_partitions
Date: Mon, 14 Aug 2017 22:40:41 +0200
Message-ID: <20170814204043.17640-2-mwilck@suse.com>
References: <20170814204043.17640-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170814204043.17640-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

This removes the deleted function from the header file.

Fixes: 2ea69fc9 'kpartx: remove "no_partitions" support'
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 kpartx/devmapper.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kpartx/devmapper.h b/kpartx/devmapper.h
index 2e28c780..f00373e0 100644
--- a/kpartx/devmapper.h
+++ b/kpartx/devmapper.h
@@ -19,6 +19,5 @@ dev_t dm_get_first_dep(char *devname);
 char * dm_mapuuid(const char *mapname);
 int dm_devn (const char * mapname, int *major, int *minor);
 int dm_remove_partmaps (char * mapname, char *uuid, dev_t devt, int verbose);
-int dm_no_partitions(char * mapname);
 
 #endif /* _KPARTX_DEVMAPPER_H */
-- 
2.14.0

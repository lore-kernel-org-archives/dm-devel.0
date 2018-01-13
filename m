From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 04/20] libmultipath: fix return code of
	sysfs_get_timeout
Date: Sat, 13 Jan 2018 22:19:22 +0100
Message-ID: <20180113211938.31552-5-mwilck@suse.com>
References: <20180113211938.31552-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180113211938.31552-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

This function should return 1 on success, as the other sysfs_get_XXX
functions. The callers actually expect this - therefore timeout values
from sysfs are never used.
---
 libmultipath/discovery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 4b31ddef23f0..ab7794d8d2e1 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -276,7 +276,7 @@ sysfs_get_timeout(struct path *pp, unsigned int *timeout)
 	}
 	*timeout = t;
 
-	return 0;
+	return 1;
 }
 
 int
-- 
2.15.1

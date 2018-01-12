From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 05/14] libmultipath: fix return code of
	sysfs_get_timeout
Date: Fri, 12 Jan 2018 23:07:34 +0100
Message-ID: <20180112220743.11513-6-mwilck@suse.com>
References: <20180112220743.11513-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180112220743.11513-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel@redhat.com
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

This function should return 1 on success, as the other sysfs_get_XXX
functions. The callers actually expect this - therefore timeout values
from sysfs are never used.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index cadf4617894f..3ae934261b65 100644
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

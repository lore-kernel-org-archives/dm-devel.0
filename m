From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 05/12] libmultipath(coverity): fix apparent
	overflow
Date: Tue,  8 Jan 2019 23:54:02 +0100
Message-ID: <20190108225409.15977-6-mwilck@suse.com>
References: <20190108225409.15977-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190108225409.15977-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

"preferred_path" contains always "0" or "1".

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 7f983a6..3fd79a3 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -520,7 +520,7 @@ sysfs_get_asymmetric_access_state(struct path *pp, char *buff, int buflen)
 		/* Parse error, ignore */
 		return 0;
 	}
-	return  preferred;
+	return !!preferred;
 }
 
 static void
-- 
2.19.2

From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 1/2] libmultipath: free allocated value in set_int
Date: Thu, 11 Oct 2018 15:43:47 -0500
Message-ID: <1539290628-16948-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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

set_int() needs to free the buffer it got back from set_value()

Fixes: 8f9ac30d ("libmultipath: fix set_int error path")
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/dict.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index bf4701e..c3f5a6e 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -39,6 +39,7 @@ set_int(vector strvec, void *ptr)
 
 	*int_ptr = atoi(buff);
 
+	FREE(buff);
 	return 0;
 }
 
-- 
2.7.4

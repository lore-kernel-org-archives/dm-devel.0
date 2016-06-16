From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 05/39] libmultipath: memory leak in
	remove_feature()
Date: Thu, 16 Jun 2016 11:47:11 +0200
Message-ID: <1466070465-1021-6-git-send-email-hare@suse.de>
References: <1466070465-1021-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1466070465-1021-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: Hannes Reinecke <hare@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Upon error the 'n' string was never freed.
Found by coverity.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmultipath/structs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index 502d98e..ed62b07 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -653,9 +653,11 @@ remove_feature(char **f, char *o)
 	 * about to be removed
 	 */
 	p = strchr(*f, ' ');
-	if (!p)
+	if (!p) {
 		/* Internal error, feature string inconsistent */
+		FREE(n);
 		return 1;
+	}
 	while (*p == ' ')
 		p++;
 	p--;
-- 
2.6.6

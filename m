From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 10/39] libmultipath/alias.c: check return value
	from strchr()
Date: Thu, 16 Jun 2016 11:47:16 +0200
Message-ID: <1466070465-1021-11-git-send-email-hare@suse.de>
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

Found by coverity.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmultipath/alias.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/libmultipath/alias.c b/libmultipath/alias.c
index 5fdcdb5..b86843a 100644
--- a/libmultipath/alias.c
+++ b/libmultipath/alias.c
@@ -229,7 +229,8 @@ allocate_binding(int fd, char *wwid, int id, char *prefix)
 		return NULL;
 	}
 	c = strchr(buf, ' ');
-	*c = '\0';
+	if (c)
+		*c = '\0';
 	alias = strdup(buf);
 	if (alias == NULL)
 		condlog(0, "cannot copy new alias from bindings file : %s",
-- 
2.6.6

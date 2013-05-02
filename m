From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 14/16] Stop annoying prio_lookup warning messages
Date: Thu,  2 May 2013 16:46:35 -0500
Message-ID: <1367531197-8987-15-git-send-email-bmarzins@redhat.com>
References: <1367531197-8987-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1367531197-8987-1-git-send-email-bmarzins@redhat.com>
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
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

Multipath shouldn't try to look up its prioritizer if it doesn't have
one. Doing so just causes annoying warning messages.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/prio.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/libmultipath/prio.c b/libmultipath/prio.c
index 8e6b93e..186cc4d 100644
--- a/libmultipath/prio.c
+++ b/libmultipath/prio.c
@@ -162,7 +162,10 @@ void prio_put (struct prio * dst)
 	if (!dst)
 		return;
 
-	src = prio_lookup(dst->name);
+	if (!strlen(dst->name))
+		src = NULL;
+	else
+		src = prio_lookup(dst->name);
 	memset(dst, 0x0, sizeof(struct prio));
 	free_prio(src);
 }
-- 
1.8.2

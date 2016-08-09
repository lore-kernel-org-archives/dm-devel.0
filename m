From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/3] libmultipath/parser.c: correctly terminate
	buffer
Date: Tue,  9 Aug 2016 09:31:12 +0200
Message-ID: <1470727873-10502-3-git-send-email-hare@suse.de>
References: <1470727873-10502-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1470727873-10502-1-git-send-email-hare@suse.de>
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
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>, Hannes Reinecke <hare@suse.com>
List-Id: dm-devel.ids

The code would be returning a static NULL buffer instead of
terminating the original buffer.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmultipath/parser.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/parser.c b/libmultipath/parser.c
index dd955f3..c47d891 100644
--- a/libmultipath/parser.c
+++ b/libmultipath/parser.c
@@ -171,7 +171,7 @@ snprint_keyword(char *buff, int len, char *fmt, struct keyword *kw, void *data)
 			r = kw->print(conf, buff + fwd, len - fwd, data);
 			put_multipath_config(conf);
 			if (!r) { /* no output if no value */
-				buff = '\0';
+				buff[0] = '\0';
 				return 0;
 			}
 			fwd += r;
-- 
2.6.6

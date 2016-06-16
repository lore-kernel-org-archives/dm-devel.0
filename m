From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 07/39] libmultipath: missing NULL check in
	set_pgfailback()
Date: Thu, 16 Jun 2016 11:47:13 +0200
Message-ID: <1466070465-1021-8-git-send-email-hare@suse.de>
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
 libmultipath/dict.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 7f912ec..9920a9b 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -805,6 +805,8 @@ set_pgfailback(vector strvec, void *ptr)
 	char * buff;
 
 	buff = set_value(strvec);
+	if (!buff)
+		return 1;
 
 	if (strlen(buff) == 6 && !strcmp(buff, "manual"))
 		*int_ptr = -FAILBACK_MANUAL;
-- 
2.6.6

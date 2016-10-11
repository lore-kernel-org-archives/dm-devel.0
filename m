From: Mike Christie <mchristi@redhat.com>
Subject: [PATCH 2/5] rbd: check for nonshared clients
Date: Tue, 11 Oct 2016 16:36:52 -0500
Message-ID: <1476221815-17900-3-git-send-email-mchristi@redhat.com>
References: <1476221815-17900-1-git-send-email-mchristi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1476221815-17900-1-git-send-email-mchristi@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, christophe.varoqui@opensvc.com
Cc: Mike Christie <mchristi@redhat.com>
List-Id: dm-devel.ids

The rbd checker only supports nonshared clients so add a check
during init time.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 libmultipath/checkers/rbd.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/libmultipath/checkers/rbd.c b/libmultipath/checkers/rbd.c
index 8f88154..f0497db 100644
--- a/libmultipath/checkers/rbd.c
+++ b/libmultipath/checkers/rbd.c
@@ -124,6 +124,11 @@ int libcheck_init(struct checker * c)
 	if (!config_info)
 		goto free_addr;
 
+	if (!strstr(config_info, "noshare")) {
+		condlog(3, "Only nonshared clients supported.");
+		goto free_addr;
+	}
+
 	ct->config_info = strdup(config_info);
 	if (!ct->config_info)
 		goto free_addr;
-- 
2.7.2

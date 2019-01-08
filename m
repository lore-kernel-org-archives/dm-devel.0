From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 10/12] libmpathpersist(coverity): range checking
	for PRIN length
Date: Tue,  8 Jan 2019 23:54:07 +0100
Message-ID: <20190108225409.15977-11-mwilck@suse.com>
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

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathpersist/mpath_pr_ioctl.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/libmpathpersist/mpath_pr_ioctl.c b/libmpathpersist/mpath_pr_ioctl.c
index c4f4ccd..cf528fe 100644
--- a/libmpathpersist/mpath_pr_ioctl.c
+++ b/libmpathpersist/mpath_pr_ioctl.c
@@ -211,7 +211,8 @@ void mpath_format_readfullstatus(struct prin_resp *pr_buff, int len, int noisy)
 	unsigned char *p;
 	char  *ppbuff;
 	uint32_t additional_length;
-
+	char tempbuff[MPATH_MAX_PARAM_LEN];
+	struct prin_fulldescr fdesc;
 
 	convert_be32_to_cpu(&pr_buff->prin_descriptor.prin_readfd.prgeneration);
 	convert_be32_to_cpu(&pr_buff->prin_descriptor.prin_readfd.number_of_descriptor);
@@ -223,9 +224,12 @@ void mpath_format_readfullstatus(struct prin_resp *pr_buff, int len, int noisy)
 	}
 
 	additional_length = pr_buff->prin_descriptor.prin_readfd.number_of_descriptor;
+	if (additional_length > MPATH_MAX_PARAM_LEN) {
+		condlog(3, "PRIN length %u exceeds max length %d", additional_length,
+			MPATH_MAX_PARAM_LEN);
+		return;
+	}
 
-	char tempbuff[MPATH_MAX_PARAM_LEN];
-	struct prin_fulldescr fdesc;
 	memset(&fdesc, 0, sizeof(struct prin_fulldescr));
 
 	memcpy( tempbuff, pr_buff->prin_descriptor.prin_readfd.private_buffer,MPATH_MAX_PARAM_LEN );
-- 
2.19.2

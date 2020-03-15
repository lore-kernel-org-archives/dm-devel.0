From: mwilck@suse.com
Subject: [PATCH v2 3/4] libmpathpersist:
	mpath_format_readfullstatus(): use real buffer size
Date: Sun, 15 Mar 2020 22:05:20 +0100
Message-ID: <20200315210521.12109-4-mwilck@suse.com>
References: <20200315210521.12109-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200315210521.12109-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

This changes no semantics, but it will allow changing the size of
prin_readfd.private_buffer in a follow-up patch.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathpersist/mpath_pr_ioctl.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/libmpathpersist/mpath_pr_ioctl.c b/libmpathpersist/mpath_pr_ioctl.c
index c78e8000..fadc9e10 100644
--- a/libmpathpersist/mpath_pr_ioctl.c
+++ b/libmpathpersist/mpath_pr_ioctl.c
@@ -238,6 +238,8 @@ static void mpath_format_readfullstatus(struct prin_resp *pr_buff)
 	uint32_t additional_length, k, tid_len_len = 0;
 	char tempbuff[MPATH_MAX_PARAM_LEN];
 	struct prin_fulldescr fdesc;
+	static const int pbuf_size =
+		sizeof(pr_buff->prin_descriptor.prin_readfd.private_buffer);
 
 	convert_be32_to_cpu(&pr_buff->prin_descriptor.prin_readfd.prgeneration);
 	convert_be32_to_cpu(&pr_buff->prin_descriptor.prin_readfd.number_of_descriptor);
@@ -249,16 +251,18 @@ static void mpath_format_readfullstatus(struct prin_resp *pr_buff)
 	}
 
 	additional_length = pr_buff->prin_descriptor.prin_readfd.number_of_descriptor;
-	if (additional_length > MPATH_MAX_PARAM_LEN) {
+	if (additional_length > pbuf_size) {
 		condlog(3, "PRIN length %u exceeds max length %d", additional_length,
-			MPATH_MAX_PARAM_LEN);
+			pbuf_size);
 		return;
 	}
 
 	memset(&fdesc, 0, sizeof(struct prin_fulldescr));
 
-	memcpy( tempbuff, pr_buff->prin_descriptor.prin_readfd.private_buffer,MPATH_MAX_PARAM_LEN );
-	memset(&pr_buff->prin_descriptor.prin_readfd.private_buffer, 0, MPATH_MAX_PARAM_LEN);
+	memcpy( tempbuff, pr_buff->prin_descriptor.prin_readfd.private_buffer,
+		pbuf_size);
+	memset(&pr_buff->prin_descriptor.prin_readfd.private_buffer, 0,
+	       pbuf_size);
 
 	p =(unsigned char *)tempbuff;
 	ppbuff = (char *)pr_buff->prin_descriptor.prin_readfd.private_buffer;
-- 
2.25.1

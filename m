From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 55/72] libmpathpersist: fix -Wsign-compare
	warnings
Date: Sat, 12 Oct 2019 21:28:45 +0000
Message-ID: <20191012212703.12989-56-martin.wilck@suse.com>
References: <20191012212703.12989-1-martin.wilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191012212703.12989-1-martin.wilck@suse.com>
Content-Language: en-US
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathpersist/mpath_persist.c  |  3 ++-
 libmpathpersist/mpath_pr_ioctl.c | 10 +++++-----
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
index 603cfc3b..0c57dd92 100644
--- a/libmpathpersist/mpath_persist.c
+++ b/libmpathpersist/mpath_persist.c
@@ -854,7 +854,8 @@ int update_map_pr(struct multipath *mpp)
 {
 	int noisy=0;
 	struct prin_resp *resp;
-	int i, ret, isFound;
+	unsigned int i;
+	int ret, isFound;
 
 	if (!get_be64(mpp->reservation_key))
 	{
diff --git a/libmpathpersist/mpath_pr_ioctl.c b/libmpathpersist/mpath_pr_ioctl.c
index 05b30b56..74b26b0c 100644
--- a/libmpathpersist/mpath_pr_ioctl.c
+++ b/libmpathpersist/mpath_pr_ioctl.c
@@ -140,7 +140,7 @@ retry :
 
 uint32_t  format_transportids(struct prout_param_descriptor *paramp)
 {
-	int i = 0, len;
+	unsigned int i = 0, len;
 	uint32_t buff_offset = 4;
 	memset(paramp->private_buffer, 0, MPATH_MAX_PARAM_LEN);
 	for (i=0; i < paramp->num_transportid; i++ )
@@ -204,11 +204,11 @@ static void mpath_format_reportcapabilities(struct prin_resp *pr_buff)
 
 static void mpath_format_readfullstatus(struct prin_resp *pr_buff)
 {
-	int num, k, tid_len_len=0;
+	int num;
 	uint32_t fdesc_count=0;
 	unsigned char *p;
 	char  *ppbuff;
-	uint32_t additional_length;
+	uint32_t additional_length, k, tid_len_len = 0;
 	char tempbuff[MPATH_MAX_PARAM_LEN];
 	struct prin_fulldescr fdesc;
 
@@ -269,8 +269,8 @@ static void mpath_format_readfullstatus(struct prin_resp *pr_buff)
 void
 decode_transport_id(struct prin_fulldescr *fdesc, unsigned char * p, int length)
 {
-	int num, k;
-	int jump;
+	unsigned int num;
+	int jump, k;
 	for (k = 0, jump = 24; k < length; k += jump, p += jump) {
 		fdesc->trnptid.format_code = ((p[0] >> 6) & 0x3);
 		fdesc->trnptid.protocol_id = (p[0] & 0xf);
-- 
2.23.0

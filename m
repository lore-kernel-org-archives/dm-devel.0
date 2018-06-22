From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 3/6] libmpathpersist: fix stack overflow in
	mpath_format_readfullstatus()
Date: Sat, 23 Jun 2018 01:15:13 +0200
Message-ID: <20180622231516.18806-3-mwilck@suse.com>
References: <20180622231516.18806-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180622231516.18806-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Eli Qiao <taget@linux.vnet.ibm.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Some storage arrays return corrupt data in response to READ FULL STATUS
PRIN commands. This may lead to stack overflow if the values aren't
sanitized.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathpersist/mpath_pr_ioctl.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/libmpathpersist/mpath_pr_ioctl.c b/libmpathpersist/mpath_pr_ioctl.c
index bcbb9691..347f21b2 100644
--- a/libmpathpersist/mpath_pr_ioctl.c
+++ b/libmpathpersist/mpath_pr_ioctl.c
@@ -241,6 +241,13 @@ void mpath_format_readfullstatus(struct prin_resp *pr_buff, int len, int noisy)
 		fdesc.rtpi = get_unaligned_be16(&p[18]);
 
 		tid_len_len = get_unaligned_be32(&p[20]);
+		if (tid_len_len + 24 + k >= additional_length) {
+			condlog(0,
+				"%s: corrupt PRIN response: status descriptor end %d exceeds length %d",
+				__func__, tid_len_len + k + 24,
+				additional_length);
+			tid_len_len = additional_length - k - 24;
+		}
 
 		if (tid_len_len > 0)
 			decode_transport_id( &fdesc, &p[24], tid_len_len);
@@ -272,6 +279,8 @@ decode_transport_id(struct prin_fulldescr *fdesc, unsigned char * p, int length)
 			break;
 		case MPATH_PROTOCOL_ID_ISCSI:
 			num = get_unaligned_be16(&p[2]);
+			if (num >= sizeof(fdesc->trnptid.iscsi_name))
+				num = sizeof(fdesc->trnptid.iscsi_name);
 			memcpy(&fdesc->trnptid.iscsi_name, &p[4], num);
 			jump = (((num + 4) < 24) ? 24 : num + 4);
 			break;
-- 
2.17.1

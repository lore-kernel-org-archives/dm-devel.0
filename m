From: mwilck@suse.com
Subject: [PATCH v2 4/4] libmpathpersist: ABI change: limit
	data-in/out size to 8192 bytes
Date: Sun, 15 Mar 2020 22:05:21 +0100
Message-ID: <20200315210521.12109-5-mwilck@suse.com>
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

Make sure that data structures used for PERSISTENT RESERVE IN/OUT
fit into 8k buffers.

This patch breaks the libmpathpersist ABI, because the offsets of
struct print_fulldescr_list.descriptors and of the fields num_transportid and
trnptid_list in struct prout_param_descriptor change.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathpersist/mpath_persist.h | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/libmpathpersist/mpath_persist.h b/libmpathpersist/mpath_persist.h
index 7cf4faf9..bdf4069d 100644
--- a/libmpathpersist/mpath_persist.h
+++ b/libmpathpersist/mpath_persist.h
@@ -92,7 +92,7 @@ struct prin_readdescr
 	uint32_t prgeneration;
 	uint32_t additional_length;	/* The value should be either 0 or divisible by 8.
 					   0 indicates no registered reservation key. */
-	uint8_t	 key_list[MPATH_MAX_PARAM_LEN];
+	uint8_t	 key_list[MPATH_MAX_PARAM_LEN - 2 * sizeof(uint32_t)];
 };
 
 struct prin_resvdescr
@@ -141,7 +141,9 @@ struct print_fulldescr_list
 {
 	uint32_t prgeneration;
 	uint32_t number_of_descriptor;
-	uint8_t private_buffer[MPATH_MAX_PARAM_LEN]; /*Private buffer for list storage*/
+	/* Data-in; Private buffer for list storage */
+	uint8_t private_buffer[MPATH_MAX_PARAM_LEN - 2 * sizeof(uint32_t)];
+	/* array of pointers into private_buffer */
 	struct prin_fulldescr *descriptors[];
 };
 
@@ -163,8 +165,13 @@ struct prout_param_descriptor {		/* PROUT parameter descriptor */
 	uint8_t	 sa_flags;
 	uint8_t _reserved;
 	uint16_t _obsolete1;
-	uint8_t  private_buffer[MPATH_MAX_PARAM_LEN]; /*private buffer for list storage*/
-	uint32_t num_transportid;	/* Number of Transport ID listed in trnptid_list[]*/
+	/*private buffer for list storage; data-out */
+	/* 24: offsetof (struct prout_param_descriptor, private_buffer) */
+	uint8_t  private_buffer[MPATH_MAX_PARAM_LEN - 24];
+	/* Internal use below here */
+	/* Number of Transport ID listed in trnptid_list[] */
+	uint32_t num_transportid;
+	/* pointers into private_buffer */
 	struct transportid *trnptid_list[];
 };
 
-- 
2.25.1

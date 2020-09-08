From: lixiaokeng <lixiaokeng@huawei.com>
Subject: [PATCH V3 11/14] mpathpersist: check whether malloc
 paramp->trnptid_list fails in handle_args func
Date: Tue, 8 Sep 2020 16:52:22 +0800
Message-ID: <88258c31-bcf7-c5ef-f411-9a881a04803f@huawei.com>
References: <2fb59aa1-eafa-49b6-08aa-a279565ec234@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <2fb59aa1-eafa-49b6-08aa-a279565ec234@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Language: en-GB
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Martin Wilck <mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>, dm-devel
	mailing list <dm-devel@redhat.com>
Cc: linfeilong <linfeilong@huawei.com>, "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>
List-Id: dm-devel.ids

In handle_args func, we donot check whether malloc paramp and
each paramp->trnptid_list[j] fails before using them, it may
cause access NULL pointer.

Here, we add alloc_prout_param_descriptor to allocate and init
paramp, and we add free_prout_param_descriptor to free paramp
and each paramp->trnptid_list[j].

V1->V2: change num_transport to num_transportids to combine them.

Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Signed-off-by: lixiaokeng <lixiaokeng@huawei.com>
---
 mpathpersist/main.c | 65 ++++++++++++++++++++++++++++++++++-----------
 1 file changed, 50 insertions(+), 15 deletions(-)

diff --git a/mpathpersist/main.c b/mpathpersist/main.c
index 28bfe410..da67c15c 100644
--- a/mpathpersist/main.c
+++ b/mpathpersist/main.c
@@ -153,6 +153,38 @@ static int do_batch_file(const char *batch_fn)
 	return ret;
 }

+static struct prout_param_descriptor *
+alloc_prout_param_descriptor(int num_transportid)
+{
+	struct prout_param_descriptor *paramp;
+
+	if (num_transportid < 0 || num_transportid > MPATH_MX_TIDS)
+		return NULL;
+
+	paramp= malloc(sizeof(struct prout_param_descriptor) +
+				(sizeof(struct transportid *) * num_transportid));
+
+	if (!paramp)
+		return NULL;
+
+	paramp->num_transportid = num_transportid;
+	memset(paramp, 0, sizeof(struct prout_param_descriptor) +
+			(sizeof(struct transportid *) * num_transportid));
+	return paramp;
+}
+
+static void free_prout_param_descriptor(struct prout_param_descriptor *paramp)
+{
+	int i;
+	if (!paramp)
+		return;
+
+	for (i = 0; i < paramp->num_transportid; i++)
+		free(paramp->trnptid_list[i]);
+
+	free(paramp);
+}
+
 static int handle_args(int argc, char * argv[], int nline)
 {
 	int c;
@@ -177,7 +209,6 @@ static int handle_args(int argc, char * argv[], int nline)
 	int prin = 1;
 	int prin_sa = -1;
 	int prout_sa = -1;
-	int num_transport =0;
 	char *batch_fn = NULL;
 	void *resp = NULL;
 	struct transportid * tmp;
@@ -334,13 +365,13 @@ static int handle_args(int argc, char * argv[], int nline)
 				break;

 			case 'X':
-				if (0 != construct_transportid(optarg, transportids, num_transport)) {
+				if (0 != construct_transportid(optarg, transportids, num_transportids)) {
 					fprintf(stderr, "bad argument to '--transport-id'\n");
 					ret = MPATH_PR_SYNTAX_ERROR;
 					goto out;
 				}

-				++num_transport;
+				++num_transportids;
 				break;

 			case 'l':
@@ -525,9 +556,12 @@ static int handle_args(int argc, char * argv[], int nline)
 		int j;
 		struct prout_param_descriptor *paramp;

-		paramp= malloc(sizeof(struct prout_param_descriptor) + (sizeof(struct transportid *)*(MPATH_MX_TIDS )));
-
-		memset(paramp, 0, sizeof(struct prout_param_descriptor) + (sizeof(struct transportid *)*(MPATH_MX_TIDS)));
+		paramp = alloc_prout_param_descriptor(num_transportids);
+		if (!paramp) {
+			fprintf(stderr, "malloc paramp failed\n");
+			ret = MPATH_PR_OTHER;
+			goto out_fd;
+		}

 		for (j = 7; j >= 0; --j) {
 			paramp->key[j] = (param_rk & 0xff);
@@ -544,13 +578,19 @@ static int handle_args(int argc, char * argv[], int nline)
 		if (param_aptpl)
 			paramp->sa_flags |= MPATH_F_APTPL_MASK;

-		if (num_transport)
+		if (num_transportids)
 		{
 			paramp->sa_flags |= MPATH_F_SPEC_I_PT_MASK;
-			paramp->num_transportid = num_transport;
-			for (j = 0 ; j < num_transport; j++)
+			paramp->num_transportid = num_transportids;
+			for (j = 0 ; j < num_transportids; j++)
 			{
 				paramp->trnptid_list[j] = (struct transportid *)malloc(sizeof(struct transportid));
+				if (!paramp->trnptid_list[j]) {
+					fprintf(stderr, "malloc paramp->trnptid_list[%d] failed.\n", j);
+					ret = MPATH_PR_OTHER;
+					free_prout_param_descriptor(paramp);
+					goto out_fd;
+				}
 				memcpy(paramp->trnptid_list[j], &transportids[j],sizeof(struct transportid));
 			}
 		}
@@ -558,12 +598,7 @@ static int handle_args(int argc, char * argv[], int nline)
 		/* PROUT commands other than 'register and move' */
 		ret = __mpath_persistent_reserve_out (fd, prout_sa, 0, prout_type,
 				paramp, noisy);
-		for (j = 0 ; j < num_transport; j++)
-		{
-			tmp = paramp->trnptid_list[j];
-			free(tmp);
-		}
-		free(paramp);
+		free_prout_param_descriptor(paramp);
 	}

 	if (ret != MPATH_PR_SUCCESS)
-- 

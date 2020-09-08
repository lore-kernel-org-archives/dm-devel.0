From: lixiaokeng <lixiaokeng@huawei.com>
Subject: [PATCH V2 14/14] multipathpersist: delete unused
 variable in handle_args
Date: Tue, 8 Sep 2020 15:06:05 +0800
Message-ID: <04f01b5d-7142-eac1-b043-f0fc19702bd7@huawei.com>
References: <a3672ace-9637-20e2-04ce-857e364ffdb3@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <a3672ace-9637-20e2-04ce-857e364ffdb3@huawei.com>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Martin Wilck <mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: linfeilong <linfeilong@huawei.com>, dm-devel mailing list <dm-devel@redhat.com>, "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>
List-Id: dm-devel.ids

In handle_args, the tmp isn't used. We delete it.

V1->V2: modify patch because of "mpathpersist: check whether
malloc paramp->trnptid_list fails in handle_args func" changing

Signed-off-by: Lixiaokeng <lixiaokeng@huawei.com>
Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Signed-off-by: Linfeilong <linfeilong@huawei.com>
---
 mpathpersist/main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mpathpersist/main.c b/mpathpersist/main.c
index da67c15c..85453ac2 100644
--- a/mpathpersist/main.c
+++ b/mpathpersist/main.c
@@ -211,7 +211,6 @@ static int handle_args(int argc, char * argv[], int nline)
        int prout_sa = -1;
        char *batch_fn = NULL;
        void *resp = NULL;
-       struct transportid * tmp;

        memset(transportids, 0, MPATH_MX_TIDS * sizeof(struct transportid));

--

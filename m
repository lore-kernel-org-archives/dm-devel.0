From: lixiaokeng <lixiaokeng@huawei.com>
Subject: [PATCH V2 02/14] libmultipath: change malloc to calloc
 in print_foreign_topology
Date: Tue, 8 Sep 2020 14:54:31 +0800
Message-ID: <f8c36c05-b578-6841-73cf-1aa11b566524@huawei.com>
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

We check the return value of malloc in print_foreign_topology.

V1->V2: chanege malloc to calloc

Signed-off-by: Lixiaokeng <lixiaokeng@huawei.com>
Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Signed-off-by: Linfeilong <linfeilong@huawei.com>
---
 libmultipath/foreign.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/foreign.c b/libmultipath/foreign.c
index e8f61351..fce19347 100644
--- a/libmultipath/foreign.c
+++ b/libmultipath/foreign.c
@@ -544,8 +544,8 @@ void print_foreign_topology(int verbosity)
        int buflen = MAX_LINE_LEN * MAX_LINES;
        char *buf = NULL, *tmp = NULL;

-       buf = malloc(buflen);
-       buf[0] = '\0';
+       buf = calloc(1, buflen);
+
        while (buf != NULL) {
                char *c = buf;

--

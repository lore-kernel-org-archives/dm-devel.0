From: lixiaokeng <lixiaokeng@huawei.com>
Subject: [PATCH V2 01/14] multipathd: initialize major and minor
 in cli_add_map
Date: Tue, 8 Sep 2020 14:53:27 +0800
Message-ID: <653802e1-d89f-abc8-2418-49b3c43c0769@huawei.com>
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

If dm_get_major_minor failed, log with major and minor should not
be printed to avoid major and minor used before initialization.

V1->V2: set major and minor to -1 at begining

Signed-off-by: Lixiaokeng <lixiaokeng@huawei.com>
Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Signed-off-by: Linfeilong <linfeilong@huawei.com>
---
 multipathd/cli_handlers.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 8db37961..e9698704 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -820,7 +820,7 @@ cli_add_map (void * v, char ** reply, int * len, void * data)
 {
        struct vectors * vecs = (struct vectors *)data;
        char * param = get_keyparam(v, MAP);
-       int major, minor;
+       int major = -1, minor = -1;
        char dev_path[PATH_SIZE];
        char *refwwid, *alias = NULL;
        int rc, count = 0;
--

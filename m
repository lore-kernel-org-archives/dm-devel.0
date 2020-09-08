From: lixiaokeng <lixiaokeng@huawei.com>
Subject: [PATCH V2 06/14] kpartx: check return value of malloc in
	main func
Date: Tue, 8 Sep 2020 14:59:20 +0800
Message-ID: <e8f626e9-d492-fc86-6a90-9cf99984940f@huawei.com>
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

In main func of kpartx.c, we should check return value of
malloc before using it.

V1->V2: change malloc to xmalloc

Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Signed-off-by: Lixiaokeng <lixiaokeng@huawei.com>
---
 kpartx/kpartx.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
index 98f6176e..6de3c9c4 100644
--- a/kpartx/kpartx.c
+++ b/kpartx/kpartx.c
@@ -61,6 +61,9 @@ struct pt {
 int ptct = 0;
 int udev_sync = 1;

+extern void *
+xmalloc (size_t size);
+
 static void
 addpts(char *t, ptreader f)
 {
@@ -383,7 +386,7 @@ main(int argc, char **argv){
                mapname = device + off;

        if (delim == NULL) {
-               delim = malloc(DELIM_SIZE);
+               delim = xmalloc(DELIM_SIZE);
                memset(delim, 0, DELIM_SIZE);
                set_delimiter(mapname, delim);
        }
--

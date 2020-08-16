From: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Subject: [PATCH 6/6] multipathd: return NULL if MALLOC fails in
 alloc_waiteri, func
Date: Sun, 16 Aug 2020 09:46:29 +0800
Message-ID: <a0d6c479-7802-eb30-9f5d-0075ca1397f9@huawei.com>
References: <351fa23b-b730-ce22-7e89-24f26a693a6a@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <351fa23b-b730-ce22-7e89-24f26a693a6a@huawei.com>
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
To: bmarzins@redhat.com, Martin Wilck <mwilck@suse.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, Zdenek Kabelac <zkabelac@redhat.com>
Cc: linfeilong <linfeilong@huawei.com>, Yanxiaodan <yanxiaodan@huawei.com>, dm-devel@redhat.com, lixiaokeng <lixiaokeng@huawei.com>, liuzhiqiang26@huawei.com
List-Id: dm-devel.ids


In alloc_waiter func, if MALLOC fails, wp is equal to NULL.
If now we call memset(wp), segmentation fault will occur.

Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Signed-off-by: lixiaokeng <lixiaokeng@huawei.com>
---
 multipathd/waiter.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/multipathd/waiter.c b/multipathd/waiter.c
index e645766..80e6e6e 100644
--- a/multipathd/waiter.c
+++ b/multipathd/waiter.c
@@ -33,8 +33,10 @@ static struct event_thread *alloc_waiter (void)
 	struct event_thread *wp;

 	wp = (struct event_thread *)MALLOC(sizeof(struct event_thread));
-	memset(wp, 0, sizeof(struct event_thread));
+	if (!wp)
+		return NULL;

+	memset(wp, 0, sizeof(struct event_thread));
 	return wp;
 }

-- 
1.8.3.1

From: mwilck@suse.com
Subject: [PATCH 12/23] multipathd: unwatch_all_dmevents: check if
	waiter is initialized
Date: Thu, 24 Sep 2020 15:40:43 +0200
Message-ID: <20200924134054.14632-13-mwilck@suse.com>
References: <20200924134054.14632-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200924134054.14632-1-mwilck@suse.com>
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
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/dmevents.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/multipathd/dmevents.c b/multipathd/dmevents.c
index b561cbf..f52f597 100644
--- a/multipathd/dmevents.c
+++ b/multipathd/dmevents.c
@@ -257,6 +257,8 @@ void unwatch_all_dmevents(void)
 	struct dev_event *dev_evt;
 	int i;
 
+	if (!waiter)
+		return;
 	pthread_mutex_lock(&waiter->events_lock);
 	vector_foreach_slot(waiter->events, dev_evt, i)
 		free(dev_evt);
-- 
2.28.0

From: mwilck@suse.com
Subject: [PATCH 16/23] libmultipath: log_thread_stop(): check if
	logarea is initialized
Date: Thu, 24 Sep 2020 15:40:47 +0200
Message-ID: <20200924134054.14632-17-mwilck@suse.com>
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
 libmultipath/log_pthread.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/libmultipath/log_pthread.c b/libmultipath/log_pthread.c
index 15baef8..0c327ff 100644
--- a/libmultipath/log_pthread.c
+++ b/libmultipath/log_pthread.c
@@ -112,6 +112,9 @@ void log_thread_reset (void)
 
 void log_thread_stop (void)
 {
+	if (!la)
+		return;
+
 	logdbg(stderr,"enter log_thread_stop\n");
 
 	pthread_mutex_lock(&logev_lock);
-- 
2.28.0

From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 30/72] multipath tools: mark unused arguments in
 thread routines
Date: Sat, 12 Oct 2019 21:28:14 +0000
Message-ID: <20191012212703.12989-31-martin.wilck@suse.com>
References: <20191012212703.12989-1-martin.wilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191012212703.12989-1-martin.wilck@suse.com>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/log_pthread.c | 2 +-
 multipathd/main.c          | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/log_pthread.c b/libmultipath/log_pthread.c
index be57bb1a..15baef88 100644
--- a/libmultipath/log_pthread.c
+++ b/libmultipath/log_pthread.c
@@ -56,7 +56,7 @@ static void flush_logqueue (void)
 	} while (empty == 0);
 }
 
-static void * log_thread (void * et)
+static void * log_thread (__attribute__((unused)) void * et)
 {
 	int running;
 
diff --git a/multipathd/main.c b/multipathd/main.c
index 43ae42d4..e55f2795 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2792,7 +2792,7 @@ set_oom_adj (void)
 }
 
 static int
-child (void * param)
+child (__attribute__((unused)) void *param)
 {
 	pthread_t check_thr, uevent_thr, uxlsnr_thr, uevq_thr, dmevent_thr;
 	pthread_attr_t log_attr, misc_attr, uevent_attr;
-- 
2.23.0

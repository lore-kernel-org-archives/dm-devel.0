From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: delete trailing whitespaces
Date: Wed, 10 Oct 2018 21:51:16 +0200
Message-ID: <20181010195116.5588-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: DM-DEV ML <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEV ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/checkers/tur.c | 2 +-
 tests/dmevents.c            | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
index 86c0cdc..5aeec6f 100644
--- a/libmultipath/checkers/tur.c
+++ b/libmultipath/checkers/tur.c
@@ -334,7 +334,7 @@ int libcheck_check(struct checker * c)
 		tur_timeout(&tsp);
 		pthread_mutex_lock(&ct->lock);
 		if (ct->state == PATH_PENDING)
-			r = pthread_cond_timedwait(&ct->active, &ct->lock, 
+			r = pthread_cond_timedwait(&ct->active, &ct->lock,
 						   &tsp);
 		if (!r) {
 			tur_status = ct->state;
diff --git a/tests/dmevents.c b/tests/dmevents.c
index 3399c81..bee117a 100644
--- a/tests/dmevents.c
+++ b/tests/dmevents.c
@@ -465,7 +465,7 @@ static void test_watch_dmevents_good1(void **state)
 		skip();
 
 	remove_all_dm_device_events();
-	assert_int_equal(add_dm_device_event("foo", 1, 5), 0);	
+	assert_int_equal(add_dm_device_event("foo", 1, 5), 0);
 	will_return(__wrap_dm_geteventnr, 0);
 	assert_int_equal(watch_dmevents("foo"), 0);
 	dev_evt = find_dmevents("foo");
-- 
2.17.2

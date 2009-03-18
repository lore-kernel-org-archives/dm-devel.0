From: Konrad Rzeszutek <konrad@virtualiron.com>
Subject: [PATCH] Unload prio and checkers libraries during
	shutdown.
Date: Wed, 18 Mar 2009 19:38:07 -0400
Message-ID: <1237419489-3303-3-git-send-email-konrad@virtualiron.com>
References: <1237419489-3303-1-git-send-email-konrad@virtualiron.com>
	<1237419489-3303-2-git-send-email-konrad@virtualiron.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1237419489-3303-2-git-send-email-konrad@virtualiron.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

From: Konrad Rzeszutek <konrad@mars.virtualiron.com>

Our statup sequence is 'load_config', 'init_checkers', and 'init_prio'.
Both init_* functions reset the list of prio and checkers, which is
unfortunate as in load_config, depending on the multipat.conf, would
load prio and checker libraries. This results in double-loading of
the libraries and a memory leak.
---
 libmultipath/checkers.c |    7 +++----
 libmultipath/checkers.h |    1 +
 libmultipath/prio.c     |    7 +++----
 libmultipath/prio.h     |    1 +
 multipath/main.c        |    2 ++
 multipathd/main.c       |    2 ++
 6 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c
index 5132081..19d0781 100644
--- a/libmultipath/checkers.c
+++ b/libmultipath/checkers.c
@@ -27,7 +27,6 @@ char * checker_state_name (int i)
 
 int init_checkers (void)
 {
-	INIT_LIST_HEAD(&checkers);
 	if (!add_checker(DEFAULT_CHECKER))
 		return 1;
 	return 0;
@@ -35,12 +34,12 @@ int init_checkers (void)
 
 struct checker * alloc_checker (void)
 {
-	return zalloc(sizeof(struct checker));
+	return MALLOC(sizeof(struct checker));
 }
 
 void free_checker (struct checker * c)
 {
-	free(c);
+	FREE(c);
 }
 
 void cleanup_checkers (void)
@@ -50,7 +49,7 @@ void cleanup_checkers (void)
 
 	list_for_each_entry_safe(checker_loop, checker_temp, &checkers, node) {
 		list_del(&checker_loop->node);
-		free(checker_loop);
+		free_checker(checker_loop);
 	}
 }
 
diff --git a/libmultipath/checkers.h b/libmultipath/checkers.h
index e735250..b610e6b 100644
--- a/libmultipath/checkers.h
+++ b/libmultipath/checkers.h
@@ -111,6 +111,7 @@ struct checker {
 
 char * checker_state_name (int);
 int init_checkers (void);
+void cleanup_checkers (void);
 struct checker * add_checker (char *);
 struct checker * checker_lookup (char *);
 int checker_init (struct checker *, void **);
diff --git a/libmultipath/prio.c b/libmultipath/prio.c
index c9d2873..4c5f4f0 100644
--- a/libmultipath/prio.c
+++ b/libmultipath/prio.c
@@ -11,7 +11,6 @@ static LIST_HEAD(prioritizers);
 
 int init_prio (void)
 {
-	INIT_LIST_HEAD(&prioritizers);
 	if (!add_prio(DEFAULT_PRIO))
 		return 1;
 	return 0;
@@ -19,12 +18,12 @@ int init_prio (void)
 
 struct prio * alloc_prio (void)
 {
-	return zalloc(sizeof(struct prio));
+	return MALLOC(sizeof(struct prio));
 }
 
 void free_prio (struct prio * p)
 {
-	free(p);
+	FREE(p);
 }
 
 void cleanup_prio(void)
@@ -34,7 +33,7 @@ void cleanup_prio(void)
 
 	list_for_each_entry_safe(prio_loop, prio_temp, &prioritizers, node) {
 		list_del(&prio_loop->node);
-		free(prio_loop);
+		free_prio(prio_loop);
 	}
 }
 
diff --git a/libmultipath/prio.h b/libmultipath/prio.h
index 491e6fc..fc9277f 100644
--- a/libmultipath/prio.h
+++ b/libmultipath/prio.h
@@ -42,6 +42,7 @@ struct prio {
 };
 
 int init_prio (void);
+void cleanup_prio (void);
 struct prio * add_prio (char *);
 struct prio * prio_lookup (char *);
 int prio_getprio (struct prio *, struct path *);
diff --git a/multipath/main.c b/multipath/main.c
index 8b38a6e..e60b9bc 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -443,6 +443,8 @@ out:
 	dm_lib_release();
 	dm_lib_exit();
 
+	cleanup_prio();
+	cleanup_checkers();
 	/*
 	 * Freeing config must be done after dm_lib_exit(), because
 	 * the logging function (dm_write_log()), which is called there,
diff --git a/multipathd/main.c b/multipathd/main.c
index 36aa93c..7de41a0 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1389,6 +1389,8 @@ child (void * param)
 	dm_lib_release();
 	dm_lib_exit();
 
+	cleanup_prio();
+	cleanup_checkers();
 	/*
 	 * Freeing config must be done after condlog() and dm_lib_exit(),
 	 * because logging functions like dlog() and dm_write_log()
-- 
1.5.4.1

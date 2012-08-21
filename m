From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 06/20] dm-crypt: Introduce an option that sets
	the number of threads.
Date: Tue, 21 Aug 2012 11:09:17 +0200
Message-ID: <d05353ef83d887f765924a045681d69be3ec50e2.1345477953.git.mbroz@redhat.com>
References: <cover.1345477953.git.mbroz@redhat.com>
	<520994e0c87d38ca6abb8dd60760aef993842a32.1345477953.git.mbroz@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <520994e0c87d38ca6abb8dd60760aef993842a32.1345477953.git.mbroz@redhat.com>
In-Reply-To: <cover.1345477953.git.mbroz@redhat.com>
References: <cover.1345477953.git.mbroz@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

Introduce an option "num_cpus". It allows the user to set the number of
threads used for encryption. The value "0" means a default.

The default is the number of CPUs in the system, but at most 3.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
---
 drivers/md/dm-crypt.c |   96 ++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 76 insertions(+), 20 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index b251e15..fd2909d 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -34,6 +34,8 @@
 #define DMREQ_PULL_BATCH			16
 #define DMREQ_PUSH_BATCH			16
 
+#define DM_CRYPT_DEFAULT_CPUS			3
+
 /*
  * context holding the current state of a multi-part conversion
  */
@@ -127,6 +129,7 @@ struct crypt_config {
 	struct workqueue_struct *io_queue;
 	struct workqueue_struct *crypt_queue;
 	unsigned crypt_threads_size;
+	int num_threads_value;	/* the value entered in the arguments */
 	struct task_struct **crypt_threads;
 
 	wait_queue_head_t crypt_thread_wait;
@@ -1630,9 +1633,14 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	struct dm_arg_set as;
 	const char *opt_string;
 	char dummy;
+	int num_threads = -1;
 
 	static struct dm_arg _args[] = {
-		{0, 1, "Invalid number of feature args"},
+		{0, INT_MAX, "Invalid number of feature args"},
+	};
+
+	static struct dm_arg num_cpu_arg[] = {
+		{0, 65536, "Number of CPUs"},
 	};
 
 	if (argc < 5) {
@@ -1716,18 +1724,31 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		if (ret)
 			goto bad;
 
-		opt_string = dm_shift_arg(&as);
-
-		if (opt_params == 1 && opt_string &&
-		    !strcasecmp(opt_string, "allow_discards"))
-			ti->num_discard_requests = 1;
-		else if (opt_params) {
-			ret = -EINVAL;
-			ti->error = "Invalid feature arguments";
-			goto bad;
+		for (i = 0; i < opt_params; i++) {
+			opt_string = dm_shift_arg(&as);
+			if (!strcasecmp(opt_string, "allow_discards")) {
+				ti->num_discard_requests = 1;
+			} else if (!strcasecmp(opt_string, "num_cpus") && i + 1 < opt_params) {
+				ret = dm_read_arg(num_cpu_arg, &as, &num_threads, &ti->error);
+				if (ret)
+					goto bad;
+				i++;
+			} else {
+				ret = -EINVAL;
+				ti->error = "Invalid feature arguments";
+				goto bad;
+			}
 		}
 	}
 
+	cc->num_threads_value = num_threads;
+
+	if (num_threads <= 0) {
+		num_threads = num_online_cpus();
+		if (num_threads > DM_CRYPT_DEFAULT_CPUS)
+			num_threads = DM_CRYPT_DEFAULT_CPUS;
+	}
+
 	ret = -ENOMEM;
 	cc->io_queue = alloc_workqueue("kcryptd_io",
 				       WQ_NON_REENTRANT|
@@ -1747,9 +1768,15 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		goto bad;
 	}
 
-	for (i = 0; i < NR_CPUS; i++)
-		if (cpu_online(i))
-			cc->crypt_threads_size = i + 1;
+	if (num_threads == num_online_cpus()) {
+		for (i = 0; i < NR_CPUS; i++)
+			if (cpu_online(i))
+				cc->crypt_threads_size = i + 1;
+	} else {
+		if (num_threads > INT_MAX / sizeof(struct task_struct *))
+			num_threads = INT_MAX / sizeof(struct task_struct *);
+		cc->crypt_threads_size = num_threads;
+	}
 
 	init_waitqueue_head(&cc->crypt_thread_wait);
 	INIT_LIST_HEAD(&cc->crypt_thread_list);
@@ -1761,18 +1788,31 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		goto bad;
 	}
 
-	for (i = 0; i < cc->crypt_threads_size; i++) {
-		if (cpu_online(i)) {
-			cc->crypt_threads[i] = kthread_create_on_node(
-				dmcrypt_thread, cc, cpu_to_node(i),
-				"dmcryptd/%d", i);
+	if (num_threads == num_online_cpus())
+		for (i = 0; i < cc->crypt_threads_size; i++) {
+			if (cpu_online(i)) {
+				cc->crypt_threads[i] = kthread_create_on_node(
+					dmcrypt_thread, cc, cpu_to_node(i),
+					"dmcryptd/%d", i);
+				if (IS_ERR(cc->crypt_threads[i])) {
+					ret = PTR_ERR(cc->crypt_threads[i]);
+					cc->crypt_threads[i] = NULL;
+					ti->error = "Couldn't spawn thread";
+					goto bad;
+				}
+				kthread_bind(cc->crypt_threads[i], i);
+				wake_up_process(cc->crypt_threads[i]);
+			}
+	} else {
+		for (i = 0; i < cc->crypt_threads_size; i++) {
+			cc->crypt_threads[i] = kthread_create(
+				dmcrypt_thread, cc, "dmcryptd/%d", i);
 			if (IS_ERR(cc->crypt_threads[i])) {
 				ret = PTR_ERR(cc->crypt_threads[i]);
 				cc->crypt_threads[i] = NULL;
 				ti->error = "Couldn't spawn thread";
 				goto bad;
 			}
-			kthread_bind(cc->crypt_threads[i], i);
 			wake_up_process(cc->crypt_threads[i]);
 		}
 	}
@@ -1821,6 +1861,7 @@ static int crypt_status(struct dm_target *ti, status_type_t type,
 {
 	struct crypt_config *cc = ti->private;
 	unsigned int sz = 0;
+	unsigned int num_args;
 
 	switch (type) {
 	case STATUSTYPE_INFO:
@@ -1845,8 +1886,23 @@ static int crypt_status(struct dm_target *ti, status_type_t type,
 		DMEMIT(" %llu %s %llu", (unsigned long long)cc->iv_offset,
 				cc->dev->name, (unsigned long long)cc->start);
 
+		num_args = 0;
+		if (ti->num_discard_requests)
+			num_args++;
+
+		if (cc->num_threads_value >= 0)
+			num_args += 2;
+
+		if (!num_args)
+			break;
+
+		DMEMIT(" %u", num_args);
+
 		if (ti->num_discard_requests)
-			DMEMIT(" 1 allow_discards");
+			DMEMIT(" allow_discards");
+
+		if (cc->num_threads_value >= 0)
+			DMEMIT(" num_cpus %d", cc->num_threads_value);
 
 		break;
 	}
-- 
1.7.10.4

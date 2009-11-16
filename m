From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: [PATCH 2/2] dm-mpath: Add element for suspended state.
Date: Sun, 15 Nov 2009 23:38:29 -0800
Message-ID: <20091116073829.4070.45194.stgit@localhost.localdomain>
References: <20091116073819.4070.40173.stgit@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20091116073819.4070.40173.stgit@localhost.localdomain>
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

Add element to multipath structure for indication of suspended state.

Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>
---
 drivers/md/dm-mpath.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index b102959..1f598c9 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -95,6 +95,8 @@ struct multipath {
 	mempool_t *mpio_pool;
 
 	struct mutex work_mutex;
+
+	unsigned int  suspended;
 };
 
 /*
@@ -1274,6 +1276,7 @@ static void multipath_postsuspend(struct dm_target *ti)
 	struct multipath *m = (struct multipath *) ti->private;
 
 	mutex_lock(&m->work_mutex);
+	m->suspended = 1;
 	flush_multipath_work();
 	mutex_unlock(&m->work_mutex);
 }
@@ -1286,6 +1289,10 @@ static void multipath_resume(struct dm_target *ti)
 	struct multipath *m = (struct multipath *) ti->private;
 	unsigned long flags;
 
+	mutex_lock(&m->work_mutex);
+	m->suspended = 0;
+	mutex_unlock(&m->work_mutex);
+
 	spin_lock_irqsave(&m->lock, flags);
 	m->queue_if_no_path = m->saved_queue_if_no_path;
 	spin_unlock_irqrestore(&m->lock, flags);
@@ -1421,6 +1428,11 @@ static int multipath_message(struct dm_target *ti, unsigned argc, char **argv)
 
 	mutex_lock(&m->work_mutex);
 
+	if (m->suspended) {
+		r = -EBUSY;
+		goto out;
+	}
+
 	if (argc == 1) {
 		if (!strnicmp(argv[0], MESG_STR("queue_if_no_path"))) {
 			r = queue_if_no_path(m, 1, 0);

From: Alasdair G Kergon <agk@redhat.com>
Subject: [2.6.22 PATCH 17/26] dm kcopyd: update dm io interface
Date: Tue, 8 May 2007 20:47:44 +0100
Message-ID: <20070508194744.GX24114@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

From: Milan Broz <mbroz@redhat.com>

This patch ports kcopyd.c to the new, scalable dm_io() interface.

Signed-off-by: Milan Broz <mbroz@redhat.com>
Signed-off-by: Heinz Mauelshagen <hjm@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
---

 drivers/md/kcopyd.c |   28 ++++++++++++++++++----------
 1 files changed, 18 insertions(+), 10 deletions(-)

Index: linux-2.6.21/drivers/md/kcopyd.c
===================================================================
--- linux-2.6.21.orig/drivers/md/kcopyd.c	2007-05-01 17:38:32.000000000 +0100
+++ linux-2.6.21/drivers/md/kcopyd.c	2007-05-01 17:40:53.000000000 +0100
@@ -1,5 +1,6 @@
 /*
  * Copyright (C) 2002 Sistina Software (UK) Limited.
+ * Copyright (C) 2006 Red Hat GmbH
  *
  * This file is released under the GPL.
  *
@@ -45,6 +46,8 @@ struct kcopyd_client {
 	unsigned int nr_pages;
 	unsigned int nr_free_pages;
 
+	struct dm_io_client *io_client;
+
 	wait_queue_head_t destroyq;
 	atomic_t nr_jobs;
 };
@@ -342,16 +345,20 @@ static void complete_io(unsigned long er
 static int run_io_job(struct kcopyd_job *job)
 {
 	int r;
+	struct dm_io_request io_req = {
+		.bi_rw = job->rw,
+		.mem.type = DM_IO_PAGE_LIST,
+		.mem.ptr.pl = job->pages,
+		.mem.offset = job->offset,
+		.notify.fn = complete_io,
+		.notify.context = job,
+		.client = job->kc->io_client,
+	};
 
 	if (job->rw == READ)
-		r = dm_io_async(1, &job->source, job->rw,
-				job->pages,
-				job->offset, complete_io, job);
-
+		r = dm_io(&io_req, 1, &job->source, NULL);
 	else
-		r = dm_io_async(job->num_dests, job->dests, job->rw,
-				job->pages,
-				job->offset, complete_io, job);
+		r = dm_io(&io_req, job->num_dests, job->dests, NULL);
 
 	return r;
 }
@@ -670,8 +677,9 @@ int kcopyd_client_create(unsigned int nr
 		return r;
 	}
 
-	r = dm_io_get(nr_pages);
-	if (r) {
+	kc->io_client = dm_io_client_create(nr_pages);
+	if (IS_ERR(kc->io_client)) {
+		r = PTR_ERR(kc->io_client);
 		client_free_pages(kc);
 		kfree(kc);
 		kcopyd_exit();
@@ -691,7 +699,7 @@ void kcopyd_client_destroy(struct kcopyd
 	/* Wait for completion of all jobs submitted by this client. */
 	wait_event(kc->destroyq, !atomic_read(&kc->nr_jobs));
 
-	dm_io_put(kc->nr_pages);
+	dm_io_client_destroy(kc->io_client);
 	client_free_pages(kc);
 	client_del(kc);
 	kfree(kc);

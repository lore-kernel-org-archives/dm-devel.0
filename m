Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B6A82F531A;
	Tue, 18 Nov 2025 07:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763449423; cv=none; b=cVv1+rde+g0EQ2rIfF1BEPV9WWSqbDj+9SkA8qE6TFjQE/4XbcO6/PN6S8gmE1hJ4E/hLmA3xirzqj0MGKi6yhNIxbnDwpJnAfkDKABB5hZGNolRMSc1NMTG1hQ8pIsHo8bCznQq6UKtB7HLAHzi2cH5VMRyIKTvHKJjvfls7FY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763449423; c=relaxed/simple;
	bh=G7u6ueM4cjoF6dCLnRm7O1ofBBir/MeDbEydaWuHi2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N/IladOVbcjsz6cilkW4PEdeauWWLfXDPweXu7TqtQmd28fF8qcnJcBHD/RXBguyAs9WtAXtdVwD5lZF5FEB2sOIAc/76Jj+k3ka93LBLNFjYPmR34jdj5XOzZWOxPSac7/JILSKGP7KZElKbDLeD9dTHoTJqXq8KkVj3Z2TZsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JfjbWxAk; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JfjbWxAk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=4w7Gp+PACL4K6k+hsc3zNN2iTFGLzAcXMBUWMZ6C0ME=; b=JfjbWxAkpJBoInY0BzLZ8c2aQI
	GqThGmEBDk+nZtDJ4mpCrfuwxDaa4JLqwTdIY39AreHaqtgBRge1/RxdMAmQMikMepsb7rGGJX/wA
	IWnqm75ZEQJYhgVYZ1J/oRY/qyZBFKpw98Ws5unsQSR63sgHuuwKKiphQ/52Z7ZkAU7TObhfeVGuN
	j6lj7yi7D8NDGl+LGj9rn0JlaHrtGId0eC1mnQtKb4efRt09jmVGkWT1Ha9U9eCqIJTmostyU6leo
	je0Ppoq2X6nU0iZ2fCPa26IvZ74QZ4/KvjlVEKJtncKxJCQvmCOWKqxbvJ2aMp2wMRGSHQKHznijk
	JXyaTfEA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLFka-0000000HX0D-3a5g;
	Tue, 18 Nov 2025 07:03:41 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev
Subject: [PATCH 3/3] dm-kcopyd: use REQ_ZWPLUG_UNORDERED
Date: Tue, 18 Nov 2025 08:03:10 +0100
Message-ID: <20251118070321.2367097-4-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251118070321.2367097-1-hch@lst.de>
References: <20251118070321.2367097-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Use the new REQ_ZWPLUG_UNORDERED bio flag so that even copies to
sequential write required zones can queue up writes bios as soon as the
reads finish.  This simplifies the code and reduces the submission
latency as all writes are immediately available in the zoned write plug
list when the previous write completes instead of going through two
layers of queueing.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm-kcopyd.c | 48 ++++++------------------------------------
 1 file changed, 6 insertions(+), 42 deletions(-)

diff --git a/drivers/md/dm-kcopyd.c b/drivers/md/dm-kcopyd.c
index 6ea75436a433..37e181c79760 100644
--- a/drivers/md/dm-kcopyd.c
+++ b/drivers/md/dm-kcopyd.c
@@ -383,7 +383,6 @@ struct kcopyd_job {
 	struct mutex lock;
 	atomic_t sub_jobs;
 	sector_t progress;
-	sector_t write_offset;
 
 	struct kcopyd_job *master_job;
 };
@@ -411,50 +410,17 @@ void dm_kcopyd_exit(void)
 }
 
 /*
- * Functions to push and pop a job onto the head of a given job
- * list.
+ * Functions to push and pop a job onto the head of a given job list.
  */
-static struct kcopyd_job *pop_io_job(struct list_head *jobs,
-				     struct dm_kcopyd_client *kc)
-{
-	struct kcopyd_job *job;
-
-	/*
-	 * For I/O jobs, pop any read, any write without sequential write
-	 * constraint and sequential writes that are at the right position.
-	 */
-	list_for_each_entry(job, jobs, list) {
-		if (job->op == REQ_OP_READ ||
-		    !(job->flags & BIT(DM_KCOPYD_WRITE_SEQ))) {
-			list_del(&job->list);
-			return job;
-		}
-
-		if (job->write_offset == job->master_job->write_offset) {
-			job->master_job->write_offset += job->source.count;
-			list_del(&job->list);
-			return job;
-		}
-	}
-
-	return NULL;
-}
-
 static struct kcopyd_job *pop(struct list_head *jobs,
 			      struct dm_kcopyd_client *kc)
 {
 	struct kcopyd_job *job = NULL;
 
 	spin_lock_irq(&kc->job_lock);
-
-	if (!list_empty(jobs)) {
-		if (jobs == &kc->io_jobs)
-			job = pop_io_job(jobs, kc);
-		else {
-			job = list_entry(jobs->next, struct kcopyd_job, list);
-			list_del(&job->list);
-		}
-	}
+	job = list_first_entry_or_null(jobs, struct kcopyd_job, list);
+	if (job)
+		list_del(&job->list);
 	spin_unlock_irq(&kc->job_lock);
 
 	return job;
@@ -541,7 +507,7 @@ static void complete_io(unsigned long error, void *context)
 		push(&kc->complete_jobs, job);
 
 	else {
-		job->op = REQ_OP_WRITE;
+		job->op = REQ_OP_WRITE | REQ_ZWPLUG_UNORDERED;
 		push(&kc->io_jobs, job);
 	}
 
@@ -730,7 +696,6 @@ static void segment_complete(int read_err, unsigned long write_err,
 		int i;
 
 		*sub_job = *job;
-		sub_job->write_offset = progress;
 		sub_job->source.sector += progress;
 		sub_job->source.count = count;
 
@@ -833,7 +798,7 @@ void dm_kcopyd_copy(struct dm_kcopyd_client *kc, struct dm_io_region *from,
 		/*
 		 * Use WRITE ZEROES to optimize zeroing if all dests support it.
 		 */
-		job->op = REQ_OP_WRITE_ZEROES;
+		job->op = REQ_OP_WRITE_ZEROES | REQ_ZWPLUG_UNORDERED;
 		for (i = 0; i < job->num_dests; i++)
 			if (!bdev_write_zeroes_sectors(job->dests[i].bdev)) {
 				job->op = REQ_OP_WRITE;
@@ -844,7 +809,6 @@ void dm_kcopyd_copy(struct dm_kcopyd_client *kc, struct dm_io_region *from,
 	job->fn = fn;
 	job->context = context;
 	job->master_job = job;
-	job->write_offset = 0;
 
 	if (job->source.count <= kc->sub_job_size)
 		dispatch_job(job);
-- 
2.47.3


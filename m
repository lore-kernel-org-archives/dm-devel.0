Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C7E0805
	for <dm-devel@lists.linux.dev>; Sat, 18 Nov 2023 00:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VfJB1Mkn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700267649;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nblRqDu5pw6T7EhVnELaglzSRSI+XupUbdiZxjlgvY8=;
	b=VfJB1Mknb9+CNKSItu8zibfWzEB4xAjMre074gKJKFCqs/7XRYm1EJzMSu5YqQAGgrd918
	3N0ld1vTUqPAP+xlJ9IDGT5NYchg0gwRrM4UKEVvgcsXS5dVvFxUfYwfphAHoP82d39QGm
	L5aVlKhQhPk+B3lj0Pdu8GmkxAhRmOg=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-609-3NjwUNNzODaqb_Mpaa04dA-1; Fri,
 17 Nov 2023 19:34:07 -0500
X-MC-Unique: 3NjwUNNzODaqb_Mpaa04dA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 939A61C0512A;
	Sat, 18 Nov 2023 00:34:06 +0000 (UTC)
Received: from pbitcolo-build-10.permabit.com (pbitcolo-build-10.permabit.lab.eng.bos.redhat.com [10.19.117.76])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 841241C060AE;
	Sat, 18 Nov 2023 00:34:06 +0000 (UTC)
Received: by pbitcolo-build-10.permabit.com (Postfix, from userid 1138)
	id 3A7A33003B; Fri, 17 Nov 2023 19:34:06 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 5/5] dm vdo io-submitter: rename to vdo_submit_vio and submit_data_vio
Date: Fri, 17 Nov 2023 19:34:05 -0500
Message-Id: <f68fb8f3534159642ddb411a3c89c1261d5d68b2.1700266895.git.msakai@redhat.com>
In-Reply-To: <cover.1700266895.git.msakai@redhat.com>
References: <cover.1700266895.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Mike Snitzer <snitzer@kernel.org>

Rename process_vio_io() to vdo_submit_vio(), and process_data_vio_io() to
submit_data_vio().

Reviewed-by: Susan LeGendre-McGhee <slegendr@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/dedupe.c       |  2 +-
 drivers/md/dm-vdo/io-submitter.c | 16 ++++++++--------
 drivers/md/dm-vdo/io-submitter.h |  2 +-
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm-vdo/dedupe.c b/drivers/md/dm-vdo/dedupe.c
index 4c4d697a4888..8cc31110f5a8 100644
--- a/drivers/md/dm-vdo/dedupe.c
+++ b/drivers/md/dm-vdo/dedupe.c
@@ -1205,7 +1205,7 @@ static void start_verifying(struct hash_lock *lock, struct data_vio *agent)
 		return;
 	}
 
-	set_data_vio_bio_zone_callback(agent, process_vio_io);
+	set_data_vio_bio_zone_callback(agent, vdo_submit_vio);
 	vdo_launch_completion_with_priority(&vio->completion, BIO_Q_VERIFY_PRIORITY);
 }
 
diff --git a/drivers/md/dm-vdo/io-submitter.c b/drivers/md/dm-vdo/io-submitter.c
index 1dd670bb0a74..39f5f202d69d 100644
--- a/drivers/md/dm-vdo/io-submitter.c
+++ b/drivers/md/dm-vdo/io-submitter.c
@@ -116,10 +116,10 @@ static void send_bio_to_device(struct vio *vio, struct bio *bio)
 }
 
 /**
- * process_vio_io() - Submits a vio's bio to the underlying block device. May block if the device
- *                    is busy. This callback should be used by vios which did not attempt to merge.
+ * vdo_submit_vio() - Submits a vio's bio to the underlying block device. May block if the device
+ *		      is busy. This callback should be used by vios which did not attempt to merge.
  */
-void process_vio_io(struct vdo_completion *completion)
+void vdo_submit_vio(struct vdo_completion *completion)
 {
 	struct vio *vio = as_vio(completion);
 
@@ -156,12 +156,12 @@ static struct bio *get_bio_list(struct vio *vio)
 }
 
 /**
- * process_data_vio_io() - Submit a data_vio's bio to the storage below along with any bios that
- *                         have been merged with it.
+ * submit_data_vio() - Submit a data_vio's bio to the storage below along with
+ *		       any bios that have been merged with it.
  *
  * Context: This call may block and so should only be called from a bio thread.
  */
-static void process_data_vio_io(struct vdo_completion *completion)
+static void submit_data_vio(struct vdo_completion *completion)
 {
 	struct bio *bio, *next;
 	struct vio *vio = as_vio(completion);
@@ -316,7 +316,7 @@ void vdo_submit_data_vio(struct data_vio *data_vio)
 	if (try_bio_map_merge(&data_vio->vio))
 		return;
 
-	launch_data_vio_bio_zone_callback(data_vio, process_data_vio_io);
+	launch_data_vio_bio_zone_callback(data_vio, submit_data_vio);
 }
 
 /**
@@ -356,7 +356,7 @@ void __submit_metadata_vio(struct vio *vio, physical_block_number_t physical,
 		return;
 	}
 
-	vdo_set_completion_callback(completion, process_vio_io,
+	vdo_set_completion_callback(completion, vdo_submit_vio,
 				    get_vio_bio_zone_thread_id(vio));
 	vdo_launch_completion_with_priority(completion, get_metadata_priority(vio));
 }
diff --git a/drivers/md/dm-vdo/io-submitter.h b/drivers/md/dm-vdo/io-submitter.h
index 57e1074a65a4..ddd5f4b391b6 100644
--- a/drivers/md/dm-vdo/io-submitter.h
+++ b/drivers/md/dm-vdo/io-submitter.h
@@ -20,7 +20,7 @@ void vdo_cleanup_io_submitter(struct io_submitter *io_submitter);
 
 void vdo_free_io_submitter(struct io_submitter *io_submitter);
 
-void process_vio_io(struct vdo_completion *completion);
+void vdo_submit_vio(struct vdo_completion *completion);
 
 void vdo_submit_data_vio(struct data_vio *data_vio);
 
-- 
2.40.0


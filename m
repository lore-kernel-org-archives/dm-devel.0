Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09F63809
	for <dm-devel@lists.linux.dev>; Sat, 18 Nov 2023 00:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YngCvCvw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700267649;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Aucb1S6s7rPNPAY4SOBvd12FRNjGCaHRM09rj6IW7Po=;
	b=YngCvCvwUB1y891Bbpl/2/R1rEQfHEvZFaozfF2jJi8dSzxwIP4ztR/iGryAyT0z8XAe6P
	405sOC19C+Sy48gXA+PKndUH7rchzzC4c0IVG4Q+pDmqXB1wmeW+FaXT/4biYTUQYiJ4HU
	G8HRo/8M94Fjj7PgkYVgcJ/B+/LoSc8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-685-1GxHMMD2PmqSiOTySkHS4w-1; Fri, 17 Nov 2023 19:34:06 -0500
X-MC-Unique: 1GxHMMD2PmqSiOTySkHS4w-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 66CAD8058ED;
	Sat, 18 Nov 2023 00:34:06 +0000 (UTC)
Received: from pbitcolo-build-10.permabit.com (pbitcolo-build-10.permabit.lab.eng.bos.redhat.com [10.19.117.76])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5BAE0492BFD;
	Sat, 18 Nov 2023 00:34:06 +0000 (UTC)
Received: by pbitcolo-build-10.permabit.com (Postfix, from userid 1138)
	id 1008C3003C; Fri, 17 Nov 2023 19:34:05 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 4/5] dm vdo io-submitter: rename to vdo_submit_data_vio
Date: Fri, 17 Nov 2023 19:34:04 -0500
Message-Id: <bbd1b42af6cb352f51a0f1a717bc39142af21d4e.1700266895.git.msakai@redhat.com>
In-Reply-To: <cover.1700266895.git.msakai@redhat.com>
References: <cover.1700266895.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Mike Snitzer <snitzer@kernel.org>

Rename submit_data_vio_io() to vdo_submit_data_vio().

Reviewed-by: Susan LeGendre-McGhee <slegendr@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/data-vio.c     | 4 ++--
 drivers/md/dm-vdo/io-submitter.c | 4 ++--
 drivers/md/dm-vdo/io-submitter.h | 2 +-
 drivers/md/dm-vdo/packer.c       | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-vdo/data-vio.c b/drivers/md/dm-vdo/data-vio.c
index 09a99a28da4f..54c06e86d321 100644
--- a/drivers/md/dm-vdo/data-vio.c
+++ b/drivers/md/dm-vdo/data-vio.c
@@ -1592,7 +1592,7 @@ static void read_block(struct vdo_completion *completion)
 		return;
 	}
 
-	submit_data_vio_io(data_vio);
+	vdo_submit_data_vio(data_vio);
 }
 
 static inline struct data_vio *
@@ -1910,7 +1910,7 @@ void write_data_vio(struct data_vio *data_vio)
 	}
 
 	data_vio->last_async_operation = VIO_ASYNC_OP_WRITE_DATA_VIO;
-	submit_data_vio_io(data_vio);
+	vdo_submit_data_vio(data_vio);
 }
 
 /**
diff --git a/drivers/md/dm-vdo/io-submitter.c b/drivers/md/dm-vdo/io-submitter.c
index 8ca9825357e6..1dd670bb0a74 100644
--- a/drivers/md/dm-vdo/io-submitter.c
+++ b/drivers/md/dm-vdo/io-submitter.c
@@ -305,13 +305,13 @@ static bool try_bio_map_merge(struct vio *vio)
 }
 
 /**
- * submit_data_vio_io() - Submit I/O for a data_vio.
+ * vdo_submit_data_vio() - Submit I/O for a data_vio.
  * @data_vio: the data_vio for which to issue I/O.
  *
  * If possible, this I/O will be merged other pending I/Os. Otherwise, the data_vio will be sent to
  * the appropriate bio zone directly.
  */
-void submit_data_vio_io(struct data_vio *data_vio)
+void vdo_submit_data_vio(struct data_vio *data_vio)
 {
 	if (try_bio_map_merge(&data_vio->vio))
 		return;
diff --git a/drivers/md/dm-vdo/io-submitter.h b/drivers/md/dm-vdo/io-submitter.h
index 77b8df6d559e..57e1074a65a4 100644
--- a/drivers/md/dm-vdo/io-submitter.h
+++ b/drivers/md/dm-vdo/io-submitter.h
@@ -22,7 +22,7 @@ void vdo_free_io_submitter(struct io_submitter *io_submitter);
 
 void process_vio_io(struct vdo_completion *completion);
 
-void submit_data_vio_io(struct data_vio *data_vio);
+void vdo_submit_data_vio(struct data_vio *data_vio);
 
 void __submit_metadata_vio(struct vio *vio, physical_block_number_t physical,
 			   bio_end_io_t callback, vdo_action_fn error_handler,
diff --git a/drivers/md/dm-vdo/packer.c b/drivers/md/dm-vdo/packer.c
index f09eb1ca4902..e391cac6c92d 100644
--- a/drivers/md/dm-vdo/packer.c
+++ b/drivers/md/dm-vdo/packer.c
@@ -486,7 +486,7 @@ static void write_bin(struct packer *packer, struct packer_bin *bin)
 	WRITE_ONCE(stats->compressed_blocks_written,
 		   stats->compressed_blocks_written + 1);
 
-	submit_data_vio_io(agent);
+	vdo_submit_data_vio(agent);
 }
 
 /**
-- 
2.40.0


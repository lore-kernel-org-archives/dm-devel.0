Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54F565675B
	for <dm-devel@lists.linux.dev>; Tue,  6 Feb 2024 02:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707185067; cv=none; b=Dy7SsJdnuqlN5uYEfYh3myF7Wf7Z9iaL4ZZWc3gy3k5zSeGpLSIW4H/UBRZl9e1J9y7Z9c2fWRvSbuGaDS5sZ7JTffDN+9Rt/VOZxgBpFbQRApTuP9ZpFM0gTIbMzcJj2iUFcitHt5+pyX7YZLJIEN/3LHCqsN7QEW0QDSlCMRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707185067; c=relaxed/simple;
	bh=eltB9wxMdKiyaxk6OLgUlbzN/tNvW7hx+7ZCGRChaCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L8uZmN2uqCXggKtmwMHMrRdIOdwyWhp9GH6K0Of4dnfqVRO7NxDqKOSHO/4ZY8luNaVNzLxJNVEvbwQXZjyq9twmsjKP9g3R7SArXFJf+SHXGfGZz9TH7ibORMGr6KVCqkiZD6DSVNaTdIAKvcWSK3Wt8O54eitYSI4tdnEYjA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Mc6Uh/Nn; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Mc6Uh/Nn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707185064;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6MiRUKBMB0KuUXvrN8OXpYC2JlZPNs9i3tDHSc13fd4=;
	b=Mc6Uh/NnkJ7qhO3yJTe4ALsrvBpOz3Zee6KkyPmmlUfv91per75Tl/9hFvRHnIAq+Vzfik
	YcdleSIDkUO8fl2+5pH+WpQtYgJS8TeLNVQjSE9bZTbaz7oGMi/0KM+CuC2Rdht0u4J/fq
	hrH5dFsEy8gQTO8nXWDJFJ5scSPjGug=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-57-5-mEUAtmOjSyfC7kZ4S4Bg-1; Mon, 05 Feb 2024 21:04:22 -0500
X-MC-Unique: 5-mEUAtmOjSyfC7kZ4S4Bg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A43C0185A783;
	Tue,  6 Feb 2024 02:04:22 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 99156492BF0;
	Tue,  6 Feb 2024 02:04:22 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 939E3569FA; Mon,  5 Feb 2024 21:04:22 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 2/7] dm vdo: fix sparse 'warning: Using plain integer as NULL pointer'
Date: Mon,  5 Feb 2024 21:04:17 -0500
Message-ID: <454e6715c7d8811765295ba656e60a09f294373d.1707184413.git.msakai@redhat.com>
In-Reply-To: <cover.1707184413.git.msakai@redhat.com>
References: <cover.1707184413.git.msakai@redhat.com>
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

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Susan LeGendre-McGhee <slegendr@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/index.c | 8 ++++----
 drivers/md/dm-vdo/vdo.c   | 3 ++-
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-vdo/index.c b/drivers/md/dm-vdo/index.c
index e343a973881d..1596f6ba43a5 100644
--- a/drivers/md/dm-vdo/index.c
+++ b/drivers/md/dm-vdo/index.c
@@ -732,18 +732,18 @@ static void close_chapters(void *arg)
 
 static void stop_chapter_writer(struct chapter_writer *writer)
 {
-	struct thread *writer_thread = 0;
+	struct thread *writer_thread = NULL;
 
 	uds_lock_mutex(&writer->mutex);
-	if (writer->thread != 0) {
+	if (writer->thread != NULL) {
 		writer_thread = writer->thread;
-		writer->thread = 0;
+		writer->thread = NULL;
 		writer->stop = true;
 		uds_broadcast_cond(&writer->cond);
 	}
 	uds_unlock_mutex(&writer->mutex);
 
-	if (writer_thread != 0)
+	if (writer_thread != NULL)
 		uds_join_threads(writer_thread);
 }
 
diff --git a/drivers/md/dm-vdo/vdo.c b/drivers/md/dm-vdo/vdo.c
index 1ead769f0150..e0eddd4007b8 100644
--- a/drivers/md/dm-vdo/vdo.c
+++ b/drivers/md/dm-vdo/vdo.c
@@ -889,7 +889,8 @@ int vdo_synchronous_flush(struct vdo *vdo)
 	int result;
 	struct bio bio;
 
-	bio_init(&bio, vdo_get_backing_device(vdo), 0, 0, REQ_OP_WRITE | REQ_PREFLUSH);
+	bio_init(&bio, vdo_get_backing_device(vdo), NULL, 0,
+		 REQ_OP_WRITE | REQ_PREFLUSH);
 	submit_bio_wait(&bio);
 	result = blk_status_to_errno(bio.bi_status);
 
-- 
2.42.0


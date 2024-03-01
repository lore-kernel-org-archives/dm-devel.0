Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F772AEEE
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 04:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709266438; cv=none; b=CYFf6f8N864HAApcRKUoqT36RQOuu4tBnekPkZsj8yWQSNlccnyI0xq0bSYeEWhC1Sek+TZU+7z4yiYD52NdfL+VLehf76H+c9wNKRSmqY0KXLKGbcgrRzaRES9ZjJpMiEPc3Uoso65+A1vRMzK+Pe3PzhT4csAX7dTOd3eS5m8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709266438; c=relaxed/simple;
	bh=4fM1tmuXO7U0//KbMfqGbYCaaL8V1AUtP7y2kLYuTsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jZ3xjNJX9YeLsg2AG4WA0bMFyRXfTYMvmtwAlZOH1NTeEh4f3mnol2OJxH91gTwHO1hDxt4ImeB+mXjKEWJoCc1OJAkW67B82++ml/F5tIGd7VCDpQiHAeu3tASsjmGOvs6O4aiNJhggF0DsGsyFi1oA3OkBKdpswxzMeH00Rn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HMuTOHcc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HMuTOHcc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709266435;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W9pSXJHatv4ovIgjrzn93fgTY0sX3D9fufrL14lbn/E=;
	b=HMuTOHcc25EODHx03PlE+yoeZsBtRL0otMxoeDvYP0WLNxlhqmrehoEDD2O63xHVfaA1KY
	2GYvyf+V9rXhMkNT0+oW8ruF3n71EhSrS7lnLzAHNZkGWoG5NRiBnpCH5tJTeRrm73bw+q
	LxGxWPBDpxYhxavVm+G6pCSvQ5X+m1M=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-63-DJEKd003MN-Gi6j4uPG1mQ-1; Thu,
 29 Feb 2024 23:13:53 -0500
X-MC-Unique: DJEKd003MN-Gi6j4uPG1mQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 88F5029AC011;
	Fri,  1 Mar 2024 04:13:53 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8247D492BC6;
	Fri,  1 Mar 2024 04:13:53 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 7F3B5A15B4; Thu, 29 Feb 2024 23:13:53 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 3/5] dm vdo indexer-volume: fix missing mutex_lock in process_entry
Date: Thu, 29 Feb 2024 23:13:51 -0500
Message-ID: <90036bb8fdef1cfb0f677465358bab87b53e2ea8.1709265967.git.msakai@redhat.com>
In-Reply-To: <cover.1709265967.git.msakai@redhat.com>
References: <cover.1709265967.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Mike Snitzer <snitzer@kernel.org>

Must mutex_lock after dm_bufio_read, before dm_bufio_read error
handling, otherwise process_entry error path will return without
volume->read_threads_mutex held. This fixes potential double
mutex_unlock.

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Susan LeGendre-McGhee <slegendr@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/volume.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-vdo/volume.c b/drivers/md/dm-vdo/volume.c
index 37c2ef0777e5..60416dc8a9d7 100644
--- a/drivers/md/dm-vdo/volume.c
+++ b/drivers/md/dm-vdo/volume.c
@@ -556,6 +556,7 @@ static int process_entry(struct volume *volume, struct queued_read *entry)
 
 	mutex_unlock(&volume->read_threads_mutex);
 	page_data = dm_bufio_read(volume->client, page_number, &page->buffer);
+	mutex_lock(&volume->read_threads_mutex);
 	if (IS_ERR(page_data)) {
 		result = -PTR_ERR(page_data);
 		uds_log_warning_strerror(result,
@@ -564,7 +565,6 @@ static int process_entry(struct volume *volume, struct queued_read *entry)
 		cancel_page_in_cache(&volume->page_cache, page_number, page);
 		return result;
 	}
-	mutex_lock(&volume->read_threads_mutex);
 
 	if (entry->invalid) {
 		uds_log_warning("Page %u invalidated after read", page_number);
-- 
2.42.0


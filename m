Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A219245020
	for <dm-devel@lists.linux.dev>; Tue, 14 Apr 2026 00:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776126176; cv=none; b=DJVrbm8nR7AVxZtS97a6WsaLLno8oFYaYl6tTikYk7x2JpErYGb7x410Dccrk9ilLYJTlFjMijb4HXET1TV+cufp7H2DCucdfkvKnKRqEIAymvw0D/YA+AlRqx48eBjWVpDqmZaXkzvm2kx1DMF47zqPlSpD6JPXzj26TY1tHU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776126176; c=relaxed/simple;
	bh=LGXCPK0WIeb96A3NC8ZkfX/nGxwdjBOpBz9Knpay8YQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=O5qN7qB8InOUXemEqTVXLaDzWK7qU1jXjuKacarZebsTt8QbIDYSxI/NlzA5cPvDayNY7Wtck3jjQuR9pQ0pO4HUUUYWBFLoz6m0uoNVD1zwv8id/yB5Qlpl738fqlqGnqN4J+WiMuju2pdpidtdhFIeQ7xAOFD4VrAofxtuSmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BZ37BC+f; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BZ37BC+f"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776126174;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YFqV/KOxxVZt5oI9jDOVr4WGcOcSzlwNUFUrpU5i+XY=;
	b=BZ37BC+fSis61rbtsDCSqRsZtw3SHhOTojnZS1QdJ+CGaHT1i/VQnmaL41RPzcNmf0ogd0
	cTFwMvaSitDVB+qtgm4UTEOwZMOl5OLittc+SeXtg+NaSN9Mnon8Z/Z+oDTDryyCNK3LNe
	7Qz28k+ciCUVJQNnzZet/V3Yb409Xns=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-271-gmWdqrukM1ma3swKIIxhLA-1; Mon,
 13 Apr 2026 20:22:48 -0400
X-MC-Unique: gmWdqrukM1ma3swKIIxhLA-1
X-Mimecast-MFC-AGG-ID: gmWdqrukM1ma3swKIIxhLA_1776126167
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C2ED9195609D;
	Tue, 14 Apr 2026 00:22:46 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4E2F519560AB;
	Tue, 14 Apr 2026 00:22:46 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 63E0MjWs1917474
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 13 Apr 2026 20:22:45 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 63E0MjTa1917473;
	Mon, 13 Apr 2026 20:22:45 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@kernel.org>
Cc: dm-devel@lists.linux.dev, linux-integrity@vger.kernel.org,
        Mimi Zohar <zohar@linux.ibm.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Subject: [PATCH 02/10] dm-ima: remove broken last_target_measured logic
Date: Mon, 13 Apr 2026 20:22:36 -0400
Message-ID: <20260414002244.1917447-3-bmarzins@redhat.com>
In-Reply-To: <20260414002244.1917447-1-bmarzins@redhat.com>
References: <20260414002244.1917447-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: fJyD0UXTA8l-pAAtWFrKl6JFOTfds8yX_0UIMb-HDMU_1776126167
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

When it ran out of space for adding more targets to the ima_buf,
dm_ima_measure_on_table_load() would measure the dm device early, and
then add the rest of the targets and measure it again.
last_target_measured was intended to flag the last target measured so
that the device wouldn't get remeasured, if no new targets were added
after the early measurement. But the way to code works, the dm device
will never be measured early unless there is another target to add to
the ima_buf.  Instead, if there is only one more target to add, that
target was getting added to the ima_buf, but it wasn't getting
remeasured, because last_target_measured was set. Since
dm_ima_measure_on_table_load() only measures a device early when there
are more targets to add, the final measurement must always happen, and
last_target_measured is unneeded.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 drivers/md/dm-ima.c | 18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

diff --git a/drivers/md/dm-ima.c b/drivers/md/dm-ima.c
index a639bb0fe6c3..209221fa8bc5 100644
--- a/drivers/md/dm-ima.c
+++ b/drivers/md/dm-ima.c
@@ -167,7 +167,6 @@ void dm_ima_measure_on_table_load(struct dm_table *table, unsigned int status_fl
 	size_t device_data_buf_len, target_metadata_buf_len, target_data_buf_len, l = 0;
 	char *target_metadata_buf = NULL, *target_data_buf = NULL, *digest_buf = NULL;
 	char *ima_buf = NULL, *device_data_buf = NULL;
-	int last_target_measured = -1;
 	status_type_t type = STATUSTYPE_IMA;
 	size_t cur_total_buf_len = 0;
 	unsigned int num_targets, i;
@@ -205,8 +204,6 @@ void dm_ima_measure_on_table_load(struct dm_table *table, unsigned int status_fl
 	for (i = 0; i < num_targets; i++) {
 		struct dm_target *ti = dm_table_get_target(table, i);
 
-		last_target_measured = 0;
-
 		/*
 		 * First retrieve the target metadata.
 		 */
@@ -256,14 +253,6 @@ void dm_ima_measure_on_table_load(struct dm_table *table, unsigned int status_fl
 
 			memcpy(ima_buf + l, device_data_buf, device_data_buf_len);
 			l += device_data_buf_len;
-
-			/*
-			 * If this iteration of the for loop turns out to be the last target
-			 * in the table, dm_ima_measure_data("dm_table_load", ...) doesn't need
-			 * to be called again, just the hash needs to be finalized.
-			 * "last_target_measured" tracks this state.
-			 */
-			last_target_measured = 1;
 		}
 
 		/*
@@ -277,11 +266,8 @@ void dm_ima_measure_on_table_load(struct dm_table *table, unsigned int status_fl
 		l += target_data_buf_len;
 	}
 
-	if (!last_target_measured) {
-		dm_ima_measure_data(table_load_event_name, ima_buf, l, noio);
-
-		sha256_update(&hash_ctx, (const u8 *)ima_buf, l);
-	}
+	dm_ima_measure_data(table_load_event_name, ima_buf, l, noio);
+	sha256_update(&hash_ctx, (const u8 *)ima_buf, l);
 
 	/*
 	 * Finalize the table hash, and store it in table->md->ima.inactive_table.hash,
-- 
2.53.0


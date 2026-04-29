Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A9A938423A
	for <dm-devel@lists.linux.dev>; Wed, 29 Apr 2026 20:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777494079; cv=none; b=OTaX38Sn9tHir26K4HFr75f4W3zfIc2CXvgICZnWaCE6oFH+/er1+pl2KLgkLHnlO/pSzbNMu4eo6R8LglW/Z6Vql1m+crF4WzL2cB2WHK15Rh1ueQfJX83RYpZGs6Bp2TG2RS4rhuL6n/RBWoqqQLPpuYeYZDKK8WzMJIVDsNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777494079; c=relaxed/simple;
	bh=LGXCPK0WIeb96A3NC8ZkfX/nGxwdjBOpBz9Knpay8YQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=J/5T4eT8jeTpf0/dzmcCmL5sdVNs/5vffiLoV7gYD4MmBHvBQ8R/SZCscZ3mp7aBWHCv61eActsDcRZ1EHPMf/fuMrFbJsDE2uKc+5s54L+pHPpiKNvbeP7amvhUJ/mt+UDfN53C/JsVGEMSfy2O9sWnwMSoLT/s5733JoGt2Cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Yq3U8muv; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Yq3U8muv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777494076;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YFqV/KOxxVZt5oI9jDOVr4WGcOcSzlwNUFUrpU5i+XY=;
	b=Yq3U8muvofc0EAhSQh2pB0kQBKvUmd3pupqFfkfltfkeVqbLyFRTw3resmR1XVJluq7Zg2
	34OYqm4FwF/f+zqbY0Ln/WeGPip68/mI0X60agIMQ5P/8+VDLtgqbzOPme5q3Y0RES4bdD
	4iO45uPjx0q1Fuc2Ek8RWU21tDKFra0=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-60-pfTWDh4VPGuhfXM09aApsw-1; Wed,
 29 Apr 2026 16:21:12 -0400
X-MC-Unique: pfTWDh4VPGuhfXM09aApsw-1
X-Mimecast-MFC-AGG-ID: pfTWDh4VPGuhfXM09aApsw_1777494071
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 50CF31800345;
	Wed, 29 Apr 2026 20:21:11 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B7132180045E;
	Wed, 29 Apr 2026 20:21:10 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 63TKL9RE2823288
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 29 Apr 2026 16:21:09 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 63TKL9fv2823287;
	Wed, 29 Apr 2026 16:21:09 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@kernel.org>
Cc: dm-devel@lists.linux.dev, linux-integrity@vger.kernel.org,
        Alasdair Kergon <agk@redhat.com>, Mimi Zohar <zohar@linux.ibm.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
        steven chen <chenste@linux.microsoft.com>
Subject: [PATCH v2 02/10] dm-ima: remove broken last_target_measured logic
Date: Wed, 29 Apr 2026 16:21:00 -0400
Message-ID: <20260429202108.2823261-3-bmarzins@redhat.com>
In-Reply-To: <20260429202108.2823261-1-bmarzins@redhat.com>
References: <20260429202108.2823261-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: mHfxuAWy16JUrdfK1VIG13iSBKlcF8vxUpTK4uJV6Xo_1777494071
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


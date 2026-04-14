Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3F7B22579E
	for <dm-devel@lists.linux.dev>; Tue, 14 Apr 2026 00:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776126174; cv=none; b=KsTFmypCYPUedKPXfFmkGv+cpPB/ZWJbn/3/iOzLzTZvR1H8zSn4AbQ0YinaViEr0WSGLOQg9vpzWtkuioNtnEIE+swU3ii9vkg1bQONXaccG1K980RxDZTwGYtTHGKgybtGCywEweH4oDFs8HqkMWE3HB/Ie7lQcJpSj8XKo/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776126174; c=relaxed/simple;
	bh=S2t/1ZIPTPz36gInG8LpTnv9ZVB7pK1s7Wd3Rc/7Xz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=tqpROwZrkyp4w3y6bzH8vOML8siB9Nsh6rrsuSReSy8scFtPRxLes+GHJQaCHopdAlPj+SL3O5ac20+xS/CnINSiU8TfHDUP8KglChQCCLcWPUXPIBZ6sps9CllvLvNsjJppRdE6kv70O5JJnlnfFfBck5TGDXwb27uPXgHJxgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XXHq95ni; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XXHq95ni"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776126171;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iIGjSRzHjgHK3cVWJrouI3TfS1aOqL3ldvWQApm8Ax0=;
	b=XXHq95nifBvWI+1auV+rCBU5QfajkQA1/eEHtpV+OEmh+COvWTOeuCViwWlNVUfLRKh9g1
	8/2p9y8HgRsF6Ujo3CG7asWfDUCHmrMKVeOSsfmlf0nJMZZKOYppeEpLWJBRkAtDfci2mK
	Iy3U7ro91UPiV3a9xteN+mCYVoZxH/o=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-302-m7oIsHyAMDeas_JGBiIC2Q-1; Mon,
 13 Apr 2026 20:22:48 -0400
X-MC-Unique: m7oIsHyAMDeas_JGBiIC2Q-1
X-Mimecast-MFC-AGG-ID: m7oIsHyAMDeas_JGBiIC2Q_1776126167
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5E8F41956048;
	Tue, 14 Apr 2026 00:22:47 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2AA3B18002A6;
	Tue, 14 Apr 2026 00:22:47 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 63E0Mkt91917498
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 13 Apr 2026 20:22:46 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 63E0MkSL1917497;
	Mon, 13 Apr 2026 20:22:46 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@kernel.org>
Cc: dm-devel@lists.linux.dev, linux-integrity@vger.kernel.org,
        Mimi Zohar <zohar@linux.ibm.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Subject: [PATCH 08/10] dm-ima: Handle race between rename and table swap
Date: Mon, 13 Apr 2026 20:22:42 -0400
Message-ID: <20260414002244.1917447-9-bmarzins@redhat.com>
In-Reply-To: <20260414002244.1917447-1-bmarzins@redhat.com>
References: <20260414002244.1917447-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: 7ogdVKSt85wVC6imgr_kv9itn3TkHp6nsQ8MgnDs6Mk_1776126167
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

a device rename could happen after do_resume() removed the inactive
table that it was swapping to out of the hash cell, but before it was
made the active table. In this case, the table metadata would still
have the old name. Update the swapped table's metadata to avoid this.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 drivers/md/dm-ima.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/md/dm-ima.c b/drivers/md/dm-ima.c
index 5c6f3f8761a8..4631dc2a6d4d 100644
--- a/drivers/md/dm-ima.c
+++ b/drivers/md/dm-ima.c
@@ -367,6 +367,19 @@ void dm_ima_measure_on_device_resume(struct mapped_device *md, bool swap,
 		kfree(md->ima.active_table.device_metadata);
 		md->ima.active_table = context->table;
 		memset(&context->table, 0, sizeof(context->table));
+		if (md->ima.active_table.device_metadata) {
+			/*
+			 * A rename could have happened while the swap was
+			 * going on. In that case, the saved table info would
+			 * still have the old name. Update the metadata to be
+			 * sure that it has the current name
+			 */
+			struct dm_ima_device_table_metadata *table = &md->ima.active_table;
+			fix_context_strings(context);
+			dm_ima_copy_device_data(md, table->device_metadata,
+						context, table->num_targets);
+			table->device_metadata_len = strlen(table->device_metadata);
+		}
 	}
 
 	if (md->ima.active_table.device_metadata) {
-- 
2.53.0


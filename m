Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F93721B18B
	for <dm-devel@lists.linux.dev>; Tue, 22 Apr 2025 23:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745365665; cv=none; b=mFPjoyGL6IXynVwP1h9zUfrS4gXSt1q2949o9m+dLCV/qb/SYjCt7SmRzOJf5ZLqyin8cRqQGcHzzMEs0/Mu9iTKKBzyLbVKD2j8+cDqWhaJTxU0yIhyTOw7QWvOVAjZC44H1InD2VuLDgJtY8/i21m81jQAJ5tjVJm6mBMwyBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745365665; c=relaxed/simple;
	bh=9iee4iHP4Zw2piPyidLK/4IhbtesHUSC8g896QfY5K4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=KQ9aixIQEWz49GujdwotLlE4fjHGl2iWAr6YrnoM3E957P4y5hgsct2ZQ4QfVnTDlmuETNhCEihOelpxtZWMY8Pg/TNCoz+qicyj+Qz74FLFSCG4Kri5wIilOJdxaxLrVe3yNYtGCgAVNlAB50wtU3sXyS/tQuxNUaK+IfzRkH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Hc7xAsxl; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Hc7xAsxl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745365662;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SXgzSMczZFHhTXokfRG/X8nC05pRLu6OA9OCVMOVGsE=;
	b=Hc7xAsxlUWHV/8KNR4JtODC1UWgQOwGqXcVkWqhbhbmF05jdJLr6YKHvIDoi2ZaWVPlY8H
	yhUR05BW8FC6+L2kYf+sc1AInA/5o+fMdEzy7RI8bh2niuD2oErEYYnTV5Ok4afqRbB3rj
	lg0Q/dfhsYiuvFgVJB2jgwlm2oveLKg=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-193--NWXrtQSPd2bFq8QcaFW2w-1; Tue,
 22 Apr 2025 19:47:41 -0400
X-MC-Unique: -NWXrtQSPd2bFq8QcaFW2w-1
X-Mimecast-MFC-AGG-ID: -NWXrtQSPd2bFq8QcaFW2w_1745365660
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8BBB4180034E;
	Tue, 22 Apr 2025 23:47:40 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1066819560A3;
	Tue, 22 Apr 2025 23:47:39 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 53MNlcKV1654077
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 22 Apr 2025 19:47:38 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 53MNlck21654076;
	Tue, 22 Apr 2025 19:47:38 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@lists.linux.dev, Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 3/4] dm-flakey: remove useless ERROR_READS check in flakey_end_io
Date: Tue, 22 Apr 2025 19:47:37 -0400
Message-ID: <20250422234738.1654052-4-bmarzins@redhat.com>
In-Reply-To: <20250422234738.1654052-1-bmarzins@redhat.com>
References: <20250422234738.1654052-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: yMyUsFbno1cbrnr-q64RLSp8yzsOIqcHSB0aeSqOk04_1745365660
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

If ERROR_READS is set, flakey_map returns DM_MAPIO_KILL for read
bios and flakey_end_io is never called, so there's no point in
checking it there. Also clean up an incorrect comment about when
read IOs are errored out.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 drivers/md/dm-flakey.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
index 35f1708b62e8..0421f9336680 100644
--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -511,8 +511,8 @@ static int flakey_map(struct dm_target *ti, struct bio *bio)
 		pb->bio_submitted = true;
 
 		/*
-		 * Error reads if neither corrupt_bio_byte or drop_writes or error_writes are set.
-		 * Otherwise, flakey_end_io() will decide if the reads should be modified.
+		 * If ERROR_READS isn't set flakey_end_io() will decide if the
+		 * reads should be modified.
 		 */
 		if (bio_data_dir(bio) == READ) {
 			if (test_bit(ERROR_READS, &fc->flags))
@@ -590,13 +590,6 @@ static int flakey_end_io(struct dm_target *ti, struct bio *bio,
 			if (rem < fc->random_read_corrupt)
 				corrupt_bio_random(bio);
 		}
-		if (test_bit(ERROR_READS, &fc->flags)) {
-			/*
-			 * Error read during the down_interval if drop_writes
-			 * and error_writes were not configured.
-			 */
-			*error = BLK_STS_IOERR;
-		}
 	}
 
 	return DM_ENDIO_DONE;
-- 
2.48.1


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794408229;
	b=mDYdRb9pY1wZGvCEgYAlcz41Pa4Oar3PyHvA7AV2hqslJyLuop7Y4qNqIP7Cn6V7rlhX
	 E0PJYJ0WalKc0z7wLEWZUdjBOXy0DDBrmki2fePf7uULonqZX1X2ghp01FPQ0JGQ4U8rx
	 QCVbk/91XT6I50oU7t8N511rAZVt6fo/SEtZZRw8SshZtVc1hGrMdwKGsc1Ysk+2SRWS6
	 ZzkYSyJQe7wyxX04ofGs86O3dKwRk6HZyHM792HCJt0uehaaF56GbmYIk6farWf2XC5lv
	 mS4KhAmLiuhSsEFURgm4z30JN63YkJrqVkdyIjzuN9WG99WAjayJL3gSVsm6YT1a+ig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794408229;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Date:From:To:cc:Subject:
	 Message-ID:MIME-Version:X-Scanned-By:X-Mimecast-Spam-Score:
	 X-Mimecast-MFC-PROC-ID:X-Mimecast-Originator:Content-Type;
	bh=BhNhi18oHKv88CGy7fgUqQZ3c+gMEFNH0lHTwZSHB8I=;
	b=uyJjNUn1otObF2L3qubn3gaCKJ7VxvWjJnE6ehBEhp3xyhzon3mxcz9qXQz6VhhEuf2m
	 muehfiQngLm70Ir64H5WdgT1SBaXKF7xqWJ6TJOXS9epm+dG+S7ol2iZvk7awFuQr+obd
	 PXsm2GPjCHBFCDtT+OmzVbviG1POiUCkFBAMfEZhRLZm3WRdX9amqyavxSMRswBNJeYEr
	 Fox/zxWk6MD9aWqfUTX0kWIjldnXJbAChUHCiQxW7MlbccoAvUAxgmNJdb/srYrHf7DV7
	 AX1yBlKHvkECVsl1F7YEsBApj8lAM8BrshYqehGjMxPWcOw+tbsgrMkDVS0UHswmowQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=HGgOa+PH;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81569606A321
	for <dm-devel@lists.linux.dev>; Wed, 11 Nov 2026 14:43:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 81569606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=HGgOa+PH
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794408227;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=BhNhi18oHKv88CGy7fgUqQZ3c+gMEFNH0lHTwZSHB8I=;
	b=HGgOa+PHcHfG47qHuWfUZgCbPYLZuTW6ROut1dqltNtxyyjVApAsZQi6Z4MH6iehRQjiQv
	ml8Cr9AsoT+ccq2eS/y71eYjZ0kM3mkL/0aofF701PgHJRO33W9fb4qRk6OtygwghkNtpg
	JOiDo0ZAue6C5+aj7rC0aVnF9shwmWY=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-479-wELaLW_NOle_CVwWcD5_cQ-1; Wed,
 11 Nov 2026 09:43:42 -0500
X-MC-Unique: wELaLW_NOle_CVwWcD5_cQ-1
X-Mimecast-MFC-AGG-ID: wELaLW_NOle_CVwWcD5_cQ_1794408222
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CDA8B19539B5;
	Wed, 11 Nov 2026 14:43:41 +0000 (UTC)
Received: from mpatocka-thinkpadx1carbongen12.rmtcz.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 10A0441F;
	Wed, 11 Nov 2026 14:43:39 +0000 (UTC)
Date: Wed, 11 Nov 2026 15:43:37 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, 
    Mike Snitzer <snitzer@kernel.org>, Alasdair Kergon <agk@redhat.com>
cc: dm-devel@lists.linux.dev, 
    syzbot+94dac3c75477e184f0b0@syzkaller.appspotmail.com
Subject: [PATCH] dm-integrity: don't attempt to commit journal on disabled
 device
Message-ID: <fe63f092-ef07-ac3f-7878-22083541f79e@redhat.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: kq3fAo_mYmVUlpSSOq2_z0gQE1jGij2AVJXRE-BP9cI_1794408222
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

If the device is disabled due to an error, we shouldn't attempt to flush 
the journal. We jump straight to the label release_flush_bios, that will 
call do_endio on all queued bios. do_endio will terminate the bios with 
the error.

This fixes WARN_ON in the function pad_uncommitted reported by syzkaller.

Reported-by: syzbot+94dac3c75477e184f0b0@syzkaller.appspotmail.com
Closes: https://syzbot.org/bug?extid=94dac3c75477e184f0b0
Fixes: 7eada909bfd7 ("dm: add integrity target")
Cc: stable@vger.kernel.org
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-integrity.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c
+++ linux-2.6/drivers/md/dm-integrity.c
@@ -2908,6 +2908,10 @@ static void integrity_commit(struct work
 
 	spin_lock_irq(&ic->endio_wait.lock);
 	flushes = bio_list_get(&ic->flush_bio_list);
+	if (unlikely(dm_integrity_failed(ic))) {
+		spin_unlock_irq(&ic->endio_wait.lock);
+		goto release_flush_bios;
+	}
 	if (unlikely(ic->mode != 'J')) {
 		spin_unlock_irq(&ic->endio_wait.lock);
 		dm_integrity_flush_buffers(ic, true);
@@ -5409,7 +5413,6 @@ try_smaller_buffer:
 		r = create_journal(ic, &ti->error);
 		if (r)
 			goto bad;
-
 	}
 
 	if (ic->mode == 'B') {


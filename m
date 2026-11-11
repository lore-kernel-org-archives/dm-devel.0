Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794419496;
	b=g20E6Yk4SLEihtCBb8+AUnqUPEQZd02WkXHAGHdpXlLUG6F6U2w1MoUldAfpMaB0VlvE
	 bBzmZJFCcpi3oT1syLivwGp2U3p5atOdNbu+rrWEEOKnqPbn2nQVEMJazfT6uRODqhIKE
	 vPWtsESXGrflxfr54rrn3c6OtVl4GgfIc6rDkMZOkdwnT0S41Re28k3ARR8pC6bqy3sbA
	 F/P3cYphcQm7DHUMXs93enHejbsoLn6W+YBbMRoNC+rSf73Sjdq1IQQfO3uJYOwmMl117
	 wyX2+a+L5HpOMfGmPJ5cItlavdp8GQPjZJrw9mHdb5y5RTMzU0nx/ZgTyWk1c0dyHnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794419496;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Date:From:To:cc:Subject:
	 Message-ID:MIME-Version:X-Scanned-By:X-Mimecast-Spam-Score:
	 X-Mimecast-MFC-PROC-ID:X-Mimecast-Originator:Content-Type;
	bh=Y1jvGd4ldv3C9CeioyugUb0XHmJlPCWGoyLO+SHYsbo=;
	b=Ix9SOucPVYvRjhHZUgsOq7McMzYZnFXVTO24jvv7tIh0ayDWjctd3IZHfYMMOvgXsact
	 hMpaaZP7kBzsiRzJnmuTb9pGzRZrG4SgaqvaGBPqNi0huON0w5lkAfWpnoUHMQy32lUD9
	 mGTTs3vT9+0J1eQa1r8/rVKJXdCt6ZZZWWMq3YiTmxvzXf2svEmasuDqqvHDlio53e7bc
	 wfcRzzg6XwMLPLi6cV45Yt3iQcBOw3xRBYFbiJWIoPkR6y1EKvTqPGt5QErMyljpuqDhO
	 zQVS3LPU287NhmLejJJ38AHUHfYmTDVpqhpmwGpNU+US+c6cNcgZ9JzQnBHCPsX5YWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=GCyGlfj6;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D4CE60A2626
	for <dm-devel@lists.linux.dev>; Wed, 11 Nov 2026 17:51:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0D4CE60A2626
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=GCyGlfj6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794419495;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=Y1jvGd4ldv3C9CeioyugUb0XHmJlPCWGoyLO+SHYsbo=;
	b=GCyGlfj6oZjGBzhwcKD5RLIJR8prosR/5IRvv22c7VhvbqteUaZgab10CfI2eV2y4hguQd
	E4Y45BVXdMbrRcGaWCcaxv5k7dLd/jSiZ3lb8tw3npDlM7wj8TPYBmRP+eQ1icaIyBR5as
	DsKs309p3t2JoZ8iqe2JDDz+8WVPcdg=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-439-CWxwieR_N_K_hRKmCik1Rw-1; Wed,
 11 Nov 2026 12:51:31 -0500
X-MC-Unique: CWxwieR_N_K_hRKmCik1Rw-1
X-Mimecast-MFC-AGG-ID: CWxwieR_N_K_hRKmCik1Rw_1794419490
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7EAFC1800BE1;
	Wed, 11 Nov 2026 17:51:30 +0000 (UTC)
Received: from mpatocka-thinkpadx1carbongen12.rmtcz.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C870C1956095;
	Wed, 11 Nov 2026 17:51:28 +0000 (UTC)
Date: Wed, 11 Nov 2026 18:51:26 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, 
    Mike Snitzer <snitzer@kernel.org>, Alasdair Kergon <agk@redhat.com>
cc: dm-devel@lists.linux.dev, 
    syzbot+94dac3c75477e184f0b0@syzkaller.appspotmail.com
Subject: [PATCH v2] dm-integrity: don't attempt to commit journal on disabled
 device
Message-ID: <5fc913df-c765-8bf8-55a9-839256261df3@redhat.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: oDyKSlSiKwDDaivfV155HylBdQksLgmSRwNt3sXwqtE_1794419490
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
 drivers/md/dm-integrity.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c
+++ linux-2.6/drivers/md/dm-integrity.c
@@ -2908,6 +2908,11 @@ static void integrity_commit(struct work
 
 	spin_lock_irq(&ic->endio_wait.lock);
 	flushes = bio_list_get(&ic->flush_bio_list);
+	if (unlikely(dm_integrity_failed(ic))) {
+		wake_up_locked(&ic->endio_wait);
+		spin_unlock_irq(&ic->endio_wait.lock);
+		goto release_flush_bios;
+	}
 	if (unlikely(ic->mode != 'J')) {
 		spin_unlock_irq(&ic->endio_wait.lock);
 		dm_integrity_flush_buffers(ic, true);
@@ -5409,7 +5414,6 @@ try_smaller_buffer:
 		r = create_journal(ic, &ti->error);
 		if (r)
 			goto bad;
-
 	}
 
 	if (ic->mode == 'B') {


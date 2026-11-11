Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794358154;
	b=Y9s21/+aIP0dcoV8H3mUCc1hox796mbx2+3iy3yUuzy5KCD8xS48yU0CaGR64yQvmdcb
	 E7CAzMBG4a/6YNzeR350Z5m30dyrMPT6Ny/175xgznsB659uF4Jo6aLpqcK420k+6hW+j
	 /qqRc3k4jMe257Sl/CgqzIWTNw9+xcmQo+FH3/8hgb7f92IFjCNmhAh2f6QUrAJtagiD2
	 AemOtte+SyCLTBieSR7OM7CpXJthUNGnLFirVY0/NPTUsDZ/6vJyrZnjJqjYsi7CvLj75
	 GQpSeucIQ8+6s2JdHnw9sZP9e4ilVsD4e6CfmCaKuaXbtTOxw8F0IpsU5ZZVY3OZV3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794358154;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:MIME-Version:X-Scanned-By:
	 X-Mimecast-MFC-PROC-ID:X-Mimecast-Originator:
	 Content-Transfer-Encoding:content-type;
	bh=xtnCeg/8KyCVflxN5Slzje9tkyEmRVFC3OaNifpvhos=;
	b=oNKJ00jdPMfwMYKff0EhafOw+a8kyC81a6OmgiIvVAQC6uTxMT8YuaLEjGoDpUu7cftm
	 +e22GBe8gY+DpowlfR37DDm4VRCMzZVVfAK2m3T4HYmz1Fxv3Gha6S3ZzKGQiPMVx7IWO
	 /pTayJlE1ymfUIk6OroUjMU7UeUPd79eKTxJxWBH7FxW6RHJncox7vRDT4739pouwrhaN
	 RNGpoDyXK9JLL1I29Dbujzx488xfLx5sBju8hakupqErf2ynHcVV4dftlXCaGN4Ybb50C
	 vnlbbzmh9g57lAwLU3UP7zZ1x+xsKdE2srhFTGf9CPLogyMM/r6l29+4RIapIX1aXPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=gcmiNki1;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 399F8606A31C
	for <dm-devel@lists.linux.dev>; Wed, 11 Nov 2026 00:49:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 399F8606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=gcmiNki1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794358152;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=xtnCeg/8KyCVflxN5Slzje9tkyEmRVFC3OaNifpvhos=;
	b=gcmiNki1YvXcaaVzDBIm5cAijM3B1taSCBydInEfOS3D7D32vCqkk5jpLTzWKk3aRVjAJ9
	aefLfGwGuOnBCUB4zBvlL2vyLvg5uGY11KsCDFRnpB/ctU22zRFoEE9v0p3uH/YZhDf9dU
	k+BkNgMr7p0ip0eUgAxpsvTEQD/mvzQ=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-159-g2umW1eiNc2e44EyTvZTRg-1; Tue,
 10 Nov 2026 19:49:08 -0500
X-MC-Unique: g2umW1eiNc2e44EyTvZTRg-1
X-Mimecast-MFC-AGG-ID: g2umW1eiNc2e44EyTvZTRg_1794358147
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 768B81800344;
	Wed, 11 Nov 2026 00:49:07 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E30DF195608C;
	Wed, 11 Nov 2026 00:49:06 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 6AB0n5bR1047766
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 10 Nov 2026 19:49:05 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 6AB0n5vm1047761;
	Tue, 10 Nov 2026 19:49:05 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@kernel.org>
Cc: dm-devel@lists.linux.dev,
        syzbot+94dac3c75477e184f0b0@syzkaller.appspotmail.com,
        stable@vger.kernel.org
Subject: [PATCH] dm-integrity: initialize journal accounting in dm_integrity_ctr
Date: Tue, 10 Nov 2026 19:49:05 -0500
Message-ID: <20261111004905.1047753-1-bmarzins@redhat.com>
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
X-Mimecast-MFC-PROC-ID: YZ43IUKgPlwNdPw-b7JGb2w8d9u5FMUuhzEMuLdOVfM_1794358147
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

If the superblock for a dm-integrity device is changed while the device
is suspended, it will resume in a failed state, and skip
replay_journal(). If this happens on a journaled dm-integriry table's
first resume, replay_journal() will have never been called, and the
journal will be uninitialized. While nothing can write to the device in
this state, integrity_commit() will be called if it receives a flush
request as well as on suspend. Even through there is nothing to commit,
pad_uncommitted() will check that the journal accounting is sane. This
triggers a kernel warning because the accounting was never set up by
replay_journal(). Fix this by setting free_sectors equal to
journal_entries. Since all the accounting variables are zeroed when
creating the ic structure, setting free_sectors is all that's necessary
to mimic a cleared journal.

Reported-by: syzbot+94dac3c75477e184f0b0@syzkaller.appspotmail.com
Closes: https://syzbot.org/bug?extid=94dac3c75477e184f0b0
Fixes: fc79aeb86a2c ("dm-integrity: validate the superblock on resume")
Cc: stable@vger.kernel.org
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 drivers/md/dm-integrity.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 1659a11a1a29..419a8b958371 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -5430,6 +5430,12 @@ static int dm_integrity_ctr(struct dm_target *ti, unsigned int argc, char **argv
 		if (r)
 			goto bad;
 
+		/*
+		 * initialize journal accounting like a cleared journal, to
+		 * handle a changed superblock on resume, where the journal
+		 * is not replayed.
+		 */
+		ic->free_sectors = ic->journal_entries;
 	}
 
 	if (ic->mode == 'B') {
-- 
2.56.0


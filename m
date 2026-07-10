Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9294F423A65
	for <dm-devel@lists.linux.dev>; Fri, 10 Jul 2026 12:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783686699; cv=none; b=I0bxIESU1bqivSp9tfVGuMmseVt3JU0kWdU15p2xAgIbUPV3d8MKnDazoFCuM0jI4BK9FZRj6WK02Ge7f7VTSp6n9BSlq1ctpBCCM83dfzZ2XItXn6+JsTnN5+w2S5ehOHArzmCvdbCFSG3JND+vpcIPR18B6QDU3al01dyI2h8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783686699; c=relaxed/simple;
	bh=/aqpOPKp5/smK7OBikv+yIIrtF6CM1/0pfwzKpHlgo4=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=AmdJA5ApePbYvbqSQF7Q2+jHDaLQVpvyEiogePkTasyeYvqqhRojD5jC5w78RbWzwIEKvmjIMIs/acCLxTi7rhNCEE5dhJ6w2qLqUZlASvVnNYESWh8cUGLZ1W0XQfOChIChG8Ln32H1rKdRuFDkTmTsEkZoLChJ/oe23CzGyk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cH1P3lIL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cH1P3lIL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783686696;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=9bkTvhQkl12MK7l+jLzVRoKSpptPYR8DyxsvJeL/0Fk=;
	b=cH1P3lILfskfYuzH3UCc6p54zCQ0zUhFxFjpUK1/IqZLItMY/rfVc861GCFbD/ST2y37+8
	TiHyURYVesWmMM1cMbgEBnQklV8LVLlEIKFT+wqitZ7Yd2IZ6yUuUxo7xkHFdo7EA49sWf
	yI2YAVAQmwFeLpadblv1TKIkUu16Lco=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-77-fjLRfBmtMFmNeCg5CmjL4Q-1; Fri,
 10 Jul 2026 08:31:33 -0400
X-MC-Unique: fjLRfBmtMFmNeCg5CmjL4Q-1
X-Mimecast-MFC-AGG-ID: fjLRfBmtMFmNeCg5CmjL4Q_1783686691
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 550451955EBC;
	Fri, 10 Jul 2026 12:31:30 +0000 (UTC)
Received: from [10.44.32.225] (unknown [10.44.32.225])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8BB6C195419F;
	Fri, 10 Jul 2026 12:31:27 +0000 (UTC)
Date: Fri, 10 Jul 2026 14:31:25 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev
cc: Jo Van Bulck <jo.vanbulck@kuleuven.be>, Shukai Ni <shukai.ni@kuleuven.be>, 
    Milan Broz <gmazyland@gmail.com>, Ondrej Kozina <okozina@redhat.com>
Subject: [PATCH] dm-integrity: fix the 'fix_hmac' option
Message-ID: <340f5b9d-0e1f-d29f-84ca-8f6f79147a64@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 9csrfTL2NboIzYZiVmR1gGwZ13zT9g1SJTTZUkZmjOo_1783686691
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

When the "fix_hmac" argument is used, dm-integrity is supposed to check
the superblock with the journal_mac. However, there was a logic bug in
the code - the code only checked the superblock mac if the bit
SB_FLAG_FIXED_HMAC was set in the superblock. So, the attacker could
clear this bit and bypass the checking trivially.

This commit changes dm-integrity so that when the user specified the
"fix_hmac" flag and the superblock doesn't have the bit
SB_FLAG_FIXED_HMAC set, the activation is aborted with an error.

Unfortunatelly, there's a bug in the integritysetup tool that when using
the 'open' command it passes the "fix_hmac" argument to the kernel even
if the user specified --integrity-legacy-hmac. The bug will be fixed in
the upcoming 2.8.7 release.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reported-by: Shukai Ni <shukai.ni@kuleuven.be>

---
 drivers/md/dm-integrity.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c	2026-07-09 21:07:04.000000000 +0200
+++ linux-2.6/drivers/md/dm-integrity.c	2026-07-09 21:10:32.000000000 +0200
@@ -5128,6 +5128,20 @@ static int dm_integrity_ctr(struct dm_ta
 		ti->error = "Journal mac mismatch";
 		goto bad;
 	}
+	if (ic->fix_hmac && !(ic->sb->flags & cpu_to_le32(SB_FLAG_FIXED_HMAC)) && ic->journal_mac_alg.key_string) {
+		/*
+		 * If this happens, it may be either because someone tampered
+		 * with the device or it may be due to a bug in the
+		 * integritysetup tool.
+		 *
+		 * In the latter case, upgrade to integritysetup 2.8.7 and use
+		 * the argument --integrity-legacy-hmac when using the open
+		 * command.
+		 */
+		r = -EINVAL;
+		ti->error = "fix_hmac is on the command line but not in the superblock";
+		goto bad;
+	}
 
 	get_provided_data_sectors(ic);
 	if (!ic->provided_data_sectors) {


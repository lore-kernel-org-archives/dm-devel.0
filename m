Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795467362;
	b=hWKTu7+iApURpHyfmv6mgf9wnyerk5pK2R77k4j3yZSFnkHnFmXzT6+yjhsaWObqMV6u
	 Hk/ztjva5pfoFvS03czFghDzUWtQL0OvuRoTZvC4AZb53x+H8/45Ty8iGdZU2Q01sgpza
	 aM0ojfPleAtaE7zA802SWUeOz8wx719fh+xtXk8HcToOsBtGLLlRIVSeiRZUqPJjIHyHO
	 CFfTuFEtZadKkOlnUbwCbYgTIKIuRg++7q3Bj5UbpdZnM1cUm70gi734Z+bUqvMRyMn/X
	 ztWSoEsCytmP04V9wdsjfzNDHt9b7p0CT4m/czyZxnrHAizENfS1+yuhmXcXauo+mAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795467362;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Date:From:To:Subject:
	 Message-ID:MIME-Version:X-Scanned-By:X-Mimecast-Spam-Score:
	 X-Mimecast-MFC-PROC-ID:X-Mimecast-Originator:Content-Type;
	bh=7a1jJoL/6ntUkpFshBAXFH1aa8YLTt64kHo0xJf3oIk=;
	b=wbFod4mDS5r8wE9nUnmay6DNcIMZuMVa1PVTW5unC/DYbMeuQjmg16JTI9rFhBZkubzO
	 Ok2R+gj0mHiw9pwx/CdUgF/yJMKbqIlhPt4rZtjb8ZDAktH+LiDQijyGu6LvT0xtIXPcM
	 RsO9XFcDNXVSIocQkRPa6ZMAguZr8UPICnI1DYZkw5GxepKWMS3p/VKWpG2mJK3EEdIcg
	 E17yoMM2ZF9MUV7QQey6NHF3GVjXfauSUYXc8ZX0COAR4tbFwjKo0Yinc74L7X7oTHuWZ
	 1kMxQPi8hWF9yGivnAzMIikexO+rs+m9mthPJwGy4mert/2860nror3Yx3TDawGXT0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=USvz+7H5;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45652606A321
	for <dm-devel@lists.linux.dev>; Mon, 23 Nov 2026 20:56:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 45652606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=USvz+7H5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795467360;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type;
	bh=7a1jJoL/6ntUkpFshBAXFH1aa8YLTt64kHo0xJf3oIk=;
	b=USvz+7H5eTBEsqz2pcG+qmyB7XoCAuiSUnJQ5WprKy2GYke+CnHBZ8tHO844xZruzAWJiE
	rKSDoIxe06uf6CpMLDCdrrVYrhmyKoPMosHDtYUoq/+apk/10BFryINKnUrRullB6m1CUp
	2QRJeV0sVIgf5HUGktMyv7jhWpPd8Lc=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-441-7lMFfcAeNW6NZiVWtJs48g-1; Mon,
 23 Nov 2026 20:55:58 +0000
X-MC-Unique: 7lMFfcAeNW6NZiVWtJs48g-1
X-Mimecast-MFC-AGG-ID: 7lMFfcAeNW6NZiVWtJs48g_1795467357
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 33C161954B18;
	Mon, 23 Nov 2026 20:55:57 +0000 (UTC)
Received: from mpatocka-thinkpadx1carbongen12.rmtcz.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6689E195608B;
	Mon, 23 Nov 2026 20:55:55 +0000 (UTC)
Date: Mon, 23 Nov 2026 21:55:53 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>, 
    Ming-Hung Tsai <mtsai@redhat.com>, dm-devel@lists.linux.dev
Subject: [PATCH] dm persistent data: assign new_root only when removal
 succeeds
Message-ID: <66133e69-7c3f-74bf-32b0-fdc9f0fd836c@redhat.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: BWb3qUJ_YKnnbwe75ts5ihiQXZddPXfVWTtXK1IaXGA_1795467357
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

The commit b6e58b5466b2 ("dm btree remove: assign new_root only when
removal succeeds") fixed a crash when removal failed due to I/O error.
This commit overlooked a similar problem in remove_one. This problem is
latent because it is only reachable from __remove_range ignores new_root
on error, but it still wrong to read uninitialized memory.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-5

---
 drivers/md/persistent-data/dm-btree-remove.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/md/persistent-data/dm-btree-remove.c
===================================================================
--- linux-2.6.orig/drivers/md/persistent-data/dm-btree-remove.c
+++ linux-2.6/drivers/md/persistent-data/dm-btree-remove.c
@@ -755,7 +755,8 @@ static int remove_one(struct dm_btree_in
 		r = -ENODATA;
 
 out:
-	*new_root = shadow_root(&spine);
+	if (!r)
+		*new_root = shadow_root(&spine);
 	exit_shadow_spine(&spine);
 
 	return r;


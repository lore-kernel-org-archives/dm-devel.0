Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793317823;
	b=TwebQ7nrvvy0Fm7lwppUGhw2wtnFx6JILQbqCqeVW2M5xmUVBVmfKID1BYNnpJnD2jun
	 eJSaJFCuU5FF94EUfIhP5f+IJLmQGX8++PhFz8V16bMejxcrPHonEThl4PnWeM8gop+sf
	 cQ3gb5X2MEzl9ZHlIZhFtw1N1Y9TQ+wAnA17LTPgWvY7iLMYq4rlMny9HfD6E0WKhKFG0
	 cdR49Ee3wLViqCXI5KY2Ap6SV2FPsjwRTPyHskobbIk1+IWCbFbs3HSh+Lcx+Us3h0Lgl
	 Znoxl1Ve/vcORC067sRTJCSxsRIB75EmG9E/z84iOwlx4lYzTGGG7deCAI35YPo90YA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793317823;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:MIME-Version:X-Scanned-By:
	 X-Mimecast-Spam-Score:X-Mimecast-MFC-PROC-ID:X-Mimecast-Originator:
	 Content-Transfer-Encoding:content-type;
	bh=Az/mDBXHiyDnQDAdYzcnjkVbZom/dZk6Ov5vycbi8us=;
	b=A8h3AKeY3SS7FqO6fddqWEYtLEyq4wr4AsFA1wPhnu+ozfLSsFMWa70K2GvDwvwoDA3k
	 xTWoa7dN2W7P0z4K7EHEVfH7EtWwqd8MTofxmCasf6mSl8QyXmzGzoHL9XwR4s8Eoi1MH
	 gIgxIctjfWHqWOLRITpxKGTchKoNP8539V7j8AkpNkCM9Zgd2pYlpDv5Owu+QwC2RCn+M
	 qQNVDPOqmK7hVtRvAdTEkBoMnhgaeb5lZb3APea7Gja/f0l1w1pW2pSwQmnM6i2Bue/Ex
	 jQaQU2oRGIUFp8PzdH8W4rYAplNtntY5+iKpfb/jn2EzqsHzsF113LCY8+UqAj3xs0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=d7c5tDYH;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 497D8606A31A
	for <dm-devel@lists.linux.dev>; Thu, 29 Oct 2026 23:50:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 497D8606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=d7c5tDYH
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793317822;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Az/mDBXHiyDnQDAdYzcnjkVbZom/dZk6Ov5vycbi8us=;
	b=d7c5tDYHedCKjEoIQ4VWALFosEGw52gLPyKP8F7tGGrF67zT1G6V+m0+g0eOc40VBWaKHU
	jJGv7okvjyhXFUf6k21CpXNHlb1SObFsGdKfEMg/2GV7OKoSqRX6vPZ8RFGuCKplrTE8/0
	CB+kQjDliN5I78ZbKtSCLwwPzdP9g6A=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-553-KDmzIlN-MYOzcSA8wCgbig-1; Thu,
 29 Oct 2026 19:50:20 -0400
X-MC-Unique: KDmzIlN-MYOzcSA8wCgbig-1
X-Mimecast-MFC-AGG-ID: KDmzIlN-MYOzcSA8wCgbig_1793317819
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3D9CA1809CAB;
	Thu, 29 Oct 2026 23:50:19 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B2818767;
	Thu, 29 Oct 2026 23:50:18 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 69TNoHwC818223
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 29 Oct 2026 19:50:17 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 69TNoEl4818210;
	Thu, 29 Oct 2026 19:50:14 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH] multipathd: Don't look at pointer to removed path
Date: Thu, 29 Oct 2026 19:50:14 -0400
Message-ID: <20261029235014.818202-1-bmarzins@redhat.com>
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
X-Mimecast-MFC-PROC-ID: rdrizsUwaYZovTjJh35VJ60EfUS-Sbi5XyBQgh8UMK4_1793317819
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

In uev_update_path(), if the path wwid changes, we remove it and use
needs_reinit to re-add the path. Once we remove the path, pp is pointing to
freed memory, but we still read the value it pp to see if it's NULL before we
check needs_reinit. This doesn't cause any bugs, since we don't dereference it,
but it would still be cleaner if we stopped accessing it completely after we
freed it. This is easy to do, since we only ever set needs_reinit if pp is
non-NULL. So just check needs_reinit before we check if pp is NULL.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 9bce4d6b..792bee36 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1769,6 +1769,9 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
 	}
 out:
 	lock_cleanup_pop(vecs->lock);
+	/* pp->initialized must not be INIT_PARTIAL if needs_reinit is set */
+	if (needs_reinit)
+		return uev_add_path(uev, vecs, 1);
 	if (!pp) {
 		/* If the path is blacklisted, print a debug/non-default verbosity message. */
 		if (uev->udev) {
@@ -1787,9 +1790,6 @@ out:
 
 		condlog(0, "%s: spurious uevent, path not found", uev->kernel);
 	}
-	/* pp->initialized must not be INIT_PARTIAL if needs_reinit is set */
-	if (needs_reinit)
-		retval = uev_add_path(uev, vecs, 1);
 	return retval;
 }
 
-- 
2.56.0


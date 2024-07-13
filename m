Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 922E61BDE6
	for <dm-devel@lists.linux.dev>; Sat, 13 Jul 2024 06:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720850717; cv=none; b=EdJeqcL6LNKA9+vkDn9KctRlPeWYWfCOwKRQQQ+uclh/mLwz99e4mHPDscMtciJJhpU2BpIPCn4lIE4qk366GxTf8blwYVmayqsvW1z+ZUXasdzhxXfrwuyBeQXkef77YxMJALfhg8insNkaXVO+wpNGWKM8n1JR8QZ7ruzcJA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720850717; c=relaxed/simple;
	bh=IETw3ODevM6KfeOpsr6LslEN1KgDvJXdWZUclGg1SEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P8PArnEewP+zIuArxGJLrzsLY7s8URxlYJ1BMk1JO4W+BVWIvvGjD8Ant8skeBfs1yG5GrjJRVnTgWGPfY824dI8Ncte9zhmzpMC0+Y5WuNWTKVz31Gd/2Fq24DHF1u5/It/Pa483vwOh8z9TwwJNTdxXiD4Zfxg4WEZfoHg+zM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cdLbtvTP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cdLbtvTP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720850714;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HAhUDORWizI+NjiHunctu7FdBIaEabTEdxYMcq6vtv0=;
	b=cdLbtvTPmmP1p43bS7JIRgQKq0ZrkS/YyRQLBjaoCQLekDL7VagGEho9xWRHkhoDfZ1hna
	e33AaEiJ6FgQckGlQcw+xfZyIRe8twcIMpxEJTEROFL51/zyQ8QymruudP7Stt+/Ygn8ND
	WBiUV7OZahv2r1LhYrrFXVGLedPZzDU=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-500-8UL0UzvdNWaY6aiw3QVU2g-1; Sat,
 13 Jul 2024 02:05:12 -0400
X-MC-Unique: 8UL0UzvdNWaY6aiw3QVU2g-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7F0A719560AA;
	Sat, 13 Jul 2024 06:05:11 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1B0541955F3B;
	Sat, 13 Jul 2024 06:05:10 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46D659nR2015554
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 13 Jul 2024 02:05:09 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46D659DX2015553;
	Sat, 13 Jul 2024 02:05:09 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 15/22] multipathd: always resync map in reload_and_sync_map
Date: Sat, 13 Jul 2024 02:04:59 -0400
Message-ID: <20240713060506.2015463-16-bmarzins@redhat.com>
In-Reply-To: <20240713060506.2015463-1-bmarzins@redhat.com>
References: <20240713060506.2015463-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

reload_and_sync_map() needs to always resync the map after calling
reload_map(), because the mpp state may no longer match the kernel
state if reload_map() fails.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index c9cb9ac8..0f763e29 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2188,13 +2188,15 @@ static int reload_map(struct vectors *vecs, struct multipath *mpp,
 
 int reload_and_sync_map(struct multipath *mpp, struct vectors *vecs)
 {
+	int ret = 0;
+
 	if (reload_map(vecs, mpp, 1))
-		return 1;
+		ret = 1;
 	if (setup_multipath(vecs, mpp) != 0)
 		return 2;
 	sync_map_state(mpp);
 
-	return 0;
+	return ret;
 }
 
 static int check_path_reinstate_state(struct path * pp) {
-- 
2.45.0


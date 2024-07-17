Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE04318306A
	for <dm-devel@lists.linux.dev>; Wed, 17 Jul 2024 18:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721239876; cv=none; b=M/ZKNfwqb+DS7XlMoVnRw8ZnqjKMKT/2z4PljJPQ0/EASKa1UtPKdU/CepbMvSLY5Z02ZosXoxHYCSPdsaP5fCrmPiFAldKlQO9htnXdka3kmxdKKDRd84dxozB4sSQaYiWsjMYPT43zfu2tW0+SQZoko1eG1DKBdTVkE3XHkMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721239876; c=relaxed/simple;
	bh=i8F+l7SS8O1bNGWj2PTt+ZCcTaF0lALBL7SV8KbWhag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ChI0RbPZluq61oTID8kfH4BCiYqMcGgLvV6UNycZ7HKoInAU7Q6o/Xalds1TqUedGyjtaX80o5SAs7eeiL5agqji3sRCWQSpb35Z2ON6OfJW8xz6TyjVWkRfjVqvKmlZQDzg1r1MEGBWTghkybyMy339fXrlsiEbMQJ07AjCZjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=G5GoAl1P; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G5GoAl1P"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721239873;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1irfF3S8GR26MRA8ut3reXlF22uXF+hw10h7wB/frdo=;
	b=G5GoAl1PyjPuLJT7U/Uikc5QDEr6eA/52CaNfS63n/BU4rqYvZUh1vojvzEdePGE+RglwE
	mWpFgQw+jrfoh2+Y0FaYJiBgPcOWRUTzOOGeGEh+R4KFjTq6X0e8FcN8HVgNtgkOxCoy8p
	2LDcDgY7843lFeDcs0Upu6oW/UnSIHU=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-193-KdIX43_KOjqoFn66QH27fw-1; Wed,
 17 Jul 2024 14:11:12 -0400
X-MC-Unique: KdIX43_KOjqoFn66QH27fw-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 46A6D19560A1;
	Wed, 17 Jul 2024 18:11:10 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D71E03000185;
	Wed, 17 Jul 2024 18:11:09 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46HIB8k42173588
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 17 Jul 2024 14:11:08 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46HIB8xL2173587;
	Wed, 17 Jul 2024 14:11:08 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 08/20] multipathd: return 0 from check_path() if that path wasn't checked
Date: Wed, 17 Jul 2024 14:10:54 -0400
Message-ID: <20240717181106.2173527-9-bmarzins@redhat.com>
In-Reply-To: <20240717181106.2173527-1-bmarzins@redhat.com>
References: <20240717181106.2173527-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

If check_path_state() returns PATH_WILD or PATH_UNCHECKED, then the
path wasn't correctly checked, and check_path() should return 0.

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 7c4d3bf6..733952cf 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2386,7 +2386,7 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
 
 	newstate = check_path_state(pp);
 	if (newstate == PATH_WILD || newstate == PATH_UNCHECKED) {
-		return 1;
+		return 0;
 	} else if ((newstate != PATH_UP && newstate != PATH_GHOST &&
 		    newstate != PATH_PENDING) && (pp->state == PATH_DELAYED)) {
 		/* If path state become failed again cancel path delay state */
-- 
2.45.0


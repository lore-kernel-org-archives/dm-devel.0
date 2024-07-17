Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2F0E1836C2
	for <dm-devel@lists.linux.dev>; Wed, 17 Jul 2024 18:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721239877; cv=none; b=MdsYGBPHvJw+m6roswQ8uvLBhMbP9kEBDnvR/Is2zXJ7vso48hb6VA1Y0AinhzY8fPRqniA67C80sOOpD6nro8GQha08AsiRyojgZ9WyNWMiyW30890dV0x4vZK7AyeQpzEQG9qQNAccvCW6cdS96AJLWK7H0ksI56GkQX6Ap2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721239877; c=relaxed/simple;
	bh=uQjjxFvBvwRjdkxor5lomLbaE6XLT6sEDxfRfZ+dBOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L39nFNoNScXsZ59oKpZrYks1YwZsRk8JNsMPcYmk4o31egym7RaZf0GYB5Y9PyunF50TkEEdVFX6eUbzAtiACL8FZGPrh1ZGVSgi/kl9MlijybeybM1WuzfGpUyMnq2+6GnarbYJMByJzy3j+6poTEvEYJ8eKeAUOmyl4O93JsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BAEAa+K0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BAEAa+K0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721239874;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3QsjdWdcteki8vJH9EZyEFpdh6FiyuGrRVf/qGgBjr8=;
	b=BAEAa+K0Uai73ptdCHBB5HjGs3lPMom2T0LAPvH0ZU7JFl5Xe+yOdpcEQE9fmTa8PJMGQf
	GFNk7RbhzNPbvgSP4C0S3JCAp9bSui7c9HMVb8tfdeL+olST//lyCtBN7KXsjmzj9sd2e+
	0HAH0aU8ofriWE7b0HT2Scrn9ZaW4m4=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-133-KuXjLDisMsm-h_sEIbcc5Q-1; Wed,
 17 Jul 2024 14:11:12 -0400
X-MC-Unique: KuXjLDisMsm-h_sEIbcc5Q-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 99F271956046;
	Wed, 17 Jul 2024 18:11:11 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 02D8F1955D42;
	Wed, 17 Jul 2024 18:11:10 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46HIB9SS2173620
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 17 Jul 2024 14:11:09 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46HIB9bT2173619;
	Wed, 17 Jul 2024 14:11:09 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 16/20] multipathd: don't read conf->checkint twice in check_path
Date: Wed, 17 Jul 2024 14:11:02 -0400
Message-ID: <20240717181106.2173527-17-bmarzins@redhat.com>
In-Reply-To: <20240717181106.2173527-1-bmarzins@redhat.com>
References: <20240717181106.2173527-1-bmarzins@redhat.com>
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

check_path() already has saved the value of conf->checkint in the local
variable checkint, so there's no reason to read it again.

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 92a0e424..84450906 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2513,9 +2513,7 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
 		 * upon state change, reset the checkint
 		 * to the shortest delay
 		 */
-		conf = get_multipath_config();
-		pp->checkint = conf->checkint;
-		put_multipath_config(conf);
+		pp->checkint = checkint;
 
 		if (newstate != PATH_UP && newstate != PATH_GHOST) {
 			/*
-- 
2.45.0


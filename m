Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C9151AC8AC
	for <dm-devel@lists.linux.dev>; Wed, 28 Aug 2024 22:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724883487; cv=none; b=dJTlJiK9RN31XJMzsCyTVxcAcdEadJ9NbIzNOFkfYuQ9SN8uHAru+Kvrj9/OJXW7+QzK1wiBEY/8WdNjfVpgQpnsEhCOXgw5P5fXCKmkeWPCSfHeBZNo0lusnwVJzJ+I3oC2KGAOlVB+goYNBmQLto8AfNzDXwBtpvFpuCYD84M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724883487; c=relaxed/simple;
	bh=SV47Y3w3gPoTsnjPWVPJlWM86JdnlO51/qh2vMOuBTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ukPOG97CDXIEslpI6xVEXJZ5SFsIEroafaidtnWVcDu/yyLbaBkjCq2/OX0opHuEM6auBC0Ff8r2t3jexvY3Fuz/RTVM3yIQ+K7S/oK4SiKDUrsfjqDYRjJ8PbEo6nPZQdS8EbU6H4oKlq3FfD3I3QutstyW0MlalS/fwYK/4fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VQyDbESm; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VQyDbESm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724883483;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=90VKzYASsH/Z317rWFrHNN4KM9fm/4nBsHDu8Wh3PZA=;
	b=VQyDbESm91Hc1uawki2GWHzIDL10RxwlucuI+Hc7QcjxA+HPu04SvNmSl3K8iXJ+Iw/Ouv
	LXAbdqASUDSSaxqORdHpsfXUh6cqgQQVZ6hoeUtUN8KAxCQRM/RrinYkZ5NsgBpWOZugvz
	Yg6IE//aV57xbvWTO17YuT5plwZXV2E=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-645-QKUyihm3PfOK4rfSBuzohg-1; Wed,
 28 Aug 2024 18:18:02 -0400
X-MC-Unique: QKUyihm3PfOK4rfSBuzohg-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 24BCC1956048;
	Wed, 28 Aug 2024 22:18:01 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 92A85300019C;
	Wed, 28 Aug 2024 22:18:00 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 47SMHxJt4060616
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 28 Aug 2024 18:17:59 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 47SMHx6n4060615;
	Wed, 28 Aug 2024 18:17:59 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 11/15] multipathd: split handle_uninitialized_path into two functions
Date: Wed, 28 Aug 2024 18:17:53 -0400
Message-ID: <20240828221757.4060548-12-bmarzins@redhat.com>
In-Reply-To: <20240828221757.4060548-1-bmarzins@redhat.com>
References: <20240828221757.4060548-1-bmarzins@redhat.com>
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

Split handle_uninitialized_path() into check_uninitialized_path, which
handles udev retriggers for INIT_MISSING_UDEV paths and starts the path
checker for INIT_FAILED and INIT_NEW paths, and
update_uninitialized_path() which gets the path checker result and
reruns pathinfo if the path is up.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 300f8247..91263a10 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2718,13 +2718,10 @@ update_path(struct vectors * vecs, struct path * pp, time_t start_secs)
 }
 
 static int
-handle_uninitialized_path(struct vectors * vecs, struct path * pp,
-			  unsigned int ticks)
+check_uninitialized_path(struct path * pp, unsigned int ticks)
 {
-	int newstate;
 	int retrigger_tries;
 	struct config *conf;
-	int ret;
 
 	if (pp->initialized != INIT_NEW && pp->initialized != INIT_FAILED &&
 	    pp->initialized != INIT_MISSING_UDEV)
@@ -2772,6 +2769,15 @@ handle_uninitialized_path(struct vectors * vecs, struct path * pp,
 	}
 
 	start_path_check(pp);
+	return CHECK_PATH_STARTED;
+}
+
+static int
+update_uninitialized_path(struct vectors * vecs, struct path * pp)
+{
+	int newstate, ret;
+	struct config *conf;
+
 	newstate = check_path_state(pp);
 
 	if (!strlen(pp->wwid) &&
@@ -2862,7 +2868,9 @@ next_mpp:
 			continue;
 		pp->is_checked = true;
 
-		rc = handle_uninitialized_path(vecs, pp, ticks);
+		rc = check_uninitialized_path(pp, ticks);
+		if (rc == CHECK_PATH_STARTED)
+			rc = update_uninitialized_path(vecs, pp);
 		if (rc == CHECK_PATH_REMOVED)
 			i--;
 		else if (rc == CHECK_PATH_CHECKED)
-- 
2.45.0


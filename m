Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BBE539B978
	for <dm-devel@lists.linux.dev>; Mon, 15 Jun 2026 19:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781550440; cv=none; b=Bq3eXy/WykewNp3xR+9ET60DC2gES5fvwaDx9BrXqhmiPILqLnKIGjZYTxBVfUR64DemCrhIvmOwa8leCdl37CYaENK53vmkA5qYq7wks2PX+3IAe0zP5jwIPthA+YYN2FZGP+14Ymcuj9tTRGPdXiTMo/5YGpS3erZtlhW8pyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781550440; c=relaxed/simple;
	bh=qw3GxXIegoQlGjfzuPE9Gw3u/lBnzXYcX6zH+/AsV4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=LvL2aKkg2gcV0ITc4eLezD46A2lZhQQPmuy1yZX3/xel2ShDzlfB7jBZ4G6+Ek5+4YfHBvkobX26a0/++L4IY/n5ei71uY4Jm/FVbqZ2dvpjWOypqWsqKURURTDzegfmlqijqcYvjkLwCb1YycUwXjQqXCJIFSJ1eKOFTlMsepE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=efdH1/tj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="efdH1/tj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781550438;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BT53s5LiHVBD3a8YVl6jX9ISDOWdFZWrwlk78NJjTus=;
	b=efdH1/tj/kTyVJmGf9ULsiNX/YUdfk17S3H4lM5uO+y0Rk58Ve2BN6/ZdGkRDQXWvJpOnN
	W3+Q+oXrwYRvcTozFoJGrLGKp764UN87BjioW4HSysopF1BpOZAcSEeB7s4idgjDBZlObI
	r9fyAtGLauS8x1YYFNi/BbLllFye1jU=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-137-mj0pdvakOTGEL7PFKshXvQ-1; Mon,
 15 Jun 2026 15:07:17 -0400
X-MC-Unique: mj0pdvakOTGEL7PFKshXvQ-1
X-Mimecast-MFC-AGG-ID: mj0pdvakOTGEL7PFKshXvQ_1781550433
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 680901955D90;
	Mon, 15 Jun 2026 19:07:13 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 362BD1800367;
	Mon, 15 Jun 2026 19:07:13 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 65FJ7CGb797602
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 15 Jun 2026 15:07:12 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 65FJ7Csl797601;
	Mon, 15 Jun 2026 15:07:12 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>,
        Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 4/4] libmultipath: don't set hwhander for bio based devices
Date: Mon, 15 Jun 2026 15:07:11 -0400
Message-ID: <20260615190711.797573-5-bmarzins@redhat.com>
In-Reply-To: <20260615190711.797573-1-bmarzins@redhat.com>
References: <20260615190711.797573-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: DxKALkEtP2f-7_TCfecqphhP1jX9ZfIlGbmp1WpcSKc_1781550433
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

The kernel prints an error message when a bio-based multipath device
sets a hardware handler, since bio-based devices only support using
the already attached hardware handler as-is. Change select_hwhandler()
to not set a hardware handler for bio-based devices.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/propsel.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 8be6f5e3..8531ca09 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -560,6 +560,11 @@ int select_hwhandler(struct config *conf, struct multipath *mp)
 
 	dh_state = &handler[2];
 
+	if (mp->queue_mode == QUEUE_MODE_BIO) {
+		mp->hwhandler = DEFAULT_HWHANDLER;
+		origin = "(setting: disabled due to \"queue_mode bio\")";
+		goto set;
+	}
 	/*
 	 * TPGS_UNDEF means that ALUA support couldn't determined either way
 	 * yet, probably because the path was always down.
@@ -600,6 +605,7 @@ out:
 		mp->hwhandler = DEFAULT_HWHANDLER;
 		origin = tpgs_origin;
 	}
+set:
 	mp->hwhandler = strdup(mp->hwhandler);
 	condlog(3, "%s: hardware_handler = \"%s\" %s", mp->alias, mp->hwhandler,
 		origin);
-- 
2.53.0


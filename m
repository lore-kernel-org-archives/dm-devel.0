Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC6AD1531C8
	for <dm-devel@lists.linux.dev>; Wed,  1 Oct 2025 03:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759289733; cv=none; b=gKIJoyfqaTv/wCiaCyn/JWDpbsJyY64JroLfFXKuoSPHVCCi9O91qRv/A1JBgJ+P1d1njgetZFPyjLDKTt96asqwxXvnhqKdi4aAh4xdWL4G7OHcVn4OiB6AkPkYR25gwYvEnC0EBmdCkoRFqRtECRkTxuwwFc7dlWzFL7kadTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759289733; c=relaxed/simple;
	bh=o6OBh0N/5Xr+V3gpD/WZpp0daEZRhX3/X5Ch6CBc94s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=Oh819b0DDEo7ejBws8ksaiLLLMsvX0ME9Klc6bnNk49tXU7XvoTmBk2z+Ny6Lj9BGUft3aPHae+M8LtrFOkHI2KpXik2kduUy4lF2CouqmqRHSwI6BHVXVwWI87tY5mEQdHCYSUZ6rRT5mWCCGxNZJmkpSenmI69alh95u4FljY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BC3X055c; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BC3X055c"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759289729;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=YIoBoA2AyJe7H0xylN4l7ibVZQhdfyhMSP3AYM0h8QU=;
	b=BC3X055c3PJqQtIfovcO5262H5f0n2GkcJiZfy8Vnq+nIShrAVFNamfA9o0GWSmuZs2LKQ
	ThAlyxEU/Ymy43tc42RCyX9CEMSzVmxr8s/kl9anmY5Fb/pzfy7oQW4wh+0btrSZJBQmz+
	ukFJnN/Kb/VoV2jlLfCoAWKNZabkOPw=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-263-EhAe42EMN9qM8VTySpQUIg-1; Tue,
 30 Sep 2025 23:35:27 -0400
X-MC-Unique: EhAe42EMN9qM8VTySpQUIg-1
X-Mimecast-MFC-AGG-ID: EhAe42EMN9qM8VTySpQUIg_1759289727
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C5FCC1800447;
	Wed,  1 Oct 2025 03:35:26 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 755ED1800576;
	Wed,  1 Oct 2025 03:35:26 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 5913ZPkB1760923
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 30 Sep 2025 23:35:25 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 5913ZOjU1760922;
	Tue, 30 Sep 2025 23:35:24 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH] multipathd: Fix tracking of old PR key
Date: Tue, 30 Sep 2025 23:35:24 -0400
Message-ID: <20251001033524.1760914-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: UTF4xnB4Prd4R2NvDihAO5qXDITviDUuUHsn3HQNCSI_1759289727
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

When libmpathpersist is in the process of changing a registered key,
multipathd needs to remember both the old and new values of the key to
deal with a race between limpathpersist updating the key and multipathd
restoring a failed path. It was supposed to stop remembering the old
value when libmpathpersist was done changing the key and issued a
"setprstatus" command. However, clearing the old key was done in
set_pr(), which only gets called by cli_setprstatus() when registering a
new device, not when changing the key on a registered device. Also,
set_pr() is called by update_map_pr().  This means that multipathd was
forgetting the key when it shouldn't and not when it should. Fix this
to only forget the key when cli_setprstatus() is called, and always
then.

Fixes: 1aeffa9e ("libmpathpersist: handle updating key race condition")
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/cli_handlers.c | 1 +
 multipathd/main.c         | 1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 0c65e7d2..7f572fb4 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -1293,6 +1293,7 @@ cli_setprstatus(void * v, struct strbuf *reply, void * data)
 		set_pr(mpp);
 		condlog(2, "%s: prflag set", param);
 	}
+	memset(&mpp->old_pr_key, 0, 8);
 
 	return 0;
 }
diff --git a/multipathd/main.c b/multipathd/main.c
index d7642a0b..d11a8576 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -4250,7 +4250,6 @@ void set_pr(struct multipath *mpp)
 {
 	mpp->ever_registered_pr = true;
 	mpp->prflag = PR_SET;
-	memset(&mpp->old_pr_key, 0, 8);
 }
 
 void unset_pr(struct multipath *mpp)
-- 
2.50.1


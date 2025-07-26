Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0A7A1EFFB7
	for <dm-devel@lists.linux.dev>; Sat, 26 Jul 2025 03:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753502346; cv=none; b=WNaEsw8hS2BOkiXH7NvEsR5Sx/l7Xgwo44ZnnCXMc6jz4mI7+q/1XemU8NEK1NLDb72jJkEd1EJggHAGeGcvBC4UFTmBFj5WhHW3tYsqjgqifZ2igWh+LZjqSklWiUEziKgDW35UsI6Kr3W46N82SPYKuNa/S/G0LOROTJYnrVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753502346; c=relaxed/simple;
	bh=H8r1rKxz0tw4dh2xUwm+ynjU86MugTSW72A5yOlVFXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=U77XpRy1eHUE+ANqoBVAfbGLRy5GcHsnt9T4rY/juqmxjpoo1d/M9YmfaSGNmO9XFF+bEHKJfl+RtpgpMMLhtsGqf9zlK0AnS+89VoNXkLNEScy9skZ63Gg5wLDtHOsZKkjmfOCIJ8EkZVTfFH7ldvVZAI/pbWP7wwx6VQ6cGaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YRuU6/7f; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YRuU6/7f"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753502343;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kn7wjM/4qNSJZ7UctYbsPpUuyT0waSsQgXr1++JP2H0=;
	b=YRuU6/7fcvQSSi92shS9FA8RTcHApgK5LF1ByZCzx6w4lmoTQq4RXXA2WaEgyfHCSHEqzR
	EQD/+MnGEBZjy52ucYQhp7U+pYIKY2ABrpj9G+fWHBRk/3NNsjoDB94j27EVasvs6wAQkd
	wtyA68FmnPwz81iE2OH10QlG83Pkc6I=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-97-_k5bDK6AMFyEVkIPm_QlFw-1; Fri,
 25 Jul 2025 23:59:01 -0400
X-MC-Unique: _k5bDK6AMFyEVkIPm_QlFw-1
X-Mimecast-MFC-AGG-ID: _k5bDK6AMFyEVkIPm_QlFw_1753502339
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B2AC418002B2;
	Sat, 26 Jul 2025 03:58:59 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7E8DB19560AA;
	Sat, 26 Jul 2025 03:58:59 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 56Q3ww90363353
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 25 Jul 2025 23:58:58 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 56Q3wwx7363352;
	Fri, 25 Jul 2025 23:58:58 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 10/14] libmpathpersist: only clear the key if we are using the prkeys file
Date: Fri, 25 Jul 2025 23:58:51 -0400
Message-ID: <20250726035855.363290-11-bmarzins@redhat.com>
In-Reply-To: <20250726035855.363290-1-bmarzins@redhat.com>
References: <20250726035855.363290-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: GWsdovjLmGdZw_NqZO_6UrzRjLtGTxGOw1KxAjR2vmY_1753502339
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Otherwise this request will create a useless prkeys file.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmpathpersist/mpath_persist_int.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
index dfdadab6..f901b955 100644
--- a/libmpathpersist/mpath_persist_int.c
+++ b/libmpathpersist/mpath_persist_int.c
@@ -831,7 +831,8 @@ int do_mpath_persistent_reserve_out(vector curmp, vector pathvec, int fd,
 		break;
 	case MPATH_PROUT_CLEAR_SA:
 		update_prflag(mpp->alias, 0);
-		update_prkey(mpp->alias, 0);
+		if (mpp->prkey_source == PRKEY_SOURCE_FILE)
+			update_prkey(mpp->alias, 0);
 		break;
 	case MPATH_PROUT_RES_SA:
 	case MPATH_PROUT_REL_SA:
-- 
2.48.1


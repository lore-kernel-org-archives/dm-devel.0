Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D7B6173356
	for <dm-devel@lists.linux.dev>; Wed,  5 Jun 2024 23:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717629782; cv=none; b=rTnhSNwEKOrCC+teFVrOXytKuhcur9BNrYQG1l/EmX2QJ4kgnLLLsSASYGtFVkt5KnlMgtrPjpIM1YjmyKSmahxZzXmSKFQ1+Q2mGm/3Ca6Cc8xC95Pk/lTE4yZDb2cQzNS2WjodFc66F7lcWApRiJZGuOri7Mve5XBKdbaNJCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717629782; c=relaxed/simple;
	bh=Vt2R7u2NfxVb0mRGIYkEgRA0gyVKi+nUz4r/qIcJLK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WtePWUsPKmQHeFlAC8GpL/ZoSRN77iNsuxwRVdudTxjTqdJIItPlKB/9p2XhUQgpVkcmHgtX40EH+WNa+ZT78WYoLG+WULrKEp+fp2QYfMPQLRl66sIAfroBugfanz5qEc9fSNWroiBknKqQsbjE/tWJu/cEsVpAQu4m26hN/84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GwiuopWK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GwiuopWK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717629779;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y+Rnfn0ngzVIqfw5twW03kPs0kmUE0F756hmn1strKE=;
	b=GwiuopWKWF/6ed8few5Y9+nyBC3vha/reuvM+Q3lfvKI9tgdm8m2VoWObuUcQtqQ6XC3fe
	IDnL7NumoIafKHhJ7xg66PwpiMQJk1mqc1CMJXnrBAVsoioWn02rWoVTmUYOCmiayIKRJ+
	Ibml2QFSfVNudSXiL4PYf59wIhyiff0=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-176-ORgLXmcyPLamz33-xeTMTw-1; Wed,
 05 Jun 2024 19:22:56 -0400
X-MC-Unique: ORgLXmcyPLamz33-xeTMTw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C056D3806705;
	Wed,  5 Jun 2024 23:22:55 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B8025C15971;
	Wed,  5 Jun 2024 23:22:55 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 455NMt6t623326
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 5 Jun 2024 19:22:55 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 455NMtl6623325;
	Wed, 5 Jun 2024 19:22:55 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 5/7] multipath-tools: Makefile.inc: compile with -fexceptions
Date: Wed,  5 Jun 2024 19:22:52 -0400
Message-ID: <20240605232254.623290-6-bmarzins@redhat.com>
In-Reply-To: <20240605232254.623290-1-bmarzins@redhat.com>
References: <20240605232254.623290-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

multipath is not currently running the cleanup_functions from
__attribute__((cleanup(cleanup_function))) when threads are cancelled.
To do this, it needs to be compiled with -fexceptions

https://gcc.gnu.org/onlinedocs/gcc-14.1.0/gcc/Common-Variable-Attributes.html#index-cleanup-variable-attribute
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 Makefile.inc | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Makefile.inc b/Makefile.inc
index 81b86cd8..ed4a4234 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -105,7 +105,8 @@ CPPFLAGS	:= $(FORTIFY_OPT) $(CPPFLAGS) $(D_URCU_VERSION) \
 		   -DRUNTIME_DIR=\"$(runtimedir)\" -DCONFIG_DIR=\"$(TGTDIR)$(configdir)\" \
 		   -DDEFAULT_CONFIGFILE=\"$(TGTDIR)$(configfile)\" -DSTATE_DIR=\"$(TGTDIR)$(statedir)\" \
 		   -DEXTRAVERSION=\"$(EXTRAVERSION)\" -MMD -MP
-CFLAGS		:= -std=gnu99 $(CFLAGS) $(OPTFLAGS) $(WARNFLAGS) -pipe
+CFLAGS		:= -std=gnu99 $(CFLAGS) $(OPTFLAGS) $(WARNFLAGS) -pipe \
+		   -fexceptions
 BIN_CFLAGS	:= -fPIE -DPIE
 LIB_CFLAGS	:= -fPIC
 SHARED_FLAGS	:= -shared
-- 
2.45.0


Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B26E23AC12
	for <dm-devel@lists.linux.dev>; Fri, 10 Nov 2023 19:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hXeRuOdk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699645987;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1OyUbcSYpdfuyn4NfaFiHRXlxdXn9/ZJa/cramglxXo=;
	b=hXeRuOdkRi+BZciIsyqK7LUj1k5PA9cIIO9s/1jQmM44XXzmF9tlrmYJwSNGZ40afpJJKZ
	L0flVAr7wsXl7WE0BQZ+kQolFC2idLx6nOInG/ryI7u2v+tMu1jFFWwWUYx94T1u+yzKqe
	e4tu7EQScmhOTACqMjoRIlvr3SP2+6k=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-614-Fuvbr226P4eCKJnQ8foy1A-1; Fri, 10 Nov 2023 14:53:06 -0500
X-MC-Unique: Fuvbr226P4eCKJnQ8foy1A-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8DF27811E93;
	Fri, 10 Nov 2023 19:53:05 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (bmarzins-01.fast.rdu2.eng.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 884C6492BE7;
	Fri, 10 Nov 2023 19:53:05 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1) with ESMTPS id 3AAJr56C107917
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 10 Nov 2023 14:53:05 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1/Submit) id 3AAJr5Rn107916;
	Fri, 10 Nov 2023 14:53:05 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 1/2] Makefile.inc: always use /usr/share/man for mandir
Date: Fri, 10 Nov 2023 14:53:03 -0500
Message-ID: <20231110195304.107907-2-bmarzins@redhat.com>
In-Reply-To: <20231110195304.107907-1-bmarzins@redhat.com>
References: <20231110195304.107907-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

The current build system, with nothing overridden, will install the man
pages in /share/man, which AFAIK isn't correct for any distribution.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 Makefile.inc | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile.inc b/Makefile.inc
index a20e2cec..ed40b449 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -60,7 +60,7 @@ modulesloaddir	:= $(systemd_prefix)lib/modules-load.d
 libudevdir	:= $(systemd_prefix)lib/udev
 udevrulesdir	:= $(libudevdir)/rules.d
 bindir		:= $(exec_prefix)sbin
-mandir		:= $(usr_prefix)share/man
+mandir		:= /usr/share/man
 LIB		:= $(if $(shell test -d /lib64 && echo 1),lib64,lib)
 syslibdir	:= $(prefix)$(LIB)
 usrlibdir	:= $(usr_prefix)$(LIB)
-- 
2.41.0


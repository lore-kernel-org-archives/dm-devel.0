Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E7BF1D6AA
	for <dm-devel@lists.linux.dev>; Wed,  9 Oct 2024 01:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728436533; cv=none; b=l6NRW3kFTXUOGLpYjpCvvtyDju6qh7dn+DHDU+ErzDAZbLM/5t11+tyFdIV7FGHVxUPI2IQf6sxNT0ZpsCVyNsOGG8QaGtI+a7FB0jtCVB1mjxJarGA5yb9p8UK9uD4OxcwQ0KcPvvXKj5IeI5f5gtQMJwxChjL4TkgIQeJk6zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728436533; c=relaxed/simple;
	bh=/gwPJEkUJRxZWnG/yNxxk0/KQxOhLA+xhqgoyL3Bg6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pq9/hkTtfwfN+Atk1DkR1g2pwEMgy4GDMhGixrzYNOp8m5NkhB1SxqiHGlML0fUyKtHIgApN3MamfWJiJ36Ia8lUJYkjjntLc58a0JXMNA9f/B25WDu5bwhyIZ/rOUCPPzb0n3QtYmjUUryWPeNhLGvyuO/2/r4JriO1KBjhRZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Or1s3CkJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Or1s3CkJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728436530;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SG/QEWVYn2IyaP1Pf7//bD8wY3Ah2v2mDwF8hGeVz+E=;
	b=Or1s3CkJV7R8B8b7e34NHGmsUeZYzqwlQeHOS8rVawkj/8FU03DCgUCq3YsfVF388DMaYQ
	V75s9ykogYtmMMDExevPF2iTfkfg+rsoiT7WjI8vr4E9kXLjh3VUwCvCNAst0j/83sZhM6
	5iUkh212BGeVs6h2ryKz4q5XhnBdQq4=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-460-AqSNoSxtOcmJ9G_lVeTGMg-1; Tue,
 08 Oct 2024 21:15:27 -0400
X-MC-Unique: AqSNoSxtOcmJ9G_lVeTGMg-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 57F391955F65;
	Wed,  9 Oct 2024 01:15:26 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A885919560AA;
	Wed,  9 Oct 2024 01:15:25 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4991FOQi2381616
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 8 Oct 2024 21:15:24 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4991FOcV2381615;
	Tue, 8 Oct 2024 21:15:24 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v4 02/22] libmultipath: add missing checker function prototypes
Date: Tue,  8 Oct 2024 21:15:03 -0400
Message-ID: <20241009011523.2381575-3-bmarzins@redhat.com>
In-Reply-To: <20241009011523.2381575-1-bmarzins@redhat.com>
References: <20241009011523.2381575-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/checkers.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/libmultipath/checkers.h b/libmultipath/checkers.h
index 6e54d8f0..fb1160af 100644
--- a/libmultipath/checkers.h
+++ b/libmultipath/checkers.h
@@ -188,6 +188,9 @@ int libcheck_check(struct checker *);
 int libcheck_init(struct checker *);
 void libcheck_free(struct checker *);
 void *libcheck_thread(struct checker_context *ctx);
+void libcheck_reset(void);
+int libcheck_mp_init(struct checker *);
+
 
 /*
  * msgid => message map.
-- 
2.45.0


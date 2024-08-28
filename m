Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A548F1AC442
	for <dm-devel@lists.linux.dev>; Wed, 28 Aug 2024 22:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724883485; cv=none; b=cpwTbmYwEtbR/pTayZXI0kyDiEJt+/HNfBg/GhD9QpMvKjsAQPGDIOozeauB3b3mbl/mtjNGYa2pHDvRx0heu05IbmjQewzNaymu7PjK7xU6XPyNRBWPSCzqMZZpNC6PSJn5VfdqLlPeEjbdD3znM5rnChywMmHmTX4vCAzTuzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724883485; c=relaxed/simple;
	bh=vIAcuVFqBqZFDp5s3U8YZDkhvPVhMgHVNLHpEoMttMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nCFXEI025IeTm2eTJTqZZl92eA0Bb6mFd8cPZAdxgDOTMJpFkVgxBEXskFMBqEKvbKoUYkfxNnETuemoGq89uDYYH610FU7AzZoBPhAbMktxtGj/dvx7H99dR+usufwqq8BjoBSEWgZ5Q7bdhKNGzljxHuRzzSPdcLrz1QaGJcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cNq+G3C5; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cNq+G3C5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724883482;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=B4v6gzKlDdY7pFVvU8nqDcBNEI0j08uWzi4XYoOh0t0=;
	b=cNq+G3C5hACAEsytkqPoik6GMwyRvC3k3wmu7/ZNZmxN3QlyH25Pn/g5zN8PZBJPsTVvcU
	VG70IfFlKTNu5y+AvQ5Cztw4usH1oAeIavpp4wZPherYH+cl/3iuMDC2hTy6cJnaOpCZmc
	jOUth5mwHT/9YobSKpfB6ib9C0M4dok=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-454-6GwIemjCPuCtMQJ5md5hvA-1; Wed,
 28 Aug 2024 18:18:01 -0400
X-MC-Unique: 6GwIemjCPuCtMQJ5md5hvA-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DC9421955D45;
	Wed, 28 Aug 2024 22:17:59 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2D01A19560A3;
	Wed, 28 Aug 2024 22:17:58 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 47SMHvqL4060580
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 28 Aug 2024 18:17:57 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 47SMHvY04060579;
	Wed, 28 Aug 2024 18:17:57 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 02/15] libmultipath: add missing checker function prototypes
Date: Wed, 28 Aug 2024 18:17:44 -0400
Message-ID: <20240828221757.4060548-3-bmarzins@redhat.com>
In-Reply-To: <20240828221757.4060548-1-bmarzins@redhat.com>
References: <20240828221757.4060548-1-bmarzins@redhat.com>
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


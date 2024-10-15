Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 010A71714B0
	for <dm-devel@lists.linux.dev>; Tue, 15 Oct 2024 03:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728962924; cv=none; b=ZKVK8r6E/aaXbkvESazaR6M69qlXHC5RoAXR5OlN1U+7hweodAtZ8eir0V7ymDiFY5G04MpxhmFUAQ+sSiqNRfjFaU/yLJKMUc4n5YwP4c6+/NUJqcTIp/hgW/E4tO4x2/Ox68PK2UZ4SnLNt2dI86EMPMkPklpzHq6Yl/OVJVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728962924; c=relaxed/simple;
	bh=/gwPJEkUJRxZWnG/yNxxk0/KQxOhLA+xhqgoyL3Bg6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KrDo2MEDqSlJB8kt3zG6fI+Ov4kcg+ilhx+gCaFCWLiIRM0OIvJz0w9ePitblzIh6+k0qkjgb/kKQ9bAljCo6HqJb5cBW6EVzRJcIvYhLemWyCrESypWvqutGRJcfh5wb6BUL7XI9d3Pkpe9G+M5LZG/sCwAqBvP8ejYQ4OLRoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VKUpvLI5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VKUpvLI5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728962921;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SG/QEWVYn2IyaP1Pf7//bD8wY3Ah2v2mDwF8hGeVz+E=;
	b=VKUpvLI55vMGhBeDvT1YWhhu9p2f6S63ePhGm7/p2WupuT47KakK2KQIcnRzgOZw6csqwt
	y5za1jK0WBaMVpKWw2iwN89IGWateJWJFroq5VJMwh4x38jT6MTkqO1GD2mGdkB/e4KggQ
	AqRjvHPe4xQ9ScA4JMD7eOXkb7nobwg=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-389-kCxG-Bm-OD2EIJ-MRrbysw-1; Mon,
 14 Oct 2024 23:28:38 -0400
X-MC-Unique: kCxG-Bm-OD2EIJ-MRrbysw-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8450E19560B4;
	Tue, 15 Oct 2024 03:28:37 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 271741956054;
	Tue, 15 Oct 2024 03:28:37 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 49F3SZsY2693287
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 14 Oct 2024 23:28:36 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 49F3SZm82693286;
	Mon, 14 Oct 2024 23:28:35 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v5 02/23] libmultipath: add missing checker function prototypes
Date: Mon, 14 Oct 2024 23:28:14 -0400
Message-ID: <20241015032835.2693247-3-bmarzins@redhat.com>
In-Reply-To: <20241015032835.2693247-1-bmarzins@redhat.com>
References: <20241015032835.2693247-1-bmarzins@redhat.com>
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


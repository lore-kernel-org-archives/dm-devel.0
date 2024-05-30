Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DB953D3BC
	for <dm-devel@lists.linux.dev>; Thu, 30 May 2024 16:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717088108; cv=none; b=pXlLcqS/ESq7pbIaEGV60bBcxDhjqC9Y6SKVrK6qj50Cr6tkJcuDZpJIpxHmQgqdt889CnQXgx21QStKnQqkCVeLNTtGtJoIHEYM4vdjNnvYegQASoePa2cLLdyVJH0MFT0RGXdKUB9EDd2zDCn2jscN94yPWOkQ8+SRNQKUDUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717088108; c=relaxed/simple;
	bh=88anZiaL1RaDT+IvtBQ6M1Z+v3s1OSB7M0TWXCM+tCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jZhxK5MPozdFKEyXkjcX+DJC9AN+nhEVu0kmX3Vo5swTHPRg1mQ5SthyQGSE//g0F89FyxIIdyTawF0Y+AYxY8NAUGqPiGvwJi/GRedeuIdyd9XBJACAmQVDqIBE30Sc+pa6HM8NsapN66Ho8uR4OzOt50idjdrPjCLgPH00JgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ijInwBqu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ijInwBqu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717088106;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sJD+23/W8/yjBaWOiBHOpLb8a0NBDn7pgvBwA1mCHRE=;
	b=ijInwBquB0KFouVhS/nnpQn0pRWKNcVgBB49hDTMAKVRCYh2xIMnn5fj+mkUerc6wAnlbY
	HdxNUpqmaOJmEUJEKN81zGG+f96A1XdYPVF2exVbNj/K6NuhB/An8S0OnpWsAh+7xfCezq
	9rP1btFpZ/UWZ0FoKXF8+7N+/hyWAYM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-78-_AClHzRFMwaYhHR-myNWaQ-1; Thu, 30 May 2024 12:55:02 -0400
X-MC-Unique: _AClHzRFMwaYhHR-myNWaQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6B23181227E;
	Thu, 30 May 2024 16:55:02 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 627A528E6;
	Thu, 30 May 2024 16:55:02 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 44UGt28Q397037
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 30 May 2024 12:55:02 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 44UGt2Y6397036;
	Thu, 30 May 2024 12:55:02 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>,
        Nitin Yewale <nyewale@redhat.com>
Subject: [PATCH v2 3/7] libmultipath: print all values in snprint_failback
Date: Thu, 30 May 2024 12:54:56 -0400
Message-ID: <20240530165500.397009-4-bmarzins@redhat.com>
In-Reply-To: <20240530165500.397009-1-bmarzins@redhat.com>
References: <20240530165500.397009-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Add the missing output for manual failback and print the defferral time
for deferred failbacks, if one isn't currently in progress.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/print.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/libmultipath/print.c b/libmultipath/print.c
index 89813517..0e3225ef 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -218,9 +218,13 @@ snprint_failback (struct strbuf *buff, const struct multipath * mpp)
 		return append_strbuf_str(buff, "immediate");
 	if (mpp->pgfailback == -FAILBACK_FOLLOWOVER)
 		return append_strbuf_str(buff, "followover");
+	if (mpp->pgfailback == -FAILBACK_MANUAL)
+		return append_strbuf_str(buff, "manual");
+	if (mpp->pgfailback == FAILBACK_UNDEF)
+		return append_strbuf_str(buff, "undef");
 
 	if (!mpp->failback_tick)
-		return append_strbuf_str(buff, "-");
+		return print_strbuf(buff, "deferred:%i", mpp->pgfailback);
 	else
 		return snprint_progress(buff, mpp->failback_tick,
 					mpp->pgfailback);
-- 
2.45.0


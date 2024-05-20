Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDD7D3B182
	for <dm-devel@lists.linux.dev>; Mon, 20 May 2024 23:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716248292; cv=none; b=Q39pzmLdjseuAfad4hMoNy5xsx425zjc79gmGdQloDsXQL5Krx7GUNaeewA29+2qJpmVnLmiY7msN18ay6YMg/J+PTD5hA1JZAWqTz3+uOgIk0bz2HH3EmVO+zBfZIrOfILMz/ll3U+UwB757S6SPnGVVMF0iUZvuuo2wwzJKyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716248292; c=relaxed/simple;
	bh=8egc7NBR+EVa5WZBkDegdMlAKAf0rzg4g7nRGJ40C8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sO0PelXZF5dBzh9GTmM72xF3PeqReeUWaDSxMs3j5egABM24KNMTAMC8J1+oyEtxo/r8FtdABZ0snxCNOjSZX2B8n9C0jgZFAvK8MT8NuW1WFrEXc7c7rp6NhpQsLiJrYzgV3gsnLCBJ5Dr6WcDDYEBbPTHQIYE9bSf052v6X+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ylsd406b; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ylsd406b"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716248288;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jWRfhUNrR598ea8j25mkx6lMulu3kGYzn9guK8hxDqw=;
	b=Ylsd406bnrGOdnAW/XB2pbAqbp8MLtfhW2FvMWpJZWM4adA1YlsqM0rotaO+CyPt2KHE6o
	OosN5u6v/94ytANctBZrZu1pXj3TlQm1rfjwtfKPwz7G0qPVZMCrr0DCtl5tQKaIhUBb5G
	tR54mLQW2COhnQUIXGPRV/czhfBzFZY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-210-xKoaoryINVSH4ONy7C4YIg-1; Mon, 20 May 2024 19:38:04 -0400
X-MC-Unique: xKoaoryINVSH4ONy7C4YIg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 22EF9800169;
	Mon, 20 May 2024 23:38:04 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1CBF51C09484;
	Mon, 20 May 2024 23:38:04 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 44KNc3Hl190808
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 20 May 2024 19:38:03 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 44KNc3Rt190807;
	Mon, 20 May 2024 19:38:03 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 1/2] libmultipath: accept poorly chosen aliases in find_mp_by_str
Date: Mon, 20 May 2024 19:38:02 -0400
Message-ID: <20240520233803.190793-2-bmarzins@redhat.com>
In-Reply-To: <20240520233803.190793-1-bmarzins@redhat.com>
References: <20240520233803.190793-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

A multipath device alias of dm-1 is valid, albeit a really bad idea.
Make sure that find_mp_by_str() is only checking for multipath devices
by minor number for strings that really are of the form dm-<number>, and
if the minor-number check fails, check if the string is an alias, just
to be safe.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/structs.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index e248fb51..d89f2187 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -480,11 +480,12 @@ struct multipath *
 find_mp_by_str (const struct _vector *mpvec, const char * str)
 {
 	int minor;
-	struct multipath *mpp;
+	char dummy;
+	struct multipath *mpp = NULL;
 
-	if (sscanf(str, "dm-%d", &minor) == 1)
+	if (sscanf(str, "dm-%d%c", &minor, &dummy) == 1)
 		mpp = find_mp_by_minor(mpvec, minor);
-	else
+	if (!mpp)
 		mpp = find_mp_by_alias(mpvec, str);
 
 	if (!mpp)
-- 
2.45.0


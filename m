Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E3B200A3
	for <dm-devel@lists.linux.dev>; Sat, 13 Jul 2024 06:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720850717; cv=none; b=rxA6ShBC2t62ojMadHm11p5IwBxLglpM6IMQzdHkBv+fgcek8tytOFD34FZyqtf4bsKUj08eTwwTwlVT8Bx6+uM1zbfEl+6dTZ6mAuuknh62wnW5JoeQt+fXQuJoY7ygfXQvVYwWmHBTToqEES4oWYC75CqejJZcREaBcivSxrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720850717; c=relaxed/simple;
	bh=rgp/z9PDO2WSdI0mHw2Ch951oZjH8ZWHBqhn1kRer+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b5Ixk3KITRzVvcOUnl5/Br0rI31WzGtg+sQag2TXja7uyB8kylRuOAtPZe9FBEML6zL0DytF6NitNJPHybnJdk6Arf1HR2ZlKC/Y/Yc1J9GiIkeD/c5f9Kgf3+GP2qUz13gVUUjTHIzFtIYUvVBbNQWZPxu2cSe8r5L7uUV+L9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DdkqNpVw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DdkqNpVw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720850715;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oWgXM8pC5rdsTWVk/9wioNOTmnMRs1WU1gF1pTR+2Pc=;
	b=DdkqNpVwU0CY8KKFADgW7vT0C6Rh11AhQjbSe0AYFjvRQUOdtfus2yGl7MtVnXsqNlDxfK
	pRVAM0jGzWhOKpDXg58jPPVspt9Xf19c+blhtwyR/wpwgb+w/XeRZukHdc+CBYxSOiZXEM
	e9UJmOBANNhiHNphxyOn5N7+vVD+LUQ=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-335-ikvbCmu6PaSMl9NYFG5qGQ-1; Sat,
 13 Jul 2024 02:05:11 -0400
X-MC-Unique: ikvbCmu6PaSMl9NYFG5qGQ-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AE5C2195608F;
	Sat, 13 Jul 2024 06:05:10 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 482FF1956066;
	Sat, 13 Jul 2024 06:05:10 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46D658F52015534
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 13 Jul 2024 02:05:09 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46D658kH2015533;
	Sat, 13 Jul 2024 02:05:08 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 10/22] multipathd: return 0 from path_check() if that path wasn't checked
Date: Sat, 13 Jul 2024 02:04:54 -0400
Message-ID: <20240713060506.2015463-11-bmarzins@redhat.com>
In-Reply-To: <20240713060506.2015463-1-bmarzins@redhat.com>
References: <20240713060506.2015463-1-bmarzins@redhat.com>
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

If check_path_state() returns PATH_WILD or PATH_UNCHECKED, then the
path wasn't correctly checked, and path_check() should return 0.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 5e89fae5..43bd5936 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2386,7 +2386,7 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
 
 	newstate = check_path_state(pp);
 	if (newstate == PATH_WILD || newstate == PATH_UNCHECKED) {
-		return 1;
+		return 0;
 	} else if ((newstate != PATH_UP && newstate != PATH_GHOST &&
 		    newstate != PATH_PENDING) && (pp->state == PATH_DELAYED)) {
 		/* If path state become failed again cancel path delay state */
-- 
2.45.0


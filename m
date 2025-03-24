Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41C7C1DD877
	for <dm-devel@lists.linux.dev>; Mon, 24 Mar 2025 20:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742849717; cv=none; b=DEQ77c5rIZXL5lzgkVKwSGC/ZU7hfAcjWIRwz7n6xxy+VafqyRaORc2FvR0MdB9F9i8mSForVG8Hy7I3QuECcOvjcRPPFyi8vYW709ObysA3QAG4tihbXjmA7VcmTou1hhZFfH9gAAl1bDkm+b4jbJ6ns7FAmZNLHiULfbzczus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742849717; c=relaxed/simple;
	bh=wVvXCQN2hzaQ+YWvz9JCljUD7BQnZ78PYuHTWSd+ndg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=iWNAb9ydT7bRrANlSVZMJMXvS5cCoRrJKAL8QU4FP1upLlfcf5Ukzobq8wlY1giDpzDTVXsCMaKkhwFpUs/Y3nvB1n8wxeLBVTnij8MARFjU+Abs2ItM4LlBB6ssHnCdhfv0U73HXen28sQg14ZAHJh7FStAYJGkAtR+m9DTVZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TBZAm4YT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TBZAm4YT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742849713;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FcMyTOgKe/7ZrvEOtSsAWE211P4erUMjnVzF/czLtW4=;
	b=TBZAm4YT1y+hedC56n4BsKkonD6dxUx4VDEr3z3ubvS+QG2HFNYGi5+ADwgGy0cg+ZZVc9
	H/XkwNCbPBqEomlyPqD+klOUfLAJ2pyqaz90gJ3zXljk+Nn8c/G7FjEY98XFn3+2M9fr+y
	D/LT0SVmkkGEi9/gLKfjPfzUtSDK8rw=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-56-SqcWAK5WPxmiPOnLNi_ZLw-1; Mon,
 24 Mar 2025 16:55:09 -0400
X-MC-Unique: SqcWAK5WPxmiPOnLNi_ZLw-1
X-Mimecast-MFC-AGG-ID: SqcWAK5WPxmiPOnLNi_ZLw_1742849708
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F0C2F196D2DC;
	Mon, 24 Mar 2025 20:55:07 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AF08230001A1;
	Mon, 24 Mar 2025 20:55:07 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 52OKt6Sm2523517
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 24 Mar 2025 16:55:06 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 52OKt6C82523516;
	Mon, 24 Mar 2025 16:55:06 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 3/3] multipathd: don't update paths in INIT_MISSING_UDEV
Date: Mon, 24 Mar 2025 16:55:04 -0400
Message-ID: <20250324205504.2523493-4-bmarzins@redhat.com>
In-Reply-To: <20250324205504.2523493-1-bmarzins@redhat.com>
References: <20250324205504.2523493-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ljRX_7pDJZo0URP_FScyI8Fvl35_kWMbsB4V6mutN2s_1742849708
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

There is nothing for update_uninitialized_path() to do for paths in the
INIT_MISSING_UDEV state. In fact, there shouldn't be any paths in this
state when update_uninitialized_path() is called, since they will have
switched to a different state in check_uninitialized_path().

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index ecad5a4f..9c44e6e6 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2889,7 +2889,6 @@ update_uninitialized_path(struct vectors * vecs, struct path * pp)
 	struct config *conf;
 
 	if (pp->initialized != INIT_NEW && pp->initialized != INIT_FAILED &&
-	    pp->initialized != INIT_MISSING_UDEV &&
 	    pp->initialized != INIT_OFFLINE)
 		return CHECK_PATH_SKIPPED;
 
-- 
2.48.1


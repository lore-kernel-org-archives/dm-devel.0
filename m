Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0309D4687
	for <dm-devel@lists.linux.dev>; Wed, 17 Jan 2024 01:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705454360; cv=none; b=mgFjThmudd6PYoybW6CAjjMrQI5gaWMTTxpXVtsmPVSYTgkqSoymLJR20vXON+m4ZBMcg/WDI3mumsxl5cMLdjdOsvsGvFYqwcILisFW+l0eKLyowS98U//JtbUKcW9+QgGQiuIl79bCYSHZfmuflx60kS4c4aKB0l47uCgL5Do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705454360; c=relaxed/simple;
	bh=vGbbTAMvzJvRQchGB3hnwfd8qIZiN3dtQNLXt3l4LUk=;
	h=DKIM-Signature:Received:X-MC-Unique:Received:Received:Received:
	 Received:From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:X-Scanned-By:X-Mimecast-Spam-Score:
	 X-Mimecast-Originator:Content-Transfer-Encoding:Content-Type; b=pk+/HHFNNkrCHvLZFbeGhGiOfG2+voRsIEEPKixCSsKlLlsWPd7W6Uw27cl7u3NHmQpKX2DRlbzTGm32sWfHyzg2HEK2WeyWxwZBeYLTrapHLJqz/jyhOZmEd/X7KkPKJOjrs7ifia4Ft+VGa65ZuSr2zKUDMC6dcnNugehrSgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OWjUSyOH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OWjUSyOH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705454357;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pMnQZG7wDXglE+rhv8J/VfMeFAl/3dR3jRBTo2QuoTE=;
	b=OWjUSyOH/Nk4Ee/7EzYlBQrfDGH3/85vokO1EdICC9unQPrNBdfz/bUVJ1lW4JOqc9W71/
	T0CqS2BZfUatk6bFB/G0siok/kG+/NghgQ3Rp9142dKSA3VDXzFEOd1rW0Jd9UVXJgFGxU
	EFXJJOxv7QEW//vXEpxrkyQvGXcMSjY=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-340-aUfrSfMROnSuvaf1Qv9rng-1; Tue,
 16 Jan 2024 20:19:14 -0500
X-MC-Unique: aUfrSfMROnSuvaf1Qv9rng-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 23A941C05B00;
	Wed, 17 Jan 2024 01:19:13 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1E2922026D6F;
	Wed, 17 Jan 2024 01:19:13 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 40H1JCK9018725
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 16 Jan 2024 20:19:13 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 40H1JC3V018724;
	Tue, 16 Jan 2024 20:19:12 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: device-mapper development <dm-devel@lists.linux.dev>
Cc: Martin Wilck <Martin.Wilck@suse.com>,
        Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: [PATCH v2 1/2] multipathd: fix null pointer dereference in uev_update_path
Date: Tue, 16 Jan 2024 20:19:11 -0500
Message-ID: <20240117011912.18710-2-bmarzins@redhat.com>
In-Reply-To: <20240117011912.18710-1-bmarzins@redhat.com>
References: <20240117011912.18710-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

The Auto-resize code added a check that deferences pp->mpp without
checking that it's non-NULL. Fix it.

Fixes: 981b83ad1 ("multipathd: Add auto_resize config option")
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 74f6cd92..fbc3f8da 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1630,7 +1630,7 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
 				}
 			}
 		}
-		if (auto_resize != AUTO_RESIZE_NEVER &&
+		if (auto_resize != AUTO_RESIZE_NEVER && mpp &&
 		    !mpp->wait_for_udev) {
 			struct pathgroup *pgp;
 			struct path *pp2;
-- 
2.43.0


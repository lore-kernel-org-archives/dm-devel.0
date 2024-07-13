Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11D963BB23
	for <dm-devel@lists.linux.dev>; Sat, 13 Jul 2024 06:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720850719; cv=none; b=bdyTK9LQIMYgdcoOyWcEfvP1knRMHQEsjbTttAd0X+KyNdfjC8Vba0ROUa/Cp43BSBYV4ED4JtzkIezaGr/ZXO6kf/6/j4xCqkynu7Bum4X2RLbu/hK+y8jiEcis0dMZ4nislsnamtFwW/rs4OmBMnHdYK53SuqYwdLiI1WJv7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720850719; c=relaxed/simple;
	bh=/DyHTbQ6L3EHEV6ZBavUusss1G2bDuJld2bKfBq6puw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Nhj1a5+BK44IRfGAIGHagM3U7OMC+8LkOPrSJgb4eJM2jXuwqeuvNA8IQ0JULqVzExOzeBXp1tj8/MRIq6zsfhCq9ygWsKFw+Eb50YE//YQ5Ts16qwnDflZteSDVLchxhIglAfNlSalxsO5J7o9IUaffpqIx6gqTWKOKznrxkd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YwNz5phi; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YwNz5phi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720850717;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CONAXBnMF1NhV2i/YpjMc29iCaaoWFzzqjxQkvQxbmA=;
	b=YwNz5phiCfFzAoyj7EYWj27CreD3TXQYx+oAB1gpXcB8IF7VYvfInDUcWcXUyOwwBP1LNp
	YogtFwG8CImtBk9I5nnjrIqcQgQoHJ9DPFhyQ1+pbYdPi0ICyPNiJhGIZWrvBJKb8gn8AN
	HgToYEfgXwGDYKlLLEiNdOyKuVclaSY=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-216-lUK-UdzhMmy2AiZD2U2kIQ-1; Sat,
 13 Jul 2024 02:05:11 -0400
X-MC-Unique: lUK-UdzhMmy2AiZD2U2kIQ-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 264F21956080;
	Sat, 13 Jul 2024 06:05:10 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BC9361955F40;
	Sat, 13 Jul 2024 06:05:09 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46D658sS2015518
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 13 Jul 2024 02:05:08 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46D658X12015517;
	Sat, 13 Jul 2024 02:05:08 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 06/22] multipathd: make check_path() static
Date: Sat, 13 Jul 2024 02:04:50 -0400
Message-ID: <20240713060506.2015463-7-bmarzins@redhat.com>
In-Reply-To: <20240713060506.2015463-1-bmarzins@redhat.com>
References: <20240713060506.2015463-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 9e329e89..276329c4 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2345,7 +2345,7 @@ check_path_state(struct path *pp)
 /*
  * Returns '1' if the path has been checked and '0' otherwise
  */
-int
+static int
 check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
 {
 	int newstate;
-- 
2.45.0


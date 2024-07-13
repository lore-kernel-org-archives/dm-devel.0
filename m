Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7A694779F
	for <dm-devel@lists.linux.dev>; Sat, 13 Jul 2024 06:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720850722; cv=none; b=afBqtx63u/GQDV8X7umUrsqVBhz34Dkpc1GvHE0sk6o3m7EkBzTpi+RN6KQyjm/xPeiU0/PYWfPbQUZb34TgjsuuzaSyL0vpA5ACPSliU3f4WCB1yyif0p02RbtmU5rW3ZHypAao4CHBY6HkAeKUT1i0OywUJDpHmjV7PslEDBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720850722; c=relaxed/simple;
	bh=686pmFl19U+ak3w9ISHGiH0H0AhnmLYZduFRPNXnisg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B2KXfQxpCwHeEnPQcA9DZR5VJV3Ws9ex5Et7eHWWP9ULLLgKa+c0GAb9xstpn26nLTmhQsc/GJyXUYh1PlyPtMonmFRm245iunHy2QkLMCzBhsVGyS2Nfj0F4C0ONg2IkU50pOkgmkaCF9fDzJLJ64fOFH79ffxuKJ38WOKs3bE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=X/6Q2GOe; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X/6Q2GOe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720850719;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pWEmIkuaMaDCYVxaDT0udVn8mwz9u88SGvwdXym7BEE=;
	b=X/6Q2GOeO5ihtS8WUWZFO+WItA1zLYUiS+kclH2CiqGQkv54q7G9galmUaMny4A0DRN6am
	U8QRKWY1S38o4jY5MkchZ+gNMRxV9omXKPIrgV/AYYjbtMPbpKho2OyMSrPz+gE3PhLu/S
	mDCKNTlHOQZx9bsOwImK1ES28ecKHiY=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-612-i_2XinIiNH6wPFOTPO0CSA-1; Sat,
 13 Jul 2024 02:05:13 -0400
X-MC-Unique: i_2XinIiNH6wPFOTPO0CSA-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B5D341955F44;
	Sat, 13 Jul 2024 06:05:12 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 302E31955F3B;
	Sat, 13 Jul 2024 06:05:12 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46D65AR02015582
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 13 Jul 2024 02:05:10 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46D65AOU2015581;
	Sat, 13 Jul 2024 02:05:10 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 22/22] multipathd: clean up the correct wwid in check_path_wwid_change
Date: Sat, 13 Jul 2024 02:05:06 -0400
Message-ID: <20240713060506.2015463-23-bmarzins@redhat.com>
In-Reply-To: <20240713060506.2015463-1-bmarzins@redhat.com>
References: <20240713060506.2015463-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

After check_path_wwid_change() grabbed a new copy of the wwid, it was
stripping trailing whitespace off of pp->wwid, instead of the copy it
just got.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index d51bc852..50b6f3eb 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1025,9 +1025,9 @@ check_path_wwid_change(struct path *pp)
 	}
 
 	/*Strip any trailing blanks */
-	for (i = strlen(pp->wwid); i > 0 && pp->wwid[i-1] == ' '; i--);
+	for (i = strlen(wwid); i > 0 && wwid[i-1] == ' '; i--);
 		/* no-op */
-	pp->wwid[i] = '\0';
+	wwid[i] = '\0';
 	condlog(4, "%s: Got wwid %s by sgio", pp->dev, wwid);
 
 	if (strncmp(wwid, pp->wwid, WWID_SIZE)) {
-- 
2.45.0


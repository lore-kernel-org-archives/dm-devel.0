Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C97918412B
	for <dm-devel@lists.linux.dev>; Wed, 17 Jul 2024 18:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721239878; cv=none; b=qP1zvBx5GoeKim4gaz0+VWGkJ8gYI+qSefBvuczrq46wzQtd2mhhy4QA+MwBhhO0vi1Aba7YwnSReflbeVvqQCAFkWzAvKTHKSVmdIPxhkiy+9qrQdX+A1j+Bj+ZDwFYzUIVAyk2KO9rY3W4d9u+rJRcfNl5lc9wGDahPJJjQS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721239878; c=relaxed/simple;
	bh=Juo2tXG7PwhKMaTSbhyONSWxsjrjlNE0bw9TJBXWoJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y0WwdoxqmhbEkKXSFr+oLfk/CTYQzeY8ofG9gA/40jiUdeCak7QtkbkMBCfO3NlaZVaDsuqCdeSn+4PXStDuiDzT0tfPlYNHaOEA+LD9v08sAK94EJ690/8mn/UQCCxGNlhXZOaTWIrHY7DjjVd62W/D3yNCS29g8ZbSRnB5QiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=T4fYDg41; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T4fYDg41"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721239876;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GPYBb2zrqT4NJhhXaGCHvO8WxAEN9QgTUlG258g8pmg=;
	b=T4fYDg41vnD5/wIdVL8xLEyWUao7QQj5ybuGdzFvcPAOEWM3L551wx9wbXvXB6zoNmhIQT
	iOKR57GbllWGPirxrINR1kW5bLFXx2uTKTNUuhQ3iEBMmY69QjTGnpXUPRl8JDz1vyRsgK
	KD42QvfwoPMezwoOJVnKn6/32+EWYe4=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-145-kStssKaDN_SSNbhuSwgYKQ-1; Wed,
 17 Jul 2024 14:11:13 -0400
X-MC-Unique: kStssKaDN_SSNbhuSwgYKQ-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1772819560A2;
	Wed, 17 Jul 2024 18:11:12 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C49F019560AA;
	Wed, 17 Jul 2024 18:11:11 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46HIBAs42173636
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 17 Jul 2024 14:11:10 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46HIBAZt2173635;
	Wed, 17 Jul 2024 14:11:10 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 20/20] multipathd: clean up the correct wwid in check_path_wwid_change
Date: Wed, 17 Jul 2024 14:11:06 -0400
Message-ID: <20240717181106.2173527-21-bmarzins@redhat.com>
In-Reply-To: <20240717181106.2173527-1-bmarzins@redhat.com>
References: <20240717181106.2173527-1-bmarzins@redhat.com>
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

After check_path_wwid_change() grabbed a new copy of the wwid, it was
stripping trailing whitespace off of pp->wwid, instead of the copy it
just got.

Fixes: 4660cff ("multipathd: add recheck_wwid option to verify the path
wwid")

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 5eefa475..f4910403 100644
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


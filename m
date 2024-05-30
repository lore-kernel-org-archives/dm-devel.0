Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF23446B4
	for <dm-devel@lists.linux.dev>; Thu, 30 May 2024 16:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717088108; cv=none; b=DcyFW1QjidqbG2epnOA9Qzk/IYfkzTJoUXHRuOH0FWRT0cYoF2yfdDCTLGUGgUgkhirThDLSCj7vFGyMnixysJH6xnmtiiCR+OD73I6pRyd/Fwu5spMsFxvwZDzaA/0Cr6yCf7N5sE0XCPHzwv/w/LwK00ozOJlpWLbh7oMkuTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717088108; c=relaxed/simple;
	bh=hiuj3jldCEfNxomYAAgolFX0VOmKbHBrnAv9Ahcps2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QLv8F/pywZtCrRlq1qFciXzzzMt+kAGCeYeEb4pDfdHM0ofPssaPyia8YZGVX+ZVK4BRISK9AHhTHt+9p519tGOHO9Yjplx8jJ046zGDBXXRy7QiI0INxap52FfH6OemSk2r8JS4Ti1KsEcOV4NvKll164qphDrdzIxlJR9pLmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OsaI8MMu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OsaI8MMu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717088105;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6oD3Z8hkztPhypNRmqje2BZdyLuA/Ki1jkowDgBA7b0=;
	b=OsaI8MMu53NoV/Oo9NnlfGOSqJO99A7UN8ks/XzNScF8u5n3AszM1YGk9Z8NZpMd9NvL4i
	JsjflTdCxTryANRSSBKtfEbHWO+NidGKn+2FyfI5UI0QZ6KiPuva6lB/K5ZioknPL1ARLK
	p3cHOkyDMG4P389OVuTw3sLpn2sfpdc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-498-oKCzCPL8PPG3I7oHfdRTmQ-1; Thu, 30 May 2024 12:55:02 -0400
X-MC-Unique: oKCzCPL8PPG3I7oHfdRTmQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1FCA2101A525;
	Thu, 30 May 2024 16:55:02 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 134CA40C6EB7;
	Thu, 30 May 2024 16:55:02 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 44UGt1L7397029
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 30 May 2024 12:55:01 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 44UGt1MG397028;
	Thu, 30 May 2024 12:55:01 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>,
        Nitin Yewale <nyewale@redhat.com>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 1/7] libmultipath: remove pathgroup wildcard options
Date: Thu, 30 May 2024 12:54:54 -0400
Message-ID: <20240530165500.397009-2-bmarzins@redhat.com>
In-Reply-To: <20240530165500.397009-1-bmarzins@redhat.com>
References: <20240530165500.397009-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Nitin Yewale <nyewale@redhat.com>

The multipathd command "multipathd show wildcards" shows the pathgroup
format wildcards, but there is no way to use them in a multipathd
command.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/print.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/libmultipath/print.c b/libmultipath/print.c
index efd5a16a..89813517 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -912,13 +912,6 @@ int snprint_wildcards(struct strbuf *buff)
 				       pd[i].wildcard, pd[i].header)) < 0)
 			return rc;
 
-	if ((rc = append_strbuf_str(buff, "\npathgroup format wildcards:\n")) < 0)
-		return rc;
-	for (i = 0; i < ARRAY_SIZE(pgd); i++)
-		if ((rc = print_strbuf(buff, "%%%c  %s\n",
-				       pgd[i].wildcard, pgd[i].header)) < 0)
-			return rc;
-
 	return get_strbuf_len(buff) - initial_len;
 }
 
-- 
2.45.0


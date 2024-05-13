Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15E3B2E64B
	for <dm-devel@lists.linux.dev>; Mon, 13 May 2024 17:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715621816; cv=none; b=VtwOsWYvQg/7aeXhIUuVe1VT8VgBgxyAIMIO/qVOSeLz6QQtOgeHeW8HrNpT7kzlCVE//qIuCaJeAxBgHE2ULKWehNHapB0l4fVIk7yw9GddLr2tSCMcPBsfNOsD7wyzBX2pn7OsLZaMDP7A8nOYnPE3P5DbO9VTz7crzxOqeuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715621816; c=relaxed/simple;
	bh=9H2aVRNfvWv1Qe9kaJ4Xl3q8fHaEl2DP5vBzUUtl7To=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d0AShFQO2UToRArDxRQsdTgkCBZfkx+qCn0G61mtE/qNQgi6BUokj9b/gsLkLgLHuYjbPPsWeJbr9/hMZOh0/Xo4JJn0nfNDIUu/zjf5PtXjXhOXdOd0QmYOkzdF2Pc73LZaKXknEXFS6qmFQV4EKG9Tv1oY4jEl9BYrIUddP/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gdUGLYit; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gdUGLYit"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715621814;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sKWL5tx3+wSmAUBnOBo2JzGr51L/M1/BrUmjDlVGik0=;
	b=gdUGLYitv0BsCYosLJYo4j6XjXRXg0TKgqrPFTAQQBN1b1jQxVjD6Wzisa2R9jxJgmubLx
	ERS9jj6YqNywB3wUokV9IOPHYBANip8WKP6DtFthZGDXrSXNdu4ChycOpm/GnccO8MSgXB
	inkmGO4QaaxkEwe/hyG65LTpmNR5L/w=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-257-bbxON6udPtSTcPmPRMBEpw-1; Mon,
 13 May 2024 13:36:47 -0400
X-MC-Unique: bbxON6udPtSTcPmPRMBEpw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4F9A03802266;
	Mon, 13 May 2024 17:36:47 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4658A200BD93;
	Mon, 13 May 2024 17:36:47 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 44DHal3j094444
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 13 May 2024 13:36:47 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 44DHalsc094443;
	Mon, 13 May 2024 13:36:47 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>,
        Nitin Yewale <nyewale@redhat.com>
Subject: [PATCH 1/7] libmultipath: remove pathgroup wildcard options
Date: Mon, 13 May 2024 13:36:40 -0400
Message-ID: <20240513173646.94424-2-bmarzins@redhat.com>
In-Reply-To: <20240513173646.94424-1-bmarzins@redhat.com>
References: <20240513173646.94424-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Nitin Yewale <nyewale@redhat.com>

The multipathd command "multipathd show wildcards" shows the pathgroup
format wildcards, but there is no way to use them in a multipathd
command.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
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


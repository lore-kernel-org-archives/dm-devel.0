Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 167971598E7
	for <dm-devel@lists.linux.dev>; Mon, 15 Apr 2024 23:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713224592; cv=none; b=sKJAnB9lzZr25XmNohY52D+oXKMye7dRq4HMiVtxliq46SkTrkm5y1ahVuAC51g+5nBZDAXhmDKC0ndsfAj9ePsJTa0jW/dMTYLEcTrK8jkuKYOh/MvarXBiWXC9XTveiTm0yJbgd/scjvL0p4sDhujE1PaiFJ5eQUSQSwRpnjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713224592; c=relaxed/simple;
	bh=udsEj4L2PAfS4i8rh2GoCSK9q0xBnWWUYnwB6Zs26Dc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=WIOkhyKcK+1f8vvfGDqAlMfJZD0WjCed2mZELOR3BgM9xvWy4oV6L2dOwIpup7XObH0jnBxxILjwQrU5338XrIhcmj337phq2GBKnzLMQf5s4xPQx+q8u2FTCKwfZSvnN0V77MbXiB/ibb0Z0dj9nNvdQPjvjB8W0iHPTg5sP4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Xk+fGx5Z; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Xk+fGx5Z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713224589;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=bt28xuA4GOF4hexaIAMDNhHmu9xDDUas9sx6i1a3u24=;
	b=Xk+fGx5ZbZwhbsa1tLbX8trHYKcPmI9fFu62ep1NebjqiIiwYcxp5CkxIXruL1GbQmTRVw
	XSuqtk7yz+bvJElHytNnsaFyFVU3OSGDhZalaWESRLQ3mE3BJpHI5dkiEA3gPFRfLFVOx2
	kpZLvubjBRacaLehaLO//nJKfjUJn/Y=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-517-1Vm6ihK-PMCN0PBsdhLzEw-1; Mon,
 15 Apr 2024 19:43:07 -0400
X-MC-Unique: 1Vm6ihK-PMCN0PBsdhLzEw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6CAC73C000A1;
	Mon, 15 Apr 2024 23:43:07 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 633EC40AE7C4;
	Mon, 15 Apr 2024 23:43:07 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 43FNh7mT1984771
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 15 Apr 2024 19:43:07 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 43FNh6cK1984770;
	Mon, 15 Apr 2024 19:43:06 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2] multipathd: Set CPUWeight to 1000 and LimitRTPRIO to 10
Date: Mon, 15 Apr 2024 19:43:06 -0400
Message-ID: <20240415234306.1984762-1-bmarzins@redhat.com>
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

If multipathd doesn't become a real time process, it was scheduled as a
normal process, without any priority increase. Bump up the CPUWeight so
that even as a normal process, it will still run with increased
priority.

If multipathd did become a real time process, it set itself to the
highest priority, which is excessive. A priority of 10 is plenty.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---

Notes:
    v2: Lowered LimitRTPRIO as suggested by Martin Wilck.

 multipathd/multipathd.service.in | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/multipathd/multipathd.service.in b/multipathd/multipathd.service.in
index 18bb367e..a63ddd9a 100644
--- a/multipathd/multipathd.service.in
+++ b/multipathd/multipathd.service.in
@@ -19,7 +19,8 @@ NotifyAccess=main
 ExecStart=/sbin/multipathd -d -s
 ExecReload=/sbin/multipathd reconfigure
 TasksMax=infinity
-LimitRTPRIO=infinity
+LimitRTPRIO=10
+CPUWeight=1000
 
 [Install]
 WantedBy=sysinit.target
-- 
2.43.0


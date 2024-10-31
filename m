Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA0B01E495
	for <dm-devel@lists.linux.dev>; Thu, 31 Oct 2024 18:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730399590; cv=none; b=a6Iqz+IXy+F88G1aUnW4pNaAGb0bYKp3IU0h4CsfOJC0HgfxMdMM+zwaTt8KOfjtCySYXuteA8cqK3LbV26ZSMJqs1mTiX3E4bggCoNSC3rCUjAwiSPWAZKDSR0/g+puE22qH12uJnJ4Tov1Uo9oKPfVZt9yRdOCZXZyQ/hN6+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730399590; c=relaxed/simple;
	bh=hKlGzdIz3wFR08gbArtDpn6fbZ28kn4GkbToHI6GOYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bOEs2zKw6BA8QplSqUrEEzWZvwk2ekJU+UaLD4zguHjV1vbltIf1Sc2b7GgPO9C8RMoR4g+Qs2JZaSD4RZzX5KV46gN4IhOqEo7Ad8uenl42jSBzq6ifA7qLwhhvVfOXU++cAbtESZgFz7HmF0PQ1Pi/xar1paZ3aE6Esckbjj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=D7h6Q5/F; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D7h6Q5/F"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730399586;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ILQ5XdlOLXfl82vj2+yJwB0Ise0i5a3LDBczDPNv99k=;
	b=D7h6Q5/Fhhmdo6rE/mURLqNSiCr5Nj5RJL9GhUhpabpgVGnpwxS546Z4BF4DOnXqBO8WWI
	DdXJgSnMEWgekSeGEUBOceQk53QPYmyEvWyX47ABXTxJhPXtgcXUL/9YM9by3oXqG+VWzl
	Qrl73oiqxbjjL/2Iu7pGBP7zkYmVKQA=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-258-89l8iHlENOG_ANCSihI_Kg-1; Thu,
 31 Oct 2024 14:33:05 -0400
X-MC-Unique: 89l8iHlENOG_ANCSihI_Kg-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 933A41956096;
	Thu, 31 Oct 2024 18:33:04 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 46A24195605A;
	Thu, 31 Oct 2024 18:33:04 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 49VIX2Zo391449
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 31 Oct 2024 14:33:02 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 49VIX2Vk391448;
	Thu, 31 Oct 2024 14:33:02 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 4/8] multipathd.service: restart multipathd on failure
Date: Thu, 31 Oct 2024 14:32:57 -0400
Message-ID: <20241031183301.391416-5-bmarzins@redhat.com>
In-Reply-To: <20241031183301.391416-1-bmarzins@redhat.com>
References: <20241031183301.391416-1-bmarzins@redhat.com>
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

systemd will now restart multipathd on failure unless it has already been
started 3 times in the last 30 seconds.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/multipathd.service.in | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/multipathd/multipathd.service.in b/multipathd/multipathd.service.in
index 646001e6..b6a25b31 100644
--- a/multipathd/multipathd.service.in
+++ b/multipathd/multipathd.service.in
@@ -12,12 +12,15 @@ Conflicts=initrd-cleanup.service
 ConditionKernelCommandLine=!nompath
 ConditionKernelCommandLine=!multipath=off
 ConditionVirtualization=!container
+StartLimitIntervalSec=30
+StartLimitBurst=3
 
 [Service]
 Type=notify
 NotifyAccess=main
 ExecStart=@BINDIR@/multipathd -d -s
 ExecReload=@BINDIR@/multipathd reconfigure
+Restart=on-failure
 TasksMax=infinity
 LimitRTPRIO=10
 CPUWeight=1000
-- 
2.46.2


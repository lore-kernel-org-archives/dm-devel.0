Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53B705660
	for <dm-devel@lists.linux.dev>; Sat,  2 Mar 2024 00:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709339857; cv=none; b=HB8gI886RGfXWcjfGD/9SUglxdHPtO7Px41gm3x1017k1OYYOcDC6og3Ai9t2TkfDMhm/+wRtmF0YMkQAdY5F34fuyouE+9zGonOy50xzU2MyDjPactu+ptCW+p6Rc3qNIEm71pGWh8bv3+Yh2EEfpulg0xAvotSgPFNu/l9weE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709339857; c=relaxed/simple;
	bh=RmiqSkZTiqf3B2JG6NUsid1ie1L7mIspqXRnNz9295o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IUhHxMbNfusgw8j9Lz1KpF8kGjsZwIq7Q2ca6l0SkrGANs63PCv0DwwpDafsoXXcjzqRcpG1d1Bx8vnH17Oye6u/XgonX29BBTk30xs+KGgthfjBw0pgCV9qeq9I/UrlC31EMv61Da1x1GvG+wEWaeAZOJiGtqj7vZal7UEr6k4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=c8yiqawr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c8yiqawr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709339854;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9cavAMNvZEHgZO/6V3XVNnjdf9wSbPlLvGPUQMM41bk=;
	b=c8yiqawrdk0pdpH3VfrKeQ0qBfuwmD8P4JrqiKdRbnqLXHmoqfM8PnRfitQMXwzZV2rNEa
	SBZDY13Hok/Cy7f+hhL8CquyXwhXbjGWBeYojSTTf+IoD9Me2SWM0p69FiJnZIOzG2STfY
	l0cOILfv7EC3lqriDdT6tfj9J9ZuylU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-551-k2br9ZjjOVquMQKAHGtkVA-1; Fri, 01 Mar 2024 19:37:32 -0500
X-MC-Unique: k2br9ZjjOVquMQKAHGtkVA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E1A1582DFE9;
	Sat,  2 Mar 2024 00:37:30 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DAC452022AAC;
	Sat,  2 Mar 2024 00:37:30 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 4220bUIj782709
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 1 Mar 2024 19:37:30 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 4220bUFJ782708;
	Fri, 1 Mar 2024 19:37:30 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>,
        sushmbha <sushmita.bhattacharya@oracle.com>
Subject: [PATCH v2 1/2] multipathd: use condlog level for setscheduler error message
Date: Fri,  1 Mar 2024 19:37:29 -0500
Message-ID: <20240302003730.782685-2-bmarzins@redhat.com>
In-Reply-To: <20240302003730.782685-1-bmarzins@redhat.com>
References: <20240302003730.782685-1-bmarzins@redhat.com>
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

condlog uses its own log levels, so LOG_WARNING makes no sense. It
actually translates to a message sent at the LOG_DEBUG level.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 6193e691..85ac540f 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -3178,7 +3178,7 @@ setscheduler (void)
 	res = sched_setscheduler (0, SCHED_RR, &sched_param);
 
 	if (res == -1)
-		condlog(LOG_WARNING, "Could not set SCHED_RR at priority 99");
+		condlog(2, "Could not set SCHED_RR at priority 99");
 	return;
 }
 
-- 
2.43.0


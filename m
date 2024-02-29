Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A15C2D048
	for <dm-devel@lists.linux.dev>; Thu, 29 Feb 2024 01:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709171897; cv=none; b=q5npSaV+rbukvxK8pJPoBd9yfXToWm5Pk+W+xY4OiyWte7loBQsVQ7pzVl2BffC+pwOoIKeQkrgGlSXZaWiGqAoJZ5pRMso6Vrnx/Y/egpnXgeKCSBnwskyaCm/ktVzhy53nXQEkThJ4M4Fab6m/UzKwFtvKjMhs/Sufs4hHuK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709171897; c=relaxed/simple;
	bh=IJHMPUARo0uBTgxyDw3YDqz9FD4hXp17hytqr+zaVqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qB7J9PrwAkpKOlfSqAqk2mKr3LdjlzxPD/iW8L5wGmHCnNKCl+aX5ViKUuMQnkUCUWFwAMvF+1V4b4DbntIgDWIwQhf25EeDlTQpXQEP+zp6xgkmkE8cwaPVFnvJ7xiGYceX2ebfIalIztjy03SOVRCr8y0lLfV8cX9S+atM3co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IBocAsND; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IBocAsND"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709171894;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IIuJh4QAYLz4pqm/dbYD9OHeuezYApWj7WaIOsD+pFQ=;
	b=IBocAsNDeiO0i7FfOEsN2NY41QCV87fjKLDOlXWGzNH+/NmwSRM6gcI7QrGhsCPkwZ+CjC
	z9RtqOY+K+jGiLrC6LeLkR4wF8bGfy9hN67uCH5JEVZ/Ws8PjI2UykUCDtvoVTylRfCh3k
	IMNqfE9t+5WB0fBw6NfAhIe7t7/WdWU=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-517-mwPh2LoDNHSQko_XP6Pb9Q-1; Wed,
 28 Feb 2024 20:58:11 -0500
X-MC-Unique: mwPh2LoDNHSQko_XP6Pb9Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BE615280A9A3;
	Thu, 29 Feb 2024 01:58:10 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B8A1410793;
	Thu, 29 Feb 2024 01:58:10 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 41T1wAwP686433
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 28 Feb 2024 20:58:10 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 41T1wApL686432;
	Wed, 28 Feb 2024 20:58:10 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>,
        sushmbha <sushmita.bhattacharya@oracle.com>
Subject: [PATCH 1/2] multipathd: use condlog level for setscheduler error message
Date: Wed, 28 Feb 2024 20:58:08 -0500
Message-ID: <20240229015809.686418-2-bmarzins@redhat.com>
In-Reply-To: <20240229015809.686418-1-bmarzins@redhat.com>
References: <20240229015809.686418-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

condlog uses it's own log levels, so LOG_WARNING makes no sense. It
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


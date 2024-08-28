Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDCF31AD413
	for <dm-devel@lists.linux.dev>; Wed, 28 Aug 2024 22:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724883487; cv=none; b=k6V7RiVR6rhlAcafX9dzkrwwpImALk7JoPrCov5yZxRtJFJTcb9AnwZorBVMnNBJAFY+qsyZXwHFQNWys8BLjJx227+kuuxUZ7Ko7M+q3n82bhf11vsx947N+qDl/MgtSMbxyBIDTh94x4bKV74OvqslzYZVgoAeR1jjcrkUFVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724883487; c=relaxed/simple;
	bh=wo9MpefF/Iwv6YMX5x2ihGqWHo6ifCjlw6EzRDMFHnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HgfdtQuI918BxFbRX/HyufIPJeQ/i+MKuUy8vDk3veMZ/qsS+ji3e3u/rLSMr4vLY5GnF9nqzVS4gMlJCzleaxnl+8kNxXJFFHdDP71SmYzuV8f7jxNOT9jayVGeKQSZt/7YIGghP46VTzHNkNDE1/qHC5qixVRp8CRT3poeFGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=agJvRcPc; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="agJvRcPc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724883484;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T9eNF7YwFlE/dv6DeGvv+Co2p5SJ0Ny0cKpwuYcF680=;
	b=agJvRcPcKEJu2gYD1HuEMhqNMMBzf177aQXtxX2GXmy984Ac0NOp/PfxDlXbQk3lbz2KJq
	otc3NZA4UYWRZETUCuqd+fgL8ND1L9uEHeR8GY7xNFynZorWk47gWvP+61h4DpG1tliuxT
	p92yS099cwkQHdObsZtvi/2H2gDC4M4=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-680-Hcd7-Rq1OGaTtnUBk-OErA-1; Wed,
 28 Aug 2024 18:18:02 -0400
X-MC-Unique: Hcd7-Rq1OGaTtnUBk-OErA-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A5C6A1955D42;
	Wed, 28 Aug 2024 22:18:01 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 412C41955DD8;
	Wed, 28 Aug 2024 22:18:01 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 47SMI0hR4060632
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 28 Aug 2024 18:18:00 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 47SMI0Ma4060631;
	Wed, 28 Aug 2024 18:18:00 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 15/15] multipathd: fix deferred_failback_tick for reload removes
Date: Wed, 28 Aug 2024 18:17:57 -0400
Message-ID: <20240828221757.4060548-16-bmarzins@redhat.com>
In-Reply-To: <20240828221757.4060548-1-bmarzins@redhat.com>
References: <20240828221757.4060548-1-bmarzins@redhat.com>
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

If reload_and_sync_map() removes the multipath device,
deferred_failback_tick() needs to decrement the counter so that it
doesn't skip the following device.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index f9b0ebaf..9e930b53 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2098,9 +2098,12 @@ deferred_failback_tick (struct vectors *vecs)
 
 			if (!mpp->failback_tick &&
 			    need_switch_pathgroup(mpp, &need_reload)) {
-				if (need_reload)
-					reload_and_sync_map(mpp, vecs);
-				else
+				if (need_reload) {
+					if (reload_and_sync_map(mpp, vecs) == 2) {
+						/* multipath device removed */
+						i--;
+					}
+				} else
 					switch_pathgroup(mpp);
 			}
 		}
-- 
2.45.0


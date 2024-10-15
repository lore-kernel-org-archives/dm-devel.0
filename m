Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C057D172767
	for <dm-devel@lists.linux.dev>; Tue, 15 Oct 2024 03:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728962926; cv=none; b=DjucgqiI2pV6lOtinDimSMilOBROn78IuzFs+1z6t/PQy+xACDIRBqNv2LCg/YsRjFK5D4l5YCYqeq7SxkLiSD8+nZVOmwJ6SniRjJ9+WeBo0Qk1Eof6GWaP1cKRMYww4g0r9xh3pNFANR6et6YkgWCobba55+LiIbXk7Gz6WRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728962926; c=relaxed/simple;
	bh=zaNexoUneOEQPf+9ysIfEbZaWN6PLoQIcIse4OA0nXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i6qAwTRsZzD75Ld0W7tjS3wBt2l9wtuTV8MAYxMRuu0hodNfbpEZH4+XaV7Qk/PCzlCJECPIUQPMuDTuVxxNsvrzHVbiXIK2jbI8TDs9U1d19pgLFKIrZjaMYixMF8qKsU6bXwlG6kyvt7jOx+r7KjZPodSDpqxWtrj8K55MjNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fwfTe7r8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fwfTe7r8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728962923;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kR0kv7vtx28nx1HwYUaVB0jOK/P9d+OGolWX1vzDtWg=;
	b=fwfTe7r8Jywo/wxq7XLRZ/5uwAAHinXgG19QUaw9HbRkpvp07KG4DusijIpdzAxB079rzf
	+p1cq3fgp8R+2z6UHqmr2TnM/n6Jevh2JeNp6YxtAEQKOTyDNT3GzgT/fI1U2/Ww19T1WJ
	758zh9tC3kjipOGGre+gBIFH7ta4JiA=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-516-3QE-Q-feOfK9F1Zn28uFcw-1; Mon,
 14 Oct 2024 23:28:40 -0400
X-MC-Unique: 3QE-Q-feOfK9F1Zn28uFcw-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AFA8A1955EE6;
	Tue, 15 Oct 2024 03:28:39 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 78F4D3000198;
	Tue, 15 Oct 2024 03:28:39 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 49F3ScT82693351
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 14 Oct 2024 23:28:38 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 49F3ScIP2693350;
	Mon, 14 Oct 2024 23:28:38 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v5 18/23] multipathd: fix deferred_failback_tick for reload removes
Date: Mon, 14 Oct 2024 23:28:30 -0400
Message-ID: <20241015032835.2693247-19-bmarzins@redhat.com>
In-Reply-To: <20241015032835.2693247-1-bmarzins@redhat.com>
References: <20241015032835.2693247-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

If reload_and_sync_map() removes the multipath device,
deferred_failback_tick() needs to decrement the counter so that it
doesn't skip the following device.

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index ec172021..846be5a9 100644
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


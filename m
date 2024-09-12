Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B6821AD25C
	for <dm-devel@lists.linux.dev>; Thu, 12 Sep 2024 21:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726177795; cv=none; b=RdYQ3IRxaCqSg3CBlnLdLIg5GhnEi0hwxau0CgOQmwU763hFhjFezUv7PKtYVikvyxBy9pXpLIwH+Ar85/q8Bxo2PQmKQLPjgi19lPQ/Ga7bIy5I4ob6jK9l6g2iCuXQ9TOJXinPyEHxyQ9VWs/yqvzwsF4y1dpGb/+BJsXBFrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726177795; c=relaxed/simple;
	bh=vIAcuVFqBqZFDp5s3U8YZDkhvPVhMgHVNLHpEoMttMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iJEwh4qNTmDvOES7enk+Kp6xg66c4LUrF6DZE6lBU1UpoNk9wgRkrg9W4XOhU8OIIySPNTxDRCdz4SAfMh9AQhp+HWTKe9Hsy8QT06le/IFmq7ornaBPuoAETVS8/n3/7z1kopW/8HfF59gSqfD8D39IWXFnDvlu8KghiDeURKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ALZjjyS+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ALZjjyS+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726177793;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=B4v6gzKlDdY7pFVvU8nqDcBNEI0j08uWzi4XYoOh0t0=;
	b=ALZjjyS+9nvruAVZnztteHSVpctW04BWuLSn1Ni1C62dH9hFpMLRxt+j6O7Aqp0YuFz9Cd
	JvMOxfNKGjneCFuP8DhQ5p0OW7CLe1nhecD/zWv2agmvcTnGsXOHe3WiMqkomhGMukCSA3
	iIR2cVKVsFmB1qYDCp5s52LKRUFR92k=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-630-ZPcQ1l4oN0ifS6yuCy1riQ-1; Thu,
 12 Sep 2024 17:49:52 -0400
X-MC-Unique: ZPcQ1l4oN0ifS6yuCy1riQ-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CFA201955D45;
	Thu, 12 Sep 2024 21:49:50 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3167D19560A1;
	Thu, 12 Sep 2024 21:49:50 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 48CLnmbO783858
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 12 Sep 2024 17:49:48 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 48CLnm7e783857;
	Thu, 12 Sep 2024 17:49:48 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2 02/22] libmultipath: add missing checker function prototypes
Date: Thu, 12 Sep 2024 17:49:27 -0400
Message-ID: <20240912214947.783819-3-bmarzins@redhat.com>
In-Reply-To: <20240912214947.783819-1-bmarzins@redhat.com>
References: <20240912214947.783819-1-bmarzins@redhat.com>
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

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/checkers.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/libmultipath/checkers.h b/libmultipath/checkers.h
index 6e54d8f0..fb1160af 100644
--- a/libmultipath/checkers.h
+++ b/libmultipath/checkers.h
@@ -188,6 +188,9 @@ int libcheck_check(struct checker *);
 int libcheck_init(struct checker *);
 void libcheck_free(struct checker *);
 void *libcheck_thread(struct checker_context *ctx);
+void libcheck_reset(void);
+int libcheck_mp_init(struct checker *);
+
 
 /*
  * msgid => message map.
-- 
2.45.0


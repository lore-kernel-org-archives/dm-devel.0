Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A264819D899
	for <dm-devel@lists.linux.dev>; Thu, 31 Oct 2024 18:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730399591; cv=none; b=bYtNOIEs/HiYw5WbWVa+YJJlm3Vy2Oic3+bvekOPMfAFFtursCr6Q6PkEAwsgTYAp5yXvESnG2OrAGo30wsiDw6L0vlPCyT3fZehaVCvAZwb334Tkw7cy6K6EYx9Tjt61QMiuizVN2LR+8EpMWQguMXQ5Wgobz/WBpmJ/qwFmFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730399591; c=relaxed/simple;
	bh=j7Qyz7/iLN1XaE9OJPSxxm1MiTVn/UCFUOv2kgZMtXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mJYjIuCXEdSvj9vlqGNlYtg3Pf50Q7Ry0TPN2bYLPo8fHiSYAldxoGdwc7SpVdhs9WnuqpvFT9IjML3BYG1YXhUcQ/H6xrdFOHAbxAc6BzJymHGz79piJHJpCZs1GFarsi3S8g5+AOJ63wGkJIXyVkkwfB/wmAU2q7TyJ872WIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CQ/iaQSE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CQ/iaQSE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730399587;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sf82NNtDZ2WdthQc+jNpgZOHYllkp6snWIoQ11AMreQ=;
	b=CQ/iaQSEgxBZWI/0OHe1Pdfvw9R6wcxaVZe4272jSfm4I3NGs6pZfiO5HazhY9c75mFDjc
	x8b/8LKO5CPbcXcACvbKTD0s9DgTQbSuzmtx2a07KpIQ70Y/gUrcgYbyNU8fGSHvpCIvfZ
	6qMNOdMYO8ooWw+Pe4VvD/XqGwyFzf4=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-529-_pkCaXTxMWWGrLODcxUAjg-1; Thu,
 31 Oct 2024 14:33:05 -0400
X-MC-Unique: _pkCaXTxMWWGrLODcxUAjg-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 57BFC1955EE6;
	Thu, 31 Oct 2024 18:33:04 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C8086300019D;
	Thu, 31 Oct 2024 18:33:03 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 49VIX2k6391437
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 31 Oct 2024 14:33:02 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 49VIX27T391436;
	Thu, 31 Oct 2024 14:33:02 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 1/8] multipathd: print an error when failing to connect to multipathd
Date: Thu, 31 Oct 2024 14:32:54 -0400
Message-ID: <20241031183301.391416-2-bmarzins@redhat.com>
In-Reply-To: <20241031183301.391416-1-bmarzins@redhat.com>
References: <20241031183301.391416-1-bmarzins@redhat.com>
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

Issuing multipathd commands when the daemon wasn't running didn't
print anything.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/uxclnt.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/multipathd/uxclnt.c b/multipathd/uxclnt.c
index 16133a88..55d253a7 100644
--- a/multipathd/uxclnt.c
+++ b/multipathd/uxclnt.c
@@ -52,8 +52,10 @@ int uxclnt(char * inbuf, unsigned int timeout)
 	if (!inbuf)
 		return 1;
 	fd = mpath_connect();
-	if (fd == -1)
+	if (fd == -1) {
+		fprintf(stderr, "ERROR: failed to connect to multipathd\n");
 		return 1;
+	}
 
 	ret = process_req(fd, inbuf, timeout);
 
-- 
2.46.2


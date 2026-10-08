Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAFA73CB2DC
	for <dm-devel@lists.linux.dev>; Thu,  8 Oct 2026 20:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791491299; cv=none; b=q265NRGibhEjRS4mbDgJAiNImOrynExcUV1XVyVaKxSG8cpm18zkiuGngtc2NGK0sE4Gg4O3CZombgcuQION7VgX0MB+600BxPCx7GSC0Tbj8mPqio0rU3oL3lNuGxKO6+ioX9JRgPQgPO4ski8eT7w5F8TnWNgBavZUk/y2mUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791491299; c=relaxed/simple;
	bh=EVGgo/K/sJXirO6aRQpT060uEWBQUxXrZXZR3sCKXug=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=cJf8IZXI7CEBoyG0xeYJwZroye5qfDZ8xWrJOS532vX8eT5g8fBymPxNSqXepQSa7r6JnHu1GGIURFBUDhX1uPM37ja/hboNTK7zggJ7v7/05raq57P3c+t/nQ2JbqzizDY5pmSrbUFvljDUMsaPUFMUIfhHgC+IzORAibSXl40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UAXiYYP+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UAXiYYP+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791491296;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=FxuPOmMgFq2lLgeFCmQXvGhjhSnatPRcYH/hASkgxqQ=;
	b=UAXiYYP+wH90JEnJIqB/cyLVXTcP5vbgT2EA0afOpZQRad9peH+o9vh6f754+wfPqx1G+L
	DlkQJj2Ll4j6xFlcnEGneL6iqVdAiixOvUDReJ4zuiQk1nlkZC5GhGSqDqQyyajZVZv3t6
	+PmIoc671LFEicAnxMZoqQXzJd3maeM=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-633--bkeK9ZDNBSAOPGj_A0p8A-1; Thu,
 08 Oct 2026 16:28:15 -0400
X-MC-Unique: -bkeK9ZDNBSAOPGj_A0p8A-1
X-Mimecast-MFC-AGG-ID: -bkeK9ZDNBSAOPGj_A0p8A_1791491294
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 59DD718009C8;
	Thu,  8 Oct 2026 20:28:14 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0B4DD18005B3;
	Thu,  8 Oct 2026 20:28:13 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 698KSCEI1976819
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 8 Oct 2026 16:28:12 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 698KS96h1976578;
	Thu, 8 Oct 2026 16:28:09 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
        Alasdair Kergon <agk@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 0/3] dm-mpath: Miscellaneous HST path selector cleanups
Date: Thu,  8 Oct 2026 16:28:06 -0400
Message-ID: <20261008202809.1976567-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: v4Rqdn1c-H-zRtWkwc605ipYIDS8lMt1K6ePVf5NxDw_1791491294
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

These are just some minor cleanups for dm multipath's
historical-service-time path selector.

Benjamin Marzinski (3):
  dm-mpath: streamline setup work in the HST path selector
  dm-mpath: standardize repeat_count handling in the HST path selector
  dm-mpath: check values in hst_status while holding spinlock

 drivers/md/dm-ps-historical-service-time.c | 61 ++++++----------------
 1 file changed, 16 insertions(+), 45 deletions(-)

-- 
2.53.0


Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAAEE18991F
	for <dm-devel@lists.linux.dev>; Tue, 13 Aug 2024 10:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723545541; cv=none; b=HEXSInoEToEoPovB8yEhF1CZ2BxEX4ouum/yG8GDw6+vEPadLq5DFI9ced3heECTt//FQEfgUOaK6btZjTj1HyL2aVpZOtL6BPv3FG5K+tIhYkBCAfgnfkBd6LydVexpbv4zvUTe5qjmLVtG5uJAuHnXdFrlj+HEfv2V69WVUL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723545541; c=relaxed/simple;
	bh=NLasph2LUzWhlRlK1KaqaYGGzd0J6XC+IteugDtQdvM=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=qlZeH/x/qFGQjs0tZ33aNAhlXhqdMvJ2jNJHKaoKfmYYCr903alttW+faaBFzoNUgRSNDen3WXkY9z1mEgvVpKYAtR7pYp3DzrZIlBlfnoREfi7WUdtVdLnda8lkrh2uyakDidXGFJeVc+Ng6Sh64UfrdsOMbHh2EYXLMT58IkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eG3LZVoK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eG3LZVoK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723545538;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type;
	bh=Ixn5tUGrJ3/F5Fy+d7CnP50Vy0bDBTb14a4kmnKr/7A=;
	b=eG3LZVoK+yydAd6g5sClNeg34gKLYv1BnLeSRDLoj2A+3sQ3y0JtnnkqOGGuLAH9k4y9Wx
	SvwK3PtsWB87qP0ZrJAnZdkHlgtp+zfXxywEy/Vk713v8wnt8z7yW6pw7UhV7y6KNibEaE
	BFIGZFZv9Lx5tglY9goH1HaT016gbc4=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-607-qiCENhkZPJ2ke3PjaFlSIw-1; Tue,
 13 Aug 2024 06:38:54 -0400
X-MC-Unique: qiCENhkZPJ2ke3PjaFlSIw-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 059001955F3E;
	Tue, 13 Aug 2024 10:38:53 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CFF871956048;
	Tue, 13 Aug 2024 10:38:52 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id A990C30C1C18; Tue, 13 Aug 2024 10:38:51 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id A69C13FB48;
	Tue, 13 Aug 2024 12:38:51 +0200 (CEST)
Date: Tue, 13 Aug 2024 12:38:51 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
    Khazhismel Kumykov <khazhy@google.com>, 
    Zdenek Kabelac <zdenek.kabelac@gmail.com>
Subject: [PATCH v4 1/2] dm suspend: return -ERESTARTSYS instead of -EINTR
Message-ID: <75a5ffa-47b6-8a1e-7d8-0c310401284@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

This commit changes device mapper, so that it returns -ERESTARTSYS
instead of -EINTR when it is interrupted by a signal (so that the syscal
will restart the ioctl).

The manpage signal(7) says that the ioctl function should be restarted if
the signal was handled with SA_RESTART.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 drivers/md/dm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/md/dm.c
===================================================================
--- linux-2.6.orig/drivers/md/dm.c	2024-07-30 14:06:55.000000000 +0200
+++ linux-2.6/drivers/md/dm.c	2024-07-31 18:10:21.000000000 +0200
@@ -2737,7 +2737,7 @@ static int dm_wait_for_bios_completion(s
 			break;
 
 		if (signal_pending_state(task_state, current)) {
-			r = -EINTR;
+			r = -ERESTARTSYS;
 			break;
 		}
 
@@ -2762,7 +2762,7 @@ static int dm_wait_for_completion(struct
 			break;
 
 		if (signal_pending_state(task_state, current)) {
-			r = -EINTR;
+			r = -ERESTARTSYS;
 			break;
 		}
 


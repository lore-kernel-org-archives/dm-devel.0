Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA0671E531
	for <dm-devel@lists.linux.dev>; Fri, 10 Jul 2026 16:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783701445; cv=none; b=MMt9pT8xz5zyReqS1zbYkLUphYfXl5rLoNpwJY5neCjb8+aRvTvbdo/8NEwER8RGLu//bL8EQ72UNJvDpccWmXbxM87NSjTOk3cqdnnIuwp2Ul2i3Z0zbjhtI3H/S06sFf/nucCPO3SvbyLYec7+gt63Pnki2r3+4dNN5wv6BO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783701445; c=relaxed/simple;
	bh=XWyI9RQQSSKn7WqXYSYRQvZf7vLoWyLdWPP43CXeVcs=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=Yjaf1cWnneilFA3/c5rPYq7ohAkVzhaShcuGe/uhOa3uauKC9OCmWqpVyw4MviB1F7zPUp6aFYHYlZQ2jtn1dY/IrCUSr0kd5Jve6T9vI99P1gL2bxqUbT+NMFbO5jS7PGrk7tedAyNCRVhUQPgXr8y7fgfY9n3ELZe21L0SF+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CvIIyke0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CvIIyke0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783701442;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=CfNvnjYJYWh0MJ/NNu4VbmUCCRdGmAdJgjlvw6onEog=;
	b=CvIIyke0ONtJHtKVfWoXeFE2DKeh3/WLMpDt5Wyu7uxa42ug6JV50Q9QvCPEmVEpwq+w6w
	xrOSblFMePW9lZvUzFDr6yk68IFv7Be0CCEQ4+ydHQKhxFC/ODGs/lhCQeoAjBMeE+6e4C
	xGI2aAILtRP+5PbOPE/x7/C7MC6cLIk=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-656-zZBG2l9hMauKfl02BUlmYg-1; Fri,
 10 Jul 2026 12:37:21 -0400
X-MC-Unique: zZBG2l9hMauKfl02BUlmYg-1
X-Mimecast-MFC-AGG-ID: zZBG2l9hMauKfl02BUlmYg_1783701440
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5FE1818052D9;
	Fri, 10 Jul 2026 16:37:20 +0000 (UTC)
Received: from [10.44.32.225] (unknown [10.44.32.225])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 22A43195608E;
	Fri, 10 Jul 2026 16:37:18 +0000 (UTC)
Date: Fri, 10 Jul 2026 18:37:15 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>
cc: dm-devel@lists.linux.dev
Subject: [PATCH] dm-stats: fix dm_jiffies_to_msec64
Message-ID: <d12af9a2-0780-7e4e-ec0d-878f1a38e9a1@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: eWbmLBrfAfr7lWu6T6CfFy3-451k0euU9W-H4UdWYBE_1783701440
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

There were wrong calculations in dm_jiffies_to_msec64 that produced
incorrect output when HZ was different from 1000. This commit fixes them.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Fixes: fd2ed4d25270 ("dm: add statistics support")
Cc: stable@vger.kernel.org

---
 drivers/md/dm-stats.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/md/dm-stats.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-stats.c	2026-07-10 15:38:59.000000000 +0200
+++ linux-2.6/drivers/md/dm-stats.c	2026-07-10 18:16:41.000000000 +0200
@@ -840,10 +840,10 @@ static unsigned long long dm_jiffies_to_
 		result = jiffies_to_msecs(j & 0x3fffff);
 	if (j >= 1 << 22) {
 		mult = jiffies_to_msecs(1 << 22);
-		result += (unsigned long long)mult * (unsigned long long)jiffies_to_msecs((j >> 22) & 0x3fffff);
+		result += (unsigned long long)mult * ((j >> 22) & 0x3fffff);
 	}
 	if (j >= 1ULL << 44)
-		result += (unsigned long long)mult * (unsigned long long)mult * (unsigned long long)jiffies_to_msecs(j >> 44);
+		result += (unsigned long long)mult * (unsigned long long)(1 << 22) * (j >> 44);
 
 	return result;
 }


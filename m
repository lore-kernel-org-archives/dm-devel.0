Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9F481E98EF
	for <dm-devel@lists.linux.dev>; Mon, 11 May 2026 11:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778497470; cv=none; b=YqzHJl2wNepwzVRp+ZRcbm3dUeqEuDVVCbu2mBbKtViZslT3BAIZKQLz5wqdsBx3USg6CoBsABnK323g87I/mbUdcU3LshFBtDOL6jMpiXy16EEr2HuYDeQwiPaXuh03mQydyGte7mXXsC4uEk6AfSZov52yZPmtjtkmupzv5tQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778497470; c=relaxed/simple;
	bh=WjNPaFJjLiYmJkpxtl5goEo0i52LtbzHj867j+TLBLE=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=BgExAT/XYOEABAlIhSbj03Cd3mkPHwV3hfOS/r+FGKOSY//zX/PVx7K60pMqoiZzyCj3zBJX8gKLib0b+DfQC2cRX6tR2ZeEd69z3e1e+PB9hhX1PGq//t7Xtuy8U2OgQnQ2O/7fsIpefDKhFWVFk8I/voPXdRNRr67Uo4BwPq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NLhMs7qv; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NLhMs7qv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778497467;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=3EugoywdmY30b/FS3J8VK2FbsjBu6IC+LMDG7vwoa00=;
	b=NLhMs7qvcTnni909Y6DjQGoAum5q9dUblICJXHcIc0RKyZOPYT4BKnuwQjVsHkbLhMyEGy
	GWVm2vRSzI1WIdH5SXJ/Iaz3jmCShq+OyFrNLvn+MqH9u29cgBJddewzZqOUiO5atWoLW5
	ID+KB8ibfirKAp2F6RAp96MmE95R6uQ=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-155-x-DsZ_K2OpKkQfXvbYXAnA-1; Mon,
 11 May 2026 07:04:24 -0400
X-MC-Unique: x-DsZ_K2OpKkQfXvbYXAnA-1
X-Mimecast-MFC-AGG-ID: x-DsZ_K2OpKkQfXvbYXAnA_1778497463
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2517519560AD;
	Mon, 11 May 2026 11:04:23 +0000 (UTC)
Received: from [10.44.34.151] (unknown [10.44.34.151])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 92EE73002D31;
	Mon, 11 May 2026 11:04:21 +0000 (UTC)
Date: Mon, 11 May 2026 13:04:16 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>
cc: dm-devel@lists.linux.dev
Subject: [PATCH] dm-ioctl: report an error if a device has no table
Message-ID: <53175a7e-b60f-c081-d5a9-cb3827bfda70@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -6OkTyuyfDgfdszQKg6BfMnfkTzF1sHnvzEJW7tdJpI_1778497463
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

When we send a message to a device that has no table, the return code was
not set. The code would return "2", which is not considered a valid return value.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 drivers/md/dm-ioctl.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/md/dm-ioctl.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-ioctl.c	2026-04-27 19:06:34.000000000 +0200
+++ linux-2.6/drivers/md/dm-ioctl.c	2026-05-06 22:10:09.000000000 +0200
@@ -1816,8 +1816,11 @@ static int target_message(struct file *f
 		goto out_argv;
 
 	table = dm_get_live_table(md, &srcu_idx);
-	if (!table)
+	if (!table) {
+		DMERR("The device has no table.");
+		r = -EINVAL;
 		goto out_table;
+	}
 
 	if (dm_deleting_md(md)) {
 		r = -ENXIO;


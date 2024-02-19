Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CFAE44C94
	for <dm-devel@lists.linux.dev>; Mon, 19 Feb 2024 20:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708374615; cv=none; b=WUpBT9gMix+ONC8ZOWUUhiyMffDTwn3j4hafeG+M8TFifC0EmGines93W7ZbO1ki/nCpUo2dxvPYR2TameERYHC/4V2QUn8aFC9kfBQcO7DrB3/u/GG/akRgTTeY2fTmJdgqxV11wNMvyDIKhvOMZ1oF6agwyLcW011kUMrpeEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708374615; c=relaxed/simple;
	bh=7rlhbm+zccqHGK4ShnoV4ckZJecpZ34KqYaIdzRNIYE=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=pWV/YmrUVkJjbFPY/EFzgUb2/+QUJT0xiPfl9TT9ZcR1YF/Pwhs6VHCsqR6+E9WGnAnVzQSJm2vj3p7EYGuPaX/DZ9ILI9hK3slh5Lggbcehvw25/ucCcjex9qLA4Y30Ypilk1iObdu0JFM9nNoGp27vo2OV5aLm0TLipAr0Wsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Nx02f3Nc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Nx02f3Nc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708374612;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HXx4athjB8A8yEEpa4LwVYBisOfoAJyi/l4owabqxTU=;
	b=Nx02f3NcevnpcJxn3dtCDyqbXqylJV4l2yUyiNHFAwIk7uLwQZqIVy1oLgzu5nR+4386K5
	n2ZflV8RKmMSf/yqda7ecPxCjFFIgUH6mOPtGeEQxIXUmq6dKRLJIgwvfAtJ4rxMsF4KBi
	yb6RxUFekzO2aVizf/1RcKbJkaDQYqs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-103-wa6uExKpNymaIypsctMysg-1; Mon, 19 Feb 2024 15:30:11 -0500
X-MC-Unique: wa6uExKpNymaIypsctMysg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B3D6C85A589
	for <dm-devel@lists.linux.dev>; Mon, 19 Feb 2024 20:30:10 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AEE8F14F0;
	Mon, 19 Feb 2024 20:30:10 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id A834C30C1B8F; Mon, 19 Feb 2024 20:30:10 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id A76A43FB4E;
	Mon, 19 Feb 2024 21:30:10 +0100 (CET)
Date: Mon, 19 Feb 2024 21:30:10 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Mike Snitzer <msnitzer@redhat.com>
cc: dm-devel@lists.linux.dev
Subject: [PATCH 4/5] dm-crypt: don't modify the data when using authenticated
 encryption
In-Reply-To: <ab6d4358-3430-e2c9-bb93-c1e8cf72395@redhat.com>
Message-ID: <c0fb19b6-8ff9-99b1-e9fe-2e86abf33dd7@redhat.com>
References: <ab6d4358-3430-e2c9-bb93-c1e8cf72395@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

It was said that authenticated encryption could produce invalid tag when
the data that is being encrypted is modified [1]. So, fix this problem by
copying the data into the clone bio first and then encrypt them inside the
clone bio.

This may reduce performance, but it is needed to prevent the user from
corrupting the device by writing data with O_DIRECT and modifying them at
the same time.

[1] https://lore.kernel.org/all/20240207004723.GA35324@sol.localdomain/T/

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 drivers/md/dm-crypt.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux-2.6/drivers/md/dm-crypt.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-crypt.c	2024-02-05 10:58:03.000000000 +0100
+++ linux-2.6/drivers/md/dm-crypt.c	2024-02-08 14:50:08.000000000 +0100
@@ -2071,6 +2071,12 @@ static void kcryptd_crypt_write_convert(
 	io->ctx.bio_out = clone;
 	io->ctx.iter_out = clone->bi_iter;
 
+	if (crypt_integrity_aead(cc)) {
+		bio_copy_data(clone, io->base_bio);
+		io->ctx.bio_in = clone;
+		io->ctx.iter_in = clone->bi_iter;
+	}
+
 	sector += bio_sectors(clone);
 
 	crypt_inc_pending(io);


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795467620;
	b=m4IQDBeE5E5/wZmpnWaX8mm8E+vrFGqa6/W9QVf5+Ch4rkeCV+ANhoDgnjoy7E4LJ27q
	 FzNyAQ+GuH1PmpR+LPAbpZojLUSHiA5GYJH6E1sTDujG8ptovggj4slAAbnoNWKLqjvSp
	 Sf18ybrCmzGvL0Kp2ssawRkNmOA9bNZxkP2ADhHts6w45grDMvmBIEl0Yq2qgDUHhyCt9
	 +yMTf7In6lqM87lg5X2NRHfm+BdkVDzTbD77Qh0epoTn+1MHx01GU3nuVILxZmzrl6KwF
	 Ou3rFvGGhqWnrZrwwnHKvwd7DWD1EI/DOvdlkpW93FF2Lysnq5K7CY71lUqtjdfw81g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795467620;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Date:From:To:Subject:
	 Message-ID:MIME-Version:X-Scanned-By:X-Mimecast-Spam-Score:
	 X-Mimecast-MFC-PROC-ID:X-Mimecast-Originator:Content-Type;
	bh=lBr5w/IKX9bitZVRVhPWxTH8/9ZexUBetUhzVq6N/A4=;
	b=QVYUwC/e2FWtHqLKbPGvP0AT2CqLH/nXiLMhfBmmxEK3r52JWmNiaPh78lkhXUvRTexV
	 wW+LU6ZzBBIW0sVs0Q7YqRKBIfYWJbfvVIAzZHqGNxQQZl7JHI7LHdiBtr5n64kz+0zZF
	 90qKivc3E9mtM/nGtZkLitgriWllWnRl/6nEv82pYM4RWjKOuiHwcRb5pFUFA5A3z+nND
	 Z0E7mn+2SxGZGNGTfjgF/edx3NO/m6RRM1AnWmlfvDQAssXNt0HvXEFxNq+xCuBSlFLFg
	 sUOzyrCROYH5kH03CjXHs5qWC0MWpHROXeJqO3Ot4CPwKAMrl7a5vxPcu/OgD0bZUvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=eR+5VDOY;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A006D606A321
	for <dm-devel@lists.linux.dev>; Mon, 23 Nov 2026 21:00:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A006D606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=eR+5VDOY
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795467618;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type;
	bh=lBr5w/IKX9bitZVRVhPWxTH8/9ZexUBetUhzVq6N/A4=;
	b=eR+5VDOYZTLhip6Vx2fDuSmq9CpDVEGD7qs8qARXb/ORa2XzQ99ummuemBvDAMwuHchkDV
	VoPEVEr1cG6GilQfKZuNCsJ4ddVXD5bMoZhdZ7S7UUqm6hF2c2tmgi840IE3tpFkgVgHWT
	9vyuH16UsRmmrO77GFvJ57MBbx4zKxg=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-279-TAteQUNbM5ydZOPmmQiP9Q-1; Mon,
 23 Nov 2026 21:00:13 +0000
X-MC-Unique: TAteQUNbM5ydZOPmmQiP9Q-1
X-Mimecast-MFC-AGG-ID: TAteQUNbM5ydZOPmmQiP9Q_1795467612
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4C6A31800A36;
	Mon, 23 Nov 2026 21:00:12 +0000 (UTC)
Received: from mpatocka-thinkpadx1carbongen12.rmtcz.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C5E371801A60;
	Mon, 23 Nov 2026 21:00:10 +0000 (UTC)
Date: Mon, 23 Nov 2026 22:00:08 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>, 
    Ming-Hung Tsai <mtsai@redhat.com>, dm-devel@lists.linux.dev
Subject: [PATCH] dm persistent data: use the "end" value in
 sm_ll_find_common_free_block
Message-ID: <c1cd488a-bd45-0d29-37f7-b7fabb6accf9@redhat.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: mSJxnlapROkhz6rLSNupW2a1jqsR-x3kQ4ACrtpaN0M_1795467612
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

sm_ll_find_common_free_block would ignore the argument "end". It didn't
cause any data corruption, it just scanned more data than needed. This
commit makes it stop at the "end" argument. In case the caller supplies
wild value, this commit still clips it to new_ll->nr_blocks.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-5

---
 drivers/md/persistent-data/dm-space-map-common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/md/persistent-data/dm-space-map-common.c
===================================================================
--- linux-2.6.orig/drivers/md/persistent-data/dm-space-map-common.c
+++ linux-2.6/drivers/md/persistent-data/dm-space-map-common.c
@@ -397,7 +397,7 @@ int sm_ll_find_common_free_block(struct
 	uint32_t count;
 
 	do {
-		r = sm_ll_find_free_block(new_ll, begin, new_ll->nr_blocks, b);
+		r = sm_ll_find_free_block(new_ll, begin, min(end, new_ll->nr_blocks), b);
 		if (r)
 			break;
 


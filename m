Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793990404;
	b=EQmo1tl47D53i9qlohhhf93TwJBzV/9Hz7q0TQcGI2BnjlMPpcjvIekn1NXv8nb2HCzl
	 hhOlsbnpWXJ2BzNa5hb31QP4A7bfugFudvAmx5lt0qKJ7GVjDo7TlI8/eZgw+7R55Fkeu
	 lBpWhpxKPOZWDySzI0tjqt1Tba0cq5pHuSYEXmbLv4vJ49+3FmJ5jxzcYANvK7J+2MEYV
	 ZaYklbCXrJtDEw6S6a0oi6CgXqSck5qpy/cYcufeiERTINsQLjX5MU/J6IiRX0+fO5f7P
	 EOS2xg6QJHeLoRmHeDNs0DlAgvmcMj1amUrNko/prV6Zp3yfLwaVK4G9BXL5NI2L+Aw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793990404;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Date:From:To:cc:Subject:
	 Message-ID:MIME-Version:X-Scanned-By:X-Mimecast-Spam-Score:
	 X-Mimecast-MFC-PROC-ID:X-Mimecast-Originator:Content-Type;
	bh=QMPApAzbEuqPxMj7QU7QHxJM+dEETjyQnMCu53e76Sc=;
	b=cxXEfX2XdT6bcdhoAC8+gzYSC04mWKNRdWdLpeJmlQcYBuGxCfRt/Ax2MOQS7+0Xxixg
	 MGRevI2pLyUxU3AqbZ2USrlJKPEpfgMHBvf3pgqDEs8ZlbZhSWadfOBLSbHQ29qibjMOk
	 87Y0h0cVq1VRZaDtpQRfj0LvetrMtxTMfSrXvJXQs2uJ7qAQPZeMQb0YaTUN5MKmvaK/n
	 bKoCi+eEdR5FAU97wItWtOEAa36OGT07YphmGcDYwMTI1+lvjXpiiH+NKixezRMngtkl3
	 uIC1d0zo7FvstIXL1R+Yo+pbhZNc+moJHWkADZ7pwSDWQH9phLxC3jOwQ3eBwzKrqVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=M+BieLEp;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F95F606A32C
	for <dm-devel@lists.linux.dev>; Fri,  6 Nov 2026 18:40:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0F95F606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=M+BieLEp
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793990403;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=QMPApAzbEuqPxMj7QU7QHxJM+dEETjyQnMCu53e76Sc=;
	b=M+BieLEpt0AvVEVosRQNoPru0mw36unpyRLzzOrwMWg6NWsY5okYoWs79yCVb/VIUGUG2b
	w5Yzcc1G97Mdxl19LNLj5rvE7NSEIQX0FJbSJeC87uZZ8BdO0RjT6Pg3rkrTSjHMwethn0
	EcmeVEM86U60RJm02f2yQk+GzTq5NWU=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-336-b_yltrHwMfGN-n3nCB-JDA-1; Fri,
 06 Nov 2026 13:39:59 -0500
X-MC-Unique: b_yltrHwMfGN-n3nCB-JDA-1
X-Mimecast-MFC-AGG-ID: b_yltrHwMfGN-n3nCB-JDA_1793990398
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 97D0F1954107;
	Fri,  6 Nov 2026 18:39:58 +0000 (UTC)
Received: from mpatocka-thinkpadx1carbongen12.rmtcz.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E96EB1956087;
	Fri,  6 Nov 2026 18:39:56 +0000 (UTC)
Date: Fri, 6 Nov 2026 19:39:54 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>
cc: dm-devel@lists.linux.dev
Subject: [PATCH] dm-cache: fix ending a cursor that never began
Message-ID: <d89335f5-57ce-dc63-c323-a0c6d150851d@redhat.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: b91_5nqO76CiJnkEGdu732zLnj8DyhPWT0c4RGP7p1c_1793990398
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

If dm_bitset_cursor_begin fails, dm_array_cursor_end(&cmd->hint_cursor)
is called. However, cmd->hint_cursor was only initialized if the variable
hints_valid is true. Thus, we must also destroy hint_cursor only if
hints_valid is true.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-5
Cc: stable@vger.kernel.org
Fixes: 629d0a8a1a10 ("dm cache metadata: add "metadata2" feature")

---
 drivers/md/dm-cache-metadata.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/md/dm-cache-metadata.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-cache-metadata.c
+++ linux-2.6/drivers/md/dm-cache-metadata.c
@@ -1433,7 +1433,8 @@ static int __load_mappings(struct dm_cac
 					   from_cblock(cmd->cache_blocks),
 					   &cmd->dirty_cursor);
 		if (r) {
-			dm_array_cursor_end(&cmd->hint_cursor);
+			if (hints_valid)
+				dm_array_cursor_end(&cmd->hint_cursor);
 			dm_array_cursor_end(&cmd->mapping_cursor);
 			return r;
 		}


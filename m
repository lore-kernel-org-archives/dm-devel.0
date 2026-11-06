Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793990668;
	b=dwqOKMsy485xhAG27+Lu1T0G3M7lk3e7br342wPpKvPSN6LLCL/14VAJ7E84LqU/F5qv
	 yAJPXt01HCed1VSuWKS9yBnMPMtkB158dmDpUDqOjDz6TDzrNZvhfsSfoyMFWcqbEdwTF
	 sU8lF8B1yO0YJ6tjVDRoZapTzBnfsxsTnUWZCi5iuLH95PeiwwFhO6UT+sQ6UbC4vzHAB
	 D1CsD8deR4BF3nBSZ6KDexY4obluIVMoKnLwWoHb1ziP2h07d2on7szqZZ3AxMSvpLcvI
	 OcyhY3BNfwNxcgE+Nccq+4idUyKJ/IfAm5lsFwKaS7rQbWsE/mu1cAfHxMdYVnY00cg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793990668;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Date:From:To:cc:Subject:
	 Message-ID:MIME-Version:X-Scanned-By:X-Mimecast-Spam-Score:
	 X-Mimecast-MFC-PROC-ID:X-Mimecast-Originator:Content-Type;
	bh=Odk3Xg4jMoNvW8anoN3OEVKjpI1IbizsS34zapBreJQ=;
	b=ZB4E9TV1hwgMzRW1gxXYGEaoqJKFjJ5K0TD+V7QgAZj1KGrruzUdahA9l+KEgkFSAEQ+
	 LniTt/YhQdXcplOdj2JhXgQvdnDZ7n6DakP3OI5hZqmR6ut9kDA3J3rY+HX2Hx4TTFxFc
	 P9Dyb7ksqJ6G7080zgLHl3V393cA7WXdnDVwAWI7G6G/x6I55jtFHiQRUHL6bP2ZGBAR9
	 6MsYijc8hzTriln/0MBd9xTrPL59m1yg66hS1f66BUsFRtgVzgbdBQG5LJx14HCFjam3g
	 k3kDjBIThYitm2+Uuu4inNEeQhP69H7MgwzDqEpn5IbpWCPnT7XKr8A0F9kDkVuopvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Q8x18Moj;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FF1A606A326
	for <dm-devel@lists.linux.dev>; Fri,  6 Nov 2026 18:44:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3FF1A606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Q8x18Moj
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793990667;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=Odk3Xg4jMoNvW8anoN3OEVKjpI1IbizsS34zapBreJQ=;
	b=Q8x18MojxuS0FbR15PmkwujzPphYvyVZ73lTbz0NK8w/Vs1iK5P8mRFatFXt89o7MKsuhm
	BC5FzFnzFfx6w+q47qqyeLainnlKzhDDCqcFkAfW0mHEBGn0CXMbmONqgEmLswgCgk2l5O
	hsg2n+QbDwIH+fBpWCNHnN0kT2kgBaA=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-437-s-ufg_T4MXWT3Wfdk4YJYw-1; Fri,
 06 Nov 2026 13:44:24 -0500
X-MC-Unique: s-ufg_T4MXWT3Wfdk4YJYw-1
X-Mimecast-MFC-AGG-ID: s-ufg_T4MXWT3Wfdk4YJYw_1793990663
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 920AF194510D;
	Fri,  6 Nov 2026 18:44:23 +0000 (UTC)
Received: from mpatocka-thinkpadx1carbongen12.rmtcz.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 116C21956087;
	Fri,  6 Nov 2026 18:44:21 +0000 (UTC)
Date: Fri, 6 Nov 2026 19:44:19 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>
cc: dm-devel@lists.linux.dev
Subject: [PATCH] dm-thin: fix parsing of feature arguments
Message-ID: <69e705f7-eb73-19c1-2ba8-0737a53d8614@redhat.com>
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
X-Mimecast-MFC-PROC-ID: dEU5LqLu_F-RNzPlFZWinjvyL_Q2wL9yZxPlhciS49k_1793990663
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

"struct dm_arg _args" limits the number of arguments to 4, but there are
5 possible arguments that can be specified.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-5
Cc: stable@vger.kernel.org
Fixes: 787a996cb251 ("dm thin: add error_if_no_space feature")

---
 drivers/md/dm-thin.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/md/dm-thin.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-thin.c
+++ linux-2.6/drivers/md/dm-thin.c
@@ -3147,7 +3147,7 @@ static int parse_pool_features(struct dm
 	const char *arg_name;
 
 	static const struct dm_arg _args[] = {
-		{0, 4, "Invalid number of pool feature arguments"},
+		{0, 5, "Invalid number of pool feature arguments"},
 	};
 
 	/*


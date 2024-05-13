Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E32322331
	for <dm-devel@lists.linux.dev>; Mon, 13 May 2024 17:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715622181; cv=none; b=iluUnWIxEjbjSjd/zfBsdofYNI0Pu3v0X2BaohEnKMRGPSD6PuEFMCqOCyV2KhycEojwOFiqeIQ0KvZ904mDvTXqMCDtTjL0wSXBIkKvyMvFntm4XA1s/ywxygU/4gs128do06k3Y3v2xc1zPCpKLPBURkfKiNS0X64KlQWBPpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715622181; c=relaxed/simple;
	bh=jmzuC1EqGn6tkNKVwy7hoh7FaiwSY2YkYARM+bZP02w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g/BMWA7aIglVcZDwCr/DgYSx7t+w4pbZ8JEC0Z+sM1XDhjJTwCekxO7qnmVBMYUkFl8DvEjQ83cNeZE5fjCESMNR5pjS8S7YboOV8lW4jVoUc4p+DCiu+W3xfsUO0GOmWHZParpyWoFinN5JCfNBiMKre9tAoK3pvdxdzM+n1D8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=T6ecaRgw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T6ecaRgw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715622179;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lSAYs1lyvz0S+7Cz7Aq7FZQAgPSfyFAB8xvdA7+q4B0=;
	b=T6ecaRgwwJcRgYFkHcUoFBhxQ3BFSUWTuDVYYmcXhwUG9qIMcglEM1CI07SrPuSPVPImGy
	5njhpk03SHQwCI2Mu+0aMQBAITqdZM/RvC5DGe20BrqqdenTYHvFeHnQJapYf3DFmycdyq
	AwvQlUSWVle/6HnW99WGi4Tt2zp3HgE=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-512-dhA2q_j5Nr-YkI5YSqsF6Q-1; Mon,
 13 May 2024 13:36:48 -0400
X-MC-Unique: dhA2q_j5Nr-YkI5YSqsF6Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 263D83C0C891;
	Mon, 13 May 2024 17:36:48 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1D639C15983;
	Mon, 13 May 2024 17:36:48 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 44DHalAu094464
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 13 May 2024 13:36:48 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 44DHaluQ094463;
	Mon, 13 May 2024 13:36:47 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>,
        Nitin Yewale <nyewale@redhat.com>
Subject: [PATCH 6/7] libmultipath: change the vend/prod/rev printing
Date: Mon, 13 May 2024 13:36:45 -0400
Message-ID: <20240513173646.94424-7-bmarzins@redhat.com>
In-Reply-To: <20240513173646.94424-1-bmarzins@redhat.com>
References: <20240513173646.94424-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

The %s multipath and path wildcards both say they print the device
vend/prod/rev string, but neither of them do. The multipath wildcards
already provide a way to print the revision string and the %s wildcard
is used in the multipath -l output, so leave the wildcard output alone,
and change the description to only mention the vendor and product. There
is no other way to print the revision by path, and the path %s wildcard
is only used in the verbose multipath output, so make it actually print
the revision. Also check for unset strings, and print "##" instead of
nothing.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/print.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/libmultipath/print.c b/libmultipath/print.c
index 14e7e325..cccfe5a3 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -330,7 +330,7 @@ snprint_multipath_uuid (struct strbuf *buff, const struct multipath * mpp)
 }
 
 static int
-snprint_multipath_vpr (struct strbuf *buff, const struct multipath * mpp)
+snprint_multipath_vp (struct strbuf *buff, const struct multipath * mpp)
 {
 	struct pathgroup * pgp;
 	struct path * pp;
@@ -591,7 +591,10 @@ static int snprint_initialized(struct strbuf *buff, const struct path * pp)
 static int
 snprint_vpr (struct strbuf *buff, const struct path * pp)
 {
-	return print_strbuf(buff, "%s,%s", pp->vendor_id, pp->product_id);
+	return print_strbuf(buff, "%s,%s,%s",
+			    strlen(pp->vendor_id) ? pp->vendor_id : "##",
+			    strlen(pp->product_id) ? pp->product_id : "##",
+			    strlen(pp->rev) ? pp->rev : "##");
 }
 
 static int
@@ -849,7 +852,7 @@ static const struct multipath_data mpd[] = {
 	{'2', "map_loads",     snprint_map_loads},
 	{'3', "total_q_time",  snprint_total_q_time},
 	{'4', "q_timeouts",    snprint_q_timeouts},
-	{'s', "vend/prod/rev", snprint_multipath_vpr},
+	{'s', "vend/prod",     snprint_multipath_vp},
 	{'v', "vend",          snprint_multipath_vend},
 	{'p', "prod",          snprint_multipath_prod},
 	{'e', "rev",           snprint_multipath_rev},
-- 
2.45.0


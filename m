Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDD3C36AFE
	for <dm-devel@lists.linux.dev>; Mon, 20 May 2024 23:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716248291; cv=none; b=VOX1Fshtvrk7DZDSM0NbN0zu3finmI/KVbh2Ck79kNKO8uVvpsL866q841sHzL/Nm2eEj1/OBpuoelyRmVcRqqpvo3jguXTv4KJYkC0oJOtt/N0kKyzStqBNEtd0ydz1kaU+2t6Yj0Z4x+oNeEZBbkeORxSXm7ASRSsKp5rk700=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716248291; c=relaxed/simple;
	bh=PzHdB573FpxEWn6v9jFInhRkNB4FKYqpiVYelhkcIOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OXRWJD6ES3wdAygAQuqBPRcRXzt4DAKRgPrFxNvr8tyePeyvaawPaIY+X+Da/0KQcgkJHD2/m06fuxHK41fkNo212wIAp7dGU6zEwAJa57bpbSIuKO0fUPOVSDS12jWCoj757tzBIhdmf3mE7PlMjJKbvRyViYCCsB/b+LO2jeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UxUr/756; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UxUr/756"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716248287;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lIeaPkFwufKoTl6uzkbcaOvhe+hpqLX9zMBGIBPsCTQ=;
	b=UxUr/756SiJZZpQ9CGicTdEFRtIAySxxY6tiH9VE1fvp+Et4NvKgV+7IOqQ2q5FLNXCJYM
	Qmh7KkyEwzM56sqhwCZ0Z/E+ihg+d41JOS5ZLN6eMbP8uz/IXotk0sY/AV46qOnytweWsG
	XQ3yXUMmJbom+Zuc/fZDjcZdmfL06mo=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-548-xL5uM5G8P8e8dd8yjaZ4Cg-1; Mon,
 20 May 2024 19:38:04 -0400
X-MC-Unique: xL5uM5G8P8e8dd8yjaZ4Cg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4CFE61C0512F;
	Mon, 20 May 2024 23:38:04 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 46D2E4026B8;
	Mon, 20 May 2024 23:38:04 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 44KNc4UG190812
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 20 May 2024 19:38:04 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 44KNc4PB190811;
	Mon, 20 May 2024 19:38:04 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 2/2] libmultipath: accept wwids in find_mp_by_str
Date: Mon, 20 May 2024 19:38:03 -0400
Message-ID: <20240520233803.190793-3-bmarzins@redhat.com>
In-Reply-To: <20240520233803.190793-1-bmarzins@redhat.com>
References: <20240520233803.190793-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

If the device string is not an alias, check if it's a wwid. This allows
multipathd commands to use WWIDs for $map arguments. In find_mp_by_wwid,
only check strings that are small enough to be WWIDs.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/structs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index d89f2187..be3125ed 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -443,7 +443,7 @@ find_mp_by_wwid (const struct _vector *mpvec, const char * wwid)
 	int i;
 	struct multipath * mpp;
 
-	if (!mpvec)
+	if (!mpvec || strlen(wwid) >= WWID_SIZE)
 		return NULL;
 
 	vector_foreach_slot (mpvec, mpp, i)
@@ -487,6 +487,8 @@ find_mp_by_str (const struct _vector *mpvec, const char * str)
 		mpp = find_mp_by_minor(mpvec, minor);
 	if (!mpp)
 		mpp = find_mp_by_alias(mpvec, str);
+	if (!mpp)
+		mpp = find_mp_by_wwid(mpvec, str);
 
 	if (!mpp)
 		condlog(2, "%s: invalid map name.", str);
-- 
2.45.0


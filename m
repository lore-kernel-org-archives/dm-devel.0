Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D9F0315794
	for <dm-devel@lists.linux.dev>; Tue,  9 Sep 2025 00:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757376016; cv=none; b=asASXSw/CLkuXuUM/8fOZxWd94yDznxl8FSIdZoWEgZSpon4etku2KseCzwgg/razc4KvIH4oIBZXPa9fkCKiMrP461CMThQRtPxTuvSNMMMBQf9YWa+xxqWDVo3LMb97uTI6S1yRm4D5rdYh/MCfDQT/5JBaZZKLof8X14kAAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757376016; c=relaxed/simple;
	bh=Z1xRCkxbhYITCzbPSC/uVipApJIkT2w/Wxi0/zJwNwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=icdnAshFBL2q3EnAEEbdFRpbcfUe8jxxGImj9ZtuW7ZzUbec7NmrOypvcOUuhk6DMocZjQ5uYUlSONL2ONZvTuwYj7wzFgR1JPwOGHH4PIglvecaDR5vl6uqaRe+gZoGeAnGGPH4A/NPQNmVWUBdb/ImWORCU3AWfAfeqAse08Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aw00z4VW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aw00z4VW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757376013;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=67W7HQC2Ps1TY+C+QvjBn+F+M085SO+E6NTgXHXOOPg=;
	b=aw00z4VWp2PIDwL8IdSzuyCc3z83w4ZNgI8D4xZ8th+/B0uf4yS2u3KBRHpd/mz7oTngxq
	VPR+0+3Ti56tF7igBpnETUzRr76HK9zN/FhEROw1eFDIR7QkEbaax9J+SR+jYQz5XO9H4h
	H8JOkjR5HQ/oWALFawhWGboNvojoEPk=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-124-nPntjMdANuSldcQ7m5eDdw-1; Mon,
 08 Sep 2025 20:00:10 -0400
X-MC-Unique: nPntjMdANuSldcQ7m5eDdw-1
X-Mimecast-MFC-AGG-ID: nPntjMdANuSldcQ7m5eDdw_1757376008
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CFE90195608E;
	Tue,  9 Sep 2025 00:00:08 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 864713000198;
	Tue,  9 Sep 2025 00:00:08 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 589007uO751179
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 8 Sep 2025 20:00:07 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 589007KY751178;
	Mon, 8 Sep 2025 20:00:07 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 24/32] libmpathpersist: Clear prkey in multipathd before unregistering
Date: Mon,  8 Sep 2025 19:59:54 -0400
Message-ID: <20250909000002.751039-25-bmarzins@redhat.com>
In-Reply-To: <20250909000002.751039-1-bmarzins@redhat.com>
References: <20250909000002.751039-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: OGqmjz4S2a-0L7hNkcd9lnzeJ8UeQmmNY8oL_TdkEa0_1757376008
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

When you register or switch keys in libmpathpersist, it updates
mpp->reservation_key in multipathd before doing the registration. This
means that any paths that come online while you are doing the
registration get the new key registered. libmpathpersist didn't do
this when unregistering a key. This could cause the same problem.  A
path that got restored while unregistering the device could end up
getting the old key registered on it. Fix this by unsetting the key
before doing the unregister, instead of afterwards.

There is still a race condition associated with updating
mpp->reservation_key before doing the registration (but not on
unregistration). This will be dealt with by a future patch.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 libmpathpersist/mpath_persist_int.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
index eef31174..df77ac98 100644
--- a/libmpathpersist/mpath_persist_int.c
+++ b/libmpathpersist/mpath_persist_int.c
@@ -754,7 +754,7 @@ int do_mpath_persistent_reserve_out(vector curmp, vector pathvec, int fd,
 		set_ignored_key(mpp, paramp->key);
 
 	unregistering = (memcmp(&zerokey, paramp->sa_key, 8) == 0);
-	if (mpp->prkey_source == PRKEY_SOURCE_FILE && !unregistering &&
+	if (mpp->prkey_source == PRKEY_SOURCE_FILE &&
 	    (rq_servact == MPATH_PROUT_REG_IGN_SA ||
 	     (rq_servact == MPATH_PROUT_REG_SA &&
 	      (!get_be64(mpp->reservation_key) ||
@@ -832,10 +832,9 @@ int do_mpath_persistent_reserve_out(vector curmp, vector pathvec, int fd,
 	switch (rq_servact) {
 	case MPATH_PROUT_REG_SA:
 	case MPATH_PROUT_REG_IGN_SA:
-		if (unregistering) {
+		if (unregistering)
 			update_prflag(mpp->alias, 0);
-			update_prkey(mpp->alias, 0);
-		} else
+		else
 			update_prflag(mpp->alias, 1);
 		break;
 	case MPATH_PROUT_CLEAR_SA:
-- 
2.50.1


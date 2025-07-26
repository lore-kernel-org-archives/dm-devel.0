Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5377B1E47B7
	for <dm-devel@lists.linux.dev>; Sat, 26 Jul 2025 03:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753502347; cv=none; b=f7k8RDxdi4ClLl2YKPLSSNbIFps6UpbB6lyIsRGMHeewADNs7Cr4iqcWV0NL1iQjoO4vC/19251kf+Ly5BUCWJw4Kg9nxx27at8aqbxa5w5YNDijnrdm7TaKRgy4YJI8qcm/hsIvKjTu87iOFaQOD7hrdSF2PrXiUVN7MWL1TwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753502347; c=relaxed/simple;
	bh=g6088nixW1h7EnTGOZwx1PKhLZkZFIyiPGba7OgcZjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=AFah+Ayf8EEUcrcSqD7e/xHtQT9kTzPipGKXdoTg3VONXMfSpWPEq904jH6Zy13i9S2jskqhiQGHG+3xFsaG3O/3d82P+NZccitBeMQjelAnIEkr+ncy/IfhpGbdSyhEeg+PROF6VPYKq78bl4H1s0yzPxwaVBmbMy7N8T+8dws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CFTRlcen; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CFTRlcen"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753502343;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QITSIbbMpq4qWSA6dplMX5cwpwY6UDRe7l8/KrInJNg=;
	b=CFTRlcengEKX25OenqPIYwbJDWk2lSw7LxNMQlRxzFui96F9MOa5sNMIGB5wE/uMHodNwk
	z8RtHzyxJSRYrLyMNQUYIMTvGaT9Z+4VMKMJl1CSY90HPg2OKikvuJACU9z4X9Ffc2l0Zx
	n28QVWD6xFhbKa4O4kpXs5zsg+m0s1E=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-19-XbJrYF2NP8KizjQ8ET-U7w-1; Fri,
 25 Jul 2025 23:59:00 -0400
X-MC-Unique: XbJrYF2NP8KizjQ8ET-U7w-1
X-Mimecast-MFC-AGG-ID: XbJrYF2NP8KizjQ8ET-U7w_1753502339
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 795F31956080;
	Sat, 26 Jul 2025 03:58:59 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3A1133000199;
	Sat, 26 Jul 2025 03:58:59 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 56Q3wwNe363349
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 25 Jul 2025 23:58:58 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 56Q3wwB7363348;
	Fri, 25 Jul 2025 23:58:58 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 09/14] libmpathpersist: Clear prkey in multipathd before unregistering
Date: Fri, 25 Jul 2025 23:58:50 -0400
Message-ID: <20250726035855.363290-10-bmarzins@redhat.com>
In-Reply-To: <20250726035855.363290-1-bmarzins@redhat.com>
References: <20250726035855.363290-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 85bsdFL2Nr4c3f11w98WlxIKA4Wkl1ditSF11JOZvng_1753502339
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
---
 libmpathpersist/mpath_persist_int.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
index ad98001d..dfdadab6 100644
--- a/libmpathpersist/mpath_persist_int.c
+++ b/libmpathpersist/mpath_persist_int.c
@@ -747,7 +747,7 @@ int do_mpath_persistent_reserve_out(vector curmp, vector pathvec, int fd,
 		set_ignored_key(mpp, paramp->key);
 
 	unregistering = (memcmp(&zerokey, paramp->sa_key, 8) == 0);
-	if (mpp->prkey_source == PRKEY_SOURCE_FILE && !unregistering &&
+	if (mpp->prkey_source == PRKEY_SOURCE_FILE &&
 	    (rq_servact == MPATH_PROUT_REG_IGN_SA ||
 	     (rq_servact == MPATH_PROUT_REG_SA &&
 	      (!get_be64(mpp->reservation_key) ||
@@ -824,10 +824,9 @@ int do_mpath_persistent_reserve_out(vector curmp, vector pathvec, int fd,
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
2.48.1


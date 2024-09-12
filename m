Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1E6C1C245D
	for <dm-devel@lists.linux.dev>; Thu, 12 Sep 2024 21:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726177798; cv=none; b=F1gehKWEYtCAKtpz10uHqNqhNZrMWXLg+Xlm2fLmi3w6XTfxtx8B3pwQVgMmFpXk6rnOq93dknJm/lxwBM5JJchNv6rNtCdg0npDHZpcyISy6znqGiBHJDfoTzvtNixIAsWezB6/H65A5BzAYGSOvpGdRDKtIDCe2V2ZIbrAKr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726177798; c=relaxed/simple;
	bh=Blw0nCgWLhnWMWKVt2wzy6jr9/h6zFwr37wpNmiGqcs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZXbfxiZxOWao5QRDxm4KcfFIlAcphnOMygxPlQHZnlnVTuC2vnming6JIQlv9XRmv/w2ua6rUq1Vbk09GvmC/G1cV5s/6dX36Kzv3X7NMwqUYv26K34JsGc8IqDJNunAr7qpoft8+vqjh+b420NRoA08x2kc0BOXMvdbBIkHgcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QV4zPnJV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QV4zPnJV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726177795;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QhD8Yt5oy3YgpyM1C0TKAHGvFsZXD1j/bcSirkGBL5g=;
	b=QV4zPnJVMalII2CND/euSTtiQXC+/0zkG+kGYKYAOhqV/oEpaRpA/lOTDv0g4WsQYlrDvD
	k/HoM3LPeaEXVi23g2pQvealXh2X/hP904tVpvhxpfxZ4UNgjw7dMbVyAD/Ux5pmsV4Ua8
	NsftzXfV6Aom4RjAhAAzCuuQBzmJDYs=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-661-57xIIO_gObm5wVRFQQhS0w-1; Thu,
 12 Sep 2024 17:49:52 -0400
X-MC-Unique: 57xIIO_gObm5wVRFQQhS0w-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C39C51955F06;
	Thu, 12 Sep 2024 21:49:51 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7601C195609F;
	Thu, 12 Sep 2024 21:49:51 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 48CLnnIO783886
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 12 Sep 2024 17:49:50 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 48CLnn5M783885;
	Thu, 12 Sep 2024 17:49:49 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2 09/22] multipathd: split do_checker_path
Date: Thu, 12 Sep 2024 17:49:34 -0400
Message-ID: <20240912214947.783819-10-bmarzins@redhat.com>
In-Reply-To: <20240912214947.783819-1-bmarzins@redhat.com>
References: <20240912214947.783819-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Move the code that starts the path checker from do_check_path() into
check_path(), rename the remainder of do_check_path() to
update_path_state() and call that from check_path().

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 16c0531e..9319751e 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2396,7 +2396,7 @@ enum check_path_return {
 };
 
 static int
-do_check_path (struct vectors * vecs, struct path * pp)
+update_path_state (struct vectors * vecs, struct path * pp)
 {
 	int newstate;
 	int new_path_up = 0;
@@ -2414,12 +2414,6 @@ do_check_path (struct vectors * vecs, struct path * pp)
 	marginal_pathgroups = conf->marginal_pathgroups;
 	put_multipath_config(conf);
 
-	if (pp->checkint == CHECKINT_UNDEF) {
-		condlog(0, "%s: BUG: checkint is not set", pp->dev);
-		pp->checkint = checkint;
-	};
-
-	start_path_check(pp);
 	newstate = get_new_state(pp);
 	if (newstate == PATH_WILD || newstate == PATH_UNCHECKED)
 		return CHECK_PATH_SKIPPED;
@@ -2639,7 +2633,7 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks,
 	    time_t start_secs)
 {
 	int r;
-	unsigned int adjust_int, max_checkint;
+	unsigned int adjust_int, checkint, max_checkint;
 	struct config *conf;
 	time_t next_idx, goal_idx;
 
@@ -2652,14 +2646,21 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks,
 		return CHECK_PATH_SKIPPED;
 
 	conf = get_multipath_config();
+	checkint = conf->checkint;
 	max_checkint = conf->max_checkint;
 	adjust_int = conf->adjust_int;
 	put_multipath_config(conf);
 
-	r = do_check_path(vecs, pp);
+	if (pp->checkint == CHECKINT_UNDEF) {
+		condlog(0, "%s: BUG: checkint is not set", pp->dev);
+		pp->checkint = checkint;
+	}
+
+	start_path_check(pp);
+	r = update_path_state(vecs, pp);
 
 	/*
-	 * do_check_path() removed or orphaned the path.
+	 * update_path() removed or orphaned the path.
 	 */
 	if (r == CHECK_PATH_REMOVED || !pp->mpp)
 		return r;
-- 
2.45.0


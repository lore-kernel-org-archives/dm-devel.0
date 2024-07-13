Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3ECC23746
	for <dm-devel@lists.linux.dev>; Sat, 13 Jul 2024 06:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720850718; cv=none; b=Z7Vl7bp0ddtrVAg+2Drc50rWVpVObM1Y094IPe4XzDgVaNlww+29zD4f2tKEkIe7aYH3QL49fuGQgViiX3gjCzDyYZScJnRPh2Fmm9zTb8njDChIejmKETAyQLYLwLSQCadFzR6qsI0ITeFcJrxrrObcjZFQMWosJz5dQJhGG78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720850718; c=relaxed/simple;
	bh=pN8qun/VX0ZmNIv6QY6Fvlh3OvFx74Ya8XL7hw4ybuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mGI06RUX7GO14b92MHuMZ5A4V/8d/eN7K9wKUd4RIfA00YjCUstvIR9Pp6EbR44GjXgsrU2pBcJVs6tm+INieakCXgeB/NvSHKOQrA6nMFl13pUsRoHwXFQl8bfCTeXLzL5NlI4oAKyQuzhWeuf1KcOvzgKpIKd9YHxmXmbovq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Rh1rurZL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Rh1rurZL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720850715;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xo939ORJrzxw8SsxYJBz/uEPiFs4/a/F+fs2IUb3tIs=;
	b=Rh1rurZLZYtuFy2AHeAosvx/BmdgD2ijn297QXj3oQCfe/EfRWVfinscXnsvUxvNvMYydG
	7j+BPl1t4DNl2dCNp7FTV5pLinSE6gpR4EAFVe/8ujSaOiksOhx1iwzzRzq8zSb2VfvaZ6
	nGRo/sA0vU0xfPcf9gCjR3AxWrFcIWo=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-625-k9I2STZmPvukvppnp_U5UA-1; Sat,
 13 Jul 2024 02:05:11 -0400
X-MC-Unique: k9I2STZmPvukvppnp_U5UA-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AE36E196CDF5;
	Sat, 13 Jul 2024 06:05:10 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3DE15195606C;
	Sat, 13 Jul 2024 06:05:10 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46D658jB2015530
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 13 Jul 2024 02:05:08 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46D6589L2015529;
	Sat, 13 Jul 2024 02:05:08 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 09/22] multipathd: set pp->tick = max_checkint in handle_uninitialized_path
Date: Sat, 13 Jul 2024 02:04:53 -0400
Message-ID: <20240713060506.2015463-10-bmarzins@redhat.com>
In-Reply-To: <20240713060506.2015463-1-bmarzins@redhat.com>
References: <20240713060506.2015463-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

When handle_uninitialized_path() checks a path, it will either:
1. trigger a new uevent to initalize the path, in which case it won't
   check the path again until that uevent is processed and updates
   pp->tick
2. blacklist the path, in which case the path gets removed
3. intialize the path correctly, in which case it sets pp->tick = 1
4. fail to initialize the path, in which case it was supposed to set
   pp->tick to max_checkint, but instead it set pp->checkint to
   max_checkint, which never worked correctly.

By setting pp->tick to max_checkint at the start,
handle_uninitialized_path() will continue to work as it previously did,
except in case 4, where in now works correctly. There's no point in
messing with pp->checkint for paths that haven't been initialized yet.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 20 +++-----------------
 1 file changed, 3 insertions(+), 17 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 234fbf7d..5e89fae5 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2625,7 +2625,6 @@ handle_uninitialized_path(struct vectors * vecs, struct path * pp,
 {
 	int newstate;
 	int retrigger_tries;
-	unsigned int checkint, max_checkint;
 	struct config *conf;
 	int ret;
 
@@ -2640,8 +2639,7 @@ handle_uninitialized_path(struct vectors * vecs, struct path * pp,
 
 	conf = get_multipath_config();
 	retrigger_tries = conf->retrigger_tries;
-	checkint = conf->checkint;
-	max_checkint = conf->max_checkint;
+	pp->tick = conf->max_checkint;
 	put_multipath_config(conf);
 
 	if (pp->initialized == INIT_MISSING_UDEV) {
@@ -2675,12 +2673,6 @@ handle_uninitialized_path(struct vectors * vecs, struct path * pp,
 		}
 	}
 
-	/*
-	 * provision a next check soonest,
-	 * in case we exit abnormally from here
-	 */
-	pp->tick = checkint;
-
 	newstate = check_path_state(pp);
 
 	if (!strlen(pp->wwid) &&
@@ -2695,14 +2687,8 @@ handle_uninitialized_path(struct vectors * vecs, struct path * pp,
 		if (pp->initialized == INIT_OK) {
 			ev_add_path(pp, vecs, 1);
 			pp->tick = 1;
-		} else {
-			if (ret == PATHINFO_SKIPPED)
-				return -1;
-			/*
-			 * We failed multiple times to initialize this
-			 * path properly. Don't re-check too often.
-			 */
-			pp->checkint = max_checkint;
+		} else if (ret == PATHINFO_SKIPPED) {
+			return -1;
 		}
 	}
 	return 0;
-- 
2.45.0


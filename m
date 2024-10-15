Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C69D154456
	for <dm-devel@lists.linux.dev>; Tue, 15 Oct 2024 03:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728962923; cv=none; b=mb8BO9OKobnWoYLtEsgiZtrtj4NRXP8EuK6KYw/7aF1xDv4bBALNSe9D+MybZJTazD7iySTYNGZwq6J3RKSjpI1+HpGJUlJqlH85RVzO54OQJ7IBTVOqzx0zlr9w/p6xfmRDh1sVX++cCfG+50aiwHa6w+BD8iFuVC4PyKks5sA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728962923; c=relaxed/simple;
	bh=99K6VTJJFJxLyjokNBy4ckNi1r7YQLB+jPluDJU/KQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Gv161CGp/rkuXjq9MAV8xmEriUdhFYlpYnrXXurU1M1oGPZNI6NDTktI1tDB1k1hgLrnCviONuJI+wtw9QE1oVq6twEyJyUeNYmVMSTPgxw8XC4VemTFmagCms/X/yArzElNnhXrbB/ju93Fe3dBzSm482U1t1sokjzfi9yQ8p0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A4u45iTQ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A4u45iTQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728962921;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ppC/N7vQ2ltmCpoFIF5mEowm4dAipA83IZBEj/LI+qM=;
	b=A4u45iTQtlMShF2s39vRZ1YLttsZSyvUwdaPnWT9yLvWceJ8ePIoGpgvyArsWOTHkevRg1
	lWd+Sb7Se43MPQEYVuiVcdkj3/aIG658XBvxJGsqK81RMTCEpEdWzpX0Dxll4Y8q2i6Aes
	eSlOPjeuTYG/TvOjveHca9HaXl6YSM0=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-443-z6vC0DhBMG6GCU0cG8_d7w-1; Mon,
 14 Oct 2024 23:28:39 -0400
X-MC-Unique: z6vC0DhBMG6GCU0cG8_d7w-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C20EC19560AF;
	Tue, 15 Oct 2024 03:28:38 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 83B6A1956054;
	Tue, 15 Oct 2024 03:28:38 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 49F3SbA32693323
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 14 Oct 2024 23:28:37 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 49F3Sb8Y2693322;
	Mon, 14 Oct 2024 23:28:37 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v5 11/23] multipathd: split handle_uninitialized_path into two functions
Date: Mon, 14 Oct 2024 23:28:23 -0400
Message-ID: <20241015032835.2693247-12-bmarzins@redhat.com>
In-Reply-To: <20241015032835.2693247-1-bmarzins@redhat.com>
References: <20241015032835.2693247-1-bmarzins@redhat.com>
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

Split handle_uninitialized_path() into check_uninitialized_path, which
handles udev retriggers for INIT_MISSING_UDEV paths and starts the path
checker for INIT_FAILED and INIT_NEW paths, and
update_uninitialized_path() which gets the path checker result and
reruns pathinfo if the path is up.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index ac54ace4..89f02a3a 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2715,13 +2715,10 @@ update_path(struct vectors * vecs, struct path * pp, time_t start_secs)
 }
 
 static int
-handle_uninitialized_path(struct vectors * vecs, struct path * pp,
-			  unsigned int ticks)
+check_uninitialized_path(struct path * pp, unsigned int ticks)
 {
-	int newstate;
 	int retrigger_tries;
 	struct config *conf;
-	int ret;
 
 	if (pp->initialized != INIT_NEW && pp->initialized != INIT_FAILED &&
 	    pp->initialized != INIT_MISSING_UDEV)
@@ -2735,6 +2732,7 @@ handle_uninitialized_path(struct vectors * vecs, struct path * pp,
 	conf = get_multipath_config();
 	retrigger_tries = conf->retrigger_tries;
 	pp->tick = conf->max_checkint;
+	pp->checkint = conf->checkint;
 	put_multipath_config(conf);
 
 	if (pp->initialized == INIT_MISSING_UDEV) {
@@ -2769,6 +2767,15 @@ handle_uninitialized_path(struct vectors * vecs, struct path * pp,
 	}
 
 	start_path_check(pp);
+	return CHECK_PATH_STARTED;
+}
+
+static int
+update_uninitialized_path(struct vectors * vecs, struct path * pp)
+{
+	int newstate, ret;
+	struct config *conf;
+
 	newstate = get_new_state(pp);
 
 	if (!strlen(pp->wwid) &&
@@ -2859,7 +2866,9 @@ next_mpp:
 			continue;
 		pp->is_checked = true;
 
-		rc = handle_uninitialized_path(vecs, pp, ticks);
+		rc = check_uninitialized_path(pp, ticks);
+		if (rc == CHECK_PATH_STARTED)
+			rc = update_uninitialized_path(vecs, pp);
 		if (rc == CHECK_PATH_REMOVED)
 			i--;
 		else if (rc == CHECK_PATH_CHECKED)
-- 
2.45.0


Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 904061C230A
	for <dm-devel@lists.linux.dev>; Thu, 12 Sep 2024 21:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726177797; cv=none; b=HbifBIooLw6lf0HUtSBzN1TrqW4QL+CulAFZVY9+Io7WTEu6iOc7yvwRUU+dQpFPQNN+WW2GjBWarRFXJDP61AhwC3CRNkojuwN5k+XMjUhKR9MOy7vrxu0JofOH9KumT0HEAFcW9Q2t/w1Q+EpaYE+0p+ABugnXGNAt7Ir8Y4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726177797; c=relaxed/simple;
	bh=M7Ks5a71QDUir1ROh+1SuByoBTc0ThXPTn7NNlORqcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KiXVSyzG4F5CeKnqeQa+3uIB3dOKFJWFUPeqfAOPELI4fiCpinfTd3m8gJZUN3aD6nWaAr0Od/Xk7myWzNBy4mDnH6McHmE42EE65KRJK49WMHeImlbXbtl3xb7dqZE97sGzubnS56+1pdmL7KUavnMvn4GW6BV2cD57gmIuAFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ihhf8frU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ihhf8frU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726177794;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oxg1C3U5wSMVff0orqU2t3FNL/fWpy3LM88dts9YQ70=;
	b=Ihhf8frUhfVne1w0x/OJhT2f0uUgGmjeQFLmd1euJP96J4eFxLNmOQtITTFrXpCMR9JdIn
	Qo6VuEl2zuS9uN+I69Q9HugV84NPCg8lQR5rQOtqLU4hZHDNKLK1Skf1h5ufdLGbfxen16
	hL3QqS5AHJDXyBMM+Jux4ihDs9CX8Ig=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-512-9DLOIw96O8iOOkI35whOTQ-1; Thu,
 12 Sep 2024 17:49:53 -0400
X-MC-Unique: 9DLOIw96O8iOOkI35whOTQ-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4AB4E19560B5;
	Thu, 12 Sep 2024 21:49:52 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A9C4219560B7;
	Thu, 12 Sep 2024 21:49:51 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 48CLnowk783894
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 12 Sep 2024 17:49:50 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 48CLnoWO783893;
	Thu, 12 Sep 2024 17:49:50 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2 11/22] multipathd: split handle_uninitialized_path into two functions
Date: Thu, 12 Sep 2024 17:49:36 -0400
Message-ID: <20240912214947.783819-12-bmarzins@redhat.com>
In-Reply-To: <20240912214947.783819-1-bmarzins@redhat.com>
References: <20240912214947.783819-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
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
 multipathd/main.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 8bfb166d..45d40559 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2718,13 +2718,10 @@ update_path(struct vectors * vecs, struct path * pp, time_t start_secs)
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
@@ -2772,6 +2769,15 @@ handle_uninitialized_path(struct vectors * vecs, struct path * pp,
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
@@ -2862,7 +2868,9 @@ next_mpp:
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


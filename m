Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE6DE243349
	for <dm-devel@lists.linux.dev>; Thu, 16 Jan 2025 20:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737058964; cv=none; b=mNTbuEc8Bd8AthIiujxcV3pWTuQvVRY4HplyMH4IDzW3cAlPFPbYbbGf9vDI26KOR4ARPCiSFCXLKRLBOB+0suHmBbzZwSEOsElUaf76XfWNm0MJpKA7+v6OZ0eTaRIX0dDOqyGYcytYGGpbUi5WM4yoXsNsVG6dmF3025SLUs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737058964; c=relaxed/simple;
	bh=YfhyS2dd1eaJJwkvp1oq99qfinaZbaa6f33AnLwicj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=eJ5E1GAbONzelv2CkYrUee9kzjEtwzdOTO/inGSBypkuhL+7Uyhg7D/1vOL1vTqxP6KsJlzNj4JIikVZSQObja2GEnZHLgmxYuG5Cb9aCz0OlqAkmMowtmtDnixcAvS8N7l01bm2lZeQN0kiBmN/grAkq1odhk2smTfThj15vkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fuK9tYVV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fuK9tYVV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737058961;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ON63+6XxsoOcW04Jo3gAFoymXoX3NR+7FUO1m3Kd1A8=;
	b=fuK9tYVVZl7OJUJvlRuEVoJq3LnPwDGoE4VvUyFgkXRofZfUSZe8ObstTaANLKKFqGhAQC
	pTDJ3pIxYM25vYiN55z0fSMa5LxJyLtL3F+6ECHwIrDkPhfpYAEtsmxUZTr1I5pMsXrmj5
	L/2TSSBhLzdQCVyC69LYGVuNC9GNox4=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-70-dyAYAG0YNzufBUwr88fZwA-1; Thu,
 16 Jan 2025 15:22:38 -0500
X-MC-Unique: dyAYAG0YNzufBUwr88fZwA-1
X-Mimecast-MFC-AGG-ID: dyAYAG0YNzufBUwr88fZwA
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 01C9319560BB;
	Thu, 16 Jan 2025 20:22:37 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9AB0630001BE;
	Thu, 16 Jan 2025 20:22:36 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 50GKMZMd2753975
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 16 Jan 2025 15:22:35 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 50GKMZnO2753974;
	Thu, 16 Jan 2025 15:22:35 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2 1/2] libmultipath: export udev pthread cleanup functions
Date: Thu, 16 Jan 2025 15:22:33 -0500
Message-ID: <20250116202234.2753960-2-bmarzins@redhat.com>
In-Reply-To: <20250116202234.2753960-1-bmarzins@redhat.com>
References: <20250116202234.2753960-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: BVtkRLLICkHAWKAy3iQYy6CjM4RANQaCr_Whau1Re4Y_1737058957
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

A future patch will make use of cleanup_udev_enumerate_ptr() and
cleanup_udev_device_ptr().

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/discovery.c          | 4 ++--
 libmultipath/discovery.h          | 2 ++
 libmultipath/libmultipath.version | 6 ++++++
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index b5851561..72ea0c98 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -146,7 +146,7 @@ path_discover (vector pathvec, struct config * conf,
 		return pathinfo(pp, conf, flag);
 }
 
-static void cleanup_udev_enumerate_ptr(void *arg)
+void cleanup_udev_enumerate_ptr(void *arg)
 {
 	struct udev_enumerate *ue;
 
@@ -157,7 +157,7 @@ static void cleanup_udev_enumerate_ptr(void *arg)
 		(void)udev_enumerate_unref(ue);
 }
 
-static void cleanup_udev_device_ptr(void *arg)
+void cleanup_udev_device_ptr(void *arg)
 {
 	struct udev_device *ud;
 
diff --git a/libmultipath/discovery.h b/libmultipath/discovery.h
index 7d42eae5..1f7a6e20 100644
--- a/libmultipath/discovery.h
+++ b/libmultipath/discovery.h
@@ -59,6 +59,8 @@ bool has_uid_fallback(struct path *pp);
 int get_uid(struct path * pp, int path_state, struct udev_device *udev,
 	    int allow_fallback);
 bool is_vpd_page_supported(int fd, int pg);
+void cleanup_udev_enumerate_ptr(void *arg);
+void cleanup_udev_device_ptr(void *arg);
 
 /*
  * discovery bitmask
diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index 6bdf6944..63f970b7 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -244,3 +244,9 @@ global:
 local:
 	*;
 };
+
+LIBMULTIPATH_27.1.0 {
+global:
+	cleanup_udev_enumerate_ptr;
+	cleanup_udev_device_ptr;
+} LIBMULTIPATH_27.0.0;
-- 
2.46.2


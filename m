Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E792125B9
	for <dm-devel@lists.linux.dev>; Fri, 20 Dec 2024 02:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734660187; cv=none; b=oZ8TbnmGg+aum74930X5CjyfBYvuzWf6zuZvofOnRnlMbNaSkeBUtXhwcwylmzdTMpYLrnDxxI2d9hgWgoPuKpu158/2V5XejD3MnOThciYKfLCJW/vWT5FLSiF+QJpb4TwrbRW5/eHr3pcosKtKTE73NNA1HTYNDhW5jwlMb8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734660187; c=relaxed/simple;
	bh=YfhyS2dd1eaJJwkvp1oq99qfinaZbaa6f33AnLwicj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=gSToWMU4uUrhoFj//FkDoHBHWVDREVa3rWxMHooSp1W/z5Xsx/G9kmyh07JLkA0grCfzsEVeNugC7AB0h5Uf9Y0mPLy8wMyNtLECYmx68xZiwcGEFvl/ot7BJT9hVUPFDcvr+tc5UeY43Yq2J89AojTjNzbeT7w2NKmtE4wBfg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hH8r9dMS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hH8r9dMS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734660184;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ON63+6XxsoOcW04Jo3gAFoymXoX3NR+7FUO1m3Kd1A8=;
	b=hH8r9dMSbELti/ZHu2Ck7tt4lw0tlzGR2c9dR8QGXiEBgtnOPHNs9gbuhy24KdNh4LAAzZ
	OQXcj9RnZf2+DMOYkSm2Uv7bo4BQGwR/xfMQCNnsgfv5ztz1wVZW+DmJiseWSL008fmqqK
	FaDby7mQ2kI9eGhh1Cds5iqxBLhT36g=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-176-e_8eDeUKNiWyE3tToMAmaA-1; Thu,
 19 Dec 2024 21:03:00 -0500
X-MC-Unique: e_8eDeUKNiWyE3tToMAmaA-1
X-Mimecast-MFC-AGG-ID: e_8eDeUKNiWyE3tToMAmaA
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0D2E5195418F;
	Fri, 20 Dec 2024 02:02:38 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AB56B195608A;
	Fri, 20 Dec 2024 02:02:37 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4BK22aBF1759390
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 19 Dec 2024 21:02:36 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4BK22ac41759389;
	Thu, 19 Dec 2024 21:02:36 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>,
        Muneendra Kumar <muneendra.kumar@broadcom.com>
Subject: [PATCH 1/2] libmultipath: export udev pthread cleanup functions
Date: Thu, 19 Dec 2024 21:02:34 -0500
Message-ID: <20241220020235.1759375-2-bmarzins@redhat.com>
In-Reply-To: <20241220020235.1759375-1-bmarzins@redhat.com>
References: <20241220020235.1759375-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6D5960ES8M7uGPhYxOltJEGDACdbTFORB6OYtdN54O0_1734660179
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


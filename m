Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA1881CAB5
	for <dm-devel@lists.linux.dev>; Sat, 13 Jul 2024 06:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720850717; cv=none; b=LHVbMnLSGxvct02Uubc75RcpZ6cO3UXqSTocwRLkEqsvHvsjprV3PxaBgCr4S1Tjh78+rKKyLxViGdQPEPJqqaZqhAHyHgZe7dst1VtFWKhXE4dlo0lDCBxUSB8q5I0atU+tkz2WE3pxGCRQR0yGkf52R1AB9XFGqaa4z1RTvUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720850717; c=relaxed/simple;
	bh=n/eDPfgVF9RnkAcJ/TAiyCxk0nmd647vgQhMx5TtsTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O0x+G7jCBTAOU35b0skPiBm+WS5Esl1UfilrSmfEmsldOOn3/h2w+qHTU0DbKOGTno4FvUn5UrsDSqwh7W9S3FQFYao333cYV/Ve8FgjdJ+UvZHDXQfPT6v3L+C/8KX9FtHAr2o3Mo62FdQswcfJaRz2/MLIYu4I2hPdrWPBPdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AS1ySwoB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AS1ySwoB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720850714;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1UV0dfmzQP60H5+aM3SwQ15PlX0Ja+rcIYcikk0OTEs=;
	b=AS1ySwoB7M9EBFQR0Q3rzWsxDtwh1ot2VvVOCTxNDCfORoa7SwWnMrwi4C1C4ePOpailpQ
	FJr7mPT2JxvyTpYCSDyPq9/i39BC4Dm9pCVGviLI4vfAlHN/1LOt1PAgUEKjKY12N/ch4F
	0/k40f/si35b39DeZFPC57JkqGVWdcg=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-652-OoC7INSDMkSgB6J9qUmubg-1; Sat,
 13 Jul 2024 02:05:12 -0400
X-MC-Unique: OoC7INSDMkSgB6J9qUmubg-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B08931955F43;
	Sat, 13 Jul 2024 06:05:11 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 668A2195606C;
	Sat, 13 Jul 2024 06:05:11 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46D65AL82015562
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 13 Jul 2024 02:05:10 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46D65AxY2015561;
	Sat, 13 Jul 2024 02:05:10 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 17/22] multipathd: handle changed wwid when adding partial path
Date: Sat, 13 Jul 2024 02:05:01 -0400
Message-ID: <20240713060506.2015463-18-bmarzins@redhat.com>
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

If multipathd noticed that the WWID didn't match the device when adding
a partial path, but removing it failed, multipathd wasn't disabling the
path. Instead of calling handle_path_wwid_change(), which doesn't make
much sense when multipathd is expecting a uevent, just manually disable
the path if ev_remove_path() fails.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/cli_handlers.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 0643be15..5d8ba3a6 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -540,7 +540,11 @@ add_partial_path(struct path *pp, struct vectors *vecs)
 	if (strlen(wwid) && strncmp(wwid, pp->wwid, WWID_SIZE) != 0) {
 		condlog(0, "%s: path wwid changed from '%s' to '%s'. removing",
 			pp->dev, wwid, pp->wwid);
-		ev_remove_path(pp, vecs, 1);
+		if (!(ev_remove_path(pp, vecs, 1) & REMOVE_PATH_SUCCESS) &&
+		    pp->mpp) {
+			pp->dmstate = PSTATE_FAILED;
+			dm_fail_path(pp->mpp->alias, pp->dev_t);
+		}
 		udev_device_unref(udd);
 		return -1;
 	}
-- 
2.45.0


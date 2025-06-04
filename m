Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35A2272601
	for <dm-devel@lists.linux.dev>; Wed,  4 Jun 2025 03:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749008111; cv=none; b=VVFUhv+hYsBsV4+ArHG/YlLLcRvS1mfxmX8nhsRWD2iMRvloQs4LlsMFM6mc+i8tadnYm/9/dAU91eHf6o8OBo2Tg457b/T2LhRhSZrjfxfzWUH5uhHpwixdPrTBGM6Ic8D4vwKf1mV3FEsPYEe93tEfXPlsN/vXbP5CxYsPWxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749008111; c=relaxed/simple;
	bh=RqDJBaeyB3I7sxTsrVq9B1dGDcy0eNnB+sprxHon3xo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=jsGxrby/9b4Vsqtf3B83sv0NZwoj701z14CDkWuex5gEDjaeqGE1FdmzznS20lAaJCZUWKBeOxzX7kSOtCL40SgUi3RB26KHw6Zmn40+WOVsMLWuuZxF45Ad0KbHBVNVySgQwHTKVkk/vgkWD84AVJZWERX/tbqlsSd2OrmJ0t8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XoR0K34y; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XoR0K34y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749008109;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EeR7puYCpEqVwAk6ARpFJcvF14jULzBU4Ay2esDWxRQ=;
	b=XoR0K34y/10vPwO60Sptq87vJdWsnWlRPE+Ikg3vugKLpVvf3a6GZW0+0R8dkXsu5ICHO6
	BnT0OTdHKhAsfykex2NmD+ZxA8ugQ1PlqFT0Ihd6QClxXZVl7eZohxsadk/BWFMhj5M6tZ
	JeGfeH2Tem5m359J5hOkjF1FVho/UtI=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-695-M5UWFGCkOQ-h0kd14Q3yWQ-1; Tue,
 03 Jun 2025 23:35:08 -0400
X-MC-Unique: M5UWFGCkOQ-h0kd14Q3yWQ-1
X-Mimecast-MFC-AGG-ID: M5UWFGCkOQ-h0kd14Q3yWQ_1749008107
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2C2E9180AEBC;
	Wed,  4 Jun 2025 03:35:07 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D9A401955DDA;
	Wed,  4 Jun 2025 03:35:06 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 5543Z5N72121585
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 3 Jun 2025 23:35:05 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 5543Z50o2121584;
	Tue, 3 Jun 2025 23:35:05 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 2/2] libmpathpersist: check released key against the reservation key
Date: Tue,  3 Jun 2025 23:35:04 -0400
Message-ID: <20250604033504.2121566-3-bmarzins@redhat.com>
In-Reply-To: <20250604033504.2121566-1-bmarzins@redhat.com>
References: <20250604033504.2121566-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: FMDn6-R8On9jkNYsjxdxEAX9EaFNQ4qdfHu9iOKzGEU_1749008107
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

According to the SCSI Spec, if a persistent reservation RELEASE is
issued using the correct key for the I_T_L Nexus that it is issued on
but the reservation is held by a different key, the command should
return Success and do nothing. When libmpathpersist tried to release a
reservation that was held by a different key, it ended up using the
failback code designed to release a reservation held by a failed path to
release it anyways. This means that any node could release a scsi
persistent reservation held by another node. Fix this to follow the SCSI
Spec.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmpathpersist/mpath_persist_int.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
index b838a014..05739db8 100644
--- a/libmpathpersist/mpath_persist_int.c
+++ b/libmpathpersist/mpath_persist_int.c
@@ -541,6 +541,13 @@ static int mpath_prout_rel(struct multipath *mpp,int rq_servact, int rq_scope,
 		condlog (2, "%s: Path holding reservation is released.", mpp->wwid);
 		return MPATH_PR_SUCCESS;
 	}
+	if (!get_be64(mpp->reservation_key) ||
+	    memcmp(&mpp->reservation_key, resp.prin_descriptor.prin_readresv.key, 8)) {
+		condlog(2, "%s: Releasing key not holding reservation.",
+			mpp->wwid);
+		return MPATH_PR_SUCCESS;
+	}
+
 	condlog (2, "%s: Path holding reservation is not available.", mpp->wwid);
 
 	pr_buff =  mpath_alloc_prin_response(MPATH_PRIN_RFSTAT_SA);
-- 
2.48.1


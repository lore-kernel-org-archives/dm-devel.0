Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D53B31C9DF7
	for <dm-devel@lists.linux.dev>; Thu, 31 Oct 2024 18:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730399595; cv=none; b=QWBY6NMrOzWmuEu5AOMf4VjYFkgrpSErlPqgDhaQpcRZ9gMgmG7uO06eky123cQv1WClEaONoR8kdrguBdxafYhLUDDrqqAw4dWWADpxNS25XAWwBxJteoZ6/t/p+URlCZ2wC+rvm9EID/ufIeZ/16o9lhcQrQCLE6/Mrsh7Eec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730399595; c=relaxed/simple;
	bh=E/z/5lcjikMfrXVhTjQuPKEF7Sg1LSS3boVs8n2wn5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X7zQHgOKTLjaV8vohAo1WApuHR2sXlxyk5sqdxApQ/ESrsgzQkAij9TvFjk7jRvJEqc1Hg8+Ek9G5LtfQL+yE4iWxL1CFLXc9ApAo1JUaSpBkg/+IofH/Qfom3m/NIKIzVkRj7eBe56ka6LZg6VyhgbWYPf5zo205v3ZsSwXKtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GZSHC0yT; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GZSHC0yT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730399592;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t60yKO4fkKQ+3VxZFuPbNvmZUpRG03Qoczri2pGWFnc=;
	b=GZSHC0yTB95cvZhuj2KtNgtEf1V121pOGIloQgIRZkARxol/rnoTqwIgV4d6bq/cPfCErf
	l8RWS/ze1aBHvPIXARFT2cMSDqn/A36LPRzZtmXXXhlksXtZ6+lDTE70G03NUz+TIbYtbt
	l8g5tS5DWYeBkBzKFziQoffKgg/4G+U=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-225-LFh9LiBeNNqz6-vOSX9FMQ-1; Thu,
 31 Oct 2024 14:33:07 -0400
X-MC-Unique: LFh9LiBeNNqz6-vOSX9FMQ-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2704819560B2;
	Thu, 31 Oct 2024 18:33:05 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D9B991956088;
	Thu, 31 Oct 2024 18:33:04 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 49VIX3uZ391466
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 31 Oct 2024 14:33:03 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 49VIX3lU391465;
	Thu, 31 Oct 2024 14:33:03 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [RFC PATCH 8/8] libmultipath: remove devices with no table and multipath DM UUID
Date: Thu, 31 Oct 2024 14:33:01 -0400
Message-ID: <20241031183301.391416-9-bmarzins@redhat.com>
In-Reply-To: <20241031183301.391416-1-bmarzins@redhat.com>
References: <20241031183301.391416-1-bmarzins@redhat.com>
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

if dm_get_multipath() returns DMP_BAD_DEV in dm_get_maps(), it means
that it found an device with a DM UUID prefix of "mpath-" but no table.
Treat this as the remains of a failed device creation, and remove it
like dm_addmap_create() does when it fails to fully create a device and
it's left in this state.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/devmapper.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 0d1552f5..908d759c 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -1283,6 +1283,10 @@ int dm_get_maps(vector mp)
 			vector_set_slot(mp, mpp);
 			break;
 		case DMP_BAD_DEV:
+			condlog(2, "%s: removing empty multipath device",
+				names->name);
+			dm_device_remove(names->name, 0);
+			break;
 		case DMP_NO_MATCH:
 		case DMP_NOT_FOUND:
 			break;
-- 
2.46.2


Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB99C185935
	for <dm-devel@lists.linux.dev>; Fri, 22 Nov 2024 21:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732309902; cv=none; b=Ti48FqNOJJ9hIVNE4JNdyenN48Vt51VC33DSpi87AciAdo5nFyY1ULGrPz4MH4F8gNdetRbvTX4ip0ROHzpraIuM237SQZJhN/GrJ884KqpakzetTSnepdjzTqzYOUgsOB4swgbXq8ElRHXVc29+PiyvCx0eoW48waVgsiF3f5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732309902; c=relaxed/simple;
	bh=Rh2le38k2zTqgsSlbPqTcg8SjtXhfTa0CweonlKGFJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=rLYTnjYAi0+TPHBWWIc4aShB+bxE5br/az0uixT4/HTf89wTu1MSTpKrgGUKAhIUAA+jEgjx5/vhzVqP5kOw/C9ybFmU+Varxbyetv9BAEn2avqZ9H5RjpKz4ItmaJ//JTD+wr0GyMDDLUhmnBsWn3b6QfaIVhyUaav3ODOy6Aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=diqmj8sb; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="diqmj8sb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732309899;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CJ5uAYFvL1AJ+ZMTTe1UCIxratP6ILGARNXBTpgX/dM=;
	b=diqmj8sboaY1qjSzjvkcJ/8zkqZN0Wn0UTu9dgKMoWspcxGt6iWJdTbfCgcaH/CTyx2BMr
	lFu/scHWUTEyNyCtVEAcPIcOwr4YKVFeRBE+iofVXOm4+N1U7E1FseSjdwGyDAdzkQxRV3
	jrFiqSoOCrLer9GJz9PVtxS4/BApAhE=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-151-hzdTeLrnN7KklWe4UUV9Eg-1; Fri,
 22 Nov 2024 16:11:38 -0500
X-MC-Unique: hzdTeLrnN7KklWe4UUV9Eg-1
X-Mimecast-MFC-AGG-ID: hzdTeLrnN7KklWe4UUV9Eg
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 948511955F3C;
	Fri, 22 Nov 2024 21:11:37 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 35C781955EA9;
	Fri, 22 Nov 2024 21:11:37 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4AMLBZbi718927
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 22 Nov 2024 16:11:35 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4AMLBZFJ718926;
	Fri, 22 Nov 2024 16:11:35 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2 11/13] libmultipath: assume device is in use if dm_get_opencount fails
Date: Fri, 22 Nov 2024 16:11:31 -0500
Message-ID: <20241122211133.718861-12-bmarzins@redhat.com>
In-Reply-To: <20241122211133.718861-1-bmarzins@redhat.com>
References: <20241122211133.718861-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: gPhravZhsakFU8wA351Ou3kXj2ogGHi-5-VhbQ6wfAc_1732309897
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

If dm_get_opencount() fails, open_count will be negative, which means
mpath_in_use() will never fail. However, dm_flush_map__() will
eventually fail. There are multiple callers of dm_get_opencount() that
run when trying to remove a device. All the others treat a failed call
as if the device was in use, including one that will later be called
directly on this device. So save ourselves the work, and exit early

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/devmapper.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 751b45d8..3667c51b 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -961,6 +961,11 @@ int mpath_in_use(const char *name)
 {
 	int open_count = dm_get_opencount(name);
 
+	if (open_count < 0) {
+		condlog(0, "%s: %s: failed to get open count, assuming in use",
+			__func__, name);
+		return 1;
+	}
 	if (open_count) {
 		int part_count = 0;
 
-- 
2.46.2


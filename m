Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7B32156644
	for <dm-devel@lists.linux.dev>; Thu, 25 Apr 2024 23:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714088527; cv=none; b=ArGdviMXb5ZJfRiWWcMcVm1RzQHlJp8v/nM3hGtDjaXl9xfxDqqX5C9O/7WGRu0jxBdfTAAkUxLYICFuvufQroig2kGozuIUEpo5Kx4oDjryZxSAmlv+ky6ZKIHJFlKbNYazR1Z3FdasvQzr3XJxbHywwgCaF1ZGvlDGd5Hc9II=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714088527; c=relaxed/simple;
	bh=vcWu1ogL4aTCQ5Y1lQbde87ZLW2YuM0ynwL7erz/PHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P1aVPc7wKosa/oLvq0s7eBNMRRyDkzVj1k2O+KN9wpDUryvlDANk9jyCyTsMoRSOqVKJ1hdpx0KeBJ/399kHG3TAMLO4yOcYVfgxUZFGPEctsXjdulp0t6173glB73BrkoljLNh4zEiI86f8iroPaa2UGzQgps7zzGbaIrt5vNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IvFKoiuF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IvFKoiuF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714088524;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iWvY+fkQ8AcGz852NaJEvn6Dtlhi7RlgHgJnbLiql5c=;
	b=IvFKoiuFFfuueP13CNZOGMvCM8fMy4pU46GRmZUNwaS4Fnvz56Yh4maeIJK+O7aDQ8d6YW
	1D16/DecTTEkjdhA74NVwk7UaVH9Mfs3AmaxX1ue6DiTJms74b/X81Mix6d7crEmUfhlLb
	VPi59FYpJ2cCzVhJCuTw+icrV9hp4Pc=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-617-0b8beepTPEqrIzQDVaNQgA-1; Thu,
 25 Apr 2024 19:35:18 -0400
X-MC-Unique: 0b8beepTPEqrIzQDVaNQgA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 63C5B385A18A;
	Thu, 25 Apr 2024 23:35:18 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5D99F202450D;
	Thu, 25 Apr 2024 23:35:18 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 43PNZIvI2125168
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 25 Apr 2024 19:35:18 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 43PNZI402125167;
	Thu, 25 Apr 2024 19:35:18 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2 3/5] libmultipath: remove redundant config option from InfiniBox config
Date: Thu, 25 Apr 2024 19:35:15 -0400
Message-ID: <20240425233517.2125142-4-bmarzins@redhat.com>
In-Reply-To: <20240425233517.2125142-1-bmarzins@redhat.com>
References: <20240425233517.2125142-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

The InfiniBox config already sets no_path_retry to "fail", so it won't
ever queue IO. That means setting flush_on_last_del to "always" is
redundant, since queueing is always disabled. Remove the
flush_on_last_del parameter, to make it easier for users to override the
default behavior if desired.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/hwtable.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index ce600030..51b15eab 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -1160,7 +1160,6 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = NO_PATH_RETRY_FAIL,
 		.minio         = 1,
 		.minio_rq      = 1,
-		.flush_on_last_del = FLUSH_ALWAYS,
 		.fast_io_fail  = 15,
 	},
 	/*
-- 
2.43.0


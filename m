Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A492155A5B
	for <dm-devel@lists.linux.dev>; Thu, 25 Apr 2024 23:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714088123; cv=none; b=pr8m4+52hoj1fcJCus8u9d9Cp7FJ5NyqBKMn+BovB6o/mxfBJzKwe6FV4W5sAX1xZdA70w144xycydPVVlZk2YMisN/SggyRjZhkvMEJKrncYBsFPuzEXzC4qh5w4SrAwUF99kmB0iFqHbLWD9nSJx3vh0i/EVurlQb/sW+3m/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714088123; c=relaxed/simple;
	bh=aWfZtY0qBF2iVUOrFIuiK/ahMmitku/p4nz4bWTD9Pw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p73IJctEVvw3ytRVu7TSe1mRHnjTBo360H12HpEGPH+Qhi2Gwnq2dwQ4029UrC1ky21QR1cKTzcBCgiAuhgJOuQSLmQPO68tlq8wS+MIy5t6mHl5BVla48kgTYSiSEdc/U0MdVMaRpMEz9d18/EL+dZ50AyAt/enGK0GZePzvJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Z50g821G; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z50g821G"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714088121;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eAQWk3E3FgkdmNJlFuTiYxSgg2GRX1PCab20XJy7JmU=;
	b=Z50g821GS5vH2ptOXA+x+yHtmZhx7BI4Mae5yx0pCtWhSM1NY+oDDGea/0C+0Z4qubwhRj
	mr4xLz0L1kKM2OUULHEEmiSNeCOGJJvIOQ1bDQXqMqNPB2MSlbl3S9Kp2Y6GgASN112d/h
	CZPHQKFZK7XIU+oIEtpeqrhDJA0EqQY=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-682-_5oDzWjrM2yauCc5FIPv0w-1; Thu,
 25 Apr 2024 19:35:18 -0400
X-MC-Unique: _5oDzWjrM2yauCc5FIPv0w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1178A29AA3AC;
	Thu, 25 Apr 2024 23:35:18 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0B87DAC6C;
	Thu, 25 Apr 2024 23:35:18 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 43PNZHox2125160
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 25 Apr 2024 19:35:17 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 43PNZHe12125159;
	Thu, 25 Apr 2024 19:35:17 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2 1/5] libmultipath: export partmap_in_use
Date: Thu, 25 Apr 2024 19:35:13 -0400
Message-ID: <20240425233517.2125142-2-bmarzins@redhat.com>
In-Reply-To: <20240425233517.2125142-1-bmarzins@redhat.com>
References: <20240425233517.2125142-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

A future commit will make use of this function

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/devmapper.c          | 2 +-
 libmultipath/devmapper.h          | 1 +
 libmultipath/libmultipath.version | 1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 4ce7e82f..a87abf7e 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -1043,7 +1043,7 @@ has_partmap(const char *name __attribute__((unused)),
 	return 1;
 }
 
-static int
+int
 partmap_in_use(const char *name, void *data)
 {
 	int part_count, *ret_count = (int *)data;
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index a7d66604..93caa2aa 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -57,6 +57,7 @@ enum {
 	DM_FLUSH_BUSY,
 };
 
+int partmap_in_use(const char *name, void *data);
 int _dm_flush_map (const char *, int, int, int, int);
 int dm_flush_map_nopaths(const char * mapname, int deferred_remove);
 #define dm_flush_map(mapname) _dm_flush_map(mapname, 1, 0, 0, 0)
diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index 724786d5..e070f296 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -141,6 +141,7 @@ global:
 	need_io_err_check;
 	orphan_path;
 	parse_prkey_flags;
+	partmap_in_use;
 	pathcount;
 	path_discovery;
 	path_get_tpgs;
-- 
2.43.0


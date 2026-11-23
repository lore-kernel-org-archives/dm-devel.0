Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795467243;
	b=HBW/G/mRugdRGf3Fbomx5Nvd26HDldLwyb85mB3cveFhrheXNXPkpL8zpSubfW4t2qgE
	 4cVUlJZqiBODH/Dsl/j9/52JLxfp/P574O6Rx2j9FQ+DWugGXIofBr9oYHs2QfR8VYcZL
	 J4ESIi6dmyez2kF7AyA+mgtax0XcIL7ofu8cieSjLWp4XILAIjdIekr8TMetRtkBwubzV
	 sPneSOA2pFAVTpFKkY58zWHryusOCd5m1zIkHUzRHneVIW6tc6Pj8DkD9VhOdaQ+mg0Da
	 mJeXRxBTeDWlkMLPo1Fm1lsrES6CdJ4lgpPF1DqXzSF1AsCZEe0Q9ZWb+aUbr8FVdew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795467243;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Date:From:To:Subject:
	 Message-ID:MIME-Version:X-Scanned-By:X-Mimecast-Spam-Score:
	 X-Mimecast-MFC-PROC-ID:X-Mimecast-Originator:Content-Type;
	bh=GhA40jSqAzYnZOzmB5zRSHYFym9cdt7vilib5MV6saU=;
	b=oUOYEXhhLLUSry4mggAc7M+hCftCy2KAGAtHJEXHvZ6jEqrwMziId0s46cCT9WND0hUD
	 JgWLd0GW8Rabb+Q8pC90guWCrh4kXRmohW7rOyaxeTq+IM/ApJXx39hBRazZDNPmEX03P
	 SsCTLimyjJ5OjhCSos9KmgkuiospOy6kn4wQbfzqE/PG8JDRlsQ3MdqymtdfwjITx+s9O
	 vlsX6fn0QgiwY6UOB1kv7fGtrTNOZUkLw+FeM4MVlqJcOt9IK1Wm1GD/bpPN6PjwG6kmp
	 Mtx6vgdS3n5w9xgavhTyOiYq+SPXG4D6kkyu7VLFfS+z44FbimxU74AfCCW1gwVZnKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=cBmJOAJd;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4502F606A31E
	for <dm-devel@lists.linux.dev>; Mon, 23 Nov 2026 20:54:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4502F606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=cBmJOAJd
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795467242;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type;
	bh=GhA40jSqAzYnZOzmB5zRSHYFym9cdt7vilib5MV6saU=;
	b=cBmJOAJduswLfRM7AAwNOiHRoRoCGrZaWWQgjZ6yPg4LaOAsgsDDbsp0lOgYiFINGu00jA
	NlFynM3Eq4ZQHF9+KuAFK/hx0r3ly3BXrPK8S2lq1D1XisPEhgI0DxU1t7k7cQj5nU5+Kf
	rClrFEbpDA0qHlCvwHxJU5cSOzrumqc=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-556-eK-_mOLLMtiWuPVHryGd6Q-1; Mon,
 23 Nov 2026 20:53:58 +0000
X-MC-Unique: eK-_mOLLMtiWuPVHryGd6Q-1
X-Mimecast-MFC-AGG-ID: eK-_mOLLMtiWuPVHryGd6Q_1795467237
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 46C1D1956051;
	Mon, 23 Nov 2026 20:53:57 +0000 (UTC)
Received: from mpatocka-thinkpadx1carbongen12.rmtcz.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 82AC01800551;
	Mon, 23 Nov 2026 20:53:55 +0000 (UTC)
Date: Mon, 23 Nov 2026 21:53:52 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>, 
    Ming-Hung Tsai <mtsai@redhat.com>, dm-devel@lists.linux.dev
Subject: [PATCH] dm-cache: delete unused dm_cache_metadata_set_read_write
Message-ID: <80363388-6be5-c75c-652c-8b99096c5cd1@redhat.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: R_geXtRslsmfByzQea8nqofXe0P9fk1hmS83st21BTg_1795467237
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

dm_cache_metadata_set_read_write can't change the state from read-only to
read-write - the macro WRITE_LOCK_VOID returns if the device is
read-only, thus dm_bm_set_read_write is not executed.

Luckily, this doesn't cause any user-visible bug because the change from
read-only to read-write is never requested. So, we can just delete the
non-working code.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-5

---
 drivers/md/dm-cache-metadata.c |    7 -------
 drivers/md/dm-cache-metadata.h |    1 -
 drivers/md/dm-cache-target.c   |    1 -
 3 files changed, 9 deletions(-)

Index: linux-2.6/drivers/md/dm-cache-metadata.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-cache-metadata.c
+++ linux-2.6/drivers/md/dm-cache-metadata.c
@@ -1729,13 +1729,6 @@ void dm_cache_metadata_set_read_only(str
 	WRITE_UNLOCK(cmd);
 }
 
-void dm_cache_metadata_set_read_write(struct dm_cache_metadata *cmd)
-{
-	WRITE_LOCK_VOID(cmd);
-	dm_bm_set_read_write(cmd->bm);
-	WRITE_UNLOCK(cmd);
-}
-
 int dm_cache_metadata_set_needs_check(struct dm_cache_metadata *cmd)
 {
 	int r;
Index: linux-2.6/drivers/md/dm-cache-metadata.h
===================================================================
--- linux-2.6.orig/drivers/md/dm-cache-metadata.h
+++ linux-2.6/drivers/md/dm-cache-metadata.h
@@ -138,7 +138,6 @@ int dm_cache_write_hints(struct dm_cache
 int dm_cache_metadata_needs_check(struct dm_cache_metadata *cmd, bool *result);
 int dm_cache_metadata_set_needs_check(struct dm_cache_metadata *cmd);
 void dm_cache_metadata_set_read_only(struct dm_cache_metadata *cmd);
-void dm_cache_metadata_set_read_write(struct dm_cache_metadata *cmd);
 int dm_cache_metadata_abort(struct dm_cache_metadata *cmd);
 
 /*
Index: linux-2.6/drivers/md/dm-cache-target.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-cache-target.c
+++ linux-2.6/drivers/md/dm-cache-target.c
@@ -904,7 +904,6 @@ static void set_cache_mode(struct cache
 		break;
 
 	case CM_WRITE:
-		dm_cache_metadata_set_read_write(cache->cmd);
 		break;
 	}
 


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793990333;
	b=djb5f0df2bUWwBUMPVZl/wWj7Nh6nwX+Nv6BQfJqKc1nIcyYzOR7uK5fa5kJHc1TRC3l
	 Gi9IH91x6Wd+JW1OQwEzUOsX4OsmY+zsz4HmWkxczURv7cZ6v5kb7hdwIXC9rbBrEGgCC
	 g7bn480OtHTBJqgzGltNR1EbwbZ0dqIBmnbsp/W3wt6GSPbLBBMyeuoD6ZHuNFezopAlE
	 CEyzvjRI2bo/6hhFQ94MTKf4stuumT4uANbA2DfMMHC5cJa5LKgRsa/elKMRRdDU+AZ+W
	 5pWh2KUjHrxoqppJra1DztYcAgLcUah1IVua8v1bQyo4BZ9c4B3ScQ6Ea9Ps9Nm1KPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793990333;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Date:From:To:cc:Subject:
	 Message-ID:MIME-Version:X-Scanned-By:X-Mimecast-Spam-Score:
	 X-Mimecast-MFC-PROC-ID:X-Mimecast-Originator:Content-Type;
	bh=7Cc0SATlrSpSgki60LaiV8sWuxj1u5EmvRfMJrj2vdw=;
	b=EpyT7HDNrvbXIKpR4oh4Foh8P1LwHndJJcDsRvmaVAZBVGeMTK0UiTiHyzCO/M7SJLbE
	 ymikXpLF7VKEy/KbiqcARrCD8vE1RLBH89K/Ff7afle34TDFIbvrEBMjCnIe3MQih4Sme
	 V6lp/Qkdn/Qf3GaSEcUYSuKDNUlBhFA/rGahACFvATvhUarFdbKaH2lyU1AArsjT+WRaT
	 a9r7UaACgcUMBkR/GEq1TdNYPERFKxcgKLOP4z6MHZ1WRuon73GiFtK/MgWNkLOiDLBgb
	 /0Taj5ZDeMU3XWbgLhWVdDIl105Rh7FHPfnhOOZWIGSDf4HcL308+qRr38YqAjrLAcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=DUc6wrZf;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFE73606A329
	for <dm-devel@lists.linux.dev>; Fri,  6 Nov 2026 18:38:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DFE73606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=DUc6wrZf
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793990331;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=7Cc0SATlrSpSgki60LaiV8sWuxj1u5EmvRfMJrj2vdw=;
	b=DUc6wrZfB/SqFc738Djo0TpYPvGNazpzxfXYJkEQl0rlDbohuqu/eIkqVV2I0pTjSnCMmM
	fHwR+pPpU+a0l7FKqozpijAKPWgbL4dj6vhLnq+duJHTgxT0UcfkPOtklqp+eCtvvnwK9w
	EWkByLyD+U9r8AW7BYNnfQTUpCZ0NgA=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-358-JQtbgt8OMKaSQpwcVYE_xQ-1; Fri,
 06 Nov 2026 13:38:50 -0500
X-MC-Unique: JQtbgt8OMKaSQpwcVYE_xQ-1
X-Mimecast-MFC-AGG-ID: JQtbgt8OMKaSQpwcVYE_xQ_1793990329
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6708B1955DD7;
	Fri,  6 Nov 2026 18:38:49 +0000 (UTC)
Received: from mpatocka-thinkpadx1carbongen12.rmtcz.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0E07418004F7;
	Fri,  6 Nov 2026 18:38:47 +0000 (UTC)
Date: Fri, 6 Nov 2026 19:38:45 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>
cc: dm-devel@lists.linux.dev
Subject: [PATCH] dm-cache: fix NULL pointer dereference on open failure
Message-ID: <05b79ec2-42f7-ffe3-20e6-1dc499e60cf5@redhat.com>
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
X-Mimecast-MFC-PROC-ID: K9O3Ulu2uIvDB1UlQ0w_9N0W-hrx2mfrOQ_9blD1w84_1793990329
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

When __begin_transaction_flags in metadata_open fails,
dm_cache_metadata_close is called. dm_cache_metadata_close attempts to
execute list_del(&cmd->list);, but the "cmd" object is not on any list
yet, thus it crashes with NULL pointer dereference.

Fix this by initializing cmd->list after cmd is allocated.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-5
Cc: stable@vger.kernel.org
Fixes: c6b4fcbad044 ("dm: add cache target")

---
 drivers/md/dm-cache-metadata.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6/drivers/md/dm-cache-metadata.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-cache-metadata.c
+++ linux-2.6/drivers/md/dm-cache-metadata.c
@@ -766,6 +766,7 @@ static struct dm_cache_metadata *metadat
 		return ERR_PTR(-ENOMEM);
 	}
 
+	INIT_LIST_HEAD(&cmd->list);
 	cmd->version = metadata_version;
 	refcount_set(&cmd->ref_count, 1);
 	init_rwsem(&cmd->root_lock);


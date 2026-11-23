Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795411963;
	b=ETFw3l1cCyJLy4w90gP6eq4LTV1Pq1TeeAKTI8De/fdAWiiF21PMDblr7Hcn5Sn1nt0l
	 3VoBCerDpJPIMUKuvOnnbO6Cb0rdJh030Mx8ae5tysn6/Y0JTsx/mwlvLj4HXxg/ECKom
	 i14ydrAaU8zeYPk1wS9pgpEHjNS6p9XpML5udm4iFsxCehJYUvd4t+XdpY3TpH3kF/LvY
	 WtrI4dqwl9GnK0Yb9C4gxS324qybFaG72s4sOI0eQYqKoiBEOLUTOf/2ZZSJqB7m0CmeI
	 238uHhYAE38rcCYsEA7r/rQ6hTTxTtitIEUUvOulCAphITJzfd+8G93RVVbzMQRvq5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795411963;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:MIME-Version:X-Scanned-By:
	 X-Mimecast-Spam-Score:X-Mimecast-MFC-PROC-ID:X-Mimecast-Originator:
	 Content-Transfer-Encoding:content-type;
	bh=gfHJ15M5OUnkR+jtqwUB1FHE1e6eIeq84EO2ZHy7U2s=;
	b=N+cIzJ2Lw3OFMqr1yG09GZT6omFOjkM56CBqYgjRvuJ0K5E45RQsrNZNZeRbOcywyoJv
	 Zp0jgDAOjyyB/WGQ6DK0X2xLegcOd0qgUst41b2N0m/YN2e2fN8m1LhMItW+x6t+QmsP+
	 h7CIxE9MtSUA+68i8ZS4km1iw7a7zSLtKBYMy20QUpUFfUsdWv/mfWxpAy49Ctfte54nN
	 AQwk9kiSR87Cb7FkUVSrEaM65HsAxI1w3jsW2gH7a25mMQRwN567ClisAQttjSfxJyANZ
	 upqBATjvnE4XEBjK/24E+F6SJZQGWebnVUeHcJY2qHtfhnEha/vCoDL4mMBrmo75JMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b="HX/KcYKf";
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54130606A31A
	for <dm-devel@lists.linux.dev>; Mon, 23 Nov 2026 05:32:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 54130606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=HX/KcYKf
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795411962;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=gfHJ15M5OUnkR+jtqwUB1FHE1e6eIeq84EO2ZHy7U2s=;
	b=HX/KcYKfGajK6IUhdgwyhvHLSpT5ZFkOQSzzTTvJXPlBHNcGUwhGHSKbEbGIoFkD+9r3/T
	vQijzpmCLwgcH7nVL3CUorRlSr7yWT6OiyywLHUgCimmQOlzAZZSo6NvJ08frlnWVyMrUF
	yowqc67Vfi9sSaWk03UF2h3fzznrFXs=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-208-WZvcPmyCN4S-S1R0W_pXIw-1; Mon,
 23 Nov 2026 05:32:39 +0000
X-MC-Unique: WZvcPmyCN4S-S1R0W_pXIw-1
X-Mimecast-MFC-AGG-ID: WZvcPmyCN4S-S1R0W_pXIw_1795411958
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 776D11800550;
	Mon, 23 Nov 2026 05:32:38 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 271D0180054C;
	Mon, 23 Nov 2026 05:32:37 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 6AN5WaUv3060777
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 23 Nov 2026 00:32:36 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 6AN5WZEG3060762;
	Mon, 23 Nov 2026 00:32:35 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev
Subject: [PATCH] dm: set max_hw_discard_sector hints from max_discard_sectors
Date: Mon, 23 Nov 2026 00:32:35 -0500
Message-ID: <20261123053235.3060754-1-bmarzins@redhat.com>
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
X-Mimecast-MFC-PROC-ID: HhRzjW19PTOX7UHEiEskYU6MSZ8mIJ9iRrOg82fT6ig_1795411958
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

The dm-cache and dm-clone target's io_hints currently set
max_hw_discard_sector based on the origin/destination device's
max_hw_discard_sector value. This can allow them to send discard
requests larger than those underlying device's max_discard_sector value,
forcing the underlying device to split the discard again.

blk_validate_limits() sets a device's max_discard_sectors from the
minimum of its max_hw_discard_sectors and max_user_discard_sectors. If a
user sets the max_user_discard_sector to a smaller value on the
uderlying device, the current set_discard_limits() code in both dm-cache
and dm-clone will ignore that lower limit for setting the device's
max_hw_discard_sectors. Stacked devices to not inherit the
max_user_discard_sectors of their underlying devices, and DM always sets
max_user_discard_sectors to UNIT_MAX in dm_set_stacking_limits(), so
max_discard_sectors starts out equal to max_hw_discard_sectors. The
disable_passdown_if_not_supported() functions in these targets already
correctly use the underlying device's max_discard_sectors value for
checking their discard support.

Fix this by setting max_hw_discard_sector based on the underlying
device's max_discard_sectors value. This limits to cache and clone
discard sectors to the actual limits of the underlying devices.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---

This patch is related to
https://lore.kernel.org/all/20261122215641.2865290-1-bmarzins@redhat.com/
which sets max_hw_discard_sectors to the underlying device's
max_discard_sectors during regular device stacking. But this patch
is independent of it and can go in without it.

 drivers/md/dm-cache-target.c | 2 +-
 drivers/md/dm-clone-target.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 850c4b651f09..969d60cf653e 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -3534,7 +3534,7 @@ static void set_discard_limits(struct cache *cache, struct queue_limits *limits)
 	 * cache_iterate_devices() is stacking both origin and fast device limits
 	 * but discards aren't passed to fast device, so inherit origin's limits.
 	 */
-	limits->max_hw_discard_sectors = origin_limits->max_hw_discard_sectors;
+	limits->max_hw_discard_sectors = origin_limits->max_discard_sectors;
 	limits->discard_granularity = origin_limits->discard_granularity;
 	limits->discard_alignment = origin_limits->discard_alignment;
 }
diff --git a/drivers/md/dm-clone-target.c b/drivers/md/dm-clone-target.c
index bc4a5ce4c81a..d634d9111580 100644
--- a/drivers/md/dm-clone-target.c
+++ b/drivers/md/dm-clone-target.c
@@ -2041,7 +2041,7 @@ static void set_discard_limits(struct clone *clone, struct queue_limits *limits)
 	 * device limits but discards aren't passed to the source device, so
 	 * inherit destination's limits.
 	 */
-	limits->max_hw_discard_sectors = dest_limits->max_hw_discard_sectors;
+	limits->max_hw_discard_sectors = dest_limits->max_discard_sectors;
 	limits->discard_granularity = dest_limits->discard_granularity;
 	limits->discard_alignment = dest_limits->discard_alignment;
 	limits->max_discard_segments = dest_limits->max_discard_segments;
-- 
2.56.0


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795467301;
	b=NNdt8gdVVCqATlzKw35xfr0XPVyUZogn4kYXhPEjqsr8t6pCW6adbE6IRqvNj014Z6zH
	 SMoYPM7yI5cF4Q7yH6q++GRh7SWNGKp+/ZFZgMCfVAmHz3aF8bLf0eeMFrg5US2/1TWAj
	 LkvJHO/Vx74Y0VXdESuW/QVqf+2dCyD8E5jSZ98Ragd+pk86y8uA0tcH5UC90Fk6wYu+0
	 eeWvnktDnvwmCJL0CEb8hSm3uPBl6g9CF7VtNA0OYrlWczxERwK7qcqVekOodSBp3msF0
	 haghzfEKb3a78YYChztBnREQLuHY7gRS0Wa9SE7qi6cm+1gCH0Njfi8tlGJvxMwcplQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795467301;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Date:From:To:Subject:
	 Message-ID:MIME-Version:X-Scanned-By:X-Mimecast-Spam-Score:
	 X-Mimecast-MFC-PROC-ID:X-Mimecast-Originator:Content-Type;
	bh=Nn/G83WHKKdGIER/uUHBV3x3IzO17RCMHto8Kpug92w=;
	b=QE8MvFTOEkIugr6HdEn+l9JOTaepwURXhE0+HS2IHRR7HJYmN4ZVj/w8ihbLLIMCN6WW
	 g4suYp6Cd2qNewRdn2fiovRqbotHdqIj2tDUfpa1kC+/ZIaslWG9UwO/QuTlkpLvQHfxY
	 dK3Zsvg8606qwoPAspA3Iz0CyGA+c6NUN7G3h1e3bynnh8hFufeMrtg2yafPh8BfCAfHM
	 DxiTsWtihHKEnAeqy97+0ov8oc/mWJuRm06fviMvQgBh46gh0yWyX+PAdsKfbufATceH6
	 yvWYF0vOtkMccaqwfYNbte7nmMbQ2ZaAdZW9sSMUPiym/c2TM9n3XBgpnmNAL9tTubg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ZHEB938J;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3301606A331
	for <dm-devel@lists.linux.dev>; Mon, 23 Nov 2026 20:55:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A3301606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ZHEB938J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795467299;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type;
	bh=Nn/G83WHKKdGIER/uUHBV3x3IzO17RCMHto8Kpug92w=;
	b=ZHEB938JnVNHsM4Ok9QhFcBhW4EUb6ol5TGL97mI8p09g1EsBFLMNQtN/dtMKuhVXB+NEM
	w57+cUn5hunKjymBUYzLuW9ubHFsdwA4eOcdofaQ683yYg1unUStznpd5MwzQzvEx4er02
	7je9D5tuFMdZhyB5sMr+L0Rin+Ey9Mk=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-466-tWb-GRVqNgyFPRDem3UenQ-1; Mon,
 23 Nov 2026 20:54:54 +0000
X-MC-Unique: tWb-GRVqNgyFPRDem3UenQ-1
X-Mimecast-MFC-AGG-ID: tWb-GRVqNgyFPRDem3UenQ_1795467293
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8567218028A2;
	Mon, 23 Nov 2026 20:54:53 +0000 (UTC)
Received: from mpatocka-thinkpadx1carbongen12.rmtcz.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DD0773001DB1;
	Mon, 23 Nov 2026 20:54:51 +0000 (UTC)
Date: Mon, 23 Nov 2026 21:54:49 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>, 
    Ming-Hung Tsai <mtsai@redhat.com>, dm-devel@lists.linux.dev
Subject: [PATCH] dm persistent data: fix invalid calls to vt->inc and
 vt->dec
Message-ID: <9f8ed9a9-fb35-7a4d-4877-430268010b43@redhat.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: HNwHL5dUjk88COI1V6jAhd1V0nzRKzhKThk5RsHpaaU_1795467293
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

The dm-array library called vt->inc and vt->dec with invalid arguments.
None of the users of the library actually use the callbacks, so the bug
was latent.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-5

---
 drivers/md/persistent-data/dm-array.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

Index: linux-2.6/drivers/md/persistent-data/dm-array.c
===================================================================
--- linux-2.6.orig/drivers/md/persistent-data/dm-array.c
+++ linux-2.6/drivers/md/persistent-data/dm-array.c
@@ -196,18 +196,18 @@ static int alloc_ablock(struct dm_array_
 static void fill_ablock(struct dm_array_info *info, struct array_block *ab,
 			const void *value, unsigned int new_nr)
 {
-	uint32_t nr_entries, delta, i;
+	uint32_t nr_entries, i;
 	struct dm_btree_value_type *vt = &info->value_type;
 
 	BUG_ON(new_nr > le32_to_cpu(ab->max_entries));
 	BUG_ON(new_nr < le32_to_cpu(ab->nr_entries));
 
 	nr_entries = le32_to_cpu(ab->nr_entries);
-	delta = new_nr - nr_entries;
-	if (vt->inc)
-		vt->inc(vt->context, value, delta);
-	for (i = nr_entries; i < new_nr; i++)
+	for (i = nr_entries; i < new_nr; i++) {
+		if (vt->inc)
+			vt->inc(vt->context, value, 1);
 		memcpy(element_at(info, ab, i), value, vt->size);
+	}
 	ab->nr_entries = cpu_to_le32(new_nr);
 }
 
@@ -228,7 +228,7 @@ static void trim_ablock(struct dm_array_
 	nr_entries = le32_to_cpu(ab->nr_entries);
 	delta = nr_entries - new_nr;
 	if (vt->dec)
-		vt->dec(vt->context, element_at(info, ab, new_nr - 1), delta);
+		vt->dec(vt->context, element_at(info, ab, new_nr), delta);
 	ab->nr_entries = cpu_to_le32(new_nr);
 }
 


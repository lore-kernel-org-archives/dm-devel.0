Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794999765;
	b=1lJ7HgyLqS6KE6AjGdHPUSrnj8ZNJsY+vmc0FsSlhZ0AhvU2QTsN8LZY9qnGtDh7oJl5
	 9+JZP+s1KIG3Q309MsX46qffhuwYhvMrXRb1hFB26JFIqI3u2SSxaFUYN1pBsD87dHYQS
	 bUtXIn1yQ8JB1RzHuJKTyo43PanLK75Aphk5kbMrRWSEDEljqa8viPZaWqHg0NvXFEDlW
	 ocTBFK+hYf9MY9vE3x0X18RomyJKVgGfQZ/7B7H+C9G57AMUenkOZ6XSbvtgJsd5idT0E
	 sBmtDSs1wyEiDSR8GYeV4foulw5STGUjMC1f4j1LJ4FKFpXNXGnThzowTg5iD5NZjjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794999765;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XGgLe6XaIIl8o25hJ+WttFhbBRlV7LsocbjP/nKKIhU=;
	b=dKFvBDIYqoNJkO5G3O1nE7kOUJ0VBWWiCIXObzn4/LVkZ2bLFkSBWl4p1W7prKubZsw+
	 Sp/E4YRPvwTTppG7MouXcnU3lKEwah2fSQ9+D+6OuxjNDecn3csS8Q45Sdi+Xsed3TJMr
	 oShqCmusYeO8NB9yodaNRa2HjxonEJR0fBVSaDdoYssCt28cz1bVEJdovNDjg5dUz3K4e
	 WkNOLRwomukPuIdETeGwUAdafwRG10dbDvL6FmGxE2OZGTWihRQq4z17mduOtI+xgFqT5
	 sXe4PVO9i1aRv7cMty9v8XvtCOHMW7o+8YDGb0Yr/mWdjEGD+uUqgGojfXFXyZtSqJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=openvz.org;
	spf=pass smtp.mailfrom=openvz.org;
	dkim=pass header.d=openvz.org header.i=@openvz.org header.a=rsa-sha256 header.s=google header.b=UReBZktC;
	arc=none smtp.remote-ip=209.85.221.45
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87F2F60A2603
	for <dm-devel@lists.linux.dev>; Wed, 18 Nov 2026 11:02:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 87F2F60A2603
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=openvz.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=openvz.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=openvz.org header.i=@openvz.org header.a=rsa-sha256 header.s=google header.b=UReBZktC
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-48e20ed3b9dso652295f8f.2
        for <dm-devel@lists.linux.dev>; Wed, 18 Nov 2026 03:02:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz.org; s=google; t=1794999764; x=1795604564; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XGgLe6XaIIl8o25hJ+WttFhbBRlV7LsocbjP/nKKIhU=;
        b=UReBZktCxH1Ie1ZV0QMT3bFsqb5aJaM2gVujblVhD+ELcE+vNAWokk0ccKnTwgLBYf
         alIP0CuDM1FnTkwokHgxF02XCwcv6AvQQwFd76V1auESMModXRCN7POnqPv6peJ5aQIf
         mWBjjn0dRVuECuPU/ErOy2e+23Edz4loS1pLYsjlsNpj2pnfPgycJwgW5lIx5MFc1DeC
         xmCC+LVC3Iy8cN2wf1X7mjCV0KX76sFQQ1ZmDDTENxY1umV0Wpq1ZU47vzmP/1DnpKTe
         3ldpLIwTQUhejhS0gRw0ndnqy0OBO37YyP6FV2x6/UVtVyJ1HNwBFdqFGj1hAZ5OyAVf
         aXOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794999764; x=1795604564;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=XGgLe6XaIIl8o25hJ+WttFhbBRlV7LsocbjP/nKKIhU=;
        b=EtLAS1/09j0BR9xulo2zAM+dBI1eRyWYIP8P0XJtxozDqVH/rEUJCUF8rsfaJ86Oij
         hAeU7iE2yHhzRT4zFZsCKOof3c5hqcXV3ZqtHqpeG8iXEwH6dIu2er9T+3fiIdklgB64
         +zAmHhg7h2ylvdsNH7r46QCpg1UiuvXGGKm/e4LyeZ4mdzqX8R7xdg9XXCCg3OG+AA7H
         1WlFM1NkWEIZjYg9gaI06WuwJbLHB6fPoxLq/E35TvWYisfybwY8RLxgzQXpVJWiqZEQ
         LW15LtXEYlrE1EhEUsNXZmp6Jc9taMM0C53vQ4S5tcMDkdVv7l3Xcx3Q/QkzZPdUMx0K
         KhfA==
X-Forwarded-Encrypted: i=1; AL+hErHQThfCeke08ccTpj6IulpCDQxpCnqHejzby5IGAY9g3hbcQZMJIIed9hRGJeOFLtmEChEwLzwfow==@lists.linux.dev
X-Gm-Message-State: APuU4Z+JYjtIArjTbOjGH5p2+pEF0PJciCVG+yHZWm04TnriQQZpnVHh
	X6bZxW/unpU0f3ZcSH7TNVrH0VO6/Knyu33fV4t+1zJpIBjjZwbxBKk3rWnig1MsixE=
X-Gm-Gg: AYBFou0WUh0mlD7BSv5TFxZqfPWc5N7hyPLMurBLcXjaer40G+MaDWffbEelGFKzHD+
	fH0PMsjiQUNASYWe6g1Sen8Q6shpRoDjwB0ulpcKjZq/FcsDmRAvUyfi6Az5SsGjSsOVEQErSNb
	FwWjP9kP9JwHCoKwyvaoREFgw/WYIdR51/vDubjOy1Yz7WThgVPpWzxEBlayW0y4c1BEX61loKS
	7gVKPbmknlx7uhVqeS+kNcHkSm0KrrfAsBuA3YW6aIaWcOQ51t9vfiLrs1J1eqDKf3Edebmu4E6
	cHy4uzKttzoRumW9LfeGPn0BA6QxuZyHaIIONqjedLnXs5WcLvpYdmCkluxk3QMgKrpXjlmcGqy
	3gmnPGkoiJQDsV5ns3rbtkWSVZ4JpCOxUAVh1NHPO4hZT5vsoaAtD6LHauf7dSK5ZzbbIxaF7Gl
	1jVC4c6NiWMnBdG9Yc/uMHhREhK9WoUzEoUtSYgH4FttQscA+MXbT7ve53ZunDFSvS3wtck+yyz
	PBDIE8Cm9Yl7SY9ldTwINRFBz/En3gtBd8/RU8B6FGSMH9Ne69pL5kdpQjDUirZ5RjVy3A9qlAs
	Q6nlTc00MGB52x1UlaOB7+sduPbHdQjgmBWPBPqD1GnIIAbq
X-Received: by 2002:a05:600c:a54:b0:4a7:6bc7:f778 with SMTP id 5b1f17b1804b1-4bb7da4616dmr42094465e9.30.1794999763742;
        Wed, 18 Nov 2026 03:02:43 -0800 (PST)
Received: from artemis.sw.ru ([2a06:5b06:b600:300:8c09:3cc3:6efa:ac1f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4a656c1145esm3943277f8f.52.2026.11.18.03.02.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 03:02:43 -0800 (PST)
From: "Denis V. Lunev" <den@openvz.org>
To: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	dm-devel@lists.linux.dev
Cc: bmarzins@redhat.com,
	thornber@redhat.com,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	den@openvz.org
Subject: [PATCH 1/3] dm persistent data: drop the original block only once it is copied
Date: Wed, 18 Nov 2026 12:02:37 +0100
Message-ID: <20261118110239.2910290-2-den@openvz.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261118110239.2910290-1-den@openvz.org>
References: <20261118110239.2910290-1-den@openvz.org>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Denis V. Lunev <den@openvz.org>

__shadow_block() releases the original block's reference before it
reads the block, so every error return in between leaves the caller
pointing at a block the space map has given away.

metadata_ll_commit() shows what that costs. It stores the new block in
ll->bitmap_root only when the shadow succeeds, so a failed read leaves
the space map's index root at a block whose count has already reached
zero. Every commit after that shadows the same block, fails to
decrement it, and fails:

  device-mapper: space map common: unable to decrement block
  device-mapper: era: metadata_commit: pre commit failed

The metadata never recovers. dm-era reports "era Error" and fails the
writes it was tracking, which takes the workload's filesystem
read-only.

A btree caller ends up in a different state. dm_btree_insert()
publishes the new root only on success, so the caller keeps a root
whose count has dropped to zero, and the next dm_tm_shadow_block() of
it finds dm_sm_count_is_more_than_one() false and writes the block in
place instead of copying it.

Decrement the original once the copy holds its contents. A read of a
metadata block can fail for a transient reason, and a single failure is
enough to get here.

Fixes: 3241b1d3e0aa ("dm: add persistent data library")
Cc: stable@vger.kernel.org
Signed-off-by: Denis V. Lunev <den@openvz.org>
---
 drivers/md/persistent-data/dm-transaction-manager.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/md/persistent-data/dm-transaction-manager.c b/drivers/md/persistent-data/dm-transaction-manager.c
index 7401add01d12..159aac9da07a 100644
--- a/drivers/md/persistent-data/dm-transaction-manager.c
+++ b/drivers/md/persistent-data/dm-transaction-manager.c
@@ -297,10 +297,6 @@ static int __shadow_block(struct dm_transaction_manager *tm, dm_block_t orig,
 	if (r < 0)
 		return r;
 
-	r = dm_sm_dec_block(tm->sm, orig);
-	if (r < 0)
-		return r;
-
 	r = dm_bm_read_lock(tm->bm, orig, v, &orig_block);
 	if (r < 0)
 		return r;
@@ -322,7 +318,14 @@ static int __shadow_block(struct dm_transaction_manager *tm, dm_block_t orig,
 	       dm_bm_block_size(tm->bm));
 
 	dm_bm_unlock(orig_block);
-	return r;
+
+	r = dm_sm_dec_block(tm->sm, orig);
+	if (r < 0) {
+		dm_bm_unlock(*result);
+		return r;
+	}
+
+	return 0;
 }
 
 int dm_tm_shadow_block(struct dm_transaction_manager *tm, dm_block_t orig,
-- 
2.55.0


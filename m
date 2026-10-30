Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793352108;
	b=FDJAhj/WlCTSzLOMEQGNfNQmKTDfX+rdVsr9yRml71H2ottIXZZksX+4GdqPdflCbqoZ
	 Y1YVTkaF8DJKN+bLHAQi63rStr7QKbakb2P1Isalsq0pX6m8MlIIiyFUS4xsgGVb7dg4/
	 cIe+z8Nb4iPqJOu6MWBcCS1frMRQ//JDwIVAnjlIEs0rN4NeggNW0W/z3QefleHByOpNH
	 MWAwjO9MDpnQGHASR/qZTRwNbh0HZK/IFKDp1JTJPj/VsK/277viSRv9neuIz5JtCi+2u
	 MLzCsevEv60pmNTrZ6FZGe5BR6NN1wKukqX1grUp3xdDddHK3I2vIb1HbnmV6Cfh4Jw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793352108;
	h=DMARC-Filter:DKIM-Signature:Date:X-Mailer:References:Received:To:
	 Subject:Mime-Version:X-Original-From:X-Lms-Return-Path:
	 Content-Transfer-Encoding:Cc:From:Message-Id:In-Reply-To:
	 Content-Type;
	bh=lDH6CZonHxdY1g1ae5yoOdLp2lZlZBIVpWVUaxg2sgg=;
	b=htlFnEqWh/Gvj3V1PVeIR556sMLqkikXJgCUN6TrWRC4mF+frblidkWjFPHI2r1P8oao
	 i/lDvFHMtz7xB03Q88o6EJJfv3kI6BB/ELLwAfMYJJti6OlqjIJ8874LKimBofJS6SaFL
	 a0NvrnAd8AxIO0+/tM7JomjyhjIaCZHpw4RmCuqfMOmPhA2GWg2/BtPo3lNIBYMeH8cGN
	 88DToOmaCbVNVYSOKErDjKxIGbmjj7M9XFiOAjfIhUz+j7H1KYaeza472uAGUx7ceTF6H
	 g1OE7HZrdQ1AwvGzv1oHgPHLW8a53RjqyR65Sr5VDzsfx2d47wDpoiuMEFA05LPwQlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=fnnas.com;
	spf=pass smtp.mailfrom=fnnas.com;
	dkim=pass header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.a=rsa-sha256 header.s=s1 header.b=iO0+mLF7;
	arc=none smtp.remote-ip=209.127.231.53
Received: from va-2-53.ptr.blmpb.com (va-2-53.ptr.blmpb.com [209.127.231.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8AA1606A31D
	for <dm-devel@lists.linux.dev>; Fri, 30 Oct 2026 09:21:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B8AA1606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.a=rsa-sha256 header.s=s1 header.b=iO0+mLF7
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1793352104;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=lDH6CZonHxdY1g1ae5yoOdLp2lZlZBIVpWVUaxg2sgg=;
 b=iO0+mLF7SEY4LWwvGRjf/AYjDrEU7lbq4tS7iC53ICh/JobXSddQN4cviUlyktkbOhqw4q
 0SRC0DrCMnt5KXhrsbUncljTpwziwb619EG6bYkMAyfw1QEECBkHmKIsklx9jLm8zVkSe0
 +1nEqmawPVLg5USQKrGadFIRPhw2Eas6rhs6bfEOJ2xbkhATqNzzRNCKllU4akKjsP6+F2
 acz/V6OQqauEW16bxyrkbv/g/5TWsSNUN6EbVHh3vY6skZlc8FMVuF+tyS7wHJRpRKb+Yu
 2A+U9vBttgF4KMUnQzVoz1OwVSXBfBjbnqL26sh81dWwnsOaj9K+FHd3vtA8eQ==
Date: Fri, 30 Oct 2026 17:21:28 +0800
X-Mailer: git-send-email 2.56.0
References: <20261030092129.1671254-1-chencheng@fnnas.com>
Received: from fedora ([183.34.162.132]) by smtp.feishu.cn with ESMTPS; Fri, 30 Oct 2026 17:21:38 +0800
To: <dm-devel@lists.linux.dev>, <linux-kernel@vger.kernel.org>, 
	<agk@redhat.com>, <snitzer@kernel.org>, <mpatocka@redhat.com>, 
	<bmarzins@redhat.com>
Subject: [PATCH 1/2] dm snapshot: split discards on chunk boundaries
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
X-Original-From: chencheng@fnnas.com
X-Lms-Return-Path: <lba+26ae461a3+3f7d58+lists.linux.dev+chencheng@fnnas.com>
Content-Transfer-Encoding: 7bit
Cc: <stable@vger.kernel.org>, <yukuai@fygo.io>, <chencheng@fnnas.com>
From: "Chen Cheng" <chencheng@fnnas.com>
Message-Id: <20261030092129.1671254-2-chencheng@fnnas.com>
In-Reply-To: <20261030092129.1671254-1-chencheng@fnnas.com>
Content-Type: text/plain; charset=UTF-8

From: Chen Cheng <chencheng@fnnas.com>

dm-snapshot did not set ti->max_discard_granularity when it allows
discards, so a discard could reach the target unaligned, or spanning
several chunks.  Set the flag, so dm splits discards on chunk
boundaries.

Fixes: 2e6023850e17 ("dm snapshot: add optional discard support features")
Cc: stable@vger.kernel.org
Signed-off-by: Chen Cheng <chencheng@fnnas.com>
---
 drivers/md/dm-snap.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 31676ee05514..e49427bdbeef 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1356,12 +1356,14 @@ static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
 	spin_lock_init(&s->tracked_chunk_lock);
 
 	ti->private = s;
 	ti->num_flush_bios = num_flush_bios;
-	if (s->discard_zeroes_cow)
+	if (s->discard_zeroes_cow) {
 		ti->num_discard_bios = (s->discard_passdown_origin ? 2 : 1);
+		ti->max_discard_granularity = true;
+	}
 	ti->per_io_data_size = sizeof(struct dm_snap_tracked_chunk);
 
 	/* Add snapshot to the list of snapshots for this origin */
 	/* Exceptions aren't triggered till snapshot_resume() is called */
 	r = register_snapshot(s);
-- 
2.56.0

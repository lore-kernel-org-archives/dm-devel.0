Received: from iguana.tulip.relay.mailchannels.net (iguana.tulip.relay.mailchannels.net [23.83.218.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC051212FB9
	for <dm-devel@lists.linux.dev>; Sun, 18 Jan 2026 23:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.218.253
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768778751; cv=pass; b=s+ORR2dMXQggSjUQVv5tJMkbuKqywbmtggdObOqwBJ2RhCCiiFGHzKabnHGgoUlCgwAlzRB2VDdTtYyYfsKYErqPN6wANs+KOqUHlDg3pqtU+hvdU2tqpChb3nzc4BdPAyrlvuI504s/WZzzHBa5Lw6f5FoyAoPan7xmz3Crxhs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768778751; c=relaxed/simple;
	bh=ukv2snMEI9xnzP0hOZKt45u3o1OIZ0NXXFlJIQGTZgQ=;
	h=From:To:Cc:Subject:Date:MIME-Version:Message-ID:Content-Type; b=QuD2b7Gdl10NT+XBLtCdSVXjS/q5ndnr0Lb9rOY2zxxwSTgXG3Zp/5fSteea02TOhIfS+upGT8KgR7/Lc0x8g+EYSjhaRv6vgl68XXpG4zxj8jYakXGRj8Wlou82sSCAcN9CV6ODvECPeBEWU8eOvv2PvSeE7sAVlVEQzgM85hc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mattwhitlock.name; spf=pass smtp.mailfrom=mattwhitlock.name; dkim=pass (2048-bit key) header.d=mattwhitlock.name header.i=@mattwhitlock.name header.b=IAvESAcX; arc=pass smtp.client-ip=23.83.218.253
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mattwhitlock.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mattwhitlock.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mattwhitlock.name header.i=@mattwhitlock.name header.b="IAvESAcX"
X-Sender-Id: dreamhost|x-authsender|matt@whitlock.name
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 46EB14C1326;
	Sun, 18 Jan 2026 18:36:18 +0000 (UTC)
Received: from pdx1-sub0-mail-a246.dreamhost.com (trex-green-3.trex.outbound.svc.cluster.local [100.111.223.119])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id E8B594C10A5;
	Sun, 18 Jan 2026 18:36:17 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=mailchannels.net; s=arc-2022; cv=none;
	t=1768761377;
	b=P1gWEqJgLx/JTCcq83GYs0HjTvGi0xewytW6zCI8OLUaCfs5MDbXahuTGdt1QbtP4RmWOP
	91I0qVHM+M3TU0j+KPlu4q2OL5jmT9AarNB831gkOyIDC5AS2nDxUV/FDGf15omg8cqAJu
	h+SrlyxC5grxX2w1I0i+zk/i2GO/CnxCT0Qha8sfn2T4xaTfG0LKsaGr1HIlKGeph/QHdV
	OlZH0eYgXaSsC1UgNy7/DqGeXfm8nwGfVaj7517a5iui55frTO1QwQNdtOutbkcUOZGyQZ
	EjxvpMR4dMmUf4SlqO1FuacToLeaTrvca7I+bGRkA17bQoyeulqUT3O6Hkbbbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1768761377;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:dkim-signature;
	bh=nO6TSIwrWCSu4qJ+c5+so9F8tdioN7vt2lC24zkVRNI=;
	b=ba5lzRXlZRBiTiEfOdQ4dbzGWutORemj5ZkwQnQmkiyvF4MYIzyFBFnVhQZJ85jRY8NCsC
	H8BWYvY/B1Hzn31+0+c85ozzREdNAtlDAQgEDELvj5vff7y7YT/8cEsPw7fdAtg7EYeNdm
	tGkDbSniGJeKmdwyA3sodYsMDYmyJJnuHMEPEW11R/qebQe+KcgOpDEEDPTOQPjaF00ZAA
	KqfBEc0joeOit01U5sYlrHDeYo/6j4ieak+m4RaLlpPlVGa1zcbeDdPSHX1uX4iDIpM15g
	GYbaMRLYn9aSL00ZhawCx5sOAPMffAPNBg1hKobLnWxGIrYcYzwoNl9+wuUaeA==
ARC-Authentication-Results: i=1;
	rspamd-8f4d6bb8d-lrtz8;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=kernel@mattwhitlock.name
X-Sender-Id: dreamhost|x-authsender|matt@whitlock.name
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|matt@whitlock.name
X-MailChannels-Auth-Id: dreamhost
X-Name-Juvenile: 0b2d37ea10d4337d_1768761378162_3174146764
X-MC-Loop-Signature: 1768761378162:3718357440
X-MC-Ingress-Time: 1768761378162
Received: from pdx1-sub0-mail-a246.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.111.223.119 (trex/7.1.3);
	Sun, 18 Jan 2026 18:36:18 +0000
Received: from localhost (unknown [72.71.209.96])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: matt@whitlock.name)
	by pdx1-sub0-mail-a246.dreamhost.com (Postfix) with ESMTPSA id 4dvMjs35dtz107N;
	Sun, 18 Jan 2026 10:36:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mattwhitlock.name;
	s=dreamhost; t=1768761377;
	bh=nO6TSIwrWCSu4qJ+c5+so9F8tdioN7vt2lC24zkVRNI=;
	h=From:To:Cc:Subject:Date:Content-Type:Content-Transfer-Encoding;
	b=IAvESAcXuaL792gVSxy1bS0a04BjyQsqb48dHbg7Yun2cY7b5Z0nLMIU0Tbic0GIy
	 JbRdWxtBLKFiWxN6bnWjRdTff8mIr6UJ3URYs9oFOWAZAbrlNHwZ11od3NlBjKJRek
	 qe0J+t6Y0HgpVGKMnLhVyzlkQTDL6PUN0g6gUstPSkm1SHfHAD2SvwDtuu4hzpB7sT
	 YuPDgemieQw4hJTYe8Etz8dGhcQfoO2OjxduAsxnbCih0NFfbrI1EJ6CBF5wNIXAnD
	 9V3RaxJaRh6OluHjC0fzs5M+gBtNifDAUMp5j4C4ZC6yiA09R9nqO3GMJ5HBPk9K5Z
	 /BPoO0i+f3XUA==
From: Matt Whitlock <kernel@mattwhitlock.name>
To: Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>
Cc: <dm-devel@lists.linux.dev>
Subject: Patch for mapping bug in drivers/md/dm-unstripe.c
Date: Sun, 18 Jan 2026 13:36:15 -0500
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <68f72c7d-7e4e-4182-87fc-78c138046cd3@mattwhitlock.name>
User-Agent: Trojita/v0.7-781-gfddd17b7; Qt/6.10.1; xcb; Linux; Gentoo Linux
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

The "unstriped" device-mapper target incorrectly calculates the sector offset=
 on the mapped device when the target's origin is not zero.=0A=0ATake for exa=
mple this hypothetical concatenation of the members of a two-disk RAID0:=0A=0A=
linearized:       0 2097152 unstriped 2 128 0 /dev/md/raid0 0=0Alinearized: 2=
097152 2097152 unstriped 2 128 1 /dev/md/raid0 0=0A=0AThe intent in this exam=
ple is to create a single device named /dev/mapper/linearized that comprises =
all of the chunks of the first disk of the RAID0 set, followed by all of the =
chunks of the second disk of the RAID0 set.=0A=0AThis fails because dm-unstri=
pe.c's map_to_core function does its computations based on the sector number =
within the mapper device rather than the sector number within the target. The=
 bug turns invisible when the target's origin is at sector zero of the mapper=
 device, as is the common case. In the example above, however, what happens i=
s that the first half of the mapper device gets mapped correctly to the first=
 disk of the RAID0, but the second half of the mapper device gets mapped past=
 the end of the RAID0 device, and accesses to any of those sectors return err=
ors.=0A=0AHere is a very simple (tested) patch that corrects the problem:=0A=0A=
--- drivers/md/dm-unstripe.c~=092025-11-28 22:33:48.000000000 -0500=0A+++ dri=
vers/md/dm-unstripe.c=092026-01-18 12:48:52.378293579 -0500=0A@@ -117,7 +117,=
7 @@=0A static sector_t map_to_core(struct dm_target *ti, struct bio *bio)=0A=
 {=0A =09struct unstripe_c *uc =3D ti->private;=0A-=09sector_t sector =3D bio=
->bi_iter.bi_sector;=0A+=09sector_t sector =3D dm_target_offset(ti, bio->bi_i=
ter.bi_sector);=0A =09sector_t tmp_sector =3D sector;=0A =0A =09/* Shift us u=
p to the right "row" on the stripe */=0A

Received: from hamster.birch.relay.mailchannels.net (hamster.birch.relay.mailchannels.net [23.83.209.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA15B1DF987
	for <dm-devel@lists.linux.dev>; Mon, 19 Jan 2026 19:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.209.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768851408; cv=pass; b=ToVdd+T0YQny5RMmFBv2FWXMVYiggln/XKQcxG8R9FHBlYCq1P/ZslnQUSphx1oZIS3ymBuN4nKuOiTCPeofXaEhXbC8Kcq/LBTFg/Um9JP4/+uHUK2V7h3i0wTxWH1ga1k43F9SXIL+9iJhKNYEOFhFMycxBz5adHpVCzYNRcU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768851408; c=relaxed/simple;
	bh=qRSTeEgEMBz7at/TCxEQNWBmDxEZWRNRxvN8N5F5+sc=;
	h=From:To:Cc:Subject:Date:MIME-Version:Message-ID:In-Reply-To:
	 References:Content-Type; b=K48tBGy9woxGWLUifAQEksNiFWdWHFcdiAA0aBVgMrVp511lAHIAa1yvw8fyVyrZpD3/PmZlW8wbjZTD9jjVABeWzQWI4C1Wy2vpczyUDdYt46Vi9OOExNr3HzUwXYtjc0e+Jyy6UktPmTFWH61LZSgVwVnZuLulwHoWaCQMsCk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mattwhitlock.name; spf=pass smtp.mailfrom=mattwhitlock.name; dkim=pass (2048-bit key) header.d=mattwhitlock.name header.i=@mattwhitlock.name header.b=f5q6Axdq; arc=pass smtp.client-ip=23.83.209.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mattwhitlock.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mattwhitlock.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mattwhitlock.name header.i=@mattwhitlock.name header.b="f5q6Axdq"
X-Sender-Id: dreamhost|x-authsender|matt@whitlock.name
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 2A31F6C3493;
	Mon, 19 Jan 2026 16:10:46 +0000 (UTC)
Received: from pdx1-sub0-mail-a239.dreamhost.com (trex-green-8.trex.outbound.svc.cluster.local [100.110.193.162])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 9D34A6C29E1;
	Mon, 19 Jan 2026 16:10:45 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=mailchannels.net; s=arc-2022; cv=none;
	t=1768839045;
	b=uKgH1/NtjySXTPjxAc84hx5cp0+41BpZ68S/F5DmP/SfRmcuch3FgWb7afFDSiBt/Azt4h
	s5AGWQ4bJNuffrzXUn4x6Bi+B/cBCr79FPsfg9G1uyoX48103+3F+frMThFt7Ci7fV1DzO
	AxX+97F3i+sPavuc0sTgu642CW2AELhUzQNePvdpwefDvyCMo1UUgrzPLrkhURSRWA/iXq
	aMmV5BOQZNRrpcv1UHBMHW5hfRUq7G4NXdatA9+T0iNEPf5mTjIb+y+zJwP6c4hgzCY3no
	l47jnLUpO7KcBY9T8tniB6mktJfEnqq4psSrAPpOEHGNojWe6MvwbZCYQR1n4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1768839045;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M1Ua9qRT6/YIwyTj9w0lcArusjwEFY7laAux9fHwovQ=;
	b=nvi/uQqPmhRNpekF9j9LOHOt9B766c97yRSIRFKtCRxr1TW52qKrtLTEkbwR9e/PlvLgKD
	aqfMoTK9bjX6zxcwbQdYg6eE6frsGoOOlK1K+4PvzjV5ms9TCxEVFJRVoZDR2b8P0mni8d
	Lp9di2C3WjvD73nYjnZh1aEza3IX9uQDDswq8YWj4vjHK97KaXU6AeJu+c3QaMR2WJ4DS2
	S789QiueCIt1tDr+eK3cU5fS/COihlyr7QfRfwZurOmQ2Qikw3ZJF/6cc4aHoGeqsYCzNv
	j4R44c4sZrghc3pWyZqVTqnUJ0PojRoAu9vSVg/8jQVzkM2D813jG7rya3/TuA==
ARC-Authentication-Results: i=1;
	rspamd-8f4d6bb8d-pcgj5;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=kernel@mattwhitlock.name
X-Sender-Id: dreamhost|x-authsender|matt@whitlock.name
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|matt@whitlock.name
X-MailChannels-Auth-Id: dreamhost
X-Abaft-Vacuous: 5524af4058362116_1768839045892_3203098584
X-MC-Loop-Signature: 1768839045892:323297006
X-MC-Ingress-Time: 1768839045892
Received: from pdx1-sub0-mail-a239.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.110.193.162 (trex/7.1.3);
	Mon, 19 Jan 2026 16:10:45 +0000
Received: from localhost (unknown [72.71.209.96])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: matt@whitlock.name)
	by pdx1-sub0-mail-a239.dreamhost.com (Postfix) with ESMTPSA id 4dvwRT0LHMz107P;
	Mon, 19 Jan 2026 08:10:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mattwhitlock.name;
	s=dreamhost; t=1768839045;
	bh=M1Ua9qRT6/YIwyTj9w0lcArusjwEFY7laAux9fHwovQ=;
	h=From:To:Cc:Subject:Date:Content-Type:Content-Transfer-Encoding;
	b=f5q6AxdqGyaVB4XGZta0UqtxPaiiTcg8oU86faMpy76rDyi6ePEX7IhUta54UZnAw
	 3Um1vqGNvKIMbid1vbVBdvz2xdCuICTn8Dswb/HrFezIhHGPAiFTLqS53TZZetu4gv
	 fDcutTLVw8PVdw4Kl/LIAQUUQsaJHUWBt2G0KHE+DY77g9zHnMJW9LML2UcVSfx4L+
	 uGjFIuICmamXBp54CT5/70osCLPzlbWHGbvdCGutJQ1MIhZ2EBWTkv0/hW7Isn8Zho
	 yG5tbLvQv9GhHzJ8LRQjuNIuHHDGJzbgi4qOQMTKfDNN2r7X4hUYhmKjZEUopmt9ki
	 jo8RV4PnCusIQ==
From: Matt Whitlock <kernel@mattwhitlock.name>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>,
 <dm-devel@lists.linux.dev>
Subject: Re: Patch for mapping bug in drivers/md/dm-unstripe.c
Date: Mon, 19 Jan 2026 11:10:43 -0500
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <88ac5d9b-bc4a-4c7f-bc06-c4bee4ad9b33@mattwhitlock.name>
In-Reply-To: <113951bf-b1f9-02ad-3e9b-9fc1e30a575b@redhat.com>
References: <68f72c7d-7e4e-4182-87fc-78c138046cd3@mattwhitlock.name>
 <113951bf-b1f9-02ad-3e9b-9fc1e30a575b@redhat.com>
User-Agent: Trojita/v0.7-781-gfddd17b7; Qt/6.10.1; xcb; Linux; Gentoo Linux
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Monday, 19 January 2026 09:13:04 EST, Mikulas Patocka wrote:=0A> The patch=
 is OK. Please re-send it with the "Signed-off-by: Matt Whitlock =0A> <kernel=
@mattwhitlock.name>" line inserted - this line indicates that you =0A> have l=
egal right to send the patch.=0A=0AI'll never understand the obsession with t=
his one redundant snippet of text. It's not as though my hitting Copy+Paste o=
n it changes anything. Did I discover this bug? Did I write this one-liner to=
 fix it? As it happens, yes and yes, but suppose I didn't: would you then rea=
lly be legally barred from fixing this bug, forever doomed to preserve the in=
correct behavior in the kernel because someone who didn't have the "right" to=
 tell you how to fix it told you how to fix it? Good grief.=0A=0A--- resendin=
g ---=0A=0AThe "unstriped" device-mapper target incorrectly calculates the se=
ctor offset on the mapped device when the target's origin is not zero.=0A=0AT=
ake for example this hypothetical concatenation of the members of a two-disk =
RAID0:=0A=0Alinearized:       0 2097152 unstriped 2 128 0 /dev/md/raid0 0=0Al=
inearized: 2097152 2097152 unstriped 2 128 1 /dev/md/raid0 0=0A=0AThe intent =
in this example is to create a single device named /dev/mapper/linearized tha=
t comprises all of the chunks of the first disk of the RAID0 set, followed by=
 all of the chunks of the second disk of the RAID0 set.=0A=0AThis fails becau=
se dm-unstripe.c's map_to_core function does its computations based on the se=
ctor number within the mapper device rather than the sector number within the=
 target. The bug turns invisible when the target's origin is at sector zero o=
f the mapper device, as is the common case. In the example above, however, wh=
at happens is that the first half of the mapper device gets mapped correctly =
to the first disk of the RAID0, but the second half of the mapper device gets=
 mapped past the end of the RAID0 device, and accesses to any of those sector=
s return errors.=0A=0AHere is a very simple (tested) patch that corrects the =
problem:=0A=0A--- drivers/md/dm-unstripe.c~=092025-11-28 22:33:48.000000000 -=
0500=0A+++ drivers/md/dm-unstripe.c=092026-01-18 12:48:52.378293579 -0500=0A@=
@ -117,7 +117,7 @@=0A static sector_t map_to_core(struct dm_target *ti, struc=
t bio *bio)=0A {=0A =09struct unstripe_c *uc =3D ti->private;=0A-=09sector_t =
sector =3D bio->bi_iter.bi_sector;=0A+=09sector_t sector =3D dm_target_offset=
(ti, bio->bi_iter.bi_sector);=0A =09sector_t tmp_sector =3D sector;=0A =0A =09=
/* Shift us up to the right "row" on the stripe */=0A=0AAnd here are your mag=
ical 56 characters:=0A=0ASigned-off-by: Matt Whitlock <kernel@mattwhitlock.na=
me>

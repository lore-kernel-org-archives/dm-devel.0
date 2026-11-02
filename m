Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.108.3.23
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793606845;
	b=IvoiSdCuUESbZ7T3apx9vp0CY9BaKoaFYqQuViMG/Wl1Y9eMxMGoLt04acKjWuI62lmI
	 5aNLaTOazf8Au9kk3Hm6X7AojHJi95cRM+Emv1F3heUWVkhUeUQrAFMjJryZBT3u2wOKA
	 JCB7fOAzShhp/Xk57bR2p8mNqdYKbV0HYMA+Yopj9yER+xWGulZes5G8MrSN7k3O14Lss
	 /XSEV3ouhIH8HqPC7A0N+8U/6GZsheOvnmkro75xZ/R+ivew42sZCsGXW70CsBXngq8aS
	 GuX5A8mq4kmBT9uiasICHfDKQz3vbTqpVZjpr0jiL4ipRgRWKVktFDPwgdI2lHklW6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793606845;
	h=DMARC-Filter:DKIM-Signature:X-SMAIL-HELO:Received:X-Sender:X-Auth-ID:
	 X-SMAIL-MID:X-SMAIL-UIID:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=nQjXmqGK5AW9/D5/P6wpNA06FJUe5Tp5fUtCfZHHY/g=;
	b=HzEbFWbXgxo5D5Pns7rW/z74pm7NR4qIybz3NHet2o+onoMBHYaBThX2F+jCEyFRANWT
	 WdO9kWJkNxK6axB+/eR3xObDX6nCgjuWHJi79LbxIXhOK08OpI26ryT4lr/tLaWaRiNY8
	 NGBvrqxAVNbLMMHzMuUH/0wmZgJhJrAi5ft1bXYhWEkHedUbByHFiqjg8i0SBxcvMkg9a
	 uSZsU833REkc3ESPDkQYtyEaBMoX5gK7RxiAug+e0ImU/VPsNuvJm6Hc/9FhWPq6veRdF
	 4wT+Lfunq28YsyF/6oraRb4y+exs713LMQmAA+YgP+mkGTUPv3Iuh6zylSFNKv0rbAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=sina.com;
	spf=pass smtp.mailfrom=sina.com;
	dkim=pass header.d=sina.com header.i=@sina.com header.a=rsa-sha256 header.s=201208 header.b=H1iQClGI;
	arc=none smtp.remote-ip=202.108.3.23
Received: from r3-23.sinamail.sina.com.cn (r3-23.sinamail.sina.com.cn [202.108.3.23])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B013606A324
	for <dm-devel@lists.linux.dev>; Mon,  2 Nov 2026 08:07:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4B013606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sina.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sina.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=sina.com header.i=@sina.com header.a=rsa-sha256 header.s=201208 header.b=H1iQClGI
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1793606843;
	bh=nQjXmqGK5AW9/D5/P6wpNA06FJUe5Tp5fUtCfZHHY/g=;
	h=From:Subject:Date:Message-ID;
	b=H1iQClGID5TG9nLwdPcngT6cp6PUND9+O4VWyC8ymkpaoiAEun+3yedbPgUlvLxOd
	 XAOyTx5zHkHkeUNmSf1TF68SngCVUEBBUnzYTeXMbLplm4qw1NAjrPcjY6U1SgMeMO
	 ynoBS6aSeoj3C/RcjByi9CEAmGYqehP4RgjUq7m0=
X-SMAIL-HELO: lxu-ped-host..
Received: from unknown (HELO lxu-ped-host..)([111.198.231.89])
	by sina.com (10.54.253.31) with ESMTP
	id 6AE844AF00005DF0; Mon, 2 Nov 2026 16:07:14 +0800 (CST)
X-Sender: eadavis@sina.com
X-Auth-ID: eadavis@sina.com
Authentication-Results: sina.com;
	 spf=none smtp.mailfrom=eadavis@sina.com;
	 dkim=none header.i=none;
	 dmarc=none action=none header.from=eadavis@sina.com
X-SMAIL-MID: 7342496816423
X-SMAIL-UIID: D4500AC0174D403298AA3D7845CD29A4-20261102-160714-1
From: Edward Adam Davis <eadavis@sina.com>
To: syzbot+c8564fc0a96e3ecbe4d4@syzkaller.appspotmail.com
Cc: agk@redhat.com,
	bmarzins@redhat.com,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	mpatocka@redhat.com,
	snitzer@kernel.org,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [dm?] WARNING: zero-size vmalloc in cache_ctr
Date: Mon,  2 Nov 2026 16:07:11 +0800
Message-ID: <20261102080711.418538-1-eadavis@sina.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <6ae61f5d.61c4c7f9.11e392.001b.GAE@google.com>
References: <6ae61f5d.61c4c7f9.11e392.001b.GAE@google.com>
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

From: Edward Aadm Davis <eadavis@sina.com>

Introduced by commit a2f0a98b13db ("dm cache: drop redundant origin size check").
Reverts it can fix this issue.

BR,
Edward

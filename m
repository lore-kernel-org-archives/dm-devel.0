Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793991171;
	b=IMcW/tiinCyyULdtD/YaE1HwtHxsGddvqrYNs8rzA1Kzeo4ie8JBPJH/I98vhASYl7+2
	 neZPXlcDGKph9/R2Bt5HOx3buHIPqylRWPOvK1j30anmfZdta4q4+HWI9J9yUvVrAWV2m
	 4MH7CRjZD0TodAfp3t289XX4/tzlDJyH1SsCDF0kOeZVSOVagG6hRqN0CGEMsC/TUcIGh
	 HoHqWINrby2NVZgh69XPkIuhbnE7b0qRPUP0w73Plf0VuaXzbC6+jtR6ta9LP3lb49F5r
	 7kCj1r8no4dovYZkxvU/12PLBp/rc4L0qc7aXMEMZ0Y+vI2GB8wwTQs1ySCJLXzDs6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793991171;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=pfck5sZreHJ3CH4DdyI3txosS29SWb4cqdjYjaWMUV0=;
	b=AF9KDUlbJcTUOPVwU2AdjDg/SobTk5XFJD/sxk19NsP6ndh7SpkhC353mnVH5qEhpV5n
	 RRhymlmIzMyC0oj2zucjnBd6aT9rvomCmiufEvaMTfkcLJCmXa5E1Qlt55gks3DFA7aat
	 sMP8EhxgDYon31KauI0GDbs44dhPewMaeIYr9ju91PWtUCe1D+1GQywNnqbF4cJLiwzqt
	 B06IuuyYUaUJegW9Q0l0xQ1Zvn4CrR2orxLOpLRe1OpmMLEZpAfsTNlgeDR5qKax69BkO
	 a9rGcK5kkppG+g+7joX6mFRhTBcucY0XRT7F9PVkyxu71Sch/UCIZb38ftLfM1G/hSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M9uw2gBV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F67606A329
	for <dm-devel@lists.linux.dev>; Fri,  6 Nov 2026 18:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M9uw2gBV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A7661F0089F;
	Fri,  6 Nov 2026 18:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793991170;
	bh=pfck5sZreHJ3CH4DdyI3txosS29SWb4cqdjYjaWMUV0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=M9uw2gBV2C1EIFkee+D8Zti8/8/5kQx4QBK4CN+JQMGFt5bhMcw2PZbNFj62C5nme
	 BzvqA3vb8qsGvcyVBELMMOz0vaerhaSBqarwOac1BQuHLgmnciuv86Qh7ucSPYebIu
	 HSZK03jCmvije5Vy8LECSa6IT6yfJ1Ay+sZHZdvPwJiFnmrej8gjOTnePHwBV/rE8U
	 vGdxOoxoxut0k+6CfK6MB8NrXwyEQoDxYrs7wW28cZGOzpJa5AZSf8df03Te+AR7tM
	 T1/8jfl74iqejc9jTVCFSC2WKHUF/zz9tXO+hQ/2Tu5eOZLnqNPvD4xAxmSJyMZPhv
	 NSMdrmHb/kfqw==
Message-ID: <sashiko-outbox-202111@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] dm persistent data: test return value of node_copy
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mikulas Patocka" <mpatocka@redhat.com>, "Alasdair Kergon" <agk@redhat.com>, "Mike
 Snitzer" <snitzer@kernel.org>, "Benjamin Marzinski" <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
In-Reply-To: <db8878fd-43c1-d976-debd-8e1d1547e7c7@redhat.com>
References: <db8878fd-43c1-d976-debd-8e1d1547e7c7@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 18:52:49 +0000
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] dm persistent data: Fixes trailer cites wrong commit for
  node_copy()
--

commit f0758e03fa9ea11bfbf4ab38d82540be653f4f13
Author: Mikulas Patocka <mpatocka@redhat.com>

> dm persistent data: test return value of node_copy
>
> There were 3 places where the return value of node_copy was not tested.
>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Assisted-by: Claude:claude-opus-5
> Cc: stable@vger.kernel.org
> Fixes: 3241b1d3e0aa ("dm: add persistent data library")

[Severity: Low]
In commit 3241b1d3e0aa ("dm: add persistent data library"), node_copy()
returned void and used BUG_ON() for error checks.  Commit c671ffa55d8b
("dm btree remove: change a bunch of BUG_ON() calls to proper errors")
converted node_copy() to return an error code and left the three call
sites in __rebalance2() and delete_center_node() unchecked.  Should the
Fixes tag be:

  Fixes: c671ffa55d8b ("dm btree remove: change a bunch of BUG_ON() calls t=
o proper errors")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/db8878fd-43c1-d976-=
debd-8e1d1547e7c7@redhat.com?part=3D1

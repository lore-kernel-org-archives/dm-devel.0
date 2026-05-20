Received: from va-2-28.ptr.blmpb.com (va-2-28.ptr.blmpb.com [209.127.231.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D99173DCD96
	for <dm-devel@lists.linux.dev>; Wed, 20 May 2026 12:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779279034; cv=none; b=ml1tXWRJpfW0plgttObIgVlj5rn08BJRtG8HwA5/EAJbeNsg9usiodzRUSKWJazl20XcHBAug2r+eZaGnZCA/3jYLTeokWRBDHxQ6CmVrICGyx3LNvq53J2CiOHQWwY60rmH6KVrL17+e4ZVxN9URE+Tw3gvsXUoZ2pZ2+jmqIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779279034; c=relaxed/simple;
	bh=xoepihcacQ6OPdizAIcIYfpncaduxdPrQ3r5SmsYXkQ=;
	h=Content-Type:Subject:References:In-Reply-To:Date:From:Message-Id:
	 To:Cc:Mime-Version; b=b4I+hMiIAsDqm7JyPQ8GqHLj5OqpTccN9ZP/V9shiWXfgv1O6re58LmLuVUzaBh8MsmaJHY/ZhF7AWJmCVWQMJWfywjg5tnqTKkxM/ROddwp+pHkJsk4LWM1wavlCcU6QSUgHITqPnXMeLJRwaeHP2Z2d6o+g2P442ug4pQlvYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=ov4wpOqN; arc=none smtp.client-ip=209.127.231.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="ov4wpOqN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1779279025;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=JqdOMHrMOjB1EmRT+mhIwY9QZ+PatwG+SAaF7WzduGU=;
 b=ov4wpOqNgAzXUi6S5OF3d5pLnjHQ4fRiMiRASRo5Gdhw4wlD2ZJrqsSJz8cydaO95Q61CN
 x4TCSFBAS+cCCXXimghQaOFePNO9fxg1aAk2eVfWkyddAY7EBoul8b6+eO1qYscdIw+QW4
 kvPwIlYZ/Obfs9KSgGEPLierXUqmDwnImjnnqXMd4uzfaRjpt6bnVWLtmcLiKNTNe6I90R
 CDgd5Hvy01DFcdrHcx1tHWr3lOzhvYbusN2yaVu/vxJct+wcZbjGdD/kcd4KtYD96jfek6
 fJ92vY5wjj0/UWEq6OWEUMbxPQbIUjMQLpZQgn6m8s7iyu7suktOpCc7XhZOgA==
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v2] dm-raid: only requeue bios when dm is suspending.
References: <20260428232010.2785514-1-bmarzins@redhat.com>
In-Reply-To: <20260428232010.2785514-1-bmarzins@redhat.com>
Reply-To: yukuai@fygo.io
Date: Wed, 20 May 2026 20:10:20 +0800
From: "Yu Kuai" <yukuai@fnnas.com>
Message-Id: <9c54f92b-ac54-4308-913c-b97796bced54@fygo.io>
User-Agent: Mozilla Thunderbird
Received: from [192.168.1.104] ([39.182.0.188]) by smtp.feishu.cn with ESMTPS; Wed, 20 May 2026 20:10:22 +0800
X-Original-From: Yu Kuai <yukuai@fygo.io>
To: "Benjamin Marzinski" <bmarzins@redhat.com>, 
	"Yu Kuai" <yukuai@alb-78bjiv52429oh8qptp.cn-shenzhen.alb.aliyuncs.com>, 
	"Song Liu" <song@kernel.org>
Cc: <linux-raid@vger.kernel.org>, <dm-devel@lists.linux.dev>, 
	"Yang Xiuwei" <yangxiuwei@kylinos.cn>, "Xiao Ni" <xiao@kernel.org>, 
	"Nigel Croxon" <ncroxon@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26a0da4af+95b9d4+lists.linux.dev+yukuai@fnnas.com>

=E5=9C=A8 2026/4/29 7:20, Benjamin Marzinski =E5=86=99=E9=81=93:

> returning DM_MAPIO_REQUEUE from the target map() function only requeues
> the bio during noflush suspends. During regular operations or during
> flushing suspends, it fails the bio. Failing the bio during flushing
> suspends is the correct behavior here. We cannot handle the bio, and we
> cannot suspends while it is outstanding. But during normal operations,
> we should not push the bio back to dm. Instead, wait for the reshape
> to be resumed.
>
> Signed-off-by: Benjamin Marzinski<bmarzins@redhat.com>
> ---
>
> Changes from v1:
> - Track the dm device's suspending state in mddev->flags instead of
>    adding a new integer to mddev.
>
>   drivers/md/dm-raid.c | 6 ++++++
>   drivers/md/md.h      | 2 ++
>   drivers/md/raid5.c   | 7 +++++--
>   3 files changed, 13 insertions(+), 2 deletions(-)

Applied to md-7.2

--=20
Thansk,
Kuai

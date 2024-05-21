Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EBBA6CDCC
	for <dm-devel@lists.linux.dev>; Tue, 21 May 2024 11:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716291605; cv=none; b=Z7IbC1jxvEx21Pqd3XjvccIcRaB3DcIT+7OHc1KSTs0m4sD+80fwU5vzbXaOnEWa8k5QZcP7tf42A6LCyIGtZUEnzkIBZniYK9NKPnOYS9it+/Fm4IvXWH4polSMEzQ1blBdFP4cjpxvLBc9ehkc+IJ+87wZmdiTAtLMU7kG6vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716291605; c=relaxed/simple;
	bh=hIgWMVVMu4ktdcwvAZyrie6YAtl1U5c0Z1XIxoJhGco=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VbTDZtrGLONyZk7clLseOGC7M92uDpr2fBwuK/ObHW3EGVr+/+obIeaD78Ffk5AyDhouoyzVcrWgSpbJEeY5L8tQvfC4uqaF5GdHQ0tauHNDf6oRJQqfAZ53LEjBEM0U7IXWdCIWB15WWpwvknGLMlIEUiiHEhD0X6TV5p1AYYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JZ00AGc8; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JZ00AGc8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716291601;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HV87Q0WS1wh+2XVeiD7+8DBuPPINZHb+zErYv6uFbYQ=;
	b=JZ00AGc87TVjq3euBhqn9ZfkDEc3866YMfe4ivw7AMxOU7+ThCEpfoqnE3+kji4F4noggw
	Wz2ahLqRTqHL9CRvbLSpPNuCBPPv6MuciiQSptec7F2P95tVPpK8Tg2lDjyxwN3ss+8/q3
	L/KyfYDguwHoiGKyIs96aajNQg/61HU=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-649-9RZZ8vnHOamyEhVuokr16g-1; Tue, 21 May 2024 07:39:58 -0400
X-MC-Unique: 9RZZ8vnHOamyEhVuokr16g-1
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-2b432dfdcf6so11168044a91.3
        for <dm-devel@lists.linux.dev>; Tue, 21 May 2024 04:39:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716291597; x=1716896397;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HV87Q0WS1wh+2XVeiD7+8DBuPPINZHb+zErYv6uFbYQ=;
        b=qbkz6EfPyajqiQ+OY7UVwLIBRTdRCclvb583LnOVN+MFAuLB0SW1RutUkXmQeTSg1e
         Vl77jRO2ZeE+Va34R9Zb8f2jEWEz1n3grFHndl+z3ZY0ZTQ8NdtSIHY9C6Ag2gaC5QBa
         sZIPWM79bhFqCAcPOpJ/WE7qDxldbwBbRv5uds6B8y4LMhmsplgl2YtdLJvNPV5xPSRb
         z4a0qVZGSDVksXaW28kwoGbsyOb4JPHkMd/LfYmiYiSCxIUNtHEAhYYlcz22gUQQUytS
         3wqDLHH9Ui4lVg02vRYnQ46mfj/k85A/+8ClF9IQg0or34okOkZImRmXTCrogFbTmNc3
         hX+w==
X-Forwarded-Encrypted: i=1; AJvYcCWSUU/IqMzUyPTwPB17PwizWGxwRUVa9SofhVOTy9wTFw1VF6Qp8Caj/wzhRAvDqRtxs3jtcwrUe5CiikIjkS2X63wXnLtOim8=
X-Gm-Message-State: AOJu0YwkBhj1MnN5YG1cOesvfSOzPsFLYDHCooXFcvfVTDaU23iaEAaX
	Y6PKLz0SsfExl+pwTet3A2RMPTSLRgM3NNP0j/TWWDQlBh5CmNP4adSVb3IP/Sr6TImoXsOgiHT
	UM//fRP52/7JURA687P+1y5SX2tLB9AGuAw17DHbc8EZFILYyCO/U4+TrWtRupNRxBSZaEraj48
	e699Ft+0Ii8uh4eYkIy/3jNQyWJczU34Y=
X-Received: by 2002:a17:90a:8d10:b0:2ba:705:52db with SMTP id 98e67ed59e1d1-2ba0705535fmr15036144a91.38.1716291597344;
        Tue, 21 May 2024 04:39:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHjWlmWlwNEBezfCjv6JkuMU5tRIBL0riNuuVw1rJ3rVVE24HkxWufcpXCmNtu114S9NcN6gQQ+n5PwCRdRHHo=
X-Received: by 2002:a17:90a:8d10:b0:2ba:705:52db with SMTP id
 98e67ed59e1d1-2ba0705535fmr15036116a91.38.1716291596664; Tue, 21 May 2024
 04:39:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CAGVVp+Xsmzy2G9YuEatfMT6qv1M--YdOCQ0g7z7OVmcTbBxQAg@mail.gmail.com>
 <ZkXsOKV5d4T0Hyqu@fedora> <9b340157-dc0c-6e6a-3d92-f2c65b515461@huaweicloud.com>
 <CAGVVp+XtThX7=bZm441VxyVd-wv_ycdqMU=19a2pa4wUkbkJ3g@mail.gmail.com>
 <1b35a177-670a-4d2f-0b68-6eda769af37d@huaweicloud.com> <CAGVVp+WQVeV0PE12RvpojFTRB4rHXh6Lk01vLmdStw1W9zUACg@mail.gmail.com>
 <CAGVVp+WGyPS5nOQYhWtgJyQnXwUb-+Hui14pXqxd+-ZUjWpTrA@mail.gmail.com>
 <f1c98dd1-a62c-6857-3773-e05b80e6a763@huaweicloud.com> <CAGVVp+UdBekv2udwxtXBrtn0CMTrBa94oE4taUfynWncYF5ETQ@mail.gmail.com>
 <0aef762b-ecc5-7dde-7020-08d1b85ed057@huaweicloud.com> <CAGVVp+W-n8mqjjm+GRbO4fAGvqhAjHbCZJjSBysQJpAVzCUvDw@mail.gmail.com>
 <0e6f15fc-5821-476d-e598-08154d13427c@huaweicloud.com>
In-Reply-To: <0e6f15fc-5821-476d-e598-08154d13427c@huaweicloud.com>
From: Changhui Zhong <czhong@redhat.com>
Date: Tue, 21 May 2024 19:39:44 +0800
Message-ID: <CAGVVp+UZ4stcktsHw0r8ks8LCfXvYJyT+zv93wEfGuuLswArnw@mail.gmail.com>
Subject: Re: [bug report] INFO: task mdX_resync:42168 blocked for more than
 122 seconds
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Ming Lei <ming.lei@redhat.com>, Linux Block Devices <linux-block@vger.kernel.org>, 
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>, 
	Mikulas Patocka <mpatocka@redhat.com>, Song Liu <song@kernel.org>, linux-raid@vger.kernel.org, 
	Xiao Ni <xni@redhat.com>, "yangerkun@huawei.com" <yangerkun@huawei.com>, "yukuai (C)" <yukuai3@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 21, 2024 at 5:17=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> Hi,
>
> =E5=9C=A8 2024/05/21 12:28, Changhui Zhong =E5=86=99=E9=81=93:
> > On Tue, May 21, 2024 at 9:09=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.co=
m> wrote:
> >
> >>
> >> Thanks for the test! Since raid10 has the same problem as well, then t=
he
> >> problem seems to be more common in raid. And related code to raid10 is
> >> more simpler, attached is a patch to add debuginfo to raid10.
> >>
> >> BTW, Xiao can reporduce the problem as well, and will lend a hand as
> >> well.
> >>
> >> Thanks,
> >> Kuai
> >
> >
> > Hi, Yu Kuai and Xiao
> >
> > thanks for  efforts on this issue=EF=BC=8C
> > after applying the debug patch, I got the following results, please che=
ck it
> >
> > [  597.491083] Create raid10
> > [  597.647987] device-mapper: raid: Superblocks created for new raid se=
t
> > [  597.680540] md/raid10:mdX: not clean -- starting background reconstr=
uction
> > [  597.680549] md/raid10:mdX: active with 4 out of 4 devices
> > [  597.683779] mdX: bitmap file is out of date, doing full recovery
> > [  597.692971] md: resync of RAID array mdX
> > [  597.753583] try_raise_barrier: resync depth exceed limit
> > [  597.759540] try_raise_barrier: resync depth exceed limit
> > [  597.765504] try_raise_barrier: resync depth exceed limit
> > [  597.771432] try_raise_barrier: resync depth exceed limit
> > [  597.779400] barrier_waiting: nr_waiting 1
> > [  597.783879] barrier_waiting: nr_waiting 1
> > [  597.788356] barrier_waiting: nr_waiting 1
> > [  597.792838] barrier_waiting: nr_waiting 1
> > [  597.797327] barrier_waiting: nr_waiting 1
> > [  597.801806] barrier_waiting: nr_waiting 1
> > [  597.806288] barrier_waiting: nr_waiting 1
> > [  597.810780] barrier_waiting: nr_waiting 1
> > [  597.815252] barrier_waiting: nr_waiting 1
> > [  597.819737] barrier_waiting: nr_waiting 1
> > [  597.824232] barrier_waiting: nr_waiting 1
> > [  597.828714] barrier_waiting: nr_waiting 1
> > [  597.833196] barrier_waiting: nr_waiting 1
> > [  597.837678] barrier_waiting: nr_waiting 1
> > [  597.842160] barrier_waiting: nr_waiting 1
> > [  597.846640] barrier_waiting: nr_waiting 1
> > [  597.851128] barrier_waiting: nr_waiting 1
> > [  597.855610] barrier_waiting: nr_waiting 1
> > [  597.860094] barrier_waiting: nr_waiting 1
> > [  597.864576] barrier_waiting: nr_waiting 1
> > [  597.869060] barrier_waiting: nr_waiting 1
> > [  597.873548] barrier_waiting: nr_waiting 1
> > [  597.878032] barrier_waiting: nr_waiting 1
> > [  597.882522] barrier_waiting: nr_waiting 1
> > [  597.883457] barrier_waiting: nr_waiting 1
> > [  597.891503] barrier_waiting: nr_waiting 1
> > [  597.895987] barrier_waiting: nr_waiting 1
> > [  597.900459] barrier_waiting: nr_waiting 1
> > [  597.904940] barrier_waiting: nr_waiting 1
> > [  597.909421] barrier_waiting: nr_waiting 1
> > [  597.913900] barrier_waiting: nr_waiting 1
> > [  597.918377] barrier_waiting: nr_waiting 1
> > [  597.922857] barrier_waiting: nr_waiting 1
> > [  597.927350] barrier_waiting: nr_waiting 1
> > [  597.931841] barrier_waiting: nr_waiting 1
> > [  597.936322] barrier_waiting: nr_waiting 1
> > [  597.940805] barrier_waiting: nr_waiting 1
> > [  597.945284] barrier_waiting: nr_waiting 1
> > [  597.949766] barrier_waiting: nr_waiting 1
> > [  597.954246] barrier_waiting: nr_waiting 1
> > [  597.958726] barrier_waiting: nr_waiting 1
> > [  597.963205] barrier_waiting: nr_waiting 1
> > [  597.967683] barrier_waiting: nr_waiting 1
> > [  597.972163] barrier_waiting: nr_waiting 1
> > [  597.976641] barrier_waiting: nr_waiting 1
> > [  597.981119] barrier_waiting: nr_waiting 1
> > [  597.985601] barrier_waiting: nr_waiting 1
> > [  597.990082] barrier_waiting: nr_waiting 1
> > [  597.994562] barrier_waiting: nr_waiting 1
> > [  597.999043] barrier_waiting: nr_waiting 1
> > [  598.003522] barrier_waiting: nr_waiting 1
> > [  598.008000] barrier_waiting: nr_waiting 1
> > [  598.012485] barrier_waiting: nr_waiting 1
> > [  598.016964] barrier_waiting: nr_waiting 1
> > [  598.021451] barrier_waiting: nr_waiting 1
> > [  598.025931] barrier_waiting: nr_waiting 1
> > [  598.030409] barrier_waiting: nr_waiting 1
> > [  598.034888] barrier_waiting: nr_waiting 1
> > [  598.039368] barrier_waiting: nr_waiting 1
> > [  598.043848] barrier_waiting: nr_waiting 1
> > [  598.048325] barrier_waiting: nr_waiting 1
> > [  598.052805] barrier_waiting: nr_waiting 1
> > [  598.057283] barrier_waiting: nr_waiting 1
> > [  598.061767] barrier_waiting: nr_waiting 1
> > [  598.066246] barrier_waiting: nr_waiting 1
> > [  598.070726] barrier_waiting: nr_waiting 1
> > [  598.075206] barrier_waiting: nr_waiting 1
> > [  598.079689] barrier_waiting: nr_waiting 1
> > [  598.084170] barrier_waiting: nr_waiting 1
> > [  598.088648] barrier_waiting: nr_waiting 1
> > [  598.093130] barrier_waiting: nr_waiting 1
> > [  598.097646] barrier_waiting: nr_waiting 1
> > [  598.102126] barrier_waiting: nr_waiting 1
> > [  598.106605] barrier_waiting: nr_waiting 1
> > [  598.111085] barrier_waiting: nr_waiting 1
> > [  598.115566] barrier_waiting: nr_waiting 1
> > [  598.120043] barrier_waiting: nr_waiting 1
> > [  598.124522] barrier_waiting: nr_waiting 1
> > [  598.129001] barrier_waiting: nr_waiting 1
> > [  598.133481] barrier_waiting: nr_waiting 1
> > [  598.137958] barrier_waiting: nr_waiting 1
> > [  598.142442] barrier_waiting: nr_waiting 1
> > [  598.146921] barrier_waiting: nr_waiting 1
> > [  598.151400] barrier_waiting: nr_waiting 1
> > [  598.155878] barrier_waiting: nr_waiting 1
> > [  598.160359] barrier_waiting: nr_waiting 1
> > [  598.164838] barrier_waiting: nr_waiting 1
> > [  598.169319] barrier_waiting: nr_waiting 1
> > [  598.173803] barrier_waiting: nr_waiting 1
> > [  598.178282] barrier_waiting: nr_waiting 1
> > [  598.182762] barrier_waiting: nr_waiting 1
> > [  598.187241] barrier_waiting: nr_waiting 1
> > [  598.191722] barrier_waiting: nr_waiting 1
> > [  598.196201] barrier_waiting: nr_waiting 1
> > [  598.200678] barrier_waiting: nr_waiting 1
> > [  598.205159] barrier_waiting: nr_waiting 1
> > [  598.209640] barrier_waiting: nr_waiting 1
> > [  598.214120] barrier_waiting: nr_waiting 1
> > [  598.218599] barrier_waiting: nr_waiting 1
> > [  598.223078] barrier_waiting: nr_waiting 1
> > [  598.227557] barrier_waiting: nr_waiting 1
> > [  598.232036] barrier_waiting: nr_waiting 1
> > [  598.236519] barrier_waiting: nr_waiting 1
> > [  598.240999] barrier_waiting: nr_waiting 1
> > [  598.245478] barrier_waiting: nr_waiting 1
> > [  598.249959] barrier_waiting: nr_waiting 1
> > [  598.254439] barrier_waiting: nr_waiting 1
> > [  598.258917] barrier_waiting: nr_waiting 1
> > [  598.263397] barrier_waiting: nr_waiting 1
> > [  598.267880] barrier_waiting: nr_waiting 1
> > [  598.272362] barrier_waiting: nr_waiting 1
> > [  598.276842] barrier_waiting: nr_waiting 1
> > [  598.281322] barrier_waiting: nr_waiting 1
> > [  598.285802] barrier_waiting: nr_waiting 1
> > [  598.290281] barrier_waiting: nr_waiting 1
> > [  598.294758] barrier_waiting: nr_waiting 1
> > [  598.299256] barrier_waiting: nr_waiting 1
> > [  598.303737] barrier_waiting: nr_waiting 1
> > [  598.308219] barrier_waiting: nr_waiting 1
> > [  598.312698] barrier_waiting: nr_waiting 1
> > [  598.317176] barrier_waiting: nr_waiting 1
> > [  598.321659] barrier_waiting: nr_waiting 1
> > [  598.326138] barrier_waiting: nr_waiting 1
> > [  598.330617] barrier_waiting: nr_waiting 1
> > [  598.335100] barrier_waiting: nr_waiting 1
> > [  598.339580] barrier_waiting: nr_waiting 1
> > [  598.344057] barrier_waiting: nr_waiting 1
> > [  598.348536] barrier_waiting: nr_waiting 1
> > [  598.353016] barrier_waiting: nr_waiting 1
> > [  598.357496] barrier_waiting: nr_waiting 1
> > [  598.361973] barrier_waiting: nr_waiting 1
> > [  598.366453] barrier_waiting: nr_waiting 1
> > [  598.370932] barrier_waiting: nr_waiting 1
> > [  598.375412] barrier_waiting: nr_waiting 1
> > [  598.379890] barrier_waiting: nr_waiting 1
> > [  598.384371] barrier_waiting: nr_waiting 1
> > [  598.388856] barrier_waiting: nr_waiting 1
> > [  598.393326] barrier_waiting: nr_waiting 1
> > [  598.397805] barrier_waiting: nr_waiting 1
> > [  598.402288] barrier_waiting: nr_waiting 1
> > [  598.406772] barrier_waiting: nr_waiting 1
> > [  598.411251] barrier_waiting: nr_waiting 1
> > [  598.415729] barrier_waiting: nr_waiting 1
> > [  598.420209] barrier_waiting: nr_waiting 1
> > [  598.424686] barrier_waiting: nr_waiting 1
> > [  598.429165] barrier_waiting: nr_waiting 1
> > [  598.433644] barrier_waiting: nr_waiting 1
> > [  598.438125] barrier_waiting: nr_waiting 1
> > [  598.442604] barrier_waiting: nr_waiting 1
> > [  598.447083] barrier_waiting: nr_waiting 1
> > [  598.451571] barrier_waiting: nr_waiting 1
> > [  598.456050] barrier_waiting: nr_waiting 1
> > [  598.460531] barrier_waiting: nr_waiting 1
> > [  598.465010] barrier_waiting: nr_waiting 1
> > [  598.469498] barrier_waiting: nr_waiting 1
> > [  598.473981] barrier_waiting: nr_waiting 1
> > [  598.478460] barrier_waiting: nr_waiting 1
> > [  598.482940] barrier_waiting: nr_waiting 1
> > [  598.487421] barrier_waiting: nr_waiting 1
> > [  598.491901] barrier_waiting: nr_waiting 1
> > [  598.496382] barrier_waiting: nr_waiting 1
> > [  598.500860] barrier_waiting: nr_waiting 1
> > [  598.505338] barrier_waiting: nr_waiting 1
> > [  598.509837] barrier_waiting: nr_waiting 1
> > [  598.514317] barrier_waiting: nr_waiting 1
> > [  598.518797] barrier_waiting: nr_waiting 1
> > [  598.523276] barrier_waiting: nr_waiting 1
> > [  598.527756] barrier_waiting: nr_waiting 1
> > [  598.532241] barrier_waiting: nr_waiting 1
> > [  598.536719] barrier_waiting: nr_waiting 1
> > [  598.541199] barrier_waiting: nr_waiting 1
> > [  598.545679] barrier_waiting: nr_waiting 1
> > [  598.550159] barrier_waiting: nr_waiting 1
> > [  598.554639] barrier_waiting: nr_waiting 1
> > [  598.559118] barrier_waiting: nr_waiting 1
> > [  598.563597] barrier_waiting: nr_waiting 1
> > [  598.568077] barrier_waiting: nr_waiting 1
> > [  598.572561] barrier_waiting: nr_waiting 1
> > [  598.577038] barrier_waiting: nr_waiting 1
> > [  598.581517] barrier_waiting: nr_waiting 1
> > [  598.585995] barrier_waiting: nr_waiting 1
> > [  598.590475] barrier_waiting: nr_waiting 1
> > [  598.594953] barrier_waiting: nr_waiting 1
> > [  598.599434] barrier_waiting: nr_waiting 1
> > [  598.603913] barrier_waiting: nr_waiting 1
> > [  598.608392] barrier_waiting: nr_waiting 1
> > [  598.612871] barrier_waiting: nr_waiting 1
> > [  598.617349] barrier_waiting: nr_waiting 1
> > [  598.621828] barrier_waiting: nr_waiting 1
> > [  598.626308] barrier_waiting: nr_waiting 1
> > [  598.630787] barrier_waiting: nr_waiting 1
> > [  598.635272] barrier_waiting: nr_waiting 1
> > [  598.639753] barrier_waiting: nr_waiting 1
> > [  598.644231] barrier_waiting: nr_waiting 1
> > [  598.648712] barrier_waiting: nr_waiting 1
> > [  598.653192] barrier_waiting: nr_waiting 1
> > [  598.657671] barrier_waiting: nr_waiting 1
> > [  598.662150] barrier_waiting: nr_waiting 1
> > [  598.666630] barrier_waiting: nr_waiting 1
> > [  598.671111] barrier_waiting: nr_waiting 1
> > [  598.675589] barrier_waiting: nr_waiting 1
> > [  598.680068] barrier_waiting: nr_waiting 1
> > [  598.684547] barrier_waiting: nr_waiting 1
> > [  598.689024] barrier_waiting: nr_waiting 1
> > [  598.693501] barrier_waiting: nr_waiting 1
> > [  598.697982] barrier_waiting: nr_waiting 1
> > [  598.702462] barrier_waiting: nr_waiting 1
> > [  598.706945] barrier_waiting: nr_waiting 1
> > [  598.711425] barrier_waiting: nr_waiting 1
> > [  598.715989] barrier_waiting: nr_waiting 1
> > [  598.720523] barrier_waiting: nr_waiting 1
> > [  598.725014] barrier_waiting: nr_waiting 1
> > [  598.729500] barrier_waiting: nr_waiting 1
> > [  598.733983] barrier_waiting: nr_waiting 1
> > [  598.738465] barrier_waiting: nr_waiting 1
> > [  598.742947] barrier_waiting: nr_waiting 1
> > [  598.747426] barrier_waiting: nr_waiting 1
> > [  598.751909] barrier_waiting: nr_waiting 1
> > [  598.756390] barrier_waiting: nr_waiting 1
> > [  598.760869] barrier_waiting: nr_waiting 1
> > [  598.765360] barrier_waiting: nr_waiting 1
> > [  598.769839] barrier_waiting: nr_waiting 1
> > [  598.774318] barrier_waiting: nr_waiting 1
> > [  598.778801] barrier_waiting: nr_waiting 1
> > [  598.783280] barrier_waiting: nr_waiting 1
> > [  598.787758] barrier_waiting: nr_waiting 1
> > [  598.792242] barrier_waiting: nr_waiting 1
> > [  598.796723] barrier_waiting: nr_waiting 1
> > [  598.801200] barrier_waiting: nr_waiting 1
> > [  598.805688] barrier_waiting: nr_waiting 1
> > [  598.810166] barrier_waiting: nr_waiting 1
> > [  598.814646] barrier_waiting: nr_waiting 1
> > [  598.819126] barrier_waiting: nr_waiting 1
> > [  598.823606] barrier_waiting: nr_waiting 1
> > [  598.828086] barrier_waiting: nr_waiting 1
> > [  598.832574] barrier_waiting: nr_waiting 1
> > [  598.837052] barrier_waiting: nr_waiting 1
> > [  598.841531] barrier_waiting: nr_waiting 1
> > [  598.846012] barrier_waiting: nr_waiting 1
> > [  598.850491] barrier_waiting: nr_waiting 1
> > [  598.854969] barrier_waiting: nr_waiting 1
> > [  598.859456] barrier_waiting: nr_waiting 1
> > [  598.863934] barrier_waiting: nr_waiting 1
> > [  598.868412] barrier_waiting: nr_waiting 1
> > [  598.872895] barrier_waiting: nr_waiting 1
> > [  598.877374] barrier_waiting: nr_waiting 1
> > [  598.881853] barrier_waiting: nr_waiting 1
> > [  598.886334] barrier_waiting: nr_waiting 1
> > [  598.890813] barrier_waiting: nr_waiting 1
> > [  598.895293] barrier_waiting: nr_waiting 1
> > [  598.899774] barrier_waiting: nr_waiting 1
> > [  598.904253] barrier_waiting: nr_waiting 1
> > [  598.908735] barrier_waiting: nr_waiting 1
> > [  598.913215] barrier_waiting: nr_waiting 1
> > [  598.917694] barrier_waiting: nr_waiting 1
> > [  598.922173] barrier_waiting: nr_waiting 1
> > [  598.926663] barrier_waiting: nr_waiting 1
> > [  598.931153] barrier_waiting: nr_waiting 1
> > [  598.935638] barrier_waiting: nr_waiting 1
> > [  598.940115] barrier_waiting: nr_waiting 1
> > [  598.944599] barrier_waiting: nr_waiting 1
> > [  598.949080] barrier_waiting: nr_waiting 1
> > [  598.953561] barrier_waiting: nr_waiting 1
> > [  598.958042] barrier_waiting: nr_waiting 1
> > [  598.962523] barrier_waiting: nr_waiting 1
> > [  598.967006] barrier_waiting: nr_waiting 1
> > [  598.971486] barrier_waiting: nr_waiting 1
> > [  598.975965] barrier_waiting: nr_waiting 1
> > [  598.980446] barrier_waiting: nr_waiting 1
> > [  598.984923] barrier_waiting: nr_waiting 1
> > [  598.989408] barrier_waiting: nr_waiting 1
> > [  598.993890] barrier_waiting: nr_waiting 1
> > [  598.998367] barrier_waiting: nr_waiting 1
> > [  599.002844] barrier_waiting: nr_waiting 1
> > [  599.007328] barrier_waiting: nr_waiting 1
> > [  599.011800] barrier_waiting: nr_waiting 1
> > [  599.016278] barrier_waiting: nr_waiting 1
> > [  599.020756] barrier_waiting: nr_waiting 1
> > [  599.025241] barrier_waiting: nr_waiting 1
> > [  599.029720] barrier_waiting: nr_waiting 1
> > [  599.034199] barrier_waiting: nr_waiting 1
> > [  599.038682] barrier_waiting: nr_waiting 1
> > [  599.043161] barrier_waiting: nr_waiting 1
> > [  599.047641] barrier_waiting: nr_waiting 1
> > [  599.052120] barrier_waiting: nr_waiting 1
> > [  599.056601] barrier_waiting: nr_waiting 1
> > [  599.061082] barrier_waiting: nr_waiting 1
> > [  599.065567] barrier_waiting: nr_waiting 1
> > [  599.070045] barrier_waiting: nr_waiting 1
> > [  599.074522] barrier_waiting: nr_waiting 1
> > [  599.079006] barrier_waiting: nr_waiting 1
> > [  599.083486] barrier_waiting: nr_waiting 1
> > [  599.087968] barrier_waiting: nr_waiting 1
> > [  599.092448] barrier_waiting: nr_waiting 1
> > [  599.096929] barrier_waiting: nr_waiting 1
> > [  599.101407] barrier_waiting: nr_waiting 1
> > [  599.105886] barrier_waiting: nr_waiting 1
> > [  599.110366] barrier_waiting: nr_waiting 1
> > [  599.114850] barrier_waiting: nr_waiting 1
> > [  599.119332] barrier_waiting: nr_waiting 1
> > [  599.123809] barrier_waiting: nr_waiting 1
> > [  599.128293] barrier_waiting: nr_waiting 1
> > [  599.132765] barrier_waiting: nr_waiting 1
> > [  599.137242] barrier_waiting: nr_waiting 1
> > [  599.141723] barrier_waiting: nr_waiting 1
> > [  599.146203] barrier_waiting: nr_waiting 1
> > [  599.150682] barrier_waiting: nr_waiting 1
> > [  599.155165] barrier_waiting: nr_waiting 1
> > [  599.159644] barrier_waiting: nr_waiting 1
> > [  599.164124] barrier_waiting: nr_waiting 1
> > [  599.168603] barrier_waiting: nr_waiting 1
> > [  599.173080] barrier_waiting: nr_waiting 1
> > [  599.177564] barrier_waiting: nr_waiting 1
> > [  599.182043] barrier_waiting: nr_waiting 1
> > [  599.186525] barrier_waiting: nr_waiting 1
> > [  599.191008] barrier_waiting: nr_waiting 1
> > [  599.195488] barrier_waiting: nr_waiting 1
> > [  599.199967] barrier_waiting: nr_waiting 1
> > [  599.204448] barrier_waiting: nr_waiting 1
> > [  599.208928] barrier_waiting: nr_waiting 1
> > [  599.213408] barrier_waiting: nr_waiting 1
> > [  599.217890] barrier_waiting: nr_waiting 1
> > [  599.222370] barrier_waiting: nr_waiting 1
> > [  599.226850] barrier_waiting: nr_waiting 1
> > [  599.231329] barrier_waiting: nr_waiting 1
> > [  599.235811] barrier_waiting: nr_waiting 1
> > [  599.240289] barrier_waiting: nr_waiting 1
> > [  599.244767] barrier_waiting: nr_waiting 1
> > [  599.249247] barrier_waiting: nr_waiting 1
> > [  599.253731] barrier_waiting: nr_waiting 1
> > [  599.258212] barrier_waiting: nr_waiting 1
> > [  599.262691] barrier_waiting: nr_waiting 1
> > [  599.267170] barrier_waiting: nr_waiting 1
> > [  599.271650] barrier_waiting: nr_waiting 1
> > [  599.276128] barrier_waiting: nr_waiting 1
> > [  599.280606] barrier_waiting: nr_waiting 1
> > [  599.285084] barrier_waiting: nr_waiting 1
> > [  599.289569] barrier_waiting: nr_waiting 1
> > [  599.294040] barrier_waiting: nr_waiting 1
> > [  599.298522] barrier_waiting: nr_waiting 1
> > [  599.303006] barrier_waiting: nr_waiting 1
> > [  599.307483] barrier_waiting: nr_waiting 1
> > [  599.311961] barrier_waiting: nr_waiting 1
> > [  599.316442] barrier_waiting: nr_waiting 1
> > [  599.320923] barrier_waiting: nr_waiting 1
> > [  599.325403] barrier_waiting: nr_waiting 1
> > [  599.329884] barrier_waiting: nr_waiting 1
> > [  599.334363] barrier_waiting: nr_waiting 1
> > [  599.338842] barrier_waiting: nr_waiting 1
> > [  599.343322] barrier_waiting: nr_waiting 1
> > [  599.347801] barrier_waiting: nr_waiting 1
> > [  599.352282] barrier_waiting: nr_waiting 1
> > [  599.356762] barrier_waiting: nr_waiting 1
> > [  599.361246] barrier_waiting: nr_waiting 1
> > [  599.365727] barrier_waiting: nr_waiting 1
> > [  599.370206] barrier_waiting: nr_waiting 1
> > [  599.374685] barrier_waiting: nr_waiting 1
> > [  599.379166] barrier_waiting: nr_waiting 1
> > [  599.383647] barrier_waiting: nr_waiting 1
> > [  599.388125] barrier_waiting: nr_waiting 1
> > [  599.392605] barrier_waiting: nr_waiting 1
> > [  599.397083] barrier_waiting: nr_waiting 1
> > [  599.401562] barrier_waiting: nr_waiting 1
> > [  599.406044] barrier_waiting: nr_waiting 1
> > [  599.410525] barrier_waiting: nr_waiting 1
> > [  599.415008] barrier_waiting: nr_waiting 1
> > [  599.419486] barrier_waiting: nr_waiting 1
> > [  599.423968] barrier_waiting: nr_waiting 1
> > [  599.428446] barrier_waiting: nr_waiting 1
> > [  599.432924] barrier_waiting: nr_waiting 1
> > [  599.437409] barrier_waiting: nr_waiting 1
> > [  599.441890] barrier_waiting: nr_waiting 1
> > [  599.446373] barrier_waiting: nr_waiting 1
> > [  599.450859] barrier_waiting: nr_waiting 1
> > [  599.455337] barrier_waiting: nr_waiting 1
> > [  599.459819] barrier_waiting: nr_waiting 1
> > [  599.464306] barrier_waiting: nr_waiting 1
> > [  599.468783] barrier_waiting: nr_waiting 1
> > [  599.473262] barrier_waiting: nr_waiting 1
> > [  599.477744] barrier_waiting: nr_waiting 1
> > [  599.482224] barrier_waiting: nr_waiting 1
> > [  599.486704] barrier_waiting: nr_waiting 1
> > [  599.491190] barrier_waiting: nr_waiting 1
> > [  599.495670] barrier_waiting: nr_waiting 1
> > [  599.500150] barrier_waiting: nr_waiting 1
> > [  599.504629] barrier_waiting: nr_waiting 1
> > [  599.509106] barrier_waiting: nr_waiting 1
> > [  599.513588] barrier_waiting: nr_waiting 1
> > [  599.518072] barrier_waiting: nr_waiting 1
> > [  599.522552] barrier_waiting: nr_waiting 1
> > [  599.527030] barrier_waiting: nr_waiting 1
> > [  599.531509] barrier_waiting: nr_waiting 1
> > [  599.535988] barrier_waiting: nr_waiting 1
> > [  599.540470] barrier_waiting: nr_waiting 1
> > [  599.544955] barrier_waiting: nr_waiting 1
> > [  599.549426] barrier_waiting: nr_waiting 1
> > [  599.553904] barrier_waiting: nr_waiting 1
> > [  599.558384] barrier_waiting: nr_waiting 1
> > [  599.562863] barrier_waiting: nr_waiting 1
> > [  599.567342] barrier_waiting: nr_waiting 1
> > [  599.571820] barrier_waiting: nr_waiting 1
> > [  599.576298] barrier_waiting: nr_waiting 1
> > [  599.580779] barrier_waiting: nr_waiting 1
> > [  599.585254] wait_barrier: nr_pending: 1
> > [  599.589540] try_raise_barrier: nr_pending 1
> > [  599.589547] raid10_read_request: r10_bio ff3b41340eb53600 start
> > [  599.594209] try_raise_barrier: nr_pending 1
> > [  599.605582] try_raise_barrier: nr_pending 1
> > [  599.605674] allow_barrier: nr_pending: 0
> > [  599.610620] wait_barrier: nr_pending: 1
> > [  599.614653] raid_end_bio_io: r10_bio ff3b41340eb53600 done
> > [  599.618935] try_raise_barrier: nr_pending 1
> > [  599.618938] try_raise_barrier: nr_pending 1
> > [  599.618965] raid10_read_request: r10_bio ff3b4134184a6100 start
> > [  599.641092] try_raise_barrier: nr_pending 1
> > [  599.641145] allow_barrier: nr_pending: 0
> > [  599.646251] wait_barrier: nr_pending: 1
> > [  599.650157] raid_end_bio_io: r10_bio ff3b4134184a6100 done
> > [  599.654437] try_raise_barrier: nr_pending 1
> > [  599.654446] raid10_read_request: r10_bio ff3b41340eb53900 start
> > [  599.654575] allow_barrier: nr_pending: 0
> > [  599.654583] raid_end_bio_io: r10_bio ff3b41340eb53900 done
> > [  599.682715] wait_barrier: nr_pending: 1
> > [  599.687000] try_raise_barrier: nr_pending 1
> > [  599.687012] raid10_read_request: r10_bio ff3b41340eb52d00 start
> > [  599.691672] try_raise_barrier: nr_pending 1
> > [  599.703020] try_raise_barrier: nr_pending 1
> > [  599.703069] allow_barrier: nr_pending: 0
> > [  599.708037] wait_barrier: nr_pending: 1
> > [  599.712092] raid_end_bio_io: r10_bio ff3b41340eb52d00 done
> > [  599.716368] try_raise_barrier: nr_pending 1
> > [  599.716372] try_raise_barrier: nr_pending 1
> > [  599.716377] raid10_read_request: r10_bio ff3b41340eb53900 start
> > [  599.738510] try_raise_barrier: nr_pending 1
> > [  599.738554] allow_barrier: nr_pending: 0
> > [  599.743663] wait_barrier: nr_pending: 1
> > [  599.747583] raid_end_bio_io: r10_bio ff3b41340eb53900 done
> > [  599.751853] try_raise_barrier: nr_pending 1
> > [  599.751857] try_raise_barrier: nr_pending 1
> > [  599.751864] raid10_read_request: r10_bio ff3b41340eb53600 start
> > [  599.773945] try_raise_barrier: nr_pending 1
> > [  599.774058] allow_barrier: nr_pending: 0
> > [  599.779116] wait_barrier: nr_pending: 1
> > [  599.783020] raid_end_bio_io: r10_bio ff3b41340eb53600 done
> > [  599.787298] try_raise_barrier: nr_pending 1
> > [  599.787307] raid10_read_request: r10_bio ff3b41340eb53900 start
> > [  599.787461] allow_barrier: nr_pending: 0
> > [  599.787469] raid_end_bio_io: r10_bio ff3b41340eb53900 done
> > [  599.815585] wait_barrier: nr_pending: 1
> > [  599.819872] try_raise_barrier: nr_pending 1
> > [  599.819883] raid10_read_request: r10_bio ff3b41340eb52d00 start
> > [  599.824546] try_raise_barrier: nr_pending 1
> > [  599.835892] try_raise_barrier: nr_pending 1
> > [  599.835904] allow_barrier: nr_pending: 0
> > [  599.840922] wait_barrier: nr_pending: 1
> > [  599.844957] raid_end_bio_io: r10_bio ff3b41340eb52d00 done
> > [  599.849235] try_raise_barrier: nr_pending 1
> > [  599.849239] try_raise_barrier: nr_pending 1
> > [  599.849244] raid10_read_request: r10_bio ff3b41340eb53600 start
> > [  599.871381] try_raise_barrier: nr_pending 1
> > [  599.871463] allow_barrier: nr_pending: 0
> > [  599.876542] wait_barrier: nr_pending: 1
> > [  599.880451] raid_end_bio_io: r10_bio ff3b41340eb53600 done
> > [  599.884730] try_raise_barrier: nr_pending 1
> > [  599.884735] try_raise_barrier: nr_pending 1
> > [  599.884740] raid10_read_request: r10_bio ff3b41340eb53900 start
> > [  599.884889] allow_barrier: nr_pending: 0
> > [  599.884897] raid_end_bio_io: r10_bio ff3b41340eb53900 done
> > [  599.917789] wait_barrier: nr_pending: 1
> > [  599.922088] raid10_read_request: r10_bio ff3b41340eb53900 start
> > [  599.922159] try_raise_barrier: nr_pending 1
> > [  599.928829] allow_barrier: nr_pending: 0
> > [  599.933736] wait_barrier: nr_pending: 1
> > [  599.937771] raid_end_bio_io: r10_bio ff3b41340eb53900 done
> > [  599.942045] try_raise_barrier: nr_pending 1
> > [  599.942049] try_raise_barrier: nr_pending 1
> > [  599.942058] raid10_read_request: r10_bio ff3b41340eb52d00 start
> > [  599.964202] try_raise_barrier: nr_pending 1
> > [  599.964262] allow_barrier: nr_pending: 0
> > [  599.969461] wait_barrier: nr_pending: 1
> > [  599.973275] raid_end_bio_io: r10_bio ff3b41340eb52d00 done
> > [  599.977553] try_raise_barrier: nr_pending 1
> > [  599.977559] try_raise_barrier: nr_pending 1
> > [  599.977562] raid10_read_request: r10_bio ff3b41340eb53900 start
> > [  599.977715] allow_barrier: nr_pending: 0
> > [  599.977723] raid_end_bio_io: r10_bio ff3b41340eb53900 done
> > [  600.010600] wait_barrier: nr_pending: 1
> > [  600.014887] try_raise_barrier: nr_pending 1
> > [  600.014898] raid10_read_request: r10_bio ff3b41340eb53600 start
> > [  600.019559] try_raise_barrier: nr_pending 1
> > [  600.030909] try_raise_barrier: nr_pending 1
> > [  600.030917] allow_barrier: nr_pending: 0
> > [  600.036049] wait_barrier: nr_pending: 1
> > [  600.039974] raid_end_bio_io: r10_bio ff3b41340eb53600 done
> > [  600.044253] try_raise_barrier: nr_pending 1
> > [  600.044257] try_raise_barrier: nr_pending 1
> > [  600.044263] raid10_read_request: r10_bio ff3b41340eb52d00 start
> > [  600.066363] try_raise_barrier: nr_pending 1
> > [  600.066461] allow_barrier: nr_pending: 0
> > [  600.071440] wait_barrier: nr_pending: 1
> > [  600.075443] raid_end_bio_io: r10_bio ff3b41340eb52d00 done
> > [  600.079722] try_raise_barrier: nr_pending 1
> > [  600.079727] try_raise_barrier: nr_pending 1
> > [  600.079731] raid10_read_request: r10_bio ff3b41340eb53900 start
> > [  600.079868] allow_barrier: nr_pending: 0
> > [  600.079875] raid_end_bio_io: r10_bio ff3b41340eb53900 done
> > [  600.112682] wait_barrier: nr_pending: 1
> > [  600.116967] try_raise_barrier: nr_pending 1
> > [  600.116978] raid10_read_request: r10_bio ff3b41340eb53900 start
> > [  600.121640] try_raise_barrier: nr_pending 1
> > [  600.132990] try_raise_barrier: nr_pending 1
> > [  600.133057] allow_barrier: nr_pending: 0
> > [  600.138070] wait_barrier: nr_pending: 1
> > [  600.142062] raid_end_bio_io: r10_bio ff3b41340eb53900 done
> > [  600.146337] try_raise_barrier: nr_pending 1
> > [  600.146342] try_raise_barrier: nr_pending 1
> > [  600.146348] raid10_read_request: r10_bio ff3b41340eb53600 start
> > [  600.168487] try_raise_barrier: nr_pending 1
> > [  600.168532] allow_barrier: nr_pending: 0
> > [  600.173662] wait_barrier: nr_pending: 1
> > [  600.177563] raid_end_bio_io: r10_bio ff3b41340eb53600 done
> > [  600.181840] try_raise_barrier: nr_pending 1
> > [  600.181845] try_raise_barrier: nr_pending 1
> > [  600.181849] raid10_read_request: r10_bio ff3b41340eb53900 start
> > [  600.181983] allow_barrier: nr_pending: 0
> > [  600.181991] raid_end_bio_io: r10_bio ff3b41340eb53900 done
> > [  600.214790] wait_barrier: nr_pending: 1
> > [  600.219075] try_raise_barrier: nr_pending 1
> > [  600.219087] raid10_read_request: r10_bio ff3b41340eb52d00 start
> > [  600.223748] try_raise_barrier: nr_pending 1
> > [  600.235099] try_raise_barrier: nr_pending 1
> > [  600.235150] allow_barrier: nr_pending: 0
> > [  600.240130] wait_barrier: nr_pending: 1
> > [  600.244170] raid_end_bio_io: r10_bio ff3b41340eb52d00 done
> > [  600.248446] try_raise_barrier: nr_pending 1
> > [  600.248450] try_raise_barrier: nr_pending 1
> > [  600.248456] raid10_read_request: r10_bio ff3b41340eb53600 start
> > [  600.270600] try_raise_barrier: nr_pending 1
> > [  600.270648] allow_barrier: nr_pending: 0
> > [  600.275752] wait_barrier: nr_pending: 1
> > [  600.279676] raid_end_bio_io: r10_bio ff3b41340eb53600 done
> > [  600.283952] try_raise_barrier: nr_pending 1
> > [  600.283956] try_raise_barrier: nr_pending 1
> > [  600.283961] raid10_read_request: r10_bio ff3b41340eb53900 start
> > [  600.284093] allow_barrier: nr_pending: 0
> > [  600.284100] raid_end_bio_io: r10_bio ff3b41340eb53900 done
> > [  600.316975] wait_barrier: nr_pending: 1
> > [  600.321262] try_raise_barrier: nr_pending 1
> > [  600.321273] raid10_read_request: r10_bio ff3b41340eb53900 start
> > [  600.325936] try_raise_barrier: nr_pending 1
> > [  600.337279] allow_barrier: nr_pending: 0
> > [  600.337649] wait_barrier: nr_pending: 1
> > [  600.341674] raid_end_bio_io: r10_bio ff3b41340eb53900 done
> > [  600.345947] try_raise_barrier: nr_pending 1
> > [  600.345951] try_raise_barrier: nr_pending 1
> > [  600.345958] raid10_read_request: r10_bio ff3b41340eb52d00 start
> > [  600.368088] try_raise_barrier: nr_pending 1
> > [  600.368129] allow_barrier: nr_pending: 0
> > [  600.373070] wait_barrier: nr_pending: 1
> > [  600.377153] raid_end_bio_io: r10_bio ff3b41340eb52d00 done
> > [  600.381430] try_raise_barrier: nr_pending 1
> > [  600.381434] raid10_read_request: r10_bio ff3b41340eb53900 start
> > [  600.381555] allow_barrier: nr_pending: 0
> > [  600.381562] raid_end_bio_io: r10_bio ff3b41340eb53900 done
> > [  600.409730] wait_barrier: nr_pending: 1
> > [  600.414012] try_raise_barrier: nr_pending 1
> > [  600.414015] raid10_read_request: r10_bio ff3b41340eb53600 start
> > [  600.418685] try_raise_barrier: nr_pending 1
> > [  600.430034] try_raise_barrier: nr_pending 1
> > [  600.430085] allow_barrier: nr_pending: 0
> > [  600.435126] wait_barrier: nr_pending: 1
> > [  600.439107] raid_end_bio_io: r10_bio ff3b41340eb53600 done
> > [  600.443388] raid10_read_request: r10_bio ff3b41340eb52d00 start
> > [  600.443462] try_raise_barrier: nr_pending 1
> > [  600.443466] try_raise_barrier: nr_pending 1
> > [  600.465548] try_raise_barrier: nr_pending 1
> > [  600.465585] allow_barrier: nr_pending: 0
> > [  600.470613] wait_barrier: nr_pending: 1
> > [  600.474627] raid_end_bio_io: r10_bio ff3b41340eb52d00 done
> > [  600.478903] try_raise_barrier: nr_pending 1
> > [  600.478910] try_raise_barrier: nr_pending 1
> > [  600.478912] raid10_read_request: r10_bio ff3b41340eb53900 start
> > [  600.479045] allow_barrier: nr_pending: 0
> > [  600.479053] raid_end_bio_io: r10_bio ff3b41340eb53900 done
> > [  600.511838] wait_barrier: nr_pending: 1
> > [  600.516124] try_raise_barrier: nr_pending 1
> > [  600.516135] raid10_read_request: r10_bio ff3b41340eb53900 start
> > [  600.520797] try_raise_barrier: nr_pending 1
> > [  600.532156] try_raise_barrier: nr_pending 1
> > [  600.532225] allow_barrier: nr_pending: 0
> > [  600.537288] wait_barrier: nr_pending: 1
> > [  600.541229] raid_end_bio_io: r10_bio ff3b41340eb53900 done
> > [  600.545505] try_raise_barrier: nr_pending 1
> > [  600.545509] try_raise_barrier: nr_pending 1
> > [  600.545515] raid10_read_request: r10_bio ff3b41340eb53600 start
> > [  600.567662] try_raise_barrier: nr_pending 1
> > [  600.567696] allow_barrier: nr_pending: 0
> > [  600.572778] wait_barrier: nr_pending: 1
> > [  600.576742] raid_end_bio_io: r10_bio ff3b41340eb53600 done
> > [  600.581017] try_raise_barrier: nr_pending 1
> > [  600.581023] try_raise_barrier: nr_pending 1
> > [  600.581028] raid10_read_request: r10_bio ff3b41340eb53900 start
> > [  600.581145] allow_barrier: nr_pending: 0
> > [  600.581152] raid_end_bio_io: r10_bio ff3b41340eb53900 done
> > [  600.613893] wait_barrier: nr_pending: 1
> > [  600.618178] try_raise_barrier: nr_pending 1
> > [  600.618188] raid10_read_request: r10_bio ff3b41340eb52d00 start
> > [  600.622851] try_raise_barrier: nr_pending 1
> > [  600.634242] try_raise_barrier: nr_pending 1
> > [  600.634317] allow_barrier: nr_pending: 0
> > [  600.639159] wait_barrier: nr_pending: 1
> > [  600.643299] raid_end_bio_io: r10_bio ff3b41340eb52d00 done
> > [  600.647575] try_raise_barrier: nr_pending 1
> > [  600.647579] raid10_read_request: r10_bio ff3b41340eb53600 start
> > [  600.647579] try_raise_barrier: nr_pending 1
> > [  600.647633] allow_barrier: nr_pending: 0
> > [  600.647637] raid_end_bio_io: r10_bio ff3b41340eb53600 done
> > [  600.680526] wait_barrier: nr_pending: 1
> > [  600.684819] try_raise_barrier: nr_pending 1
> > [  600.684841] raid10_read_request: r10_bio ff3b41340eb53900 start
> > [  600.689492] try_raise_barrier: nr_pending 1
> > [  600.700853] try_raise_barrier: nr_pending 1
> > [  600.700910] allow_barrier: nr_pending: 0
> > [  600.706030] wait_barrier: nr_pending: 1
> > [  600.709914] raid_end_bio_io: r10_bio ff3b41340eb53900 done
> > [  600.714193] try_raise_barrier: nr_pending 1
> > [  600.714197] try_raise_barrier: nr_pending 1
> > [  600.714205] raid10_read_request: r10_bio ff3b4134184a6100 start
> > [  600.714376] allow_barrier: nr_pending: 0
> > [  600.714383] raid_end_bio_io: r10_bio ff3b4134184a6100 done
> > [  600.747144] wait_barrier: nr_pending: 1
> > [  600.751430] try_raise_barrier: nr_pending 1
> > [  600.751442] raid10_read_request: r10_bio ff3b4134184a6b00 start
> > [  600.756102] try_raise_barrier: nr_pending 1
> > [  600.767448] try_raise_barrier: nr_pending 1
> > [  600.767537] allow_barrier: nr_pending: 0
> > [  600.772502] wait_barrier: nr_pending: 1
> > [  600.776516] raid_end_bio_io: r10_bio ff3b4134184a6b00 done
> > [  600.780795] try_raise_barrier: nr_pending 1
> > [  600.780799] try_raise_barrier: nr_pending 1
> > [  600.780808] raid10_read_request: r10_bio ff3b4134184a7f00 start
> > [  600.802876] try_raise_barrier: nr_pending 1
> > [  600.803016] allow_barrier: nr_pending: 0
> > [  600.808000] wait_barrier: nr_pending: 1
> > [  600.811943] raid_end_bio_io: r10_bio ff3b4134184a7f00 done
> > [  600.816225] try_raise_barrier: nr_pending 1
> > [  600.816229] try_raise_barrier: nr_pending 1
> > [  600.816245] raid10_read_request: r10_bio ff3b4134184a7400 start
> > [  600.838385] try_raise_barrier: nr_pending 1
> > [  600.838448] allow_barrier: nr_pending: 0
> > [  600.843556] wait_barrier: nr_pending: 1
> > [  600.847451] raid_end_bio_io: r10_bio ff3b4134184a7400 done
> > [  600.851722] try_raise_barrier: nr_pending 1
> > [  600.851726] try_raise_barrier: nr_pending 1
> > [  600.851732] raid10_read_request: r10_bio ff3b41340eb53900 start
> > [  600.851897] allow_barrier: nr_pending: 0
> > [  600.851904] raid_end_bio_io: r10_bio ff3b41340eb53900 done
> > [  600.884632] wait_barrier: nr_pending: 1
> > [  600.888917] try_raise_barrier: nr_pending 1
> > [  600.888929] raid10_read_request: r10_bio ff3b41340eb53900 start
> > [  600.893588] try_raise_barrier: nr_pending 1
> > [  600.904881] try_raise_barrier: nr_pending 1
> > [  600.905028] allow_barrier: nr_pending: 0
> > [  600.909930] wait_barrier: nr_pending: 1
> > [  600.913958] raid_end_bio_io: r10_bio ff3b41340eb53900 done
> > [  600.918233] try_raise_barrier: nr_pending 1
> > [  600.918237] try_raise_barrier: nr_pending 1
> > [  600.918245] raid10_read_request: r10_bio ff3b41340eb52d00 start
> > [  600.940401] try_raise_barrier: nr_pending 1
> > [  600.940502] allow_barrier: nr_pending: 0
> > [  600.945589] wait_barrier: nr_pending: 1
> > [  600.949477] raid_end_bio_io: r10_bio ff3b41340eb52d00 done
> > [  600.953755] try_raise_barrier: nr_pending 1
> > [  600.953760] try_raise_barrier: nr_pending 1
> > [  600.953765] raid10_read_request: r10_bio ff3b41340eb53600 start
> > [  600.953893] allow_barrier: nr_pending: 0
> > [  600.953901] raid_end_bio_io: r10_bio ff3b41340eb53600 done
> > [  600.986653] wait_barrier: nr_pending: 1
> > [  600.990939] try_raise_barrier: nr_pending 1
> > [  600.990949] raid10_read_request: r10_bio ff3b41340eb53900 start
> > [  600.995611] try_raise_barrier: nr_pending 1
> > [  601.006963] try_raise_barrier: nr_pending 1
> > [  601.007109] allow_barrier: nr_pending: 0
> > [  601.011808] wait_barrier: nr_pending: 1
> > [  601.016031] raid_end_bio_io: r10_bio ff3b41340eb53900 done
> > [  601.020309] try_raise_barrier: nr_pending 1
> > [  601.020313] try_raise_barrier: nr_pending 1
> > [  601.020319] raid10_read_request: r10_bio ff3b41340eb52d00 start
> > [  601.042453] allow_barrier: nr_pending: 0
> > [  601.042803] wait_barrier: nr_pending: 1
> > [  601.046853] raid_end_bio_io: r10_bio ff3b41340eb52d00 done
> > [  601.051120] try_raise_barrier: nr_pending 1
> > [  601.051125] raid10_read_request: r10_bio ff3b41340eb53600 start
> > [  601.051126] try_raise_barrier: nr_pending 1
> > [  601.051145] try_raise_barrier: nr_pending 1
> > [  601.051415] allow_barrier: nr_pending: 0
> > [  601.051422] raid_end_bio_io: r10_bio ff3b41340eb53600 done
> > [  601.088815] wait_barrier: nr_pending: 1
> > [  601.093099] try_raise_barrier: nr_pending 1
> > [  601.093111] raid10_read_request: r10_bio ff3b41340eb53900 start
> > [  601.097772] try_raise_barrier: nr_pending 1
> > [  601.109103] try_raise_barrier: nr_pending 1
> > [  601.109172] allow_barrier: nr_pending: 0
> > [  601.114259] wait_barrier: nr_pending: 1
> > [  601.118177] raid_end_bio_io: r10_bio ff3b41340eb53900 done
> > [  601.122446] try_raise_barrier: nr_pending 1
> > [  601.122450] try_raise_barrier: nr_pending 1
> > [  601.122459] raid10_read_request: r10_bio ff3b41340eb52d00 start
> > [  601.144607] try_raise_barrier: nr_pending 1
> > [  601.144650] allow_barrier: nr_pending: 0
> > [  601.149688] wait_barrier: nr_pending: 1
> > [  601.153683] raid_end_bio_io: r10_bio ff3b41340eb52d00 done
> > [  601.157960] try_raise_barrier: nr_pending 1
> > [  601.157964] try_raise_barrier: nr_pending 1
> > [  601.157970] raid10_read_request: r10_bio ff3b41340eb53600 start
> > [  601.180129] try_raise_barrier: nr_pending 1
> > [  601.180240] allow_barrier: nr_pending: 0
> > [  601.185207] wait_barrier: nr_pending: 1
> > [  601.189209] raid_end_bio_io: r10_bio ff3b41340eb53600 done
> > [  601.193485] try_raise_barrier: nr_pending 1
> > [  601.193497] raid10_read_request: r10_bio ff3b41340eb52d00 start
> > [  601.193706] allow_barrier: nr_pending: 0
> > [  601.193714] raid_end_bio_io: r10_bio ff3b41340eb52d00 done
> > [  601.221868] wait_barrier: nr_pending: 1
> > [  601.226153] try_raise_barrier: nr_pending 1
> > [  601.226164] raid10_read_request: r10_bio ff3b41340eb53900 start
> > [  601.230826] try_raise_barrier: nr_pending 1
> > [  601.242175] try_raise_barrier: nr_pending 1
> > [  601.242239] allow_barrier: nr_pending: 0
> > [  601.247321] wait_barrier: nr_pending: 1
> > [  601.251249] raid_end_bio_io: r10_bio ff3b41340eb53900 done
> > [  601.255526] try_raise_barrier: nr_pending 1
> > [  601.255530] try_raise_barrier: nr_pending 1
> > [  601.255536] raid10_read_request: r10_bio ff3b41340eb53600 start
> > [  601.277688] try_raise_barrier: nr_pending 1
> > [  601.277818] allow_barrier: nr_pending: 0
> > [  601.282730] wait_barrier: nr_pending: 1
> > [  601.286761] raid_end_bio_io: r10_bio ff3b41340eb53600 done
> > [  601.291037] try_raise_barrier: nr_pending 1
> > [  601.291043] try_raise_barrier: nr_pending 1
> > [  601.291047] raid10_read_request: r10_bio ff3b41340eb52d00 start
> > [  601.313190] try_raise_barrier: nr_pending 1
> > [  601.313248] allow_barrier: nr_pending: 0
> > [  601.318267] wait_barrier: nr_pending: 1
> > [  601.322269] raid_end_bio_io: r10_bio ff3b41340eb52d00 done
> > [  601.326544] try_raise_barrier: nr_pending 1
> > [  601.326551] try_raise_barrier: nr_pending 1
> > [  601.326556] raid10_read_request: r10_bio ff3b41340eb53600 start
> > [  601.326708] allow_barrier: nr_pending: 0
> > [  601.326716] raid_end_bio_io: r10_bio ff3b41340eb53600 done
> > [  601.359595] wait_barrier: nr_pending: 1
> > [  601.363882] try_raise_barrier: nr_pending 1
> > [  601.363893] raid10_read_request: r10_bio ff3b41340eb53900 start
> > [  601.368556] try_raise_barrier: nr_pending 1
> > [  601.379906] try_raise_barrier: nr_pending 1
> > [  601.379973] allow_barrier: nr_pending: 0
> > [  601.385040] wait_barrier: nr_pending: 1
> > [  601.388979] raid_end_bio_io: r10_bio ff3b41340eb53900 done
> > [  601.393255] try_raise_barrier: nr_pending 1
> > [  601.393260] try_raise_barrier: nr_pending 1
> > [  601.393268] raid10_read_request: r10_bio ff3b41340eb52d00 start
> > [  601.415361] try_raise_barrier: nr_pending 1
> > [  601.415483] allow_barrier: nr_pending: 0
> > [  601.420443] wait_barrier: nr_pending: 1
> > [  601.424436] raid_end_bio_io: r10_bio ff3b41340eb52d00 done
> > [  601.428713] try_raise_barrier: nr_pending 1
> > [  601.428716] try_raise_barrier: nr_pending 1
> > [  601.428723] raid10_read_request: r10_bio ff3b41340eb53600 start
> > [  601.450871] try_raise_barrier: nr_pending 1
> > [  601.450916] allow_barrier: nr_pending: 0
> > [  601.455878] wait_barrier: nr_pending: 1
> > [  601.459951] raid_end_bio_io: r10_bio ff3b41340eb53600 done
> > [  601.464227] try_raise_barrier: nr_pending 1
> > [  601.464231] raid10_read_request: r10_bio ff3b41340eb52d00 start
> > [  601.481634] try_raise_barrier: nr_pending 1
> > [  601.486439] allow_barrier: nr_pending: 0
> > [  601.486947] wait_barrier: nr_pending: 1
> > [  601.490841] raid_end_bio_io: r10_bio ff3b41340eb52d00 done
> > [  601.495112] try_raise_barrier: nr_pending 1
> > [  601.495116] try_raise_barrier: nr_pending 1
> > [  601.495122] raid10_read_request: r10_bio ff3b41340eb53900 start
> > [  601.517260] try_raise_barrier: nr_pending 1
> > [  601.517346] allow_barrier: nr_pending: 0
> > [  601.522456] wait_barrier: nr_pending: 1
> > [  601.526326] raid_end_bio_io: r10_bio ff3b41340eb53900 done
> > [  601.530603] try_raise_barrier: nr_pending 1
> > [  601.530608] try_raise_barrier: nr_pending 1
> > [  601.530612] raid10_write_request: r10_bio ff3b41340eb52d00 start
> > [  601.552782] try_raise_barrier: nr_pending 1
>
> Thanks for the test!
>
> Now the problem is clear. r10_bio is generated and never complete, while
> IO never issued to underlying loop device, and I can reporduce this
> problem as well now.
>
> The blamed commit from git bisect is correct, and there are two
> conditions for this problem:
>
> 1) plug is not used for caller;
> 2) for raid1/raid10, bio plug is enabled;
>
> __submit_bio_noacct
>   current->bio_list =3D ...;
>   blk_start_plug
>
>    dm_submit_bio
>     md_handle_request
>      raid10_write_request
>       -> generate new bio for underlying disks
>       raid1_add_bio_to_plug -> bio added to plug
>
>   blk_finish_plug
>    raid10_unplug
>     raid1_submit_write
>      submit_bio_noacct
>       if (current->bio_list)
>        -> bio_list is not empty
>        bio_list_add(&current->bio_list[0], bio)
>
>   current->bio_list =3D NULL
>   -> the bio is in bio_list, and it's dropped.
>
> Can you give the following patch a test? It should be a final test...

Hi=EF=BC=8CKuai

yeah, I would like to testing the fix patch=EF=BC=8Cbut I hit the patching
issue with new patch=EF=BC=9A
```
patching file block/blk-core.c
patch: **** malformed patch at line 6: blk_check_zone_append(struct
request_queue *q,
```
I don=E2=80=99t know if it is caused by a format error.
please add the patch as an attachment, just like the debuginfo patch
you gave me this morning.

Thanks=EF=BC=8C
Changhui


>
> Thanks,
> Kuai
>
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 01186333c88e..1e9208024e47 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -613,9 +613,13 @@ static inline blk_status_t
> blk_check_zone_append(struct request_queue *q,
>
>   static void __submit_bio(struct bio *bio)
>   {
> +       struct blk_plug plug;
> +
>          if (unlikely(!blk_crypto_bio_prep(&bio)))
>                  return;
>
> +       blk_start_plug(&plug);
> +
>          if (!bio->bi_bdev->bd_has_submit_bio) {
>                  blk_mq_submit_bio(bio);
>          } else if (likely(bio_queue_enter(bio) =3D=3D 0)) {
> @@ -624,6 +628,8 @@ static void __submit_bio(struct bio *bio)
>                  disk->fops->submit_bio(bio);
>                  blk_queue_exit(disk->queue);
>          }
> +
> +       blk_finish_plug(&plug);
>   }
>
>   /*
> @@ -648,13 +654,11 @@ static void __submit_bio(struct bio *bio)
>   static void __submit_bio_noacct(struct bio *bio)
>   {
>          struct bio_list bio_list_on_stack[2];
> -       struct blk_plug plug;
>
>          BUG_ON(bio->bi_next);
>
>          bio_list_init(&bio_list_on_stack[0]);
>          current->bio_list =3D bio_list_on_stack;
> -       blk_start_plug(&plug);
>
>          do {
>                  struct request_queue *q =3D bdev_get_queue(bio->bi_bdev)=
;
> @@ -688,23 +692,19 @@ static void __submit_bio_noacct(struct bio *bio)
>                  bio_list_merge(&bio_list_on_stack[0],
> &bio_list_on_stack[1]);
>          } while ((bio =3D bio_list_pop(&bio_list_on_stack[0])));
>
> -       blk_finish_plug(&plug);
>          current->bio_list =3D NULL;
>   }
>
>   static void __submit_bio_noacct_mq(struct bio *bio)
>   {
>          struct bio_list bio_list[2] =3D { };
> -       struct blk_plug plug;
>
>          current->bio_list =3D bio_list;
> -       blk_start_plug(&plug);
>
>          do {
>                  __submit_bio(bio);
>          } while ((bio =3D bio_list_pop(&bio_list[0])));
>
> -       blk_finish_plug(&plug);
>          current->bio_list =3D NULL;
>   }
>
> > [  737.970751] INFO: task mdX_resync:3115 blocked for more than 122 sec=
onds.
> > [  737.978361]       Not tainted 6.9.0+ #1
> > [  737.982654] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> > disables this message.
> > [  737.991398] task:mdX_resync      state:D stack:0     pid:3115
> > tgid:3115  ppid:2      flags:0x00004000
> > [  737.991407] Call Trace:
> > [  737.991410]  <TASK>
> > [  737.991414]  __schedule+0x222/0x670
> > [  737.991426]  schedule+0x2c/0xb0
> > [  737.991434]  raise_barrier+0xca/0x1a0 [raid10]
> > [  737.991450]  ? __pfx_autoremove_wake_function+0x10/0x10
> > [  737.991459]  raid10_sync_request+0x2c3/0x19d0 [raid10]
> > [  737.991472]  ? __switch_to_asm+0x39/0x70
> > [  737.991478]  ? finish_task_switch.isra.0+0x8e/0x2a0
> > [  737.991487]  ? __schedule+0x22a/0x670
> > [  737.991491]  ? prepare_to_wait_event+0x5f/0x190
> > [  737.991498]  md_do_sync+0x660/0x1040
> > [  737.991508]  ? __pfx_autoremove_wake_function+0x10/0x10
> > [  737.991517]  md_thread+0xad/0x160
> > [  737.991521]  ? __pfx_md_thread+0x10/0x10
> > [  737.991524]  kthread+0xdc/0x110
> > [  737.991531]  ? __pfx_kthread+0x10/0x10
> > [  737.991535]  ret_from_fork+0x2d/0x50
> > [  737.991544]  ? __pfx_kthread+0x10/0x10
> > [  737.991547]  ret_from_fork_asm+0x1a/0x30
> > [  737.991553]  </TASK>
> > [  860.850998] INFO: task mdX_resync:3115 blocked for more than 245 sec=
onds.
> > [  860.858606]       Not tainted 6.9.0+ #1
> > [  860.862902] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> > disables this message.
> > [  860.871649] task:mdX_resync      state:D stack:0     pid:3115
> > tgid:3115  ppid:2      flags:0x00004000
> > [  860.871658] Call Trace:
> > [  860.871660]  <TASK>
> > [  860.871664]  __schedule+0x222/0x670
> > [  860.871674]  schedule+0x2c/0xb0
> > [  860.871681]  raise_barrier+0xca/0x1a0 [raid10]
> > [  860.871696]  ? __pfx_autoremove_wake_function+0x10/0x10
> > [  860.871704]  raid10_sync_request+0x2c3/0x19d0 [raid10]
> > [  860.871717]  ? __switch_to_asm+0x39/0x70
> > [  860.871722]  ? finish_task_switch.isra.0+0x8e/0x2a0
> > [  860.871729]  ? __schedule+0x22a/0x670
> > [  860.871733]  ? prepare_to_wait_event+0x5f/0x190
> > [  860.871740]  md_do_sync+0x660/0x1040
> > [  860.871748]  ? __pfx_autoremove_wake_function+0x10/0x10
> > [  860.871756]  md_thread+0xad/0x160
> > [  860.871761]  ? __pfx_md_thread+0x10/0x10
> > [  860.871765]  kthread+0xdc/0x110
> > [  860.871770]  ? __pfx_kthread+0x10/0x10
> > [  860.871774]  ret_from_fork+0x2d/0x50
> > [  860.871781]  ? __pfx_kthread+0x10/0x10
> > [  860.871785]  ret_from_fork_asm+0x1a/0x30
> > [  860.871790]  </TASK>
> >
> > Thanks,
> > Changhui
> >
> > .
> >
>


--=20

Changhui  Zhong

Quality Engineer,Kernel QE

Red Hat

Red Hat Beijing - Raycom


Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 781DF191
	for <dm-devel@lists.linux.dev>; Thu, 15 May 2025 13:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747316297; cv=none; b=a1Zct0dXSYmDC00619xth+213uungE6hdvHfV4kXviqIQQmPR9vzxOhknWxylmZSf3RmMB+hiCIeQIqM7+68yA6yvITWut5pSYx7ONorJ+SGAFrlBdToFU781FodwbL6rt5kMFIlvsvTB5JBWktAErnCih+5+n5hlrrGOOsFd6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747316297; c=relaxed/simple;
	bh=PXKxDhViUIcxC3KUkZHCixiArZ3XlYY3kxB+rdl/gio=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=CiPxyqpbqK+85WkTZb51/EkXM2DnkUwKpEWRmo6v4zTEImoM6Bx9dsoDja46W5lX0jgT2CE9g6zRq6wv+M+ly1VHSHTJPoXgA5vbolY5ZRAes3h5o6yvTtZP5L9SPhwEtEj+RprGbr+60iEjjcuAmIgUBRu65foWVSmnOdrb5a4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GFBXqx9k; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GFBXqx9k"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-74019695377so736026b3a.3
        for <dm-devel@lists.linux.dev>; Thu, 15 May 2025 06:38:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747316296; x=1747921096; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:user-agent:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=qVf819sirg3kVreUfa/4iH86ct1h9QFKS6LDxRK2VpM=;
        b=GFBXqx9kq+0iXXB1/fbBxFu+6sYjgx7B+f09flPBFGpC1nWpPXWnvyE+p1dtAAOOWy
         qBjesekwHbIxa0jvtvxkzrN8neSpEYRP4HGkhA8YkYFwM+knUWXT15A0wCO1wIzQR3MO
         86CNXAJCOyk+qEA7rIN8C+WyqzCt/yDIEILeQANyIZ9M3z8mck+YGmB/FyhuxW83Sfj4
         3pvabHrwyi0vPGwJMG5SI7s87h0a/BMxC3gCHp2i6IEQ1gCTyUHWl3DNo8shce0+GiWk
         NbcDsrnte3SsA/sIAcy5QCqV9M/NproynWCEkx//8CiDJ/3h1rxdSQferOSqB5hUFKse
         OHOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747316296; x=1747921096;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:user-agent:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qVf819sirg3kVreUfa/4iH86ct1h9QFKS6LDxRK2VpM=;
        b=onUUJgiblVZSyzXa4L+IuMCQHc5hGt6gVuGTtZWxScrYC0Vcd7WX75w4LYpBeaU1af
         Xiv5ZeRYA/YOkPxb8HIm9azn3TMyPxR/v63+4HFWASTbUkgxluxpJfR/cOXxdjeZgR9u
         BsyryMq6eScrd/Wci361GHsOa8BFzZKYXwl+lITWvBipft2XAGJ5o6TOxR1gMf8U96Ss
         9iM8853bCiL9reCNFFec1bNUVYwGOlszIEZy4IKUuLxXWibAfU3Tqlm5Z9d/ttLKRAeR
         GHptHgk0hFi75/LXCaYxkasRw4eWoGYgS846FxKY+s4vAgpOP49aoHD88ejK5If9V3sT
         odGw==
X-Forwarded-Encrypted: i=1; AJvYcCV29LLueltMY5ELgx5EzzU5I0NRcgZjvIYIlUbezScghat+WmB3ZmjA/dbgpBz72MDoMazkXFGriw==@lists.linux.dev
X-Gm-Message-State: AOJu0YwsAZSpvrOfySPPX+D3Xa30Pju3icslJMQ6PCSxaVkfacv3Z/65
	zN0IO5b0akVUZrhz95evBd8ex8VD553SSnu13abTMo+S2Xm5+Hj/
X-Gm-Gg: ASbGncsbql37z8YQWAoT6vq8L66bF21TRjGoRIYAALBTrs5D3DTRu48aBEGAJXQiIcb
	lOcSbtF+zyyV24ZmNdYIt+2+QzQWWk6Ft0yyzspabzgP5j84FYqJy+LEF3gzkLjd7dTPwkmTzo+
	5s/8X9kxyYfCJp1EfvJ83MFQTCAoG6fuOKlalP44vaXddDpSEoSiqbw40QBLdAibec9oq4IMa35
	+64f32nXS/G5KohY6HR06+FLkcxrUfO37m9LnK5D6pz15+snkwIHL5nkysoPN4OV9FQfLz3rQ2g
	sYYU3V+mE9a8hRoTO5N8LFtH4mY2CwM+gtNk3FmB0NGqrQYYccg=
X-Google-Smtp-Source: AGHT+IHmq4AYLXRLdQqbBREfC/3/3V7ZOrM9bmoGqUjVhH9gyGLkXnYBF9r5Lq+r6xdwPiaWMnweUw==
X-Received: by 2002:a05:6a20:1611:b0:215:dfd0:fd21 with SMTP id adf61e73a8af0-215ff191342mr12229403637.34.1747316295630;
        Thu, 15 May 2025 06:38:15 -0700 (PDT)
Received: from [127.0.0.1] ([103.56.52.49])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74237a3dbfesm11552273b3a.138.2025.05.15.06.38.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 May 2025 06:38:15 -0700 (PDT)
Date: Thu, 15 May 2025 21:38:06 +0800
From: Yu Kuai <yukuai1994@gmail.com>
To: Christoph Hellwig <hch@lst.de>, Yu Kuai <yukuai1@huaweicloud.com>
CC: xni@redhat.com, colyli@kernel.org, agk@redhat.com, snitzer@kernel.org,
 mpatocka@redhat.com, song@kernel.org, linux-kernel@vger.kernel.org,
 dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, yi.zhang@huawei.com,
 yangerkun@huawei.com, johnny.chenyi@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_RFC_md-6=2E16_v3_15/19=5D_md/md-llbitma?=
 =?US-ASCII?Q?p=3A_implement_APIs_to_dirty_bits_and_clear_bits?=
User-Agent: Thunderbird for Android
In-Reply-To: <20250514051747.GA24503@lst.de>
References: <20250512051722.GA1667@lst.de> <0de7efeb-6d4a-2fa5-ed14-e2c0bec0257b@huaweicloud.com> <20250512132641.GC31781@lst.de> <20250512133048.GA32562@lst.de> <69dc5ab6-542d-dcc2-f4ec-0a6a8e49b937@huaweicloud.com> <03f64fc7-4e57-2f32-bffc-04836a9df790@huaweicloud.com> <20250513064803.GA1508@lst.de> <87a53ae0-c4d6-adff-8272-c49d63bf30db@huaweicloud.com> <20250513074304.GA2696@lst.de> <d5ae7af0-dd73-7d6b-f520-c25e411f8f06@huaweicloud.com> <20250514051747.GA24503@lst.de>
Message-ID: <7B4FF58E-BCF5-4997-8006-CEC5A3EDEB85@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi

=E4=BA=8E 2025=E5=B9=B45=E6=9C=8814=E6=97=A5 GMT+08:00 13:17:47=EF=BC=8CCh=
ristoph Hellwig <hch@lst=2Ede> =E5=86=99=E9=81=93=EF=BC=9A
>On Tue, May 13, 2025 at 05:32:13PM +0800, Yu Kuai wrote:
>> I was thinking about record a stack dev depth in mddev to handle the
>> weird case inside raid=2E Is there other stack device have the same
>> problem? AFAIK, some dm targets like dm-crypt are using workqueue
>> to handle all IO=2E
>
>I guess anything that might have to read in metadata to serve a
>data I/O=2E  bcache, dm-snapshot and dm-thinkp would be candidates for
>that, but I haven't checked the implementation=2E
>
>> I'm still interested because this can improve first write latency=2E
>>
>>>
>>> So instead just write a comment documenting why you switch to a
>>> different stack using the workqueue=2E
>>
>> Ok, I'll add comment if we keep using the workqueue=2E
>
>Maybe do that for getting the new bitmap code in ASAP and then
>revisit the above separately?
>
>

Sure, sorry that I am in a business travel suddenly=2E I will get back to
 this ASAP I return=2E

Thanks
Kuai

Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E39BC1A0BF3
	for <dm-devel@lists.linux.dev>; Thu, 11 Dec 2025 03:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765424616; cv=none; b=BohhRkjI30Ch1YDqbykO1yHgAoRF2aJzj38ZsVyq6sIjPD9vdTA20glkvWaAG84mDvvzsLNFW4JRBjR6VosQdK9o9GJFDnMvnrRxyY2cFZki6unAxBWqhDcQFNiA3P/nBmwQESbOLmo9Dt1rS+6wItmjiAOjJxI2tjXhuL1gH8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765424616; c=relaxed/simple;
	bh=KkxXReKN5xTUWNaUgq5hSCbLyA/J8mEvonKTfzPz6SQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=W3RYWvWtGiW4H7oZ5xjJBKS6EajbzaqGa7g7RsFsSKld2/w+gm+nlaVzuPTcEfUKRqRjnUdn7z0s/AUjGSt9yDLbVZ5Wo9l78q+toeA/CmIVOrgmv3fNtIbegec/N32enB8SLe9C/uZlSDLud4r7h2O3xgaY8LMK2oI7VEF/XI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bgcwtuXn; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bgcwtuXn"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-59584301f0cso441306e87.0
        for <dm-devel@lists.linux.dev>; Wed, 10 Dec 2025 19:43:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1765424612; x=1766029412; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9NsClDZszDmtdKNIB9aUI8B0SOvnAGSqEkXCUj24YIM=;
        b=bgcwtuXn6W3pgHuvvH6L5YZHFapDoSvndykAEpDxlBZnDWMyiMisp+lYmAVk4EH0u6
         QQbgjVwcMoiCcICIDoP0EYilZCxIhvAYsGvu4M2a7ohUS4mVfXo/5R9Qogt3OwOMCsQP
         AO30PNf3BYe3rSJ5X26RoytWtU71vEMIobKKg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765424612; x=1766029412;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9NsClDZszDmtdKNIB9aUI8B0SOvnAGSqEkXCUj24YIM=;
        b=L7l4CBFebaHgHe4KsHrqe2Nx3gnPMVB/Ty0ephNnqeh+Vrqpcb48Irr50AH3mLeUhb
         WcFZKH2c1kz2sGSliP07ov5bTpV7/Y9sbU8kJXOAto88wxGzakxhyKhC4mAiHMkphJce
         4OZVynyyjN6E71E3l5Z8fVvYgjrNr6lxMzcToyRV6TBPDf+DwAMIwZLzCzEhg54pKXIH
         MHoiTK+VZIXbXIzKkwoCauR2tJJrvrM3IbNwUb10SLRg2L2tZzOD8ebmTimvNAyEW4nn
         9iOBlCyqlmknmZ30KekgPxCm8G6v/QKVswdpC07pHvI90noAvhTAY4mc94OVjdobLfBr
         RI9w==
X-Forwarded-Encrypted: i=1; AJvYcCVStSq0KQt2sG9WBan+phuuOMe1p5Hp4ZHCuq3uIAdo3p/0Mv4piGf9HtHvUmvw6I64C9Pg4r/vfw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yy+saeG5nhdkJEhoBHks5shZ0sCmR5igq0wPUC8306DWcZgfiYg
	d8P1HbsWc/uuT/9hL8P2ipDmWe2Rx+1ZTpBJ4qTynBEYz8U/HPG/2t+M/P6dKs+kh13ngzMZ9h+
	LfMTl9AQC9Q==
X-Gm-Gg: AY/fxX7ikQRGBjjIThoCoKwqhJCuEpjkUuCmYIyuxO27tZLzKqxCCKUot5G8Z0PL0le
	FqESg3NOGlJexKq6N2sERWz8Gl9A9Km5Kg3e5+g5kjTnw4P8goiMvBHaZDKF8QcuURx0U8sOtGn
	ToG1ZheFYTomJXltvXxfQZ7eqsQ4SV0eeCSjcMACZZybIt4Nz3cUzInK6zqj72t/D3qb1cJus8+
	j7LVPhAm2Swvh97P7DdV7590s6ehQHQ6xLjCsRL552bFo/sJY8j6hcdVbl7IagvJENAGIsqC8lU
	5pDmHmltWc7Hn8pvL+JHAC1CginLzq8CLuo/pQrhCPatBISZCpBlnGDrLhv84UONvnBdliR/gSI
	fL2Xqr6qjtTZDj1sL2ZXaEx/HR4BfJq/EVxgDCPpJID/kyLCAadnYTGJ2Kn1hgJvueKlUWCvHct
	xg+EHe5aKKYcQvhv5BU6202a9bFKFV7Yx23J05KBJNQfbvTbL4A+liOaruuZEuXs8v
X-Google-Smtp-Source: AGHT+IFNC+KPaHrlZ8YtO0WiTK2d8xrRJBUE5YJiNJ1nv8MySeJRHHtTcqNYOAdZTvDLSXdYlhdX6Q==
X-Received: by 2002:a05:6512:110a:b0:594:51ac:148 with SMTP id 2adb3069b0e04-598ee4e22a9mr1834291e87.15.1765424611779;
        Wed, 10 Dec 2025 19:43:31 -0800 (PST)
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com. [209.85.208.177])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-598f2fa8702sm456759e87.76.2025.12.10.19.43.30
        for <dm-devel@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Dec 2025 19:43:30 -0800 (PST)
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-37a2dcc52aeso3857731fa.0
        for <dm-devel@lists.linux.dev>; Wed, 10 Dec 2025 19:43:30 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWIXR+s9YW1aNFg+iImyA3wU5T1dB3SVbB8N+UfTOExABNgm4oVfK+TV2w+B7sMh+D6tl3DHJtnQg==@lists.linux.dev
X-Received: by 2002:a05:6402:51cb:b0:645:dc76:c169 with SMTP id
 4fb4d7f45d1cf-6496cbc4320mr3899911a12.21.1765424230003; Wed, 10 Dec 2025
 19:37:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <2b7fa07e-cf1c-73a7-d1eb-5d6082e08b29@redhat.com> <CAHk-=wi4ckGEFjHhMHcSoWidgd+URdorcdt5KCP6rQvP_DDS5g@mail.gmail.com>
In-Reply-To: <CAHk-=wi4ckGEFjHhMHcSoWidgd+URdorcdt5KCP6rQvP_DDS5g@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 11 Dec 2025 12:36:53 +0900
X-Gmail-Original-Message-ID: <CAHk-=wjkgKyDHDpXJR7_fQ3AT3gohukyAGuxqOCU1yyiRradHw@mail.gmail.com>
X-Gm-Features: AQt7F2oXSI71i8B9yfYSob00eCy9iQ-2n3kNE1KPs5b-Y8UPz-PuZgRIP2CKkwA
Message-ID: <CAHk-=wjkgKyDHDpXJR7_fQ3AT3gohukyAGuxqOCU1yyiRradHw@mail.gmail.com>
Subject: Re: [git pull] device mapper changes for 6.19
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev, 
	Alexey Simakov <bigalex934@gmail.com>, Benjamin Marzinski <bmarzins@redhat.com>, 
	Dongsheng Yang <dongsheng.yang@linux.dev>, Eric Biggers <ebiggers@kernel.org>, 
	Haotian Zhang <vulab@iscas.ac.cn>, Heinz Mauelshagen <heinzm@redhat.com>, 
	Chaitanya Kulkarni <ckulkarnilinux@gmail.com>, John Garry <john.g.garry@oracle.com>, 
	Jon Hunter <jonathanh@nvidia.com>, Li Chen <chenl311@chinatelecom.cn>, 
	Matthew Sakai <msakai@redhat.com>, Pedro Demarchi Gomes <pedrodemargomes@gmail.com>, 
	Shubhankar Mishra <shubhankarm@google.com>, Uladzislau Rezki <urezki@gmail.com>, 
	Vivek BalachandharTN <vivek.balachandhar@gmail.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 11 Dec 2025 at 09:11, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> This pull request came in late, and doesn't have a proper explanation,
> so I'm less than thrilled.
>
> Get me a proper explanation of what has been going on.

The code has also been recently rebased for some unknown reason that
isn't explained

I've pulled it, and written a better explanation for it all, but you
are now officially on my shit-list.

That means that next merge window, if you don't do things properly and
in a timely manner, I'm just not bothering to pull. Because this is
*not* how pull requests are supposed to be done in the kernel.

The two-week merge window is *not* for random unexplained late development.

The two weeks are for *merging*, not for "oh, I have time to rebase
code that wasn't ready, but I don't have time to explain any of it".

                   Linus

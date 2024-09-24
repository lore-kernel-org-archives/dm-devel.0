Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0D951448DF
	for <dm-devel@lists.linux.dev>; Tue, 24 Sep 2024 21:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727213089; cv=none; b=K1L4zOW9TJh6a0DiN1ENwiN0pvSpwTAlqD+H3RnNFdFJSpk5xOYHNmStoKQKiAFznWNAu/fyrBDQsYfT87Mt1QPzZuKifmMyQhp4u/ZUYogt1mWmEyEJx0CMsKjvp6egLuhkGNnnduNGdO5XKeJRlupECqsxSeIAaHV4GayN4/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727213089; c=relaxed/simple;
	bh=Se2SeyxPn1YF8ln96fxH093MbqW12GotKj2gD9ytgGE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BtQyR3xG3L4KIgISzBJi8pdqFz/pQJdqBwil59yLXZXWl8ozeUX1V+2THHj0zGa1fHaQfJ4XGlz4WouvZsQC8CRidO5FWM1ni2t7dVjHRaqF9XvGmut1/O/cDZvGv7a7pHWQcZVMZcSUEaVzqXBfJEEr2b2aNTU9nTbqMRDqswM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GSpF9X1a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GSpF9X1a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47846C4CEC6
	for <dm-devel@lists.linux.dev>; Tue, 24 Sep 2024 21:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727213089;
	bh=Se2SeyxPn1YF8ln96fxH093MbqW12GotKj2gD9ytgGE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=GSpF9X1aEP5ShwEMMdwzFGiXnTFSHDwRhYQxUZDvuKGB/nIhnq2QKeyZ9+FgwI3J1
	 MzQ6/uVcTfvB3PunJtfDAdrckXJdkweDYmb75mBHb+PiQZz0P+vQ4oTcdHPV7I8PTQ
	 U/OXAIrJR/DibW16WO9FY8cpcYnDJSZcIbo5quVX2XOjRmUmk4o4s5pMKCl090hgck
	 VFknEatVJilOvb8vOgbZF0SwLEHhhvQ039Asq0/OE/krJKYdA+DKDq/OEJ6mKWkxFs
	 +BQHRQqBvW70ZPVC34LghNYRoq02iWd5vrnHO9uhOXdzqEfb6ghfw1gJ1vxAslohq2
	 LyrgXavyywJ3g==
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-3a0ca7cfeb4so14161505ab.2
        for <dm-devel@lists.linux.dev>; Tue, 24 Sep 2024 14:24:49 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCX72eoVTIZKwQ61r6FyqOQQmnZBqInY2Mf/GTKxTwuLZhsa5OaK3EZB0XOOb1m7fEO0MzcACZ9jTw==@lists.linux.dev
X-Gm-Message-State: AOJu0YybuhVzrJmk514eqcpIWBih5ZSjs6gGW5IVqy5kTf0gd6Yd9PaR
	QIpqWlkH4YIdqQz2VShKhNMfndWMKtEKKQchEsP3O8KB4H5h6D+OMTQWHAgMXV0Ov4mix6fagmq
	2yUKJoJNCEtYXSTznOBfF75MWOYo=
X-Google-Smtp-Source: AGHT+IGDkW7WD2/JzFxCpyUwRB5/+sUMgv4hqELdvS0oE8C8Gvs3vzZAdADEd3f3M3MN9EO5an1dEVTf2Q18Yg4o5dM=
X-Received: by 2002:a05:6e02:174a:b0:3a0:aa15:3497 with SMTP id
 e9e14a558f8ab-3a26d6d97acmr10177795ab.1.1727213088499; Tue, 24 Sep 2024
 14:24:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240924091733.8370-1-shenlichuan@vivo.com> <d95d7419-7bac-802f-a5d6-456900539c32@redhat.com>
In-Reply-To: <d95d7419-7bac-802f-a5d6-456900539c32@redhat.com>
From: Song Liu <song@kernel.org>
Date: Tue, 24 Sep 2024 14:24:37 -0700
X-Gmail-Original-Message-ID: <CAPhsuW51S=WfyNoP_cWvNVq3rPW0+iBrhzRVaKK=q3PLRA94UA@mail.gmail.com>
Message-ID: <CAPhsuW51S=WfyNoP_cWvNVq3rPW0+iBrhzRVaKK=q3PLRA94UA@mail.gmail.com>
Subject: Re: [PATCH v1] md: Correct typos in multiple comments across various files
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Shen Lichuan <shenlichuan@vivo.com>, colyli@suse.de, kent.overstreet@linux.dev, 
	agk@redhat.com, snitzer@kernel.org, yukuai3@huawei.com, 
	linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, 
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Mikulas,

On Tue, Sep 24, 2024 at 6:30=E2=80=AFAM Mikulas Patocka <mpatocka@redhat.co=
m> wrote:
>
> Hi
>
> I've applied the device mapper part of the patch.

Would you mind taking the whole patch instead? You can add

Acked-by: Song Liu <song@kernel.org>

Thanks,
Song

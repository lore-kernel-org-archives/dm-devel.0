Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ECB9249E0
	for <dm-devel@lists.linux.dev>; Wed, 17 Jan 2024 19:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705519670; cv=none; b=fGoG9mwATCF5m5QOGec/RY0v/WA8kjTTQFd1t5ayQ1/PjrAL3Nw3uo42BCYp0yfA3ncy6mroKG6uSphL7WD3KTvKGp547oduyEHCjLfzs5RWjYfFIJq28dqOrCLnjlopznKiOA4Ijwk/ALqBGxD1hX/AwyYReQAFk26DAaT0gno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705519670; c=relaxed/simple;
	bh=J5Qt0OQzLo+VgwJlPGC/ZASQHyYROtme2Zcup4bNbJU=;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:
	 X-Google-Smtp-Source:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gmail-Original-Message-ID:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding; b=cfQYxMLf/hFoXhD/8cyePH9sBPgVkyeu0r/1MKWYdhw+mL66MGHShH0eEQlbyqu15ay5pZOk9v1tAED/PdHAPNEsLWKul6+g0Qcq5zcmF8HCDrHyWhNjyeUXhGtgcFa6CHfOj2TsijWLHpJieA4jNxQ99P+qocfrh3n/Hp4aEDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KtCXcc1o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KtCXcc1o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3523AC43390
	for <dm-devel@lists.linux.dev>; Wed, 17 Jan 2024 19:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705519670;
	bh=J5Qt0OQzLo+VgwJlPGC/ZASQHyYROtme2Zcup4bNbJU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=KtCXcc1oPK2Lv0NMwbW2xPhpdUEt+aYypbXw/OKTOydfoz24UcYMfWptIstnQyI0x
	 7NBGH5FT9Td2zl5rx7rAQVPb9pUmEJHQig1pDdmnWObcziCLRixQe3ewDeCNGNib5W
	 m5sVFS1QmhQeeHhghfRfJTGXdyO65UnAtAkJDbmpzpqhyKIW7/fUW5Sm1YB+5pwQj8
	 KR1YQwGzkeW22TmpNLGt/OuX/+TszmKfLGubwRTRnkYPbMPCyNqFkqoeBeSrYAWoFA
	 1Sq6vW1Nn+oIbKHgwZHAmLiwSYH/ukmnCU498b80/KO3vBNBtUzohenZZoDXbI5Kcd
	 TgL0Eb/ZegX1g==
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-2cdb50d8982so47452081fa.2
        for <dm-devel@lists.linux.dev>; Wed, 17 Jan 2024 11:27:50 -0800 (PST)
X-Gm-Message-State: AOJu0YwTnvdA3B7+6XHlz2z+n+tNlt3u1sGgJCoaol0tVL8s5UGYWNFU
	jx2dYQ0MKxIhsRaYVhGUOckH4lvzySt//qToUnI=
X-Google-Smtp-Source: AGHT+IHTPnSVMG724WM2AW/x85fIZ+Xr62JXPkjS9R2FpfNqV+6ixXO+NucMCyM926pfyxd4L4efbWeEiuQLoG/qD0I=
X-Received: by 2002:a05:651c:206:b0:2cd:46cb:7b53 with SMTP id
 y6-20020a05651c020600b002cd46cb7b53mr4575871ljn.91.1705519668329; Wed, 17 Jan
 2024 11:27:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <e5e8afe2-e9a8-49a2-5ab0-958d4065c55e@redhat.com>
In-Reply-To: <e5e8afe2-e9a8-49a2-5ab0-958d4065c55e@redhat.com>
From: Song Liu <song@kernel.org>
Date: Wed, 17 Jan 2024 11:27:36 -0800
X-Gmail-Original-Message-ID: <CAPhsuW40f2SQqzcRkCxu-9=or=3HNiDBHirHO4F=BjAn_ufZgg@mail.gmail.com>
Message-ID: <CAPhsuW40f2SQqzcRkCxu-9=or=3HNiDBHirHO4F=BjAn_ufZgg@mail.gmail.com>
Subject: Re: [PATCH 0/7] MD fixes for the LVM2 testsuite
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Yu Kuai <yukuai3@huawei.com>, David Jeffery <djeffery@redhat.com>, 
	Li Nan <linan122@huawei.com>, dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, 
	Mike Snitzer <msnitzer@redhat.com>, Heinz Mauelshagen <heinzm@redhat.com>, 
	Benjamin Marzinski <bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Mikulas,

On Wed, Jan 17, 2024 at 10:17=E2=80=AFAM Mikulas Patocka <mpatocka@redhat.c=
om> wrote:
>
> Hi
>
> Here I'm sending MD patches that fix the LVM2 testsuite for the kernels
> 6.7 and 6.8. The testsuite was broken in the 6.6 -> 6.7 window, there are
> multiple tests that deadlock.
>
> I fixed some of the bugs. And I reverted some patches that claim to be
> fixing bugs but they break the testsuite.
>
> I'd like to ask you - please, next time when you are going to commit
> something into the MD subsystem, download the LVM2 package from
> git://sourceware.org/git/lvm2.git and run the testsuite ("./configure &&
> make && make check") to make sure that your bugfix doesn't introduce
> another bug. You can run a specific test with the "T" parameter - for
> example "make check T=3Dshell/integrity-caching.sh"

Thanks for the report and fixes!

We will look into the fixes and process them ASAP.

We will also add the lvm2 testsuite to the test framework.

Song

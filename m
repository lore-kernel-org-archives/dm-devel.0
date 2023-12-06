Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAA6C675B5
	for <dm-devel@lists.linux.dev>; Wed,  6 Dec 2023 17:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sc/mjRZU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D8ECC433CA
	for <dm-devel@lists.linux.dev>; Wed,  6 Dec 2023 17:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701883508;
	bh=cTsb/UUe/7c50IQGHlJ5frauXTjRzXHTTCqGuvYx7Ys=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Sc/mjRZUJ3dnU4TEueWhY5Cesz7wCFYS63sbRpDT9rWZmeozgUxdqIpQNIGGCrPon
	 8JIg3kcscEdyrOZAkrsHryihS8evbvVSgFuKEPDNZkOX7B3MT5S7HEl2iiO2ESNzfF
	 0vuheCGXJXy0So23AgNzGz6vcXLexnSDoE+JVdCPYBhNzC91TFi780rWYqBgn6TtTz
	 2FIedVRgbZr97ESDnjDa3M+0ZTybzcfdmHHiUzQg2u8kXPmnclQClq7MnOKkHELdaZ
	 hAjaok80KERa/QERWVrN4nfhY0mf6EDOLM4vMJ5LVDW0xdJUUV4HiWSavZlRDMmQAN
	 COSt6ZQYO48zg==
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-50bfa5a6cffso17660e87.0
        for <dm-devel@lists.linux.dev>; Wed, 06 Dec 2023 09:25:08 -0800 (PST)
X-Gm-Message-State: AOJu0YxdpBNDoeZzowgOdwA77lKDAKJfXrlbEtVO7NWC/RaDDwN3ZRcw
	CS7SB4x56MsluHnT+6FBHjs3WER4XYRI8lcxsbk=
X-Google-Smtp-Source: AGHT+IHT1kpTKlXAwY6gHfg8PdXTVmwgYffVePOsfH7VO3lnRkQcNzkn7H0RXNt5Jg6sS0YQO0gWte3wMHqntnZPKbU=
X-Received: by 2002:a05:6512:33cf:b0:50b:eedd:edd0 with SMTP id
 d15-20020a05651233cf00b0050beeddedd0mr962504lfg.105.1701883506495; Wed, 06
 Dec 2023 09:25:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231204031703.3102254-1-yukuai1@huaweicloud.com>
 <CAPhsuW4sF=jAyA+Q=2tFBBAApjcW=gWXndDNX6t3nrAfnk_zZA@mail.gmail.com> <269ac5cb-aa09-02ca-4150-c90cd5a72e06@huaweicloud.com>
In-Reply-To: <269ac5cb-aa09-02ca-4150-c90cd5a72e06@huaweicloud.com>
From: Song Liu <song@kernel.org>
Date: Wed, 6 Dec 2023 09:24:54 -0800
X-Gmail-Original-Message-ID: <CAPhsuW7US8f7gR+Eo=hYU0RF+L8YkF6ebiWG+FDO6frAxoBarw@mail.gmail.com>
Message-ID: <CAPhsuW7US8f7gR+Eo=hYU0RF+L8YkF6ebiWG+FDO6frAxoBarw@mail.gmail.com>
Subject: Re: [PATCH -next] md: split MD_RECOVERY_NEEDED out of mddev_resume
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, 
	dm-devel@lists.linux.dev, janpieter.sollie@edpnet.be, 
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, yi.zhang@huawei.com, 
	yangerkun@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 6, 2023 at 3:36=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com> wr=
ote:
>
> Hi,
>
> =E5=9C=A8 2023/12/06 16:30, Song Liu =E5=86=99=E9=81=93:
> > On Sun, Dec 3, 2023 at 7:18=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com=
> wrote:
> >>
> >> From: Yu Kuai <yukuai3@huawei.com>
> >>
> >> New mddev_resume() calls are added to synchroniza IO with array
> >> reconfiguration, however, this introduce a regression while adding it =
in
> >> md_start_sync():
> >>
> >> 1) someone set MD_RECOVERY_NEEDED first;
> >> 2) daemon thread grab reconfig_mutex, then clear MD_RECOVERY_NEEDED an=
d
> >>     queue a new sync work;
> >> 3) daemon thread release reconfig_mutex;
> >> 4) in md_start_sync
> >>     a) check that there are spares that can be added/removed, then sus=
pend
> >>        the array;
> >>     b) remove_and_add_spares may not be called, or called without real=
ly
> >>        add/remove spares;
> >>     c) resume the array, then set MD_RECOVERY_NEEDED again!
> >>
> >> Loop between 2 - 4, then mddev_suspend() will be called quite often, f=
or
> >> consequence, normal IO will be quite slow.
> >>
> >> Fix this problem by spliting MD_RECOVERY_NEEDED out of mddev_resume(),=
 so
> >> that md_start_sync() won't set such flag and hence the loop will be br=
oken.
> >
> > I hope we don't leak set_bit MD_RECOVERY_NEEDED to all call
> > sites of mddev_resume().
>
> There are also some other mddev_resume() that is added later and don't
> need recovery, so md_start_sync() is not the only place:
>
>   - md_setup_drive
>   - rdev_attr_store
>   - suspend_lo_store
>   - suspend_hi_store
>   - autorun_devices
>   - md_ioct
>   - r5c_disable_writeback_async
>   - error path from new_dev_store(), ...
>
> I'm not sure add a new helper is a good idea, because all above apis
> should use new helper as well.

I think for most of these call sites, it is OK to set MD_RECOVERY_NEEDED
(although it is not needed), and md_start_sync() is the only one that may
trigger "loop between 2 - 4" scenario. Did I miss something?

It is already rc4, so we need to send the fix soon.

Thanks,
Song

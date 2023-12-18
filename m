Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D5A1FB5
	for <dm-devel@lists.linux.dev>; Mon, 18 Dec 2023 01:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O2rqV73e"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-552d39ac3ccso4077829a12.0
        for <dm-devel@lists.linux.dev>; Sun, 17 Dec 2023 17:25:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702862699; x=1703467499; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bJJJcnW9NIcj4bkD41Zw66nJEJBPkvnjleD0Bm4wmV0=;
        b=O2rqV73eAVsYng/O4JarU6U8ZpYRcnoiju88eS8Yi4/G1y/rEcEAoE6Xr6GaVJQXEV
         g3OkBoePXzNEMKG9wPAYY/7MnKFuE/izTxV2RTVmHxkNV/U3b/onckX8TE6YjIi/7Gr7
         hnXTB8giIs0lF3SuNMMvom/VLMZYkZgmZ1loVnltQZo6ll7pwziOJad/9pFcq2rUSpe9
         FITfrEVGYOiYHYCuqZ73BQivldMxApL807Et6+Xo4SlaSImU907xhwpU/xX7qQR8atZh
         6RpQFCWGea8tConNjM44IS5F9UVeWjNjKW0IF+ee7Dbr8gwubrk4Mj+iLCf/I/hNlVW1
         nPQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702862699; x=1703467499;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bJJJcnW9NIcj4bkD41Zw66nJEJBPkvnjleD0Bm4wmV0=;
        b=jX+XR+y4UoSyWh9SLnZtR8ny6Vqphnzanbw/tTTNmG4RJkUYF1Ks8r3QV1Z0Y0APP1
         /0/9bWL/z0PyE9manrAzHcost8qxlm95UdA4Y+ACrVAPOReoQxwwGfMePiMDQAy+fESK
         Qoc5wCGH7Ac/iTssH6Uw4lBjwa4mGd9im//lg3oLtbBXTsjEoJt6utul9HcUa+75Hjs4
         qaFvsrvZYiIhJEqY4gDETF+Uo72tECSpdyf9wRA84DZNOZBt/Dz+E4EaS5rlfrIpfFLK
         D/V/S/qR2U2qD0bcaniOUSt6eCg23hTjuhynk8Fm2jHjvX8xy2J1aE59hXJ3kSLShTsy
         unKg==
X-Gm-Message-State: AOJu0Yy5m6cMhuKI6yEEtEXst1PIlUK6Ejuty3ThUq++4gxExD4SBdic
	J9goTI/J9KCcvSs92XTN+cyd/gi+EbKcyOV3two=
X-Google-Smtp-Source: AGHT+IHbg0CMMmZq/61mfQueTu6x41ayxb++hfJoDxIAB3Ftw962nG0mh1/NajwLubZfxcdjXMLfo0JEK2QKbhvP/pM=
X-Received: by 2002:a17:907:280f:b0:a1f:4d21:301a with SMTP id
 eb15-20020a170907280f00b00a1f4d21301amr16094009ejc.13.1702862698999; Sun, 17
 Dec 2023 17:24:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CAMQnb4MQUJ0VnA5XO-enrXTJvHbo6FJCVPGszGaq-R34hfbeeg@mail.gmail.com>
 <20231213104216.27845-1-hongyu.jin.cn@gmail.com> <20231213104216.27845-2-hongyu.jin.cn@gmail.com>
 <ZXnir8x6127EW7Gp@redhat.com>
In-Reply-To: <ZXnir8x6127EW7Gp@redhat.com>
From: Henry King <hongyu.jin.cn@gmail.com>
Date: Mon, 18 Dec 2023 09:24:54 +0800
Message-ID: <CAMQnb4O15c=JC-zkCJD0U9GWwWko+Hez1iU7+cc3vhNSG86p9w@mail.gmail.com>
Subject: Re: [PATCH v5 1/5] block: Fix bio IO priority setting
To: Mike Snitzer <snitzer@kernel.org>
Cc: agk@redhat.com, mpatocka@redhat.com, axboe@kernel.dk, ebiggers@kernel.org, 
	zhiguo.niu@unisoc.com, ke.wang@unisoc.com, yibin.ding@unisoc.com, 
	hongyu.jin@unisoc.com, linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev, 
	linux-block@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Mike Snitzer <snitzer@kernel.org> =E4=BA=8E2023=E5=B9=B412=E6=9C=8814=E6=97=
=A5=E5=91=A8=E5=9B=9B 00:58=E5=86=99=E9=81=93=EF=BC=9A
>
> On Wed, Dec 13 2023 at  5:42P -0500,
> Hongyu Jin <hongyu.jin.cn@gmail.com> wrote:
>
> > From: Hongyu Jin <hongyu.jin@unisoc.com>
> >
> > Move bio_set_ioprio() into submit_bio():
> > 1. Only call bio_set_ioprio() once to set the priority of original bio,
> >    the bio that cloned and splited from original bio will auto inherit
> >    the priority of original bio in clone process.
> >
> > 2. The IO priority can be passed to module that implement
> >    struct gendisk::fops::submit_bio, help resolve some
> >    of the IO priority loss issues.
> >
> > This patch depends on commit 82b74cac2849 ("blk-ioprio: Convert from
> > rqos policy to direct call")
> >
> > Fixes: a78418e6a04c ("block: Always initialize bio IO priority on submi=
t")
> >
> > Co-developed-by: Yibin Ding <yibin.ding@unisoc.com>
> > Signed-off-by: Yibin Ding <yibin.ding@unisoc.com>
> > Signed-off-by: Hongyu Jin <hongyu.jin@unisoc.com>
>
> Would be nice to get this block core fix upstream ASAP independent of
> your various DM changes.
dm modification depends on block modification to have effect, so it is
reviewed together.
>
> Please simplify this patch's header like was requested in review of v4:
> https://patchwork.kernel.org/project/dm-devel/patch/20231212111150.18155-=
2-hongyu.jin.cn@gmail.com/
ok, i will send the header=E3=80=82

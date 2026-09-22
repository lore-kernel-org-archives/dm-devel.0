Received: from mail-qk2-f21.google.com (mail-qk2-f21.google.com [74.125.230.213])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B487E3A1E7E
	for <dm-devel@lists.linux.dev>; Tue, 22 Sep 2026 20:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.230.213
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790108044; cv=pass; b=l0Ljwbkm/Xi97VQN4cgK8f3IEShJZkRGdigD63BPNd+o90XfJbx/QE1+KkKqsxSYEMfXZ3L8F2byN6NiYo+K9bmTMhGGbsDftg5XSngSRXRFtytP7j8ZXHTbqsJyP2+dAmfzmv7lXUz447ME7jDgve39S6TiEnmGvbg3Bsxm6ok=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790108044; c=relaxed/simple;
	bh=1UA9a1hfBrb0xbFFf8Sc7ugr9w51WvMuM9aXktICUvE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eBao2/937z2jIXSk4/aYjwQM4vgodfbfoijYG11Rk4Rp13+LLpacPkxGp5mV/OSHoKBbWhNqrfTeDOeB9yym9fkYGKQ1rIuVyoagOrBsmlBL6xGJmAmbdRZYvkazpsFjdOJwuVijTfmgCWpVp1P1JrtEzERedMlU3Nw5hVqBkoY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Fa2tX70k; arc=pass smtp.client-ip=74.125.230.213
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fa2tX70k"
Received: by mail-qk2-f21.google.com with SMTP id af79cd13be357-93910cadea0so20208585a.1
        for <dm-devel@lists.linux.dev>; Tue, 22 Sep 2026 13:13:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790108001; cv=none;
        d=google.com; s=arc-20260327;
        b=LATLTWm1HTY3UnRYaoFV1pooln/jZRkE5ZrP40QYfapsOzwYucVZHBBEOrkkOA7b73
         GqiVpxooMJA2C1P2AUNVJGFKj7wD5hUMw5SKwSdLP96/Q9S3F+H1JwK4wHZ//hJxb74y
         lrlEX5cZ6kjVoRXlo1WtffaJ54UKmeRLX5/vRaO2baMVWkmBUZoYIehuDkE21hCdrH2x
         Y2343MAAw44C0u6iBtqyDTofKqKGgIR1CLo8YSCz/3ZxYGlkgCkdCucQha3l95x1n9Tm
         8WSHrDT+muyjh132DOUd7Wg3NC9upCPzgKdHpEPDcFndOMA7/mIRSio/1KGHsd5eOKbz
         xw0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=k8LLV/hFwxGdE2PSJD1a575Lox+2W1a0UsvegnWw/g0=;
        fh=8i1RYoFmZ/1P7NjG5EtySDs0QZ4EyCnnvfMdJb31Td8=;
        b=mLXmQxJ2CBcgWamrTG5m5ok9SuXveVoV24jsQiSSsiet6cKl1q737PRfhPqviDUjK6
         yxHkiMVx1+AjEno79mruEyRDMfFitTYkJsW8LMU+YzyNtOf0YrFQ9UqW8iiniqAti790
         +5wlJViYmzlrgka94E93YmbSPptoWJSEgOW0lwXqi/b0FJ5BYxAucbX4Njms6/5K/WLH
         vB9IVHaHGkBn/W9pOa3gYaos8Hxp7JVCA1QJhySx7giBbID8oC7AQF57nX0LHQAcyprZ
         0OFPVr4B0VhdFev++Bo6d8d77KgSm3rDC6DRXjyprDnaepXhZpOti2SHRVqXa+oqcUSu
         pp2Q==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790108001; x=1790712801; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=k8LLV/hFwxGdE2PSJD1a575Lox+2W1a0UsvegnWw/g0=;
        b=Fa2tX70k5czb6r2RDJD7msNOB11EOU7wQogcPfmIsIX4ReSiytsnlSjGJEDzZdDqeN
         5PpfWBru0SOd01QioTeCsisbMUnuMAEDGaXUT50py+sqZ9mehkaA7zNpn6p0NjEQYGXM
         uvgAGrpfX0OLBavG4LErNUZXGM4VCESM21WKFyuKR1P6MEzhcN5suzurWeGX07TEF56w
         vWUayOCkbNix0F3nEtIaYdWWva3khnso9hQWmWvEeMeHeJABopWcTCcFjDsP18DM26nB
         gNwubbJu1bVF++v2owFh5D6VsfCY+5wlruMi5drs2QZgTdkqthqXXLZVjLt6zmhlmoAS
         M/jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790108001; x=1790712801;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=k8LLV/hFwxGdE2PSJD1a575Lox+2W1a0UsvegnWw/g0=;
        b=cMFhKQblkyzbhuyTOXf9pvERRAJV1WWu+toYSFYe4VWdwWW2AB8TeZ5O8MfB1fSgIP
         dTXvYX9ceZB+TgUbWTn05rmr2sKlIu6FW9kBCTj7aaLBdBw58NdxOxJ0ucS6Sd3e4wRE
         +ZZms6RPVNzZoFW7i+y5iHtRzaPJVao9hGWjXXTfBbbnhfTty7KMLw5zxF21vkX+6Dfh
         4jPNg0/c64EgIe1JN8mCfkrcepFaVDelaUK/r2qKh2yULHPrIKFPKU03xZyvDcnHVSWq
         SVqpGa2cSBGSQSC8PMiWblrMbeFCaaDtthGTuNTgpeApV8eEqnJEgk26AQalpdhDQ6yi
         WWiw==
X-Forwarded-Encrypted: i=1; AKwUvByOpT4zrVwUrCat9L43KRj3GmRQmkJIxkE8LN0nRmCEPn6KJSG80RpyHHCWNZ+ajiUO/DJ7m8pl8A==@lists.linux.dev
X-Gm-Message-State: AFuF++kQYLJFaTE1B+T+hwMx3NO4KbMbdxnwnh9vE4v0Ql0TPwoZy+P6
	BJwv2JV6HtjHjE39GBaH+XPsChBPB8rm0GhhsHqjMRJT+mjVy9+BUWgPFFaUjviLDCY/4DDE+ZK
	hZQojtHevAp7B34cNbwa+C1ffnVAJo5Y=
X-Gm-Gg: AYBFou1QR1il9IkiepITYdT9O12ShG1CPneE3FQnfpeozIT7FAZ0RIlH3behVLG+PBz
	NmYNExhVKv3Z1SAGR32tVoubCdjEirr2SGY+jSfSe6o4MyRLlEcJ0YRKiWyEL7aJaNxZwghvt7S
	IIB4jPKUlVzD2qnBxdNhUid0VrFTpyuoVdcbbmW+SKtBX4XhWeK+xR5P6Xvp8W3QziRD8yp9jCN
	6c34Ul3FT2sFdjiJjyCAzTBsyQ8pVnCs6dt8Taq98pxzca1jj+qg9vcTmissiPWBjZdv9f5e+Vx
	VFf20iZNWP435USeXn9lEbm6UfEMP5nluh61qMVnhZmjuk/PKn/X
X-Received: by 2002:a05:620a:808e:b0:93b:d7a2:dd2c with SMTP id
 af79cd13be357-93c251f05f6mr87457685a.60.1790108001557; Tue, 22 Sep 2026
 13:13:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260918234339.54105-1-raghunathpalla.0209@gmail.com> <956ce83b-ef24-56f1-d70a-f7378f55cdf8@redhat.com>
In-Reply-To: <956ce83b-ef24-56f1-d70a-f7378f55cdf8@redhat.com>
From: Raghunath Palla <raghunathpalla.0209@gmail.com>
Date: Tue, 22 Sep 2026 21:13:07 +0100
X-Gm-Features: AcwNN1VD5iYZ19XInMPbyYu2owj3fTmlHfD_4JMZ-WTtNT8yf3_9qcVRQyoqqYM
Message-ID: <CABNt8qNjztQ-TmKPtS7iY5csniFasfYGSfiJ=O+qxe7DySFWuw@mail.gmail.com>
Subject: Re: [PATCH] dm ioctl: don't let data_start run past the buffer
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
	Benjamin Marzinski <bmarzins@redhat.com>, Milan Broz <mbroz@redhat.com>, dm-devel@lists.linux.dev, 
	Shuah Khan <shuah@kernel.org>, Brigham Campbell <me@brighamcampbell.com>, linux-kernel@vger.kernel.org, 
	linux-kernel-mentees@lists.linux.dev, 
	syzbot+48d935cf48a4a76be346@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"

Hi Mikulas,

Thanks for applying the patch and for the cleanup. The change looks good
to me.

Thanks,
Palla Raghunath


On Mon, 21 Sept 2026 at 15:29, Mikulas Patocka <mpatocka@redhat.com> wrote:
>
>
>
> On Sat, 19 Sep 2026, Palla Raghunath wrote:
>
> > struct dm_ioctl has seven bytes of trailing padding, so the smallest
> > buffer userspace is allowed to ask for, offsetof(struct dm_ioctl, data),
> > is seven bytes shorter than sizeof(struct dm_ioctl).
> >
> > get_result_buffer() sets data_start to sizeof(struct dm_ioctl) without
> > looking at how big the buffer actually is. Ask for the minimum and
> > data_start ends up seven bytes past the end. Callers add it to
> > data_size, and ctl_ioctl() copies that much back to userspace:
> >
> >   BUG: KASAN: slab-out-of-bounds in _copy_to_user+0xad/0xd0
> >   Read of size 312 at addr ffff8880169e4c00 by task repro-dm/140
> >    ctl_ioctl+0x5e3/0xcb0
> >    dm_ctl_ioctl+0x25/0x40
> >   allocated 305-byte region [ffff8880169e4c00, ffff8880169e4d31)
> >
> > A DM_LIST_DEVICES with data_size set to 305 is enough to hit it, and the
> > seven bytes that leak are whatever sat next to the allocation.
> >
> > Clamp data_start to the buffer size.
> >
> > Reported-by: syzbot+48d935cf48a4a76be346@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=48d935cf48a4a76be346
> > Fixes: 76c072b48e39 ("dm ioctl: move compat code")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Palla Raghunath <raghunathpalla.0209@gmail.com>
> > ---
> >  drivers/md/dm-ioctl.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> >
> > diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
> > index a6b8e97755cd..211569dd3c54 100644
> > --- a/drivers/md/dm-ioctl.c
> > +++ b/drivers/md/dm-ioctl.c
> > @@ -656,6 +656,13 @@ static void *get_result_buffer(struct dm_ioctl *param, size_t param_size,
> >  {
> >       param->data_start = align_ptr(param + 1) - (void *) param;
> >
> > +     /*
> > +      * The buffer can be as small as offsetof(*param, data), which is
> > +      * less than sizeof(*param), so don't run off the end of it.
> > +      */
> > +     if (param->data_start > param_size)
> > +             param->data_start = param_size;
> > +
> >       if (param->data_start < param_size)
> >               *len = param_size - param->data_start;
> >       else
> > --
> > 2.34.1
>
> Hi
>
> I accepted the patch, but I changed it slightly, so that there is just one
> condition in get_result_buffer. The resulting function is:
>
> static void *get_result_buffer(struct dm_ioctl *param, size_t param_size,
>                                size_t *len)
> {
>         param->data_start = align_ptr(param + 1) - (void *) param;
>
>         if (param->data_start < param_size) {
>                 *len = param_size - param->data_start;
>         } else {
>                 /*
>                  * The buffer can be as small as offsetof(*param, data), which
>                  * is less than sizeof(*param), so don't run off the end of it.
>                  */
>                 *len = 0;
>                 param->data_start = param_size;
>         }
>
>         return ((void *) param) + param->data_start;
> }
>
> Mikulas
>

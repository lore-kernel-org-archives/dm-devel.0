Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B99CA76048
	for <dm-devel@lists.linux.dev>; Wed, 22 May 2024 17:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716399447; cv=none; b=GxDDynpPYXdw4ajR7XoB2A5VGWAh6CwFSuOAE1GBHwZ6VMrEaVSUOl0MRw0Pv1e+0rb1vDlZdqmKW1ygcK/PN+GNCkN+L5mt88Oik8L2wne6V950KXEOywVT7fEffmXYososmS7nEY7vg1/x1YxvwPGz8dlJRtPuOHdeBqGgYto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716399447; c=relaxed/simple;
	bh=BsCfFqXmskMjOpeSEN/u265PuQFM1MR/tOMn8LfJ/Y0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qz+smS62D5a11rj1DKUSNxoTYhpALnplesZ+nyY+wS5hIffQ65hNliAumnqWCsukhT04/IQXn8nhZblI9uIqzy6x2jsue24qokaokK5mqFBPIh6cFrhS9A+zT/6l396qKMs8P7Cyuf3ZbOWW5C7wzC1TZn6uoufa5x40BwAfdUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JR8NK0Js; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JR8NK0Js"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716399444;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=llHIFO0/Fki+cPFoMQv30dTXRmTpbLAeQQBl/Bb7SGc=;
	b=JR8NK0Js3G5M08F+bOcbU/Lk6VYWG4F01o+joxsY5zxNYVBwd8lefhgSoxacBtnbSVXTBQ
	yz8eENZ85jvyatt83P4MQPtj8Z4tMdNOx9ZVtKaQGpQS/kqupHviGk5OK7MrpnM9sENwEZ
	HWwnE4vQVP9yIlPZSIwvL7p/5JhXpoo=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-652-mmiqV0dIPKmBFRB9jtY04A-1; Wed, 22 May 2024 13:37:22 -0400
X-MC-Unique: mmiqV0dIPKmBFRB9jtY04A-1
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-61dfa4090c1so223614287b3.3
        for <dm-devel@lists.linux.dev>; Wed, 22 May 2024 10:37:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716399441; x=1717004241;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=llHIFO0/Fki+cPFoMQv30dTXRmTpbLAeQQBl/Bb7SGc=;
        b=sfRppmJtmihwstyHeLPRjPptccOpxvMfT4j35BybHs3U4R/LQ3FWLSm590V1Yuv2E2
         Fro5ReBmplyWwjz8ofPisI1ekzvMrzjZntblbGZryk2UDvJGJ3wFrhxhCJLkeKvl0BHv
         qoM1Pn9ywXrLci0sa17susrN2AFUl9OeGBDsGGB+p2Frw3hpD+B4C6aDSROHe9JpmaZy
         9ZGJyvMjZ3kxAJJzgMjNwEiISkQi2O3dJnBB6AWM4SU36PWxMfsphsG5YQAoXyyd62W9
         FpGZf6of4GSuiMOEjimvjVivs9GPs6ymxR3NcqhFrVoPlbqcBoWksNaukpJjYbl6+YVC
         klag==
X-Forwarded-Encrypted: i=1; AJvYcCVqPDCOyJkyVMVhWjYDMnP2NU7mqg/RkVDSIyYJopp6x008PGthchJTXRxFvKwkU9k9iA3IpIFAtZgpBI0idcZcOB00541LPNk=
X-Gm-Message-State: AOJu0YycaT+NhzJsV9sZ+iLf/GKng1xlBvNm/ewKMGiMjWy+aeIc7/fr
	YTGt92BT8Wj7/+vkRie4KqxMMvTLnpyS6+KwKZgKpzbrhESJvQH7CVRyUerAs58G3TkQPfW1GMS
	nbgTfdD0g48xcF9RjugqF1jhzT/R12jTPVj1jLYYobf+LobNKknlbsHdVTmJ499VwGSDp7hndEx
	7yEfhrK+PCA9D4mUx6q/m8Cr0vr/fxJUo=
X-Received: by 2002:a0d:df42:0:b0:619:5176:5e34 with SMTP id 00721157ae682-627e4658bd2mr25563497b3.18.1716399441529;
        Wed, 22 May 2024 10:37:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGqqHn6QBnyL0lTqc0WTSwbHo1OjdUoiiNvEfqYstLHD0xqqU0pqXN9YQvZpMEZ3DT++9JhHSkyOOjLKQvcAqU=
X-Received: by 2002:a0d:df42:0:b0:619:5176:5e34 with SMTP id
 00721157ae682-627e4658bd2mr25563287b3.18.1716399441162; Wed, 22 May 2024
 10:37:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240522025117.75568-1-snitzer@kernel.org> <20240522142458.GB7502@lst.de>
 <Zk4h-6f2M0XmraJV@kernel.org>
In-Reply-To: <Zk4h-6f2M0XmraJV@kernel.org>
From: Ewan Milne <emilne@redhat.com>
Date: Wed, 22 May 2024 13:37:10 -0400
Message-ID: <CAGtn9rkzDdsq-_VQQfcRB8V9tD82_DWLx=pz+59DuBEkvuvOQw@mail.gmail.com>
Subject: Re: dm: retain stacked max_sectors when setting queue_limits
To: Mike Snitzer <snitzer@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, dm-devel@lists.linux.dev, linux-block@vger.kernel.org, 
	Marco Patalano <mpatalan@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

We tried the sd_revalidate_disk() change, just to be sure.  It didn't fix i=
t.

-Ewan

On Wed, May 22, 2024 at 12:49=E2=80=AFPM Mike Snitzer <snitzer@kernel.org> =
wrote:
>
> On Wed, May 22, 2024 at 04:24:58PM +0200, Christoph Hellwig wrote:
> > On Tue, May 21, 2024 at 10:51:17PM -0400, Mike Snitzer wrote:
> > > Otherwise, blk_validate_limits() will throw-away the max_sectors that
> > > was stacked from underlying device(s). In doing so it can set a
> > > max_sectors limit that violates underlying device limits.
> >
> > Hmm, yes it sort of is "throwing the limit away", but it really
> > recalculates it from max_hw_sectors, max_dev_sectors and user_max_secto=
rs.
>
> Yes, but it needs to do that recalculation at each level of a stacked
> device.  And then we need to combine them via blk_stack_limits() -- as
> is done with the various limits stacking loops in
> drivers/md/dm-table.c:dm_calculate_queue_limits
>
> > > This caused dm-multipath IO failures like the following because the
> > > underlying devices' max_sectors were stacked up to be 1024, yet
> > > blk_validate_limits() defaulted max_sectors to BLK_DEF_MAX_SECTORS_CA=
P
> > > (2560):
> >
> > I suspect the problem is that SCSI messed directly with max_sectors ins=
tead
> > and ignores max_user_sectors (and really shouldn't touch either, but th=
at's
> > a separate discussion).  Can you try the patch below and maybe also pro=
vide
> > the sysfs output for max_sectors_kb and max_hw_sectors_kb for all invol=
ved
> > devices?
>
> FYI, you can easily reproduce with:
>
> git clone https://github.com/snitm/mptest.git
> cd mptest
> <edit so it uses: export MULTIPATH_BACKEND_MODULE=3D"scsidebug">
> ./runtest ./tests/test_00_no_failure
>
> Also, best to change this line:
> ./lib/mpath_generic:        local _feature=3D"4 queue_if_no_path retain_a=
ttached_hw_handler queue_mode $MULTIPATH_QUEUE_MODE"
> to:
> ./lib/mpath_generic:        local _feature=3D"3 retain_attached_hw_handle=
r queue_mode $MULTIPATH_QUEUE_MODE"
> Otherwise the test will hang due to queue_if_no_path.
>
> all underlying scsi-debug scsi devices:
>
> ./max_hw_sectors_kb:2147483647
> ./max_sectors_kb:512
>
> multipath device:
>
> before my fix:
> ./max_hw_sectors_kb:2147483647
> ./max_sectors_kb:1280
>
> after my fix:
> ./max_hw_sectors_kb:2147483647
> ./max_sectors_kb:512
>
> > diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> > index 332eb9dac22d91..f6c822c9cbd2d3 100644
> > --- a/drivers/scsi/sd.c
> > +++ b/drivers/scsi/sd.c
> > @@ -3700,8 +3700,10 @@ static int sd_revalidate_disk(struct gendisk *di=
sk)
> >        */
> >       if (sdkp->first_scan ||
> >           q->limits.max_sectors > q->limits.max_dev_sectors ||
> > -         q->limits.max_sectors > q->limits.max_hw_sectors)
> > +         q->limits.max_sectors > q->limits.max_hw_sectors) {
> >               q->limits.max_sectors =3D rw_max;
> > +             q->limits.max_user_sectors =3D rw_max;
> > +     }
> >
> >       sdkp->first_scan =3D 0;
> >
> >
>
> Driver shouldn't be changing max_user_sectors..
>
> But it also didn't fix it (mpath still gets ./max_sectors_kb:1280):
>
> [   74.872485] blk_insert_cloned_request: over max size limit. (2048 > 10=
24)
> [   74.872505] device-mapper: multipath: 254:3: Failing path 8:16.
> [   74.872620] blk_insert_cloned_request: over max size limit. (2048 > 10=
24)
> [   74.872641] device-mapper: multipath: 254:3: Failing path 8:32.
> [   74.872712] blk_insert_cloned_request: over max size limit. (2048 > 10=
24)
> [   74.872732] device-mapper: multipath: 254:3: Failing path 8:48.
> [   74.872788] blk_insert_cloned_request: over max size limit. (2048 > 10=
24)
> [   74.872808] device-mapper: multipath: 254:3: Failing path 8:64.
>
> Simply setting max_user_sectors won't help with stacked devices
> because blk_stack_limits() doesn't stack max_user_sectors.  It'll
> inform the underlying device's blk_validate_limits() calculation which
> will result in max_sectors having the desired value (which it already
> did, as I showed above).  But when stacking limits from underlying
> devices up to the higher-level dm-mpath queue_limits we still have
> information loss.
>
> Mike
>


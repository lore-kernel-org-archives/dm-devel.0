Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0389A18046
	for <dm-devel@lists.linux.dev>; Tue, 14 May 2024 05:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715665885; cv=none; b=J8G9am6eGa16GMjMeZSig1hM4Q/Nr0XIBO7LnaUPX/Zl4oUUt26stLHdrL6XI6UEtcI8i57CihWDvdB2TbyMnYeqSW77IXVZmDbJj1aCuF94yrNu8PIt7/W+v/TKhqF59F3rJQeIflMkux3vLpbOkOQjon9ED0lP/YioW/Z2Q3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715665885; c=relaxed/simple;
	bh=OF8o9YDp1xbXXS9pK3U5R7wgQQr0jKjnEAPulQ1fMhg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TDFso+klLiS9iQanMsalXwSvQ4Fqe3fJjAZIhmv4onGoY7j4uUpe5Da1x+b4wELa2NKeRAvWuKMjujCVhhajeauDYXpy91EHFIwbzrRvzL8px80HDSGrAkuYTBSvnnA5+3IMY4YRS/xbIkqyXdZiun45OYcM116Zy7Ib460Dn3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HcoKvcBF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HcoKvcBF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715665882;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FiYLFnKZivRpeJ4PWERZJck4xmYEwFKMbyVtwgpr9ws=;
	b=HcoKvcBFtxdGiFfEo5FUQ6hyTP+x/EQAcw22KvkpYEC9bqr0VR/11cT5iNi1tvREArGOxF
	VmfVIroBZ22ikiVe0FBhifmqt3/QHhZfYQeLaIFUxgW7JBU/VX1YyTUMoOC5ZG1Gw7FXsq
	C25+iT8XD3FWwJWBGP0O3hhbJZUTCqw=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-190-4gMsZrhYNsOcUES8qfDkag-1; Tue, 14 May 2024 01:51:21 -0400
X-MC-Unique: 4gMsZrhYNsOcUES8qfDkag-1
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-604bad9b2e8so4944891a12.2
        for <dm-devel@lists.linux.dev>; Mon, 13 May 2024 22:51:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715665880; x=1716270680;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FiYLFnKZivRpeJ4PWERZJck4xmYEwFKMbyVtwgpr9ws=;
        b=JiJ5f0+5RF/GtBKfP/DIOv+bg1Bc+epVFu/5Bt/uh7PV9seYPwX1AVCoLoUeMu9rxX
         eR8Ve6cBSZWSjJ9yNAuyWEgXrnVWuAQej7cmsDhnqBhE0Wn7OJgJHZXHOnSAOuo9auBS
         RmX4bRb+ADJkQmbi9+xm498HUnrwgsPQJ7IgHoiG0Js5PXTta7hTUx866wA6gXSojTrF
         r+nO78/bJTcGG2/6f/zcXWTPsWIFzA0ghfM5rq1DayXIc+oauMZJ2OCsZGdvS+X90fdD
         jQemm8cnX9o7octBpJ61D5BxJ7cyJqyXOsxUC12LbMAMdzNffaphBPOxOdXRNJuMVhuN
         4O4g==
X-Forwarded-Encrypted: i=1; AJvYcCU6HhVQ0U41FML1l4DM5GzK4yfZDyLmXX3Gwl9zxPJ6/M9qG+QYPSmi7UjZYkLJiUALJXeZ8WaMJ6WXMcqcusx+dteYd4+Ou2g=
X-Gm-Message-State: AOJu0Yw6xhaNzKx1t8o7uI49Hu8zwFWwML0OPufmT4bd7AcmCcnBYQI/
	wRIkqc90uyatBTYmVJRA/IJc4YEmMPy0MzCjAqE1GgvcLj2BTor9p/WaM9KLWC99rIQUf4ZRcUZ
	YuzqR0wk5tp7h5Es8hmwDt8Kjmb/KPN24ENusz0s6HnXokwoJUjy+eP2Z4ZvaSx9UvAHxJ1uELr
	rxrE+7lfIY3zbCsd8LVgsGPFE0/gSeIhQ=
X-Received: by 2002:a05:6a21:9207:b0:1af:fbab:cfba with SMTP id adf61e73a8af0-1affbabd1e5mr3839100637.27.1715665880387;
        Mon, 13 May 2024 22:51:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEY7xbn2J2Vy9Rqv5L4uLboL7HEssdNiD/t6t5qivKpv4cPvOh/U0ZqSPmB54v090ZDOMRtOFqS27x88F0RbUE=
X-Received: by 2002:a05:6a21:9207:b0:1af:fbab:cfba with SMTP id
 adf61e73a8af0-1affbabd1e5mr3839080637.27.1715665880007; Mon, 13 May 2024
 22:51:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240509011900.2694291-1-yukuai1@huaweicloud.com> <20240509011900.2694291-2-yukuai1@huaweicloud.com>
In-Reply-To: <20240509011900.2694291-2-yukuai1@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Tue, 14 May 2024 13:51:08 +0800
Message-ID: <CALTww2_2UG49wxNZv1Ay7u9X-2SoV31ca-=2K8uWHH9nRT2Apw@mail.gmail.com>
Subject: Re: [PATCH md-6.10 1/9] md: rearrange recovery_flage
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org, 
	dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-raid@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com, 
	yangerkun@huawei.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 13, 2024 at 9:57=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> From: Yu Kuai <yukuai3@huawei.com>
>
> Currently there are lots of flags and the names are confusing, since
> there are two main types of flags, sync thread runnng status and sync
> thread action, rearrange and update comment to improve code readability,
> there are no functional changes.
>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  drivers/md/md.h | 52 ++++++++++++++++++++++++++++++++++++-------------
>  1 file changed, 38 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 029dd0491a36..2a1cb7b889e5 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -551,22 +551,46 @@ struct mddev {
>  };
>
>  enum recovery_flags {
> +       /* flags for sync thread running status */
> +
> +       /*
> +        * set when one of sync action is set and new sync thread need to=
 be
> +        * registered, or just add/remove spares from conf.
> +        */
> +       MD_RECOVERY_NEEDED,
> +       /* sync thread is running, or about to be started */
> +       MD_RECOVERY_RUNNING,
> +       /* sync thread needs to be aborted for some reason */
> +       MD_RECOVERY_INTR,
> +       /* sync thread is done and is waiting to be unregistered */
> +       MD_RECOVERY_DONE,
> +       /* running sync thread must abort immediately, and not restart */
> +       MD_RECOVERY_FROZEN,
> +       /* waiting for pers->start() to finish */
> +       MD_RECOVERY_WAIT,
> +       /* interrupted because io-error */
> +       MD_RECOVERY_ERROR,
> +
> +       /* flags determines sync action */
> +
> +       /* if just this flag is set, action is resync. */
> +       MD_RECOVERY_SYNC,
> +       /*
> +        * paired with MD_RECOVERY_SYNC, if MD_RECOVERY_CHECK is not set,
> +        * action is repair, means user requested resync.
> +        */
> +       MD_RECOVERY_REQUESTED,
>         /*
> -        * If neither SYNC or RESHAPE are set, then it is a recovery.
> +        * paired with MD_RECOVERY_SYNC and MD_RECOVERY_REQUESTED, action=
 is
> +        * check.

Hi Kuai

I did a test as follows:

echo check > /sys/block/md0/md/sync_action
I added some logs in md_do_sync to check these bits. It only prints
MD_RECOVERY_SYNC and MD_RECOVERY_CHECK without MD_RECOVERY_SYNC. So
the comment is not right?

Best Regards
Xiao

>          */
> -       MD_RECOVERY_RUNNING,    /* a thread is running, or about to be st=
arted */
> -       MD_RECOVERY_SYNC,       /* actually doing a resync, not a recover=
y */
> -       MD_RECOVERY_RECOVER,    /* doing recovery, or need to try it. */
> -       MD_RECOVERY_INTR,       /* resync needs to be aborted for some re=
ason */
> -       MD_RECOVERY_DONE,       /* thread is done and is waiting to be re=
aped */
> -       MD_RECOVERY_NEEDED,     /* we might need to start a resync/recove=
r */
> -       MD_RECOVERY_REQUESTED,  /* user-space has requested a sync (used =
with SYNC) */
> -       MD_RECOVERY_CHECK,      /* user-space request for check-only, no =
repair */
> -       MD_RECOVERY_RESHAPE,    /* A reshape is happening */
> -       MD_RECOVERY_FROZEN,     /* User request to abort, and not restart=
, any action */
> -       MD_RECOVERY_ERROR,      /* sync-action interrupted because io-err=
or */
> -       MD_RECOVERY_WAIT,       /* waiting for pers->start() to finish */
> -       MD_RESYNCING_REMOTE,    /* remote node is running resync thread *=
/
> +       MD_RECOVERY_CHECK,
> +       /* recovery, or need to try it */
> +       MD_RECOVERY_RECOVER,
> +       /* reshape */
> +       MD_RECOVERY_RESHAPE,
> +       /* remote node is running resync thread */
> +       MD_RESYNCING_REMOTE,
>  };
>
>  enum md_ro_state {
> --
> 2.39.2
>


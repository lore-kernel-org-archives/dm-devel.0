Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8878B1B7FD
	for <dm-devel@lists.linux.dev>; Tue, 14 May 2024 06:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715667228; cv=none; b=cNcCqVc4qoB24RBdr9nyBE/fzCg1xKRK8Ibcveqqg39UhGujIDIl0dvOO6FGO2zsx8cUjQ7JJblMw2TR0pbNBx8pNrP1t4Y5ERwKLRxSO0bO2y+JYONJIeA8UckIoiZwX/keEin+BQghV2ihfc5KHpnDJtp6WFGpm30zedAnmog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715667228; c=relaxed/simple;
	bh=qEjGhlQZJJ90rSaBtG/Fvx7YJHzstZH0d56H+Ox7MCk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sUzo8VGpBBJ4G77dzlznMhDCAmpogUneLUGuO1HmeOPeAdYEyUJ2F5viPjWUEMDBjCGi7D1TsUFhyRuwCtL3lXLGnPhPKYqIy+9Qw81FUaF0k/fFixAFxTyBlJa2YO+qJMLo0MhC6692ZwNdQ8o62aNGy/GpPQ7fO/csFxX1r6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LU0V2qVC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LU0V2qVC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715667225;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P6B0DumV2udlVipcUJf/RNNgM5snKSkCNhRyGCU8nt4=;
	b=LU0V2qVCRHvUyIhu2F06iZq/VPi5/ukDyCYWO/mlBv2PX6WGmOZl4S4av0co8ykdlIlsUx
	UbqA7UyII4kG9wzZz/Xzp0rbPxf0pD7fhkpDXca6tM98uT+cfaLmA9oQZfsxHWYIet3v6e
	zGZM2kd/c0NWFAZK25PDXOAnT6zqaAk=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-477-6bXSc55VM-y--Tj02DSSTA-1; Tue, 14 May 2024 02:13:44 -0400
X-MC-Unique: 6bXSc55VM-y--Tj02DSSTA-1
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-6f452eb2035so4940028b3a.0
        for <dm-devel@lists.linux.dev>; Mon, 13 May 2024 23:13:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715667223; x=1716272023;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P6B0DumV2udlVipcUJf/RNNgM5snKSkCNhRyGCU8nt4=;
        b=WOOwKCkz5tU/D/BP3dtD8Fp6j3WYjoZ+M0YlyfzpSSZwY7xrunXGs/ulHZzVBEsyK+
         wD/kP1Bbjy+9+WeWaZDNqgrax7OZ8zl6zawLt6+sGS7e+w/IBh0id9VeAEOup37rP9+V
         HS865GAZ+taSdMPchi3qR8WEv1MnTBoxO43szbF9V0IfLcn8NSWcJNwIiDjcL9wynqV2
         L+7QW3NjfAHPX63wdJw9zTpgyTjuNTHhqUKBAaEjUWkZBeSmqmNUYPr5WVl7K/i/veUX
         3t8qKjxX0Xsu2CAMDhtwjCa46wpu7S+YSD3sMVWa12hJbx+CFOFndxvVXMKTMa4DO6RJ
         aLyQ==
X-Forwarded-Encrypted: i=1; AJvYcCXhp9hY+/u9E1H1gnIYPylCOmGbS1UElCQW+MeHRGlkChz1Qt80NnbcnQiIiVpdakoGA3zjIF5PPrJNMo79rCnW+yb1DKtJ4lU=
X-Gm-Message-State: AOJu0YxG0EskYVt6om+TB/D6NvCYo2lUE+NeJRaIqHZV1thHo6YFxCQc
	bXi7Yu5KvK+G91p5o6HS0YaW1S62M4cNQUGuY9dFeXjItQT3+wCv/umtDwY5zTd/rYmxfMrHln5
	OrrCORZcPv44pupYcIc31dvNUv9Jd2uIwIDW1zqjhhF9c+UQhnC3H5hQffYPsn2J7HUrl4bzwxd
	6Eipr1IU+Bs8KZ3Tv4ArcFiH/3Eozjdes=
X-Received: by 2002:a05:6a21:19c:b0:1a3:df1d:deba with SMTP id adf61e73a8af0-1afde0dc95amr12474880637.31.1715667222692;
        Mon, 13 May 2024 23:13:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE/yVQHUfYGCuo3MWod5iRA3A17cM+ibG3X8Vh9ykLbjxo2us8ibYX8tJQ2E5RvUodUrPf4VNlb2IEhNNSuVBA=
X-Received: by 2002:a05:6a21:19c:b0:1a3:df1d:deba with SMTP id
 adf61e73a8af0-1afde0dc95amr12474864637.31.1715667222322; Mon, 13 May 2024
 23:13:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240509011900.2694291-1-yukuai1@huaweicloud.com> <20240509011900.2694291-3-yukuai1@huaweicloud.com>
In-Reply-To: <20240509011900.2694291-3-yukuai1@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Tue, 14 May 2024 14:13:30 +0800
Message-ID: <CALTww28Qjce6jG+v6=8vubiBWoCt5=21_-VE6hgOMU2HZxnF=g@mail.gmail.com>
Subject: Re: [PATCH md-6.10 2/9] md: add a new enum type sync_action
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org, 
	dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-raid@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com, 
	yangerkun@huawei.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 13, 2024 at 6:19=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> From: Yu Kuai <yukuai3@huawei.com>
>
> In order to make code related to sync_thread cleaner in following
> patches, also add detail comment about each sync action.
>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  drivers/md/md.h | 57 ++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 56 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 2a1cb7b889e5..2edad966f90a 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -34,6 +34,61 @@
>   */
>  #define        MD_FAILFAST     (REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPOR=
T)
>
> +/* Status of sync thread. */
> +enum sync_action {
> +       /*
> +        * Represent by MD_RECOVERY_SYNC, start when:
> +        * 1) after assemble, sync data from first rdev to other copies, =
this
> +        * must be done first before other sync actions and will only exe=
cute
> +        * once;
> +        * 2) resize the array(notice that this is not reshape), sync dat=
a for
> +        * the new range;
> +        */
> +       ACTION_RESYNC,
> +       /*
> +        * Represent by MD_RECOVERY_RECOVER, start when:
> +        * 1) for new replacement, sync data based on the replace rdev or
> +        * available copies from other rdev;
> +        * 2) for new member disk while the array is degraded, sync data =
from
> +        * other rdev;
> +        * 3) reassemble after power failure or re-add a hot removed rdev=
, sync
> +        * data from first rdev to other copies based on bitmap;
> +        */
> +       ACTION_RECOVER,
> +       /*
> +        * Represent by MD_RECOVERY_SYNC | MD_RECOVERY_REQUESTED |
> +        * MD_RECOVERY_CHECK, start when user echo "check" to sysfs api

Same question with patch 01 here

Regards
Xiao

> +        * sync_action, used to check if data copies from differenct rdev=
 are
> +        * the same. The number of mismatch sectors will be exported to u=
ser
> +        * by sysfs api mismatch_cnt;
> +        */
> +       ACTION_CHECK,
> +       /*
> +        * Represent by MD_RECOVERY_SYNC | MD_RECOVERY_REQUESTED, start w=
hen
> +        * user echo "repair" to sysfs api sync_action, usually paired wi=
th
> +        * ACTION_CHECK, used to force syncing data once user found that =
there
> +        * are inconsistent data,
> +        */
> +       ACTION_REPAIR,
> +       /*
> +        * Represent by MD_RECOVERY_RESHAPE, start when new member disk i=
s added
> +        * to the conf, notice that this is different from spares or
> +        * replacement;
> +        */
> +       ACTION_RESHAPE,
> +       /*
> +        * Represent by MD_RECOVERY_FROZEN, can be set by sysfs api sync_=
action
> +        * or internal usage like setting the array read-only, will forbi=
d above
> +        * actions.
> +        */
> +       ACTION_FROZEN,
> +       /*
> +        * All above actions don't match.
> +        */
> +       ACTION_IDLE,
> +       NR_SYNC_ACTIONS,
> +};
> +
>  /*
>   * The struct embedded in rdev is used to serialize IO.
>   */
> @@ -571,7 +626,7 @@ enum recovery_flags {
>         /* interrupted because io-error */
>         MD_RECOVERY_ERROR,
>
> -       /* flags determines sync action */
> +       /* flags determines sync action, see details in enum sync_action =
*/
>
>         /* if just this flag is set, action is resync. */
>         MD_RECOVERY_SYNC,
> --
> 2.39.2
>


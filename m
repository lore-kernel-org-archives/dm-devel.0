Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E78841A80
	for <dm-devel@lists.linux.dev>; Wed, 22 May 2024 20:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716410051; cv=none; b=D8NNTsJFBslqfaMIGUCy3D6LeE0s63ocsxmFvqVZ/Q7RRznm02mSjHAqMoZjRzJBjYLHZyCAoKVxAzKPbHKfn0tRPC8uL6V2+B4NHjcIGBaKMumdJR4a8ZDZYaOBQnAwygk39OvGatoQzUrk6JrbuMNWaKcE3QuWZk9rkYIPmxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716410051; c=relaxed/simple;
	bh=lw7qxI1EG5k1V/CgFWFkAlmixJPYuYeuePjzKcJEqN8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IKl29uDDfO2rRhp9EjCQkXT/ywB5hpe0IN2ZLzlGGteMZ0jOiZIvujloajwrxwnDi811YyVbldPioYv9nYlbMsW9V3g3Gh8ymaYnh8cz4a5d8cUQHEmLgx1FgZyyD9qoGjjeBPeHk+NsNm6rGrMa4rXsu0sI2eLHU4YmrGrtkaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hlPx46SY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hlPx46SY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716410047;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ge373HOlN0Aik/3EkLuJhurpwm+4P7IPirL4EqDjrfg=;
	b=hlPx46SYqPJsZHogMxCQ8sQqxL+S7F0yVnkjqv8LHnDWWWA+eQIQTa8bhsY//QcwKlBfjx
	Sd+WZoaqnMJIapCm2ZZ3VZquH8/gpv6/1rDPPZWtZxrEJ4bGOtn8PvFlMVWVsWvTK7PpBw
	0acdrUCP3VsNZvZODz9932Rr5mdA9XY=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-609-bOBF-DJLMmujjL-k6x5hCg-1; Wed, 22 May 2024 16:34:06 -0400
X-MC-Unique: bOBF-DJLMmujjL-k6x5hCg-1
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-627e6fe0303so21748397b3.2
        for <dm-devel@lists.linux.dev>; Wed, 22 May 2024 13:34:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716410045; x=1717014845;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ge373HOlN0Aik/3EkLuJhurpwm+4P7IPirL4EqDjrfg=;
        b=ttbyCerLOiUARXF8cH3G0m1sEcc+0iupmQ+VcTpNSlO3YgjcahtgoVdeGBypR/XM7o
         17gtHcksZMaQrVvUeq4E5V862y18yL+/bt0eDdt7pWo72Mi7TkqWuApVPmP/vxHQWeLd
         qCGHgTZNkKE5vc978P1dGk4in4qWqJVi5yqwieRzI6+98N7EOk1FyI0fD1m5Okjrr1Ws
         7w2diLfdO0NuA2yEdOvDAi2xW6uNsmlC79aC9fufT2yjomu93UNbzrL8aRRIpg54V+U4
         s7Q/F9Y732LuepclRkOt6JO8afUmP7rVmwWiMRUd9LhXaOFdECUzl8RAQWgoz3ODJe3t
         B2sA==
X-Gm-Message-State: AOJu0YzMhg3gsKIL1dF+oz5vkLWABIQC3xLTPlcJbzOTiK4kX8vs2kdl
	BBBhal1F8Q5XtJ882shOJnxY/ftQuu1dovoMqvgnoiHZDcUnV68EWvoemSNSEQuN7/QrjrGIM2S
	8kvPwQCCdEDj0CjzbcvUQ0dBU2DaU6ukAtyj0JXNu/2xiu6S4wzrVtqlWeFgiBlHx2cNNGVNfor
	EFPFTByCIsa3F1e01t2x+g2LQLg8OV8UM=
X-Received: by 2002:a81:92d7:0:b0:618:8a27:6150 with SMTP id 00721157ae682-627e46df567mr31092217b3.24.1716410045490;
        Wed, 22 May 2024 13:34:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEquxDTlRXGGA4s22WX4KXYImQfH+64pcqPMeHwlR2wNKwmu5VhT1cWrWZHjKw90Pdk3ZCZHnvRz+hJXHtXZdo=
X-Received: by 2002:a81:92d7:0:b0:618:8a27:6150 with SMTP id
 00721157ae682-627e46df567mr31092057b3.24.1716410045103; Wed, 22 May 2024
 13:34:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240522025117.75568-1-snitzer@kernel.org>
In-Reply-To: <20240522025117.75568-1-snitzer@kernel.org>
From: Ewan Milne <emilne@redhat.com>
Date: Wed, 22 May 2024 16:33:53 -0400
Message-ID: <CAGtn9rkcsmOiw0ZLA5DTYbybROMqp0rUTCbh9h0b1r29TB9oDw@mail.gmail.com>
Subject: Re: [PATCH] dm: retain stacked max_sectors when setting queue_limits
To: Mike Snitzer <snitzer@kernel.org>
Cc: dm-devel@lists.linux.dev, linux-block@vger.kernel.org, hch@lst.de, 
	Marco Patalano <mpatalan@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 21, 2024 at 10:51=E2=80=AFPM Mike Snitzer <snitzer@kernel.org> =
wrote:
>
> Otherwise, blk_validate_limits() will throw-away the max_sectors that
> was stacked from underlying device(s). In doing so it can set a
> max_sectors limit that violates underlying device limits.
>
> This caused dm-multipath IO failures like the following because the
> underlying devices' max_sectors were stacked up to be 1024, yet
> blk_validate_limits() defaulted max_sectors to BLK_DEF_MAX_SECTORS_CAP
> (2560):
>
> [ 1214.673233] blk_insert_cloned_request: over max size limit. (2048 > 10=
24)
> [ 1214.673267] device-mapper: multipath: 254:3: Failing path 8:32.
> [ 1214.675196] blk_insert_cloned_request: over max size limit. (2048 > 10=
24)
> [ 1214.675224] device-mapper: multipath: 254:3: Failing path 8:16.
> [ 1214.675309] blk_insert_cloned_request: over max size limit. (2048 > 10=
24)
> [ 1214.675338] device-mapper: multipath: 254:3: Failing path 8:48.
> [ 1214.675413] blk_insert_cloned_request: over max size limit. (2048 > 10=
24)
> [ 1214.675441] device-mapper: multipath: 254:3: Failing path 8:64.
>
> The initial bug report included:
>
> [   13.822701] blk_insert_cloned_request: over max size limit. (248 > 128=
)
> [   13.829351] device-mapper: multipath: 253:3: Failing path 8:32.
> [   13.835307] blk_insert_cloned_request: over max size limit. (248 > 128=
)
> [   13.841928] device-mapper: multipath: 253:3: Failing path 65:16.
> [   13.844532] blk_insert_cloned_request: over max size limit. (248 > 128=
)
> [   13.854363] blk_insert_cloned_request: over max size limit. (248 > 128=
)
> [   13.854580] device-mapper: multipath: 253:4: Failing path 8:48.
> [   13.861166] device-mapper: multipath: 253:3: Failing path 8:192.
>
> Reported-by: Marco Patalano <mpatalan@redhat.com>
> Reported-by: Ewan Milne <emilne@redhat.com>
> Fixes: 1c0e720228ad ("dm: use queue_limits_set")
> Signed-off-by: Mike Snitzer <snitzer@kernel.org>
> ---
>  drivers/md/dm-table.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index 88114719fe18..6463b4afeaa4 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -1961,6 +1961,7 @@ int dm_table_set_restrictions(struct dm_table *t, s=
truct request_queue *q,
>                               struct queue_limits *limits)
>  {
>         bool wc =3D false, fua =3D false;
> +       unsigned int max_hw_sectors;
>         int r;
>
>         if (dm_table_supports_nowait(t))
> @@ -1981,9 +1982,16 @@ int dm_table_set_restrictions(struct dm_table *t, =
struct request_queue *q,
>         if (!dm_table_supports_secure_erase(t))
>                 limits->max_secure_erase_sectors =3D 0;
>
> +       /* Don't allow queue_limits_set() to throw-away stacked max_secto=
rs */
> +       max_hw_sectors =3D limits->max_hw_sectors;
> +       limits->max_hw_sectors =3D limits->max_sectors;
>         r =3D queue_limits_set(q, limits);
>         if (r)
>                 return r;
> +       /* Restore stacked max_hw_sectors */
> +       mutex_lock(&q->limits_lock);
> +       limits->max_hw_sectors =3D max_hw_sectors;
> +       mutex_unlock(&q->limits_lock);
>
>         if (dm_table_supports_flush(t, (1UL << QUEUE_FLAG_WC))) {
>                 wc =3D true;
> --
> 2.43.0
>

This fixed the FC DM-MP failures, so:

Tested-by: Marco Patalano <mpatalan@redhat.com>
Revewied-by: Ewan D. Milne <emilne@redhat.com>


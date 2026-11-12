Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794481751;
	b=eRPgWFKlRqLhHBpLD2ywwFnAWW6YqTECEePuXh6SR80ulJLs5i2Pf4hRKJL9PIt0jCp2
	 hbwuZSC9X1CWO+2vu+CK2HYfv9dji0FrD5Vd3XOBpZgpsO5C+dLpmFO+MDbfkF7OqQayS
	 xSUUwUQUnrgxODLO+z8g7/gLngCxV1MEQHTHXQdlzH+vH0LenPEE+Bq0bGCljFcyWBEHI
	 32gx0PLhfZFKt2wqMrmTQ44R7Bz7QnyBNtu7IvXHiww3qBk45N6fO2lDxDWjUUI7nYoUB
	 WlLJAa9Q7cNa7n1zMstCyUHQcDYLEZNCXb3d6FU/INMxmo+IaS+7M55/MdVWr667XrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794481751;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:MIME-Version:References:In-Reply-To:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Cc:X-Mimecast-Spam-Score:
	 X-Mimecast-MFC-PROC-ID:X-Mimecast-Originator:Content-Type:
	 Content-Transfer-Encoding;
	bh=TjUTucK+fDwBhweUm3d5TAgFRX+xfgS/F2Y1mD/lATc=;
	b=etxlwvR7ZFgI0X5JBg6Cy1hXPbqcM2S4klVHZoWnGjMd5sBH3gOn9NpokAj8/pm5EgQS
	 BvrDMV454qRdrJO3ZRrJB6gtMv1I6AGGfy0ylCJJJv5cssFA3MCzvYH0x/5VKIX+lDZlN
	 gfkNpArPhaYpXTZ7F/TTysiDf9krwBD/3qtFF22EDPntA+S5XQMgsoVMELHdyb2YsSxAv
	 d+xy64AZMmxc7PUXWXMTTBAcgReny6pmvldS0vz2gKLV2vK93YPexotS9wI6aYtJo0541
	 uzjV5YM5A82jOg1NUNpaXKURggXM8JeWy/c+VH/H2ScKep9ipmMkieX4AJ2/+4Vn2DQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=F3iK6cCK;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 145E1606A321
	for <dm-devel@lists.linux.dev>; Thu, 12 Nov 2026 11:09:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 145E1606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=F3iK6cCK
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794481749;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TjUTucK+fDwBhweUm3d5TAgFRX+xfgS/F2Y1mD/lATc=;
	b=F3iK6cCKB4GqVUZ4dzzxKJPWWRpWQ7QAa2gZDb8chXw+qh6Ez4ox2vAf0SjpIg5Xa7jTTv
	AeN3q+zVK2tM0/ASpnuxh9GaAju/MaSwu2bd/J4rNWqCth3vwMbKKVmmSqZloVbZPS1Yyo
	qcdo0PeeMPaxo6m3RGs747ZiTONaw2Y=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-616-gu_Zi9gINKKFYeP9QAGt9A-1; Thu, 12 Nov 2026 06:09:07 -0500
X-MC-Unique: gu_Zi9gINKKFYeP9QAGt9A-1
X-Mimecast-MFC-AGG-ID: gu_Zi9gINKKFYeP9QAGt9A_1794481746
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-5be4b14ffd6so369330e87.1
        for <dm-devel@lists.linux.dev>; Thu, 12 Nov 2026 03:09:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794481746; x=1795086546;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TjUTucK+fDwBhweUm3d5TAgFRX+xfgS/F2Y1mD/lATc=;
        b=r6GX8NwEutGXDBroowlMO/fuhBOHY2ZLVqOS67yXcyiHj09Ly6hlR3EcP5s6yi6pm2
         6oOM+XbPFbrKE6qOtcsP1dgU4Rl1W+bCUpNCvD9sBoX1qt8odU+x8D66LFhoW60zuXAm
         tk0U4cBJdAzXOFDrL82WhfBIAaEKYh6cCBquxcd7nsWFKCgNinHsqMBqRqENPpEN0zEe
         QwO1pd+ebDFredWcwvKYNwcT2CQco3M6ZSuNf3gJixRJVsn/vRrWe6SbW8BKnFQl0jYA
         xeIOLEW0WeOmAn1nZQWj4VORBS190AoFFRaDtrEmtO6UVG8qfWVUcshWhhuiyRF0P2sX
         GNRA==
X-Forwarded-Encrypted: i=1; AL+hErE9AvVv28352AiV4rq9akVpPFgCLkuFdVr6lPaIIQixsT0mLeegKVvS9rPj8oNaic6N18jlrQ0v+Q==@lists.linux.dev
X-Gm-Message-State: APuU4Z8H61Dwci69asP5Ezih4qTiDGnFbB+oRWM/xCjSmSbOWni+Tjfh
	MfJc0M2uhqiFXEgjNw/RRKfpZAELIF3gXuCZuCRbw1svDGFpQsfRYTuTUymADot8Gj0Qa/2xw8/
	8s5w87fTEqdcgJUXS3TwaEeDVGU3M1SC4N/usqpqFMx4QTOrWzhyVMJ2XrZajdO4+NBHkuGSu6s
	yImtGfiwV+LGy6+2uuj/pv+STg6JqRbwInqw==
X-Gm-Gg: AYBFou1BAJYSik5hbkbxoeWsU6Va0aMQVuvB3AE6+JaB/pwcGbzfRez9iIIfU7rUblQ
	h3hRsrgCxH+YPeGJaYxxfMKA+q2BO0FvsaG/WYpeH09v2WjJ2JqSLKcS8zDuy3XXd0zlw+rTx1O
	PodOeBfdTFO3jCJYvmUrbYNLpe1w3L7xnhZynzbE6JpZhHrwTtipwk++IxUIXWtWeXSSXwTiDch
	KvfYwWFr/UsM8E1j8w9065Vt0r9X4bBAWwYXla+45/1pkXkvy0=
X-Received: by 2002:a2e:a881:0:b0:3ac:4b79:573b with SMTP id 38308e7fff4ca-3ae1bf86ff2mr4320381fa.13.1794481745776;
        Thu, 12 Nov 2026 03:09:05 -0800 (PST)
X-Received: by 2002:a2e:a881:0:b0:3ac:4b79:573b with SMTP id
 38308e7fff4ca-3ae1bf86ff2mr4320331fa.13.1794481745244; Thu, 12 Nov 2026
 03:09:05 -0800 (PST)
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <6a3e4a64-3719-3a3f-1d51-1a7b478e046e@redhat.com>
In-Reply-To: <6a3e4a64-3719-3a3f-1d51-1a7b478e046e@redhat.com>
From: Ming Hung Tsai <mtsai@redhat.com>
Date: Thu, 12 Nov 2026 19:08:53 +0800
X-Gm-Features: AclHuK-Jf4TXBUWDRbYEQcekUkOQHXezjZnl89GmACRGMZDTEKA_D-rGfUuqA90
Message-ID: <CALjSBEsrtKKPFu4mjNcLOn11K_86ssiJ5pN5DMEQzHV1dEYCPQ@mail.gmail.com>
Subject: Re: [PATCH] dm-thin: fix leak if __set_snapshot_details fails
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
	Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 2x-vi9aMdl2OGXQxsSwXKjLuf19JLgEfZmEor5H53xA_1794481746
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 7, 2026 at 2:49=E2=80=AFAM Mikulas Patocka <mpatocka@redhat.com=
> wrote:
>
> If __set_snapshot_details fails, the variable td is leaked - this
> prevents any other snapshot with the same id from being created.
>
> Fix this by removing it from the list and freeing it.
>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Assisted-by: Claude:claude-opus-5
> Cc: stable@vger.kernel.org
> Fixes: 991d9fa02da0 ("dm: add thin provisioning target")
>
> ---
>  drivers/md/dm-thin-metadata.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> Index: linux-2.6/drivers/md/dm-thin-metadata.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/drivers/md/dm-thin-metadata.c
> +++ linux-2.6/drivers/md/dm-thin-metadata.c
> @@ -1225,10 +1225,13 @@ static int __create_snap(struct dm_pool_
>         __close_device(td);
>
>         if (r)
> -               goto bad;
> +               goto bad2;
>
>         return 0;
>
> +bad2:
> +       list_del(&td->list);
> +       kfree(td);
>  bad:
>         dm_btree_remove(&pmd->tl_info, pmd->root, &key, &pmd->root);
>         dm_btree_remove(&pmd->details_info, pmd->details_root,
>
>

The bug is hard to trigger. __set_snapshot_details() fails only when
__open_device(origin) fails. There are three causes: the origin
details are missing, the metadata read fails, or kmalloc() fails. All
three are corner cases. Even so, the patch is still needed. Otherwise
td stays on pmd->thin_devices with changed =3D 1. On the next metadata
commit, __write_changed_details() writes this invalid device entry
into the details tree, breaking consistency between the mapping tree
and the details tree.

There is a separate issue in the same error path. The final
dm_btree_remove(&pmd->details_info, ...) at the bad: label should be
removed. The snapshot details are not in the details tree during
__create_snap(), so this call always runs on a missing key and returns
-ENODATA. dm_btree_remove() skips the new_root update on -ENODATA, but
create_snap's error path ignores this return code and commits the
undefined metadata anyway. This leaves pmd->details_root dangling and
leaks metadata blocks. I'll send a separate patch to drop the
details_info remove.

Reviewed-by: Ming-Hung Tsai <mtsai@redhat.com>


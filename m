Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 095D819CD07
	for <dm-devel@lists.linux.dev>; Tue, 10 Dec 2024 16:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733848544; cv=none; b=eh9nbqPeBNtPOwbgrVjVDpPSHxWKlaMfOnn8iOnqIkvXh4qUky46zSsGAW35K9Um2oxhyNkv7YLG6XooQ1mvkVRAG3N6fg65P7r1O4yNnAF1VMjwYpE9zi/+GD1Ajzq49nV782u5AYX9rIYZlY3S/1sih5F9jyyFuC57iQEEF4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733848544; c=relaxed/simple;
	bh=j5P5Ri87jsKjxrDiyD+9eRxBlhsWIVsHGxZQIF8rNdI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SoAt0zJi61/JkvQxu22zdSFnIystdCaQz3sTQW34Itg+t3hdxLPxpQLaRWqCer/JEvgL1IcwC++ZfESN+bUadxl8mBrgoFP2BjPsL0rEhH5HZoRGlm4YTEw4USQCen8N7Z+IxCwIygrv4YJlhr31q5it6pT/I9cF8YwX10hDXHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CNjTatCi; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CNjTatCi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733848541;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1fs+d7KELqE/JaG9MrHp+pZ6XReDOf6rydyafGQcIpk=;
	b=CNjTatCiPv3PiFOsHtyRfZj8EaP3BqRCpaF1gN6dZ/gFwVrbcPK3UTvrirJNs606WqnfF3
	xrSzbGHNvNyc8PiSFM8L1D7CpVm06N4gIoDULzXmuMdsaeNrg96IKNvw6AjtT/K9oaEeuH
	R8zxN82P1ecLrSBoBOasYze/Goxih/8=
Received: from mail-yb1-f199.google.com (mail-yb1-f199.google.com
 [209.85.219.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-549-WBRoztLCO_OfTSugdq-WwA-1; Tue, 10 Dec 2024 11:35:40 -0500
X-MC-Unique: WBRoztLCO_OfTSugdq-WwA-1
X-Mimecast-MFC-AGG-ID: WBRoztLCO_OfTSugdq-WwA
Received: by mail-yb1-f199.google.com with SMTP id 3f1490d57ef6-e3a0f608b88so5913900276.0
        for <dm-devel@lists.linux.dev>; Tue, 10 Dec 2024 08:35:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733848540; x=1734453340;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1fs+d7KELqE/JaG9MrHp+pZ6XReDOf6rydyafGQcIpk=;
        b=n1x63fIXzbbcB7t5Ly49dMymirJWFL1llXF4S8H1ktXApNuSh9X9JSOrQbVIyqXpav
         iXOUiayMnzPIFvHacl2UeO/+br0jchtGmMMVWKhvjBQoLuc1wj2guP920ezt+CRVQwR7
         CYCKApj61c507PJuOBudrI8OxrkSk4NahfycZ/gjtKM7B1N62u1EuEdQTY6ZV3c0r1sB
         0zCwRCfS9XOBLTi6xVPzZKHG5f4pCQOknjHqULdyKJ20VV13dMaVyPwivAUupNNVSA3J
         adB4wvLzD4XbGPXvRmtKAAATRTzE44RuRgl1pi4Fcyog3hbW6TGYiiQs8QoqSOPGDwa3
         vl+w==
X-Gm-Message-State: AOJu0Yy7pVZcp++okpCi9wnNWUZcrrxYqoOD3P0Hf+FroHIph31wkrLU
	qwFta/Toih7G3GsxxsCWfksBeot/docqMdtH0jk1irZ2Jr4OBTFSXzXca/QI4oqEJMeaBk/dARK
	Qh8kP21ZfVOdTQVEUgymc8YDqOVrjuwbXeHswxv7UcleFzJ61nTyGU8Yp1RLzCj6uZuwrxG9UBI
	SSjil64CKDf47ts2vS5bIf0AD+Ud5h6sY=
X-Gm-Gg: ASbGncto8wVV8//nbFFjHSWMYsI649OfigbuiY20hFqkB1fis5YxcNaipMS3AyVbJSh
	vVGgcVkJAL37TovtAMu6hPROmS88YrLl3uTU=
X-Received: by 2002:a05:6902:1509:b0:e3a:4f3f:af41 with SMTP id 3f1490d57ef6-e3a59b00e5fmr4176513276.17.1733848540170;
        Tue, 10 Dec 2024 08:35:40 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFLdgO9ozWrINqtWh4GUhIwyKPwOGWAp8lxhoVw2VmfNGpBpAkEx3qrmPw9NYhq5VWSPIwJ+evf4HiECYMc840=
X-Received: by 2002:a05:6902:1509:b0:e3a:4f3f:af41 with SMTP id
 3f1490d57ef6-e3a59b00e5fmr4176498276.17.1733848539908; Tue, 10 Dec 2024
 08:35:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241203173756.1257967-1-mtsai@redhat.com> <20241203174643.1259197-1-mtsai@redhat.com>
In-Reply-To: <20241203174643.1259197-1-mtsai@redhat.com>
From: Joe Thornber <thornber@redhat.com>
Date: Tue, 10 Dec 2024 16:35:00 +0000
Message-ID: <CAJ0trDbzsZ5dAd=LP0kWUScxXb8UKMhprUX+QJUqMQZ=UgaYuw@mail.gmail.com>
Subject: Re: [PATCH 1/3] dm array: fix releasing a faulty array block twice in dm_array_cursor_end
To: Ming-Hung Tsai <mtsai@redhat.com>
Cc: dm-devel@lists.linux.dev, Mikulas Patocka <mpatocka@redhat.com>, 
	Heinz Mauelshagen <heinzm@redhat.com>, Mike Snitzer <snitzer@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 7I6795zvS65CC6C7s04LyyKacCtXurRUNhdAjp6nWaw_1733848540
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Reviewed-by: thornber@redhat.com

On Tue, Dec 3, 2024 at 5:47=E2=80=AFPM Ming-Hung Tsai <mtsai@redhat.com> wr=
ote:
>
> When dm_bm_read_lock() fails due to locking or checksum errors, it
> releases the faulty block implicitly while leaving an invalid output
> pointer behind. The caller of dm_bm_read_lock() should not operate on
> this invalid dm_block pointer, or it will lead to undefined result.
> For example, the dm_array_cursor incorrectly caches the invalid pointer
> on reading a faulty array block, causing a double release in
> dm_array_cursor_end(), then hitting the BUG_ON in dm-bufio cache_put().
>
> Reproduce steps:
>
> 1. initialize a cache device
>
> dmsetup create cmeta --table "0 8192 linear /dev/sdc 0"
> dmsetup create cdata --table "0 65536 linear /dev/sdc 8192"
> dmsetup create corig --table "0 524288 linear /dev/sdc $262144"
> dd if=3D/dev/zero of=3D/dev/mapper/cmeta bs=3D4k count=3D1
> dmsetup create cache --table "0 524288 cache /dev/mapper/cmeta \
> /dev/mapper/cdata /dev/mapper/corig 128 2 metadata2 writethrough smq 0"
>
> 2. wipe the second array block offline
>
> dmsteup remove cache cmeta cdata corig
> mapping_root=3D$(dd if=3D/dev/sdc bs=3D1c count=3D8 skip=3D192 \
> 2>/dev/null | hexdump -e '1/8 "%u\n"')
> ablock=3D$(dd if=3D/dev/sdc bs=3D1c count=3D8 skip=3D$((4096*mapping_root=
+2056)) \
> 2>/dev/null | hexdump -e '1/8 "%u\n"')
> dd if=3D/dev/zero of=3D/dev/sdc bs=3D4k count=3D1 seek=3D$ablock
>
> 3. try reopen the cache device
>
> dmsetup create cmeta --table "0 8192 linear /dev/sdc 0"
> dmsetup create cdata --table "0 65536 linear /dev/sdc 8192"
> dmsetup create corig --table "0 524288 linear /dev/sdc $262144"
> dmsetup create cache --table "0 524288 cache /dev/mapper/cmeta \
> /dev/mapper/cdata /dev/mapper/corig 128 2 metadata2 writethrough smq 0"
>
> Kernel logs:
>
> (snip)
> device-mapper: array: array_block_check failed: blocknr 0 !=3D wanted 10
> device-mapper: block manager: array validator check failed for block 10
> device-mapper: array: get_ablock failed
> device-mapper: cache metadata: dm_array_cursor_next for mapping failed
> ------------[ cut here ]------------
> kernel BUG at drivers/md/dm-bufio.c:638!
>
> Fix by setting the cached block pointer to NULL on errors.
>
> Signed-off-by: Ming-Hung Tsai <mtsai@redhat.com>
> Fixes: fdd1315aa5f0 ("dm array: introduce cursor api")
> ---
>  drivers/md/persistent-data/dm-array.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/md/persistent-data/dm-array.c b/drivers/md/persisten=
t-data/dm-array.c
> index 157c9bd2fed7..c46a374f7459 100644
> --- a/drivers/md/persistent-data/dm-array.c
> +++ b/drivers/md/persistent-data/dm-array.c
> @@ -917,23 +917,28 @@ static int load_ablock(struct dm_array_cursor *c)
>         if (c->block)
>                 unlock_ablock(c->info, c->block);
>
> -       c->block =3D NULL;
> -       c->ab =3D NULL;
>         c->index =3D 0;
>
>         r =3D dm_btree_cursor_get_value(&c->cursor, &key, &value_le);
>         if (r) {
>                 DMERR("dm_btree_cursor_get_value failed");
>                 dm_btree_cursor_end(&c->cursor);
> +               goto out;
>
>         } else {
>                 r =3D get_ablock(c->info, le64_to_cpu(value_le), &c->bloc=
k, &c->ab);
>                 if (r) {
>                         DMERR("get_ablock failed");
>                         dm_btree_cursor_end(&c->cursor);
> +                       goto out;
>                 }
>         }
>
> +       return 0;
> +
> +out:
> +       c->block =3D NULL;
> +       c->ab =3D NULL;
>         return r;
>  }
>
> --
> 2.47.0
>


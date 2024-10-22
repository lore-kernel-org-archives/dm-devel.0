Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 836D6137747
	for <dm-devel@lists.linux.dev>; Tue, 22 Oct 2024 07:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729582191; cv=none; b=dMNOo2X5cKr9vrTKOYqwLFEttsfzTyoq5dC9kxF1z5Go1EuWxTFcV6K8rKjQZq/lsgbf0xQS1miN3GWeqd8wRUHj/CFdyndK8UI3thZTfibKtneIMkJKatIp9KPBTWBrMo+pziptm0tZ8BSc6kHPO+aeLmVQyBGHZq07dOvzr98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729582191; c=relaxed/simple;
	bh=dymu7MJtK7F/xTaFMTh0+EynZPWUkGi9im63vCuFz0k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OB9mWLbXNDqFbK6Ye14TXEM9jH0x6ChehatlAVDJbRzuHJZ/O5z/aJGEFwfBMHUHbK8C/ZBHBt5867dNgJwOCGnu6X7ysrzHtc4Z6O/fpTl7buOfTeOu+bHGiXcY8siZI1su8wst6VrGJVbFpsRRHfQA8HwVE/d3b1HPAPnyW6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JQDPIeGJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JQDPIeGJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729582188;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5RM8EOonYeMssB0FZab654Q5uQxoLX9F92f3prQG8ko=;
	b=JQDPIeGJiAOUXflREN6qFDlgpfdFONOdA/W0kE0EEN4hbFUJP1Ei5Qn+eIHENXNBAphavn
	OWKi0G2NQb1Xm7hrohBRuAuQQ35NV2jU32PCfkcZlVCO4vM6/LFR3agUnZ8GLmYXLraI5v
	bNVpmZHfTyd+h7YoVCblnKzZamygK9c=
Received: from mail-yb1-f200.google.com (mail-yb1-f200.google.com
 [209.85.219.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-411-EROthCSTN-O5FjfLHhEBcw-1; Tue, 22 Oct 2024 03:29:45 -0400
X-MC-Unique: EROthCSTN-O5FjfLHhEBcw-1
Received: by mail-yb1-f200.google.com with SMTP id 3f1490d57ef6-e1159159528so9001580276.1
        for <dm-devel@lists.linux.dev>; Tue, 22 Oct 2024 00:29:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729582184; x=1730186984;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5RM8EOonYeMssB0FZab654Q5uQxoLX9F92f3prQG8ko=;
        b=l1+FUIthzbvYUIBbZS5dG5yyQuc/K3JOM83VBgkyGR6UwhlHcpRIYn1ebfBY+DrHK4
         cL/hePZ/16DWG75XAtMoR91n70xoslUXZr2l67dd2VUqqpt+KKm/MLcHdzDx3j51237E
         PH3P5nLDVBqjWHp6oQNvKk7SxNos15epuaIM5x66SFoXLAWrUzCFuXyaekq/EhZf3BND
         CXQCFjLBPnIFqp2Gno9qZFZrIiI7cfWLMe0+KENjIwl/pCXEo17rZb3oIhkZ8fVoUCaK
         Pu9DbOmx9UIMRUskf9HlnYXYIp4+n3Y4AIdZyi5XUYxefaCwvK8pbhCQCpFKb2I2d9ik
         ERCQ==
X-Gm-Message-State: AOJu0Yz63q1wCAyaSGfZ31n700Xvf+eJmOwfhVhQWOD4fdUxKTwacJnH
	3LNXqGC1NnyC0LYsBC86gwsn5JaUiE1fFWOYRTgob48q6RwXkoRouixrnqG4KE1B1tK413iMzYb
	gM1spmV2OG6upWXTTUXEmlqOhUW8aFQXFLRZA8hZX3KBFFsIDZ9FKrYVcCFCvi/hG0l2vIkfBVC
	wNgt2oUOuECo0zDoL5XDEva6DcS150GfA=
X-Received: by 2002:a05:6902:4e1:b0:e2b:d235:430c with SMTP id 3f1490d57ef6-e2e245a3991mr2070552276.16.1729582184418;
        Tue, 22 Oct 2024 00:29:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE9ok4I4+ofPnzVTFvjQbC6XXOeJKO8jAE2efPLqYafRVYIlBeNdfC04a6/5WvHOCGoLP4fCsfERsP5QzvcjS0=
X-Received: by 2002:a05:6902:4e1:b0:e2b:d235:430c with SMTP id
 3f1490d57ef6-e2e245a3991mr2070532276.16.1729582184132; Tue, 22 Oct 2024
 00:29:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241022071222.778553-1-mtsai@redhat.com>
In-Reply-To: <20241022071222.778553-1-mtsai@redhat.com>
From: Joe Thornber <thornber@redhat.com>
Date: Tue, 22 Oct 2024 08:29:15 +0100
Message-ID: <CAJ0trDbAXTK+fJFjmuQW8wkWfEfxDynftXiB_k4yVsZXZCjJjA@mail.gmail.com>
Subject: Re: [PATCH 1/5] dm cache: correct the number of origin blocks to
 match the target length
To: Ming-Hung Tsai <mtsai@redhat.com>
Cc: dm-devel@lists.linux.dev, mpatocka@redhat.com, heinzm@redhat.com, 
	snitzer@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

ack

On Tue, Oct 22, 2024 at 8:12=E2=80=AFAM Ming-Hung Tsai <mtsai@redhat.com> w=
rote:
>
> When creating a cache device, the actual size of the cache origin might
> be greater than the specified cache target length. In such case, the
> number of origin blocks should match the cache target length, not the
> full size of the origin device, since access beyond the cache target is
> not possible. This issue occurs when reducing the origin device size
> using lvm, as lvreduce preloads the new cache table before resuming the
> cache origin, which can result in incorrect sizes for the discard bitset
> and smq hotspot blocks.
>
> Reproduce steps:
>
> 1. create a cache device consists of 4096 origin blocks
>
> dmsetup create cmeta --table "0 8192 linear /dev/sdc 0"
> dmsetup create cdata --table "0 65536 linear /dev/sdc 8192"
> dmsetup create corig --table "0 524288 linear /dev/sdc 262144"
> dd if=3D/dev/zero of=3D/dev/mapper/cmeta bs=3D4k count=3D1 oflag=3Ddirect
> dmsetup create cache --table "0 524288 cache /dev/mapper/cmeta \
> /dev/mapper/cdata /dev/mapper/corig 128 2 metadata2 writethrough smq 0"
>
> 2. reduce the cache origin to 2048 oblocks, in lvreduce's approach
>
> dmsetup reload corig --table "0 262144 linear /dev/sdc 262144"
> dmsetup reload cache --table "0 262144 cache /dev/mapper/cmeta \
> /dev/mapper/cdata /dev/mapper/corig 128 2 metadata2 writethrough smq 0"
> dmsetup suspend cache
> dmsetup suspend corig
> dmsetup suspend cdata
> dmsetup suspend cmeta
> dmsetup resume corig
> dmsetup resume cdata
> dmsetup resume cmeta
> dmsetup resume cache
>
> 3. shutdown the cache, and check the number of discard blocks in
>    superblock. The value is expected to be 2048, but actually is 4096.
>
> dmsetup remove cache corig cdata cmeta
> dd if=3D/dev/sdc bs=3D1c count=3D8 skip=3D224 2>/dev/null | hexdump -e '1=
/8 "%u\n"'
>
> Fix by correcting the origin_blocks initialization in cache_create and
> removing the unused origin_sectors from struct cache_args accordingly.
>
> Signed-off-by: Ming-Hung Tsai <mtsai@redhat.com>
> Fixes: c6b4fcbad044 ("dm: add cache target")
> ---
>  drivers/md/dm-cache-target.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
> index aaeeabfab09b..90772b42c234 100644
> --- a/drivers/md/dm-cache-target.c
> +++ b/drivers/md/dm-cache-target.c
> @@ -2003,7 +2003,6 @@ struct cache_args {
>         sector_t cache_sectors;
>
>         struct dm_dev *origin_dev;
> -       sector_t origin_sectors;
>
>         uint32_t block_size;
>
> @@ -2084,6 +2083,7 @@ static int parse_cache_dev(struct cache_args *ca, s=
truct dm_arg_set *as,
>  static int parse_origin_dev(struct cache_args *ca, struct dm_arg_set *as=
,
>                             char **error)
>  {
> +       sector_t origin_sectors;
>         int r;
>
>         if (!at_least_one_arg(as, error))
> @@ -2096,8 +2096,8 @@ static int parse_origin_dev(struct cache_args *ca, =
struct dm_arg_set *as,
>                 return r;
>         }
>
> -       ca->origin_sectors =3D get_dev_size(ca->origin_dev);
> -       if (ca->ti->len > ca->origin_sectors) {
> +       origin_sectors =3D get_dev_size(ca->origin_dev);
> +       if (ca->ti->len > origin_sectors) {
>                 *error =3D "Device size larger than cached device";
>                 return -EINVAL;
>         }
> @@ -2407,7 +2407,7 @@ static int cache_create(struct cache_args *ca, stru=
ct cache **result)
>
>         ca->metadata_dev =3D ca->origin_dev =3D ca->cache_dev =3D NULL;
>
> -       origin_blocks =3D cache->origin_sectors =3D ca->origin_sectors;
> +       origin_blocks =3D cache->origin_sectors =3D ti->len;
>         origin_blocks =3D block_div(origin_blocks, ca->block_size);
>         cache->origin_blocks =3D to_oblock(origin_blocks);
>
> --
> 2.47.0
>


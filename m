Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795771349;
	b=B0mOryfx6jcg1DMmDVgx1OOxBym8GLlI1ZsX6sH2nIBqAQac0NeKplUqt6Kovpi+gZ6U
	 33u0oQweEdCeXKQb6Yh4KWiJ91YgcRwlh/Y0zps8OuorZ4v5lpShLGVGgKPPzROAdrzPU
	 2lNn1zZXGD45gT7PHjvyZa+gSPIEQACPkrYosICEdYwpv+5/BXp1J3PMfZlqMNXMSZwTE
	 RptAB6ytaykLjveEo/EotlW6gjXkgCZO9WxKB1ixrx0FW5yr+BqbUaeebkZSvPobkBn9P
	 8CoSaT5Tm8s+pulwPBOjdQGQB785ZLYsDLWRmXaugIPuxZguWZBAtO5YhIVFvM795hw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795771349;
	h=DMARC-Filter:DKIM-Signature:X-MC-Rep:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:MIME-Version:References:In-Reply-To:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Cc:X-Mimecast-Spam-Score:
	 X-Mimecast-MFC-PROC-ID:X-Mimecast-Originator:Content-Type:
	 Content-Transfer-Encoding;
	bh=lRVWoXHWreHp+KU3b738W9MVqAqGC16lHMedn1zkJ/w=;
	b=mkuCTM/ezWqzmc31jCrubr9kSzcnPTeR9BjVth2t/sIng7BJpdqg2/Wk476ofs4Hl8h0
	 wiHyaBr1VlkIl99lM/u9M6dTQmNUbbs1qKfrNvJEkCfOplxZlHmGKbCRITR612MyPfQOE
	 z3w7BO2SPW3qU54PvFfLmIWD+A/D+7sT0ZZYBFJeo7qNBWa47VCGoG+lrn71jBbZvK27F
	 yCI8W5meWB/Jv4o5V6LhsliKYMYVpgE4P+DubeVL/I9XV2r6jmZyL49w5QaA9yo+5ZHZW
	 5KDFlKMuTK1U9EVOD9IdsrjwXZMtTolIhYSjsv9MB/dJSl5O4rrlELOam49HFuiwYSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=JxNxaVm0;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD271606A321
	for <dm-devel@lists.linux.dev>; Fri, 27 Nov 2026 09:22:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CD271606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=JxNxaVm0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795771347;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lRVWoXHWreHp+KU3b738W9MVqAqGC16lHMedn1zkJ/w=;
	b=JxNxaVm0cv2Cj2g9Pi6ASiUB9ZKHTswNMBWBi96UuIgxfA5eT2a/PQ5u0cejCcxc/ch8eg
	BSJqJFBADte+IdQSReYLy4vAkrBtfIXrOv0Ia/iquS6NYhcD0h2/SRe/E0lcJWaBgFKH8W
	lWoLZYw+WZiv8yyyOkJ1OCe2BYxoTbc=
X-MC-Rep: binary re single
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-175-U86o7NbxO9q4HLv-372A7A-1; Fri, 27 Nov 2026 09:22:26 +0000
X-MC-Unique: U86o7NbxO9q4HLv-372A7A-1
X-Mimecast-MFC-AGG-ID: U86o7NbxO9q4HLv-372A7A_1795771344
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-3ae0c42947aso35330251fa.1
        for <dm-devel@lists.linux.dev>; Fri, 27 Nov 2026 01:22:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795771344; x=1796376144;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lRVWoXHWreHp+KU3b738W9MVqAqGC16lHMedn1zkJ/w=;
        b=krAh/vHogqs0AL3kkD4gS9IV0ut1zMmCnoZO9ybzC3D8PidXyBUduQogJ1Lh66znpy
         H1Kio/QS+/8WV1Ybuj/oGfTFLUs8Gy9MTxv9jg9gCd8linjNOqNy2GnfcP0fL9J4BJRM
         rTo47FCffJWfgqNy9SsrmAqeQoUW1Eg1hM/Pf0IGZTFNXXyWfUQX7alDewXGSuh59BKf
         OuaTu3TRjfZuSUfmGntAx8gpC88CrrZ/W53bLPR1PGKMYAo8To+CLF3fUl3ixOGTIY9E
         lVoU1apFxs0htSngP7mDoDOktMQHjKKOHdY4YcVVS3iSPulyET1NC+KVHbE51/wJjcGY
         YG0g==
X-Forwarded-Encrypted: i=1; AL+hErGJescx84rM32QvBw3zDQC6khQn8qB9OT0iJju7PQcawfrDjJa4P6rP7uyVAMaok6Q8e91tP5LVEg==@lists.linux.dev
X-Gm-Message-State: APuU4Z+3avm/dHraRj2l+jY3+62U8Wp2AwU7CS2f5vWpVM3PPfFSGZy7
	Mwl8VMBQEBHfbm/6vdHS0oAzxE8tig6k2X7QRKNZBKOX1pwQByeFA/SvgSvIEZqThvfacbtt3Rl
	mai1uEJuTOQ4kXecp4WKHrrn6kRp/IOUPS2EspCrLtCnnUMa0DyczhIWwMj56xTIknP3XiYJkkq
	D8HLABxFqoOWCGk3VTi9EG/cn5v/YicdIVcg==
X-Gm-Gg: AZFdTZeVPnWGP1wnO2NsPd2dm5iagSj4p4JkFgV6XXBVEJ/twiv4+KZ/EURwigV6Fpu
	QS44//OTqRwy0+TnXn/0jIApbLc+5Qsf+NrgPjjgfJB48VvkDSoOfq1z1HA7EGZh/fB4S3cT7Ur
	8ZQ76c+3gqiMBqMOU86lySjK7j495phklzfsIkiMs9gbMWQZ+zcA4lLDOtOn2hbF8xVtUH33Z4c
	pRgDmoQLyT0PByNF6SpVXHAM0NH01lIQu3CwV3hAC1DGPhxaDQ=
X-Received: by 2002:a2e:9a0d:0:b0:3a9:74f3:17d5 with SMTP id 38308e7fff4ca-3ae7f8d2d94mr80755971fa.3.1795771344403;
        Fri, 27 Nov 2026 01:22:24 -0800 (PST)
X-Received: by 2002:a2e:9a0d:0:b0:3a9:74f3:17d5 with SMTP id
 38308e7fff4ca-3ae7f8d2d94mr80755861fa.3.1795771343968; Fri, 27 Nov 2026
 01:22:23 -0800 (PST)
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <9f8ed9a9-fb35-7a4d-4877-430268010b43@redhat.com>
In-Reply-To: <9f8ed9a9-fb35-7a4d-4877-430268010b43@redhat.com>
From: Ming Hung Tsai <mtsai@redhat.com>
Date: Fri, 27 Nov 2026 17:22:11 +0800
X-Gm-Features: Aa3M54p8weozP7nNLhXte4wZdNIPdZ0A7Od4Jxg-SfDiuxWDuywv1rf2-K2eld4
Message-ID: <CALjSBEvigM4pvS-PreuMmqaj1OK_vG53BFSE3rfcaK+ZJ3Qyow@mail.gmail.com>
Subject: Re: [PATCH] dm persistent data: fix invalid calls to vt->inc and vt->dec
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
	Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 23iNoCtqAh7MD8g4mUyhJAF5eLPxPpQWvJjrgBtsQHQ_1795771344
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 24, 2026 at 4:54=E2=80=AFAM Mikulas Patocka <mpatocka@redhat.co=
m> wrote:
>
> The dm-array library called vt->inc and vt->dec with invalid arguments.
> None of the users of the library actually use the callbacks, so the bug
> was latent.
>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Assisted-by: Claude:claude-opus-5
>
> ---
>  drivers/md/persistent-data/dm-array.c |   12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> Index: linux-2.6/drivers/md/persistent-data/dm-array.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/drivers/md/persistent-data/dm-array.c
> +++ linux-2.6/drivers/md/persistent-data/dm-array.c
> @@ -196,18 +196,18 @@ static int alloc_ablock(struct dm_array_
>  static void fill_ablock(struct dm_array_info *info, struct array_block *=
ab,
>                         const void *value, unsigned int new_nr)
>  {
> -       uint32_t nr_entries, delta, i;
> +       uint32_t nr_entries, i;
>         struct dm_btree_value_type *vt =3D &info->value_type;
>
>         BUG_ON(new_nr > le32_to_cpu(ab->max_entries));
>         BUG_ON(new_nr < le32_to_cpu(ab->nr_entries));
>
>         nr_entries =3D le32_to_cpu(ab->nr_entries);
> -       delta =3D new_nr - nr_entries;
> -       if (vt->inc)
> -               vt->inc(vt->context, value, delta);
> -       for (i =3D nr_entries; i < new_nr; i++)
> +       for (i =3D nr_entries; i < new_nr; i++) {
> +               if (vt->inc)
> +                       vt->inc(vt->context, value, 1);
>                 memcpy(element_at(info, ab, i), value, vt->size);
> +       }
>         ab->nr_entries =3D cpu_to_le32(new_nr);
>  }
>

I think we can keep the range call from be500ed721a6 instead. Copy the
values first, then call inc() once on the new entries:

diff --git a/drivers/md/persistent-data/dm-array.c
b/drivers/md/persistent-data/dm-array.c
index 961fa3c1439a..f1afbb89bce6 100644
--- a/drivers/md/persistent-data/dm-array.c
+++ b/drivers/md/persistent-data/dm-array.c
@@ -204,10 +204,10 @@ static void fill_ablock(struct dm_array_info
*info, struct array_block *ab,

        nr_entries =3D le32_to_cpu(ab->nr_entries);
        delta =3D new_nr - nr_entries;
-       if (vt->inc)
-               vt->inc(vt->context, value, delta);
        for (i =3D nr_entries; i < new_nr; i++)
                memcpy(element_at(info, ab, i), value, vt->size);
+       if (vt->inc)
+               vt->inc(vt->context, element_at(info, ab, nr_entries), delt=
a);
        ab->nr_entries =3D cpu_to_le32(new_nr);
 }


> @@ -228,7 +228,7 @@ static void trim_ablock(struct dm_array_
>         nr_entries =3D le32_to_cpu(ab->nr_entries);
>         delta =3D nr_entries - new_nr;
>         if (vt->dec)
> -               vt->dec(vt->context, element_at(info, ab, new_nr - 1), de=
lta);
> +               vt->dec(vt->context, element_at(info, ab, new_nr), delta)=
;
>         ab->nr_entries =3D cpu_to_le32(new_nr);
>  }

The second half looks correct to me. The range to dec starts at
new_ne, not new_nr - 1.

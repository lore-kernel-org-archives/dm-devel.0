Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794891263;
	b=UZKlwpViMzlgTW5lsEXFzlFdkJYZQQvpNAqM/Qt82oB4d/8tsSzs3ZqaMUrjzDk3jMg4
	 qoyRCRfS8hUcDIfeJ6dWdvzfCJn3OsupSVq/5tTjR9EU/WYOMVxBCygdtf7V1HicLyhB4
	 3u0qY2XZGcqr3c/4J97gD+TbhEwiPrdU0gUigfZ0Z3ydPAryi6nLoZ6KSLNrk4jyD9p9s
	 umvDzuN6Ewry0jQ5WFAt6J9U3dQs686/hfhzAPrFy0fyDQk5XyFsqMx/Tc/T4sVic1tFp
	 F0bx6bSXx/ZkYz3Y+Os5MYdJlWSKiJ35rv27+beUagpc7kGnrOI8/whNlVjRHbViylQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794891263;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:MIME-Version:References:In-Reply-To:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Cc:X-Mimecast-Spam-Score:
	 X-Mimecast-MFC-PROC-ID:X-Mimecast-Originator:Content-Type:
	 Content-Transfer-Encoding;
	bh=Q7H2nc9bosJoZgL9qNmHTOhIFvJBNvNVcBjiUkQrllk=;
	b=PN1hHEeoXy9LX2HKfoBNgAFuHDgf8rdPAxuqQ4CPYdAV7iXTu/XEeU1IabxkyHJLGK/F
	 Ei6AVKsXdctpjNlIvdIZJbUPQ/wlBD0n7Ibvq28wrBrrCLdNcI8HIL8S15JJyDat2yyZX
	 YlkMq4fBcLImWv9jIiLCnR32V1w9htuXE1LwPGN0wPUL03Vgt3lOhbV1z7ZrXkr7fJO8i
	 wJoQ6dH/MMIsJjxzakedVcbjWH1waqjLC4Y2ePH3qEjY4HmGBJugH6JlXB1A7s2mgQW1n
	 t7Y0TuJsc+vZLPUSiYILrCnMSliGGrYlQ6MNn4Nvs0NKoOeHArVC9vgY493te4uMfNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=iTXHqGhb;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 098AC606A332
	for <dm-devel@lists.linux.dev>; Tue, 17 Nov 2026 04:54:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 098AC606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=iTXHqGhb
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794891262;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q7H2nc9bosJoZgL9qNmHTOhIFvJBNvNVcBjiUkQrllk=;
	b=iTXHqGhbjWrXez6m8s1klTD/S1GpzzLTu9PR4KsoGCl6JY5gBbZDWlQ1vMOWBONNVuTpV5
	3BkJkIUQdkXkvTMrtxA032PsPEPZyE6tzOqfy3JWuwAq7li2cMaxGa/uJb2aDcfEVlHxK1
	gx6d1FLasWevLPB5irqME1PPwBoEj4c=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-84-pufi21JwMtadqw_TuH8VBQ-1; Mon, 16 Nov 2026 23:54:20 -0500
X-MC-Unique: pufi21JwMtadqw_TuH8VBQ-1
X-Mimecast-MFC-AGG-ID: pufi21JwMtadqw_TuH8VBQ_1794891259
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-3ad09084d85so23988281fa.3
        for <dm-devel@lists.linux.dev>; Mon, 16 Nov 2026 20:54:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794891259; x=1795496059;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Q7H2nc9bosJoZgL9qNmHTOhIFvJBNvNVcBjiUkQrllk=;
        b=XIG/DmN8aupEshPpWK5YkricwzGQ/q26cPpQ7tytW6Bf2VeAiguJt6g/sP+V5hcY8V
         2eMVHI2Mo0xr05RRw9c7mqwESr9BF6hGJj9SZi2qLQ5w4GadOSKFjNyxGqPOUTliCz+s
         u/RIjcOXL0yIRi9v3wA2oiZKCCyjEvN8HtR3IC3wSxowQ/Fd9VkqV3Rip+4scEXreGdh
         mhCPV3GtiMsgGxh4vLvsvAWwTl93iWHDh1adKaTVJzayBFx3IOfg+tM/AwTeJnQDO8X+
         +0ZrY3X1l4EY2DNP4moU/WfLHXU4IvRwEoYXXgC6wyk2Su2lOLlsYT77OaGkGpA2H22c
         tlFA==
X-Forwarded-Encrypted: i=1; AL+hErFdnJuUe4figUmWNlZPHaEQUphcEy0gS7t5HDzEPZI74vbDvSu/NayHjlQAvOcjUHihZao06H8Z2A==@lists.linux.dev
X-Gm-Message-State: APuU4Z95qLAvQ3mEUel1vHuCMrZrEWWC6r0IWA4BfwKhE5VcgKeE2EgQ
	RmW7RyICBCrAbeYlMgI4MJQ+ARIf1qwtwo7gTYPzgH8TlHLAUaEEmh0D1+MO0KoSfybFISAuJhZ
	KJky1zpIqOgZAwNYXjIEJszUmEiYP/npCX07FeNfIU4ryC3yJqOWoi4sdQq2DjR+N8Qy3l7Xdd1
	ZqXKmQJBAD31A9bW/F4lrQXceWMwzHa9RC3Q==
X-Gm-Gg: AYBFou0wJltAjH/NxI3m8j6gN/irE3fgfa5DqIzHxoc5n2TsYIW2D3KUILL9FPfP1tV
	7ruge594BChLIuBJdHB9ZWeWagpHRXcoxR3vNaFzS8jIBFIqiU6MpivcuQDt5hZo5laq8xcv0ZR
	yJm6VwQ/UyUjWttlv8kj3AJ6dHsIXl4uq7QwSt+TyIrNnznBwvHSawZxafDd0o8B5dYrCaBTYU1
	wjGQkVvcTLJ+qSiODYecqR+5rMjJzmRckpPBZffDmnd/meLQht43NMandVYJWi6tD6rLRvuWis=
X-Received: by 2002:a05:651c:987:b0:3ae:25db:8a10 with SMTP id 38308e7fff4ca-3ae2b50dc54mr38699681fa.18.1794891258861;
        Mon, 16 Nov 2026 20:54:18 -0800 (PST)
X-Received: by 2002:a05:651c:987:b0:3ae:25db:8a10 with SMTP id
 38308e7fff4ca-3ae2b50dc54mr38699631fa.18.1794891258476; Mon, 16 Nov 2026
 20:54:18 -0800 (PST)
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <CALKjhPewyFB0=2tfyNVuDPosTAisDD2YcejTpX+0iiKRXdsGaw@mail.gmail.com>
 <f9266fcb-d030-dd16-e16f-0569b93bf4b6@redhat.com>
In-Reply-To: <f9266fcb-d030-dd16-e16f-0569b93bf4b6@redhat.com>
From: Ming Hung Tsai <mtsai@redhat.com>
Date: Tue, 17 Nov 2026 12:54:06 +0800
X-Gm-Features: AclHuK_jpXwqt8GjPaIqf_AW3r_cm6NLbWKbBwBxrR01hq8PTlb885wJw1OdM4g
Message-ID: <CALjSBEsCVz5h55GtN_s5cf96qT6T8RqYiL6A4och+SHJOeiaSQ@mail.gmail.com>
Subject: Re: [PATCH] dm btree: Remove redundant index condition
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Donut Oreo Computer I <donut.oreo.computer@gmail.com>, dm-devel@lists.linux.dev, 
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
	Benjamin Marzinski <bmarzins@redhat.com>, linux-kernel@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: _An9Imcj_pfKNhnrrXTodyjgDRY9aTHSdhLnWogpYl8_1794891259
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 17, 2026 at 4:07=E2=80=AFAM Mikulas Patocka <mpatocka@redhat.co=
m> wrote:
>
>
>
> On Fri, 6 Nov 2026, Donut Oreo Computer I wrote:
>
> > The index is unsigned, so checking whether i is non-negative is
> > unnecessary.
>
> Really?
>
> In the caller, there is
>
> "unsigned int level, index =3D -1, last_level =3D info->levels - 1;"
>
> In btree_insert_raw, there is "int r, i =3D *index, top =3D 1;"
>
> If you cast -1 to unsigned int and then cast it back to int, you get -1.
>
> So, it doesn't seem like an obvious dead code to me.
>
> Mikulas
>
> > Signed-off-by: Donut Oreo Computer <donut.oreo.computer@gmail.com>
> > ---
> >  drivers/md/persistent-data/dm-btree.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/md/persistent-data/dm-btree.c
> > b/drivers/md/persistent-data/dm-btree.c
> > index dd02eee4a23c..b7ac2f6d1d71 100644
> > --- a/drivers/md/persistent-data/dm-btree.c
> > +++ b/drivers/md/persistent-data/dm-btree.c
> > @@ -1108,7 +1108,7 @@ static int btree_insert_raw(struct shadow_spine
> > *s, dm_block_t root,
> >                  * see a way to do this automatically as part of the sp=
ine
> >                  * op.
> >                  */
> > -               if (shadow_has_parent(s) && i >=3D 0) { /* FIXME: secon=
d
> > clause unness. */
> > +               if (shadow_has_parent(s)) {
> >                         __le64 location =3D
> > cpu_to_le64(dm_block_location(shadow_current(s)));
> >
> >                         __dm_bless_for_disk(&location);
> > --
> > 2.56.0
> >
>

The commit message is not accurate. It's not that "the variable i is
always greater than zero", it's "the variable i cannot be negative if
shadow_has_parent() returns true". The reason is how the variable i
relates to the shadow spine. 'i' is the slot in the parent node that
points to the current node. It is initialized to -1 only on the first
btree_insert_raw() call, when the shadow_spine is empty and
shadow_has_parent() returns false (because the top-level root doesn't
have a parent). After shadowing the second node along the path and
shadow_has_parent(s) returns true, the variable i must be
non-negative.

For multi-level btrees, the index passed to remove_raw() means the
slot of the previous level's leaf, hence 'i' is always >=3D 0 on subtree
roots.

With the invariant "index =3D=3D -1 only when the shadow_spine is empty",
it should be safe to remove the i >=3D 0 check. remove_raw() and
remove_nearest() in dm-btree-remove.c alrealy rely on the same rule,
without the extra check.

__btree_get_overwrite_leaf() has the same redundant check. I'll handle
it in a separate patch after testing.


Hank


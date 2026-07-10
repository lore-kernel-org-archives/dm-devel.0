Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0210F3B4E84
	for <dm-devel@lists.linux.dev>; Fri, 10 Jul 2026 08:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783673677; cv=none; b=B3PSwT6sy4kIdaQRV00sUMeeVGLt/OM+qz0q4AO4SD3yEb2HIC65wekcER4oIjRZElczMawfWcX8IuZ5LkaJEn2f69QNE901scQAbP+ycRIlm1zwxj+8AULDUDQCpRnuz3htkcNrmTIr9ZTHAQNWtLSGjGdqsAQLhlcYOTBngnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783673677; c=relaxed/simple;
	bh=UY9XoYYbdHo3B1f1LdsDdE4woUSNdhh5gCfiyBEvclo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lAYsSl+rZedLIx5LAfuesxP2ivX6TPTwXGtDXcC7zuB2jD6iISaNURs/Ish3QkxY0Oq88O8OrbvisMApFNlK9nxiy96a+q3Eq7zAxBn6vCciQj+lm9V2dMy1uaugAornetoBnjzU4s1TZhFZ0notL0HTgbzhJRyKAqaHTRnpbQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DPXJMryZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DPXJMryZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783673674;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JQ5bqe6YWB2qNp4rkQXvWJYUsXQ/mJDSNUKHllQYkF4=;
	b=DPXJMryZ7AQ+u2wMfX8yATGWlpEdZ+VXqjCoia8/QtUlE8PwxxotNLvcIMZhM87ZzHWPGh
	B+FCO78c6M5vYsgWTNpnxfVTs0tcoI1TyQrGcJN3hrBOPxQGAFHf+hb/MKCX+mwepi3Q31
	B3xqbTEgEoqFzxA8CEf7lEIYEC0xQ9A=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-537-e4R5Le1KOAWLEn9sPcbHcw-1; Fri, 10 Jul 2026 04:54:33 -0400
X-MC-Unique: e4R5Le1KOAWLEn9sPcbHcw-1
X-Mimecast-MFC-AGG-ID: e4R5Le1KOAWLEn9sPcbHcw_1783673672
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-39c7f821a32so2290701fa.0
        for <dm-devel@lists.linux.dev>; Fri, 10 Jul 2026 01:54:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783673672; x=1784278472;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JQ5bqe6YWB2qNp4rkQXvWJYUsXQ/mJDSNUKHllQYkF4=;
        b=i1knTmmyx29bj+ZF+HXEyUH+P3iKyjoWpcNEdvN1tB5Oq+4RCWGhvszueZ+Jrevr4W
         /zUNMk3um1PVWu6S6mJaZBkud+LvxHcrqcl8dsRFbTCKUqeltFrdLBwG7nHbLdr4NcDD
         N8KxND1z6t7NOVU8+kQPGiu7pSpREw2VW0f7QCjbA7sDh5R6fyqGaGPRkvHKCh99WVsA
         rbPeb3qUDdFXUeFJWd8s2ZvAJpP9XQxzXGTUiO/ZuzLD1ogypG76I55JPHKcvooblyHj
         hhQHbAJM2Z+/zNNkzyxb96sjPuWVcKbS0eoB2lh/b6iBR+aGv+UcIkjGLaIXMFGpZnJv
         c22Q==
X-Forwarded-Encrypted: i=1; AHgh+RqVRkhRkL25ZPiYQRcIrc45yh0ExKgCsMh5/Bs8PQzm++PRIZekRhTw5ovDTatjUn061fXBOsY3aQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YyHd2ztAEZQhMC8HUjz5/1U4GuTPt6IcRB1p1UojMDpyDOib3jK
	l75JCzHRws5wGYbgzzhmxX8il2AWBOYcWPxKZCgC+oH3DRbeE1VNR6up3oAoR1B+ovytl0RJ/Oo
	0WDAKnu6J/xu1vXuHyQo/woHu/c2YMzVdi3pIfklEm/Zb4MPsYx2eUEr/j9/FhGwVBaQKik7H8r
	nh1qUxbOyxYawuBZuwJUqiBwPczsPatEB0Fw==
X-Gm-Gg: AfdE7cnxOdQqqLd8fmc8hYU8bhuvx9MALWUnHMdfb7k44nfViOAPnWaa2EnfNPn1o/R
	vOnFyt+y+yyWpb18UaZ1I1l3JF4H0s83HxQpePKEEXYosigmsBYphk/VNqD/8Lcqh9cdcVJZvm4
	4WsQXeZB4N2ntWeibTL38PpnHRCWETTg/12NiAIpM3Psd2s4yzHuKvyev7ISBhTL7fYgid
X-Received: by 2002:a2e:b8c4:0:b0:396:9630:5ed with SMTP id 38308e7fff4ca-39c79923d77mr18668651fa.15.1783673672102;
        Fri, 10 Jul 2026 01:54:32 -0700 (PDT)
X-Received: by 2002:a2e:b8c4:0:b0:396:9630:5ed with SMTP id
 38308e7fff4ca-39c79923d77mr18668551fa.15.1783673671643; Fri, 10 Jul 2026
 01:54:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260708004624.42174.39f86a755909.dm-cache-invalidate-cblock-truncation@trailofbits.com>
In-Reply-To: <20260708004624.42174.39f86a755909.dm-cache-invalidate-cblock-truncation@trailofbits.com>
From: Ming Hung Tsai <mtsai@redhat.com>
Date: Fri, 10 Jul 2026 16:54:20 +0800
X-Gm-Features: AUfX_mxRTS2Ckyu5T4yGaQToqeJZwTQKMoOvRkJE8mDalv8DMUMQ6WmyzsqoEl0
Message-ID: <CALjSBEvdnqYYY+gpy341q3N1h+oW9Aja4UAaFG_wdp3Q30LU0w@mail.gmail.com>
Subject: Re: [PATCH v2] dm cache: parse invalidate_cblocks with kstrtouint()
To: Samuel Moelius <sam.moelius@trailofbits.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
	Mikulas Patocka <mpatocka@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>, 
	"open list:DEVICE-MAPPER (LVM)" <dm-devel@lists.linux.dev>, open list <linux-kernel@vger.kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Jrduv_CZ1lJzG9spQO4NU7btvGFjQwKLZMPEgvHRAdo_1783673672
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 8, 2026 at 8:54=E2=80=AFAM Samuel Moelius
<sam.moelius@trailofbits.com> wrote:
>
> -static int parse_cblock_range(struct cache *cache, const char *str,
> +static int parse_cblock_range(struct cache *cache, char *str,
>                               struct cblock_range *result)
>  {
> -       char dummy;
> -       uint64_t b, e;
> +       char *begin =3D strsep(&str, "-");
> +       unsigned int b, e;
>         int r;
>
> -       /*
> -        * Try and parse form (ii) first.
> -        */
> -       r =3D sscanf(str, "%llu-%llu%c", &b, &e, &dummy);
> +       if (str) {
> +               r =3D kstrtouint(begin, 10, &b);
> +               if (r)
> +                       goto bad;
> +
> +               r =3D kstrtouint(str, 10, &e);
> +               if (r)
> +                       goto bad;
>
> -       if (r =3D=3D 2) {
>                 result->begin =3D to_cblock(b);
>                 result->end =3D to_cblock(e);
>                 return 0;
>         }
>
> -       /*
> -        * That didn't work, try form (i).
> -        */
> -       r =3D sscanf(str, "%llu%c", &b, &dummy);
> -
> -       if (r =3D=3D 1) {
> +       r =3D kstrtouint(begin, 10, &b);

This duplicates the kstrtouint(begin) call below. I'd prefer parse
begin once, then branch on whether str is non-NULL.

> +       if (!r) {
>                 result->begin =3D to_cblock(b);
> -               result->end =3D to_cblock(from_cblock(result->begin) + 1u=
);
> +               result->end =3D cblock_succ(result->begin);
>                 return 0;
>         }

This should follow the same early-return-on-error pattern above: goto
bad on failure, and keep the happy path unindented.

> -       DMERR("%s: invalid cblock range '%s'", cache_device_name(cache), =
str);
> +bad:
> +       DMERR("%s: invalid cblock range '%s%s%s'", cache_device_name(cach=
e),
> +             begin, str ? "-" : "", str ?: "");

Since strsep() is destructive, printing the rejected token is simpler
and more useful for debugging. How about:

blocknr =3D strsep(&str)
r =3D strtouint(blocknr)
...
if (str) {
  blocknr =3D str
  r =3D strtouint(blocknr)
  ...
} else {
  ... // single-value case
}

DMERR("%s", blocknr)


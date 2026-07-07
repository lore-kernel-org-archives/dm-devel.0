Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5A8E2EA47C
	for <dm-devel@lists.linux.dev>; Tue,  7 Jul 2026 08:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783412754; cv=none; b=FfclHNxH+AE6gN06xiM8rZOFG+pNRg5tw8TJbWlcPbnnmyJiwGwNS5i1iga4kEDG4834xxdhwEx/6VUTD5l6Hh9CYs4+S0jA5zuACRtIBB+jholnopiqutW8okF97cMiywjbP9nqGto0/PH50L8mW085nApuiLOD1jBGDeMoz7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783412754; c=relaxed/simple;
	bh=li10z66NfKSJ6rj5DVXujsBLiAJw1WkjXPIYn2CsY6A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OFtxAVWTVNVuMtshpi4HKsxk3rROVYsVvz682LRFylsJ2onByOnAt08wHbe1adwGNbqLcvfexwUeKWGwslTftevbSGTLLudAAw/J4ERNenHXI657gygGtecfnEXSZm0Si/8iF7b4Pp/oynK8Ghi3IV+N+nWtnqtz+V2tx1YcsZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=B9MdiFII; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B9MdiFII"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783412751;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rMD4Ork1BMpdY5m4DMMPDRahVDhtSQ5eWbnm8MAyX5U=;
	b=B9MdiFII/kNleJqzb5P+K6POLQSziRe5Lt9voXJyk97Gy0IS3eOjgT8rm4te0iRyDEGOXd
	QpwteSD+D6EEaFjd7rpM9AQ9lMF3VWvEPUmtx/A0M5vaUI3a5vkcM930DmB5Ll+qqjsqIW
	w7yruPKOjBkmSk3uSCvBM3PvAdlYU8E=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-113-jyBeBOjXOmu98rlS94oXnA-1; Tue, 07 Jul 2026 04:25:50 -0400
X-MC-Unique: jyBeBOjXOmu98rlS94oXnA-1
X-Mimecast-MFC-AGG-ID: jyBeBOjXOmu98rlS94oXnA_1783412749
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-5aeb423df3bso1940266e87.3
        for <dm-devel@lists.linux.dev>; Tue, 07 Jul 2026 01:25:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783412749; x=1784017549;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rMD4Ork1BMpdY5m4DMMPDRahVDhtSQ5eWbnm8MAyX5U=;
        b=R+M58W5D46QNefHrasf9LSV2sNheOj/HYOoKScFfEy5bxwfDDYTBM9gTz0YkhyBSbe
         8MS0/oLIiQkR5Q29/j8ySyEPZ72zoOyEefIL5pkHJmkmxHHGuxEunOtMAdGAUoTo6xj/
         earGKAT2rHmG68nx46kNWt0FzEk3gXa5FyUKvunYjilGdYLM49Q8XvqbdNc7qTPIMAiF
         /EzHhI1Eab87EdDH/xxhkEnZUWQzhw0lzGgwNhlUKEAx/gjS9O2zPqMEeHe7mJUALeuR
         Sm5AEztYrPLuwh+5nwoBbqJfdwWD/OQkKEnMWLj6K35cd78dPtVtIajZyJ6BA0xTl8vT
         9Aiw==
X-Forwarded-Encrypted: i=1; AHgh+Ro41fQhwabO54jzXw6Wmau3+86a908Nw57xUEEndh11F3fSH7PZeJNDTrDsVOc1O4jGib5bsgkiTg==@lists.linux.dev
X-Gm-Message-State: AOJu0YyLFxefFt5vNz4Ija7zQi81P+a25ZyowLc9N45NPNZMuZ1ftGvk
	+1djlnVH2A4CkqmFWtdPM5upmTqGFHHTq6TRbP9RYUMcx/XTSQ0RxbIo17ISwAHSbuhwv52B9it
	75HYjkfBnejEmnO2QbEUjLoyqAPYYUh1dF9SkGzmNjhDlFvRx0AEzt+9rwxUekEAZmFwxG4wQlS
	Ru3fMKhf/kLEmGQ2KPrxrP9d5H+1WN3ImJ3Q==
X-Gm-Gg: AfdE7cktZIJGG2tYol9U3pK0HrQC0hosH8fsU84CfA3iPqaq5iUq/ayW4gPsvA+rvAK
	87jBQWVYVXBypJNITMGI2V/9PAIjmDccHzGyuoL1kjP2ndKfdc5/hwfBpnimuopOkXNqP+Phpig
	CaDr87Vw05IHgr56SmJKEZJqoLn7OA7sMndXQJ/LI/vj/IwD4s33c139eLn9kPR6R/uQ==
X-Received: by 2002:a05:6512:8394:b0:5ae:be77:44b3 with SMTP id 2adb3069b0e04-5b007c764c0mr690430e87.58.1783412749157;
        Tue, 07 Jul 2026 01:25:49 -0700 (PDT)
X-Received: by 2002:a05:6512:8394:b0:5ae:be77:44b3 with SMTP id
 2adb3069b0e04-5b007c764c0mr690395e87.58.1783412747556; Tue, 07 Jul 2026
 01:25:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260628151139.75447.cf67e9b6b484.dm-cache-invalidate-cblock-truncation@trailofbits.com>
In-Reply-To: <20260628151139.75447.cf67e9b6b484.dm-cache-invalidate-cblock-truncation@trailofbits.com>
From: Ming Hung Tsai <mtsai@redhat.com>
Date: Tue, 7 Jul 2026 16:25:35 +0800
X-Gm-Features: AVVi8CcuHH0Zsww1TN11mIeetcynVSj6-eDBKx1dAtiqOnWYt9KlQuUsUfwC_0g
Message-ID: <CALjSBEu_kwrQf_2b3b+Fo5OFK2SYztLRcTftsfDS943yhuacQQ@mail.gmail.com>
Subject: Re: [PATCH] dm cache: parse invalidate_cblocks with kstrtoull()
To: Samuel Moelius <sam.moelius@trailofbits.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
	Mikulas Patocka <mpatocka@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>, 
	"open list:DEVICE-MAPPER (LVM)" <dm-devel@lists.linux.dev>, open list <linux-kernel@vger.kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: sbpRDXJ9i9vKdH9f_D6BlkiQyvi0HtPbEkEYej2GJKQ_1783412749
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 28, 2026 at 11:19=E2=80=AFPM Samuel Moelius
<sam.moelius@trailofbits.com> wrote:
>
> invalidate_cblocks parses cache block numbers with sscanf() and then
> stores them in the narrower dm_cblock_t type.  Values larger than the
> cblock representation are truncated before invalidation, so a request
> for one cache block can invalidate a different block.
>
> Checking the parsed value after sscanf() is not sufficient because
> sscanf() does not reliably reject values beyond U64_MAX before storing
> into the destination.  Such inputs can still be converted to a wrapped
> u64 value and then pass a later range check.
>
> Parse each single value or range endpoint with kstrtoull() instead, and
> reject values that do not fit in dm_cblock_t before converting them to
> cblock values.  The existing range validation continues to reject empty
> or out-of-cache ranges, including the single-value U32_MAX case whose
> exclusive end wraps to zero.
>
> Assisted-by: Codex:gpt-5.5-cyber-preview
> Signed-off-by: Samuel Moelius <sam.moelius@trailofbits.com>
> ---

The kstrndup is unnecessary. strsep() can split the range in place,
and kstrtouint() handles both u32 and u64 overflow in one call. No
manual range check or heap allocation is needed.

result->end for the single-value case can use the existing cblock_succ().

>  drivers/md/dm-cache-target.c | 48 +++++++++++++++++++++++++++---------
>  1 file changed, 36 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
> index 097315a9bf0f..35c1eea48116 100644
> --- a/drivers/md/dm-cache-target.c
> +++ b/drivers/md/dm-cache-target.c
> @@ -16,6 +16,7 @@
>  #include <linux/dm-kcopyd.h>
>  #include <linux/jiffies.h>
>  #include <linux/init.h>
> +#include <linux/kstrtox.h>
>  #include <linux/mempool.h>
>  #include <linux/module.h>
>  #include <linux/rwsem.h>
> @@ -3311,6 +3312,26 @@ struct cblock_range {
>         dm_cblock_t end;
>  };
>
> +static int parse_cblock(const char *str, size_t len, uint64_t *result)
> +{
> +       char *buf;
> +       int r;
> +
> +       if (!len)
> +               return -EINVAL;
> +
> +       buf =3D kstrndup(str, len, GFP_KERNEL);
> +       if (!buf)
> +               return -ENOMEM;
> +
> +       r =3D kstrtoull(buf, 10, result);
> +       kfree(buf);
> +       if (r)
> +               return r;
> +
> +       return *result > U32_MAX ? -EINVAL : 0;
> +}
> +
>  /*
>   * A cache block range can take two forms:
>   *
> @@ -3320,32 +3341,35 @@ struct cblock_range {
>  static int parse_cblock_range(struct cache *cache, const char *str,
>                               struct cblock_range *result)
>  {
> -       char dummy;
> +       const char *dash =3D strchr(str, '-');
>         uint64_t b, e;
>         int r;
>
> -       /*
> -        * Try and parse form (ii) first.
> -        */
> -       r =3D sscanf(str, "%llu-%llu%c", &b, &e, &dummy);
> +       if (dash) {
> +               r =3D parse_cblock(str, dash - str, &b);
> +               if (r)
> +                       goto bad;
> +
> +               r =3D parse_cblock(dash + 1, strlen(dash + 1), &e);
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
> +       r =3D parse_cblock(str, strlen(str), &b);
> +       if (!r) {
>                 result->begin =3D to_cblock(b);
>                 result->end =3D to_cblock(from_cblock(result->begin) + 1u=
);
>                 return 0;
>         }
>
> +bad:
> +       if (r =3D=3D -ENOMEM)
> +               return r;
> +
>         DMERR("%s: invalid cblock range '%s'", cache_device_name(cache), =
str);
>         return -EINVAL;
>  }
> --
> 2.43.0
>
>


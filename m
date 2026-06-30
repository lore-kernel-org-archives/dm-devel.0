Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00306337BA4
	for <dm-devel@lists.linux.dev>; Tue, 30 Jun 2026 02:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782786512; cv=pass; b=aWgFej31ndddL9JmwUD5UWVpexLnUo0d2wH/+/M2gIdi6p183hkZa+IddqzJfajmirgiI3rgEQ1I3ni2gdHCYIPRo8JXgRlM85EazrK6SwH0rN5gH9jKb8MMSizaPZSg23sMbzI39ukQlI9SYOYXxT3Iep4goiWfGZ1pJVxAXZ0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782786512; c=relaxed/simple;
	bh=XVJU4NKWdHFjeXjLtOLW1JeL+7j/sambfM/0UhMt9Tc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nzqGvm/ACmh1IlRu2VnEaqo99SRZMBDofiPCY6FpZm3bEKeO18tHDiZ7Bl9O08taCHHXCiuNcXw5isju31Z3kPRlFyVdSRJlJUoFK/1b/2e/lq3drYLGWX/oTXhPsypuRhfpZnWDS2eWko/gnq6zoASPRIGc0WWESdOCZkF+ySo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=djMFtuVq; arc=pass smtp.client-ip=209.85.167.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="djMFtuVq"
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-495c63c4141so1328277b6e.2
        for <dm-devel@lists.linux.dev>; Mon, 29 Jun 2026 19:28:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782786509; cv=none;
        d=google.com; s=arc-20260327;
        b=e1N/o5M+3ldGyKOFMR0DXnjsVl8Bg/9Sh+RbJ6BS+xGfIqrNAg1ajXFZDjZ8864yuv
         cU6+ZJGwflj4e2xUStg2KcBmnDoGd0hmIv195d+H2sDH1VWG4BxePAaOpRAQUcK2l034
         tbWC6S5Z7WpNo/lIttppiVphpB94V6MbvtJ9UYMQAutYuEnbmiu5P8xbOK++oef5pZ7B
         A7AebC5bkKziNHIKozpCSirLdl7mMQs4z+EPauMsE9/xjxX5h9RtPTUg3YXnVfNTKvK+
         2fMf+DK4ZumjdhAOLnkUV5ez8geiS5VVCRTLmZeiOejilPDS6T+CaO4OE2ZVA170IyYm
         HTqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rZL9IRwXNqsz3s3p1O9648QKfkUBT6vrsHgB1H9JMdU=;
        fh=8Smi77/A6hEd3rMRd8JcvOJaqOHDFMhQWpHLIHIIpxw=;
        b=d551ft8lwFzCCMMUk7P4sHRRmtzZtHBrAx3/v03IDqV+bSUVQFub9FOCBljWkeDyWG
         J+nSLyHnI4sFX7OybyH5h9X58yGhZC3+vM0CdaulBC9BDAuIfbH1lqIEGyqxu9HFf7Bu
         XY6Hu4jZ8Mwm/xSkR+LU3aOiCxdzOdBTy//W89hbwvhtKOZT/QjT5ZdIwxlSxwru0911
         ss7GVjGdg25Fah88dnmuxK0Rctwgjy81OpnCrwW4Nfm7z2a4hKJhyfeiyxLyV+/DOcZF
         hKd5QErp8BQaPAsRBAizbOji3bDexz1MHvl00bU815KvPBZhi/FSQTb5sN2+FtE3SqBi
         7B7w==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782786509; x=1783391309; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rZL9IRwXNqsz3s3p1O9648QKfkUBT6vrsHgB1H9JMdU=;
        b=djMFtuVqTYoath07CdT9ds9fQbqJXIhopVZNGVk1kd63lpys3gwTMF1DzGuiqMZQyy
         d7LAxciBmag4dKGsa39+UM7QMpWrNTr3YJKiMbAqZCXZB1/1GtUUBcB8nElnQsa3Pt/p
         iohzVoHHceqwfgtHDafMiV+DUJRE8q2FR+NbI/8SbMnx84CRLBGtWGu+5/0tS6K5n01W
         nVNDY7fE3ISbTv+CUVGlDAZObdBFSQJfCyod9jPYlHFPcnhb9+glCbxxcrH8Zhr5I3tT
         KSKr3m+qj7o8SD7yX/PZZtInijPp9n2hZMrbq4EBY7A6lffMe7nbHy8GUddp+SzN87Ht
         IU2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782786509; x=1783391309;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rZL9IRwXNqsz3s3p1O9648QKfkUBT6vrsHgB1H9JMdU=;
        b=QDP+e4nEW343VeXvf4Rw5iKOG+s3El5+z38z6y/jZodmQ2J+8p+PzR63o1oc5dEYGf
         bG5kSQhv8ABsSBGQha00orSUK/u+/09FQ2arY+7lLZAn4xyk5v6D2ynQRyMmFsnCRtA5
         nsEUQ6RVgyL5wJDHA79rpPiFN1LsbfLz3SgLN+ZMIShaFff944ksrXIh/nOWmsNCpX53
         g3RuCTRLMupp05BvF7yxAHhseOVRUzM0Q74twBxO5jIZdYpyGmi0/YKvW51VFif8G6F+
         IhSQpmMLWY7FkSbW1dvIhf+50nAVUnHTy3noIfuxL1v+piuMdknHsLZd+KKchPjCUQuF
         tEsg==
X-Forwarded-Encrypted: i=1; AFNElJ+CwdvtifXAknS55i0UlYoaGYBdqZ85lL+yyGUbneDUCw0oTsSY5yJwn/d+OyWY/pnzRLC7LRDWoQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YyOY/eGxWsKhqzojyspo/O5QeRb1aD38E4ilmvKrP7vhgS6Nhii
	YBBxE5s8GG14J6SoWE2Cx6ZGfE2d/kTxVqVMMZvtF83FL1zUaEziyRsBUKgnULfzMVJNEam6enG
	rZbh9XsIW75VaX+XIL30bKK9eGW0PkNY=
X-Gm-Gg: AfdE7cl9jH9dui+SV+jmSnbH96DZyVNIjzo4CyImxF7RgZX3C7xmdkXSkyfl4OaqDJZ
	4sKD6lnXJWgsnt7CgDClw5epGL//Omjes+GsQoUfRxAZBSyaRRqY/ivSCjpmWJywlQZUrE7/KlV
	1D9l3j+XMA3TjoU5HbE06MWTQz1PeJCAGC87boqKuLpBY+zgaAkr7s5Uaj4UTcb4WrJA+9Vzl1X
	a2ju+0gVrBIRKP0w424XUEx8zq7KZ0bPrr4XtyCaiYLOmmu2rjyYaQ/VL3aAHTj+CJ3wy2M/GDp
	J2HXZO+s52OfeKbzfYVnVQBM7mRZ
X-Received: by 2002:a05:6808:13ce:b0:48f:3fe5:be66 with SMTP id
 5614622812f47-495eaf6a9d6mr1658180b6e.24.1782786508901; Mon, 29 Jun 2026
 19:28:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260629154739.128526.10d4fd36508c.dm-pcache-missing-option-value-null-deref@trailofbits.com>
In-Reply-To: <20260629154739.128526.10d4fd36508c.dm-pcache-missing-option-value-null-deref@trailofbits.com>
From: Zheng Gu <cengku@gmail.com>
Date: Tue, 30 Jun 2026 10:28:17 +0800
X-Gm-Features: AVVi8Cch8v8ogzXVQyRXd5LIriAQXoVcJbrRzHXfplOF1xErPKkhuMc5Li8Sme4
Message-ID: <CADSj-VoDRhF+01FCjNLmbCRarxc8u6c_JLHfmePAOG9gfhT7EQ@mail.gmail.com>
Subject: Re: [PATCH v2] dm-pcache: reject option groups without values
To: Samuel Moelius <sam.moelius@trailofbits.com>
Cc: Dongsheng Yang <dongsheng.yang@linux.dev>, 
	"open list:DEVICE-MAPPER PCACHE TARGET" <dm-devel@lists.linux.dev>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 29, 2026 at 11:48=E2=80=AFPM Samuel Moelius
<sam.moelius@trailofbits.com> wrote:
>
> The pcache target parses optional arguments as name/value pairs.  A
> table that advertises one optional argument and supplies only a
> recognized option name, for example "cache_mode", reaches
> parse_cache_opts() with argc =3D=3D 1.  The parser consumes the name,
> decrements argc to zero, then calls dm_shift_arg() again for the value.
> dm_shift_arg() returns NULL when no arguments remain, and the following
> strcmp() dereferences that NULL pointer.
>
> Check that each recognized option has a value before consuming it.  This
> keeps valid "cache_mode writeback" and "data_crc true/false" tables
> unchanged while making malformed tables fail during target construction
> with a precise missing-value error.
>
> Assisted-by: Codex:gpt-5.5-cyber-preview
> Signed-off-by: Samuel Moelius <sam.moelius@trailofbits.com>
> ---
> Changes in v2:
>   - Verify required arguments in a more flexible way
>
>  drivers/md/dm-pcache/dm_pcache.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/drivers/md/dm-pcache/dm_pcache.c b/drivers/md/dm-pcache/dm_p=
cache.c
> index 81c795c0400e..d5cfd162c063 100644
> --- a/drivers/md/dm-pcache/dm_pcache.c
> +++ b/drivers/md/dm-pcache/dm_pcache.c
> @@ -168,6 +168,10 @@ static int parse_cache_opts(struct dm_pcache *pcache=
, struct dm_arg_set *as,
>                 argc--;
>
>                 if (!strcmp(arg, "cache_mode")) {
> +                       if (!argc) {
> +                               *error =3D "Missing value for cache_mode"=
;
> +                               return -EINVAL;
> +                       }
>                         arg =3D dm_shift_arg(as);
>                         if (!strcmp(arg, "writeback")) {
>                                 opts->cache_mode =3D PCACHE_CACHE_MODE_WR=
ITEBACK;
> @@ -177,6 +181,10 @@ static int parse_cache_opts(struct dm_pcache *pcache=
, struct dm_arg_set *as,
>                         }
>                         argc--;
>                 } else if (!strcmp(arg, "data_crc")) {
> +                       if (!argc) {
> +                               *error =3D "Missing value for data_crc";
> +                               return -EINVAL;
> +                       }
>                         arg =3D dm_shift_arg(as);
>                         if (!strcmp(arg, "true")) {
>                                 opts->data_crc =3D true;
> --
> 2.43.0
>

Reviewed-by:  Zheng Gu <cengku@gmail.com>

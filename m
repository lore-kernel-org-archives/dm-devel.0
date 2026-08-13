Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58CA642BC57
	for <dm-devel@lists.linux.dev>; Thu, 13 Aug 2026 20:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786653606; cv=pass; b=CJ1TXCx/BBmMKmmY6i/5lxnKqYnM5+3KYhWeo3PNnf05IY40sJKjJ5wk4L2M5VEZY40Xsh5V45fucAHqqzx4vFht01Kow5rYR7ZeVVzzgqKvu8P4/Uwr2pk5I7oOkjT/3bkkfJcmLIGVxVhSX+UJIF9mM18/0U/YhVkMOeuarHE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786653606; c=relaxed/simple;
	bh=nMz2/CxojV9Iw0e7EZ5xxc4evspwGIEpOXWNtIm2d6c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LwhpEAJ/hdZ+jMZun47KJ+HNFYKCKP0rJ9I5dURQj7X7ikrw6FoNcAPuLP13qgDi1wBu9pHg1TmG1Ubzi9Zb5si3IP2Z9eRpNJeCClQHII+sq9Ic1Bm42FdwSNC4YG8MdHRL4ngRumRYHUs0Fl2hge+nuh9mTde6pdOx2lpTScY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Hq4g9mA/; arc=pass smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hq4g9mA/"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6a0a4a28cbdso394355a12.3
        for <dm-devel@lists.linux.dev>; Thu, 13 Aug 2026 13:40:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786653603; cv=none;
        d=google.com; s=arc-20260327;
        b=aEspYT4ixedpg/TRH+vGlmaR5ASOrsnTIkHgFvwApdDWkc76zAUdX+eqhrSeeoJs7h
         y8zFPdqgSCRDrxYnnejTuokf+ypJ1Pfi+bE0emKVM/vAKvtAXSR/Fm08VKeqztirtvk9
         jodDeE6UZUJGHPcNezrdPKch73zhwzgqMsrENaXuGVF3SOcIhyWheQs2dwtCV0S0MLZa
         j+E+dkP2jmTBxCvVQSpjc7DNJrPG3sKRhlaRoGYLTXw5ioIRuL90oq5LbjvyYc+eP9S4
         DlV6/UjZxof7IUiVyfSggXV5kw9wpGW0bHa1xJ03ygpTF84vAvydlJPSUacMzqK2qg4I
         G9NQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+7QYGQcc6efPdcIyR9Kk/VcR5kHG1m4PlGTbLXvsq/8=;
        fh=n7o421mmnOjf7qCyruQMG88TxIECvn54gGBUnmLAWn8=;
        b=JU+cZD6Yq7Mcmi9p06dVJHpDwXL5YyVY9E9jqrZGIvbu1jZSVeoxsdL7kTH8wZtKD5
         5xpm7D5WMKc07BKZZkDBKHePStXBE9d3+adXSgcw/sJcnd6IpqNH7qFcDK3Ph8nBRU3k
         /F3Mq30jXOC9Rk867AoWZ5KScm9p9vZkIctOSlg0+JYH12eS90gInCqhYWT1TF7Ah23I
         DQW/14/lwYY+Qp2FBZWdgxgq9CBx1S+LTyOvFdMvYj0cIV6X7jKLOjkJuxwxyDtnH5pk
         J3SX8OdtGU8nK7BXoK/U/OFALgda77EsI5SecozSwX4eFczOHEapZv/aAqITBP6qBbqQ
         j8Fw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786653603; x=1787258403; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+7QYGQcc6efPdcIyR9Kk/VcR5kHG1m4PlGTbLXvsq/8=;
        b=Hq4g9mA/CawV6n9643Ee9vDPC86mS9CL+YX7gsHKrtX++xpP59hjKty6d1P+usez6D
         wdbF3OWkAgwm95THXhUPLxUJaD3b7zBNsc927ffs1/NG69iDORWiEWk0mn9lKCZadONk
         U/lErfjjW+fF3Vge5WppiiBFn2BnhrjPuHCBC6aKdF1goVEl/1cgnSB/bb5kcwE5udOK
         AlwcDeJS1i9rEgrvpq2Pa396Ly7P5Mr2qpvwKqMqSSqr9k/gKtLND+M107wxMXe/W1rm
         shE7SkkNkbrQGqew0PPDsYh/Fd+ZrY/1ND2BY5Mg4++FYCW8DxKAZpfZ8BHWCInEhv2J
         171g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786653603; x=1787258403;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+7QYGQcc6efPdcIyR9Kk/VcR5kHG1m4PlGTbLXvsq/8=;
        b=XVUFQKfYuA1ofe/kDelDf/KFohl2J9PHvuOs7ce43L3S8Ko5a0rNHmS1JPHcDHebyR
         7XjlZKy6rLcom/CE574v3RftgRqBlUGXlQFTfyuklYWm7PXGqI/2dMy/hVt4+4BfoKHb
         CWwcxhoOQe4c/8xxoAygWtZsrhgGrsYbJc1PbfIsBZcZFv+lj2EfjEWJPQp3EnsqFCV5
         mhXNEuA4x23b4k7M8Ywrm5VQhkGvK7jeTz0qs4C6F2rsKaLklVzIcaCxRi1gRNwPptAP
         JMuTvMw2bLTDQewEsHrgWt2F68NBsi6V5nFFxIrJcu1qULO9eG4G7/kkQN67rHMnZffF
         hSVQ==
X-Forwarded-Encrypted: i=1; AHgh+RqbNT/4pQ7EF9B23WUIiU7O/coo1CpWjEry/gLjysJOJgBwBBr0NC8TChD0FPWqYDdxElQC0JUyRQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yws8P85km9gaDIy9yfWEtBVsH13b6aaun6mqAFgCUJb4OXov8yT
	kCdriCh9f5lrk3TGzDXO9ZF53YjNJFlgfdk9u/2NBl4sjhkxKCQyYrtEiiTRGLme6UVgJfGnmps
	S8yN4GDpa9BHpYsx4JaZ22KvhXRkzJPA=
X-Gm-Gg: AR+sD10sZ7DODaWgy9mOe4X/93gaDYaiUebsMzsRiavze9Bm2laeiGpFUbm72ym8UZ1
	etI8TtUA5JBFp0Hq6KfaMCWZ6GQ4lEUeriGVWVOHn9q6VWQ0iFUHlUa4ZQStQZ72H0oLQ1Yj104
	BRY03Ga/PwSsalOYO4E/bati8ZgZcwXXth2urz2YMsyvX9mwGBIveQFiHXg+drhUjDdTtBMTdXc
	JKaclHlWLchWuJSk+KDoS/CqESz0NFWBOCrV7T2akBpRQxWLm4J+VTQ0+JPdwtT6jX5CYf5nMe8
	cJ+SPvcfJX4ZU08oB8nEg3+A8jOkdaaW6Lt1eV+YjgyocpVDg4jXYN80S/uUxucLUj9rZDvVcUF
	7HgmXjGzmugi99lpELYoX1TEmsLDLLOwaxcAfCUzCUa8rbpuoUg7r7Dj58HuR0eJE9wpfJ6Y0nV
	ObSwUF+xvDlQU8oZKLWwUvx/NoBaI/6g==
X-Received: by 2002:a17:907:e1d1:20b0:c21:f41:e192 with SMTP id
 a640c23a62f3a-c212a491c1cmr30423166b.26.1786653603360; Thu, 13 Aug 2026
 13:40:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260813081335.40282-3-thorsten.blum@linux.dev>
In-Reply-To: <20260813081335.40282-3-thorsten.blum@linux.dev>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Thu, 13 Aug 2026 23:39:27 +0300
X-Gm-Features: AUfX_mwrjRkemxdoSy350ITr0TGthS00EGXs_Om_R3zQbscgw2CZRRLh_ge1dbY
Message-ID: <CAHp75VeXb5DhdpMo3x2dwGETC6s3hmwG1s3eZktyOd7czZOGxw@mail.gmail.com>
Subject: Re: [PATCH] dm-crypt: Reject malformed raw keys in crypt_set_key()
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
	Mikulas Patocka <mpatocka@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>, 
	Mike Snitzer <snitzer@redhat.com>, dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 13, 2026 at 11:15=E2=80=AFAM Thorsten Blum <thorsten.blum@linux=
.dev> wrote:
>
> dm-crypt calculates the raw key size by dividing the hex string length
> by two. If the string has an odd number of characters, the key size is
> rounded down and hex2bin() only decodes complete byte pairs.
>
> For example, a 33-character raw key string is malformed, but dm-crypt
> treats it as a 16-byte key and ignores the last character.
>
> Reject raw key strings whose length does not match the expected number
> of hex characters. This restores the trailing character check that was
> lost when the open-coded decoder was replaced with hex2bin().

Thanks for the report and the fix.

...

> +       if (cc->key_size && key_string_len !=3D cc->key_size * 2)
> +               goto out;

Okay, the original code did two things (differently to the
implementation with hex2bin() call):
- if key length is odd and the last character is not NUL, it failed with -E=
INVAL
- if the key length is even and the last characters are \n\0, the
string was parsed normally with the exception that the H\n part
becomes 0x0H instead of 0xH0 if follow the order

I dunno if the second was ever supported and not theoretical (so a
user can forge that one), but this change is only about the first. So
if we don't care about the second part, the expectation is that the
key always ends up with the NUL having an odd number of hex digits in
it. So, why not simply restore that NUL-check?

>         /* Decode key from its hex representation. */
>         if (cc->key_size && hex2bin(cc->key, key, cc->key_size) < 0)
>                 goto out;



--=20
With Best Regards,
Andy Shevchenko

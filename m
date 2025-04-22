Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B15E1223DC5
	for <dm-devel@lists.linux.dev>; Tue, 22 Apr 2025 22:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745360208; cv=none; b=IUoyXqnZIud+cC66Lu+F2t4L9yhJHCOs2MI/gBJm5LYAKwaHERIwOkOCqWhxWm1SkHWOoMYZfLFl4pni+Nz6pwHRxDojdcekvAHMWdRiSGerrsEV6JO+Id8Nt2G5rK/3FNQuvAt4WpKR42X8p/iM/cSYjKbBnIox9E7ykUEw7S8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745360208; c=relaxed/simple;
	bh=j34TG0ZCU906v9hRGob+DPUSHNnxdo24R0/qWN7aDeI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YQptcOmfNpL7cPTPX/HJa20KY1G0wxpNU18U0zyz3HQjtQzl/CjBCsOloU3T0h/0g9Rrnu878FKw5/VgbHNzjJeTaMV54n++nsBNkACpMUpsv5mRZTJrsq8LAQDTxu+PA95YPNOY3GHGcNZKqKcfqc0yvLoTlRfxfcxoFp2Vq7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4i0fvoFr; arc=none smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4i0fvoFr"
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-30beedb99c9so50644861fa.3
        for <dm-devel@lists.linux.dev>; Tue, 22 Apr 2025 15:16:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745360205; x=1745965005; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CKoimiCksQIzBUGjbx7qewGySEIiTp7eGdVRQpnqRgQ=;
        b=4i0fvoFrAh6hPi9i5ir4cRGuY56eAt98MqlHf4zgKOzyiaoYs/c5iyidtFLL9a/4JN
         Y5fN49ALvFnwarVxwqwYQaXgY2ZGi4wwuRORiktgLOBduwdcjE43vdOI4ivd5kdBgwec
         V6VR1V/PSVSKt3lmphpGdKMbjPSrrMKvbaVMt4inFS2Q6v2bet11drc/jZDHeYbT+FIS
         8WeWWqA/2W2SE/gzve5D+jRxM0hDW0U2+H4TDW+e7xri1k8SqIT/S2Oen9gnrj56STRj
         9ppsAYd8EMpfw0UsHS8IGuXTdmx54+bR1y6DNHL+19BfoLfcFVqJwLVIb1HY/WNSKNSX
         CIxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745360205; x=1745965005;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CKoimiCksQIzBUGjbx7qewGySEIiTp7eGdVRQpnqRgQ=;
        b=iEcrzYi9mB6W11HGNQ/k/xbFWF4wh3D+z4N9fx+aQr7/gePxxfJwAnoML+93z/0Q7G
         xQWa28TNOv3roWjEVwgllRSbe2iqBZbJAN5k13yVlmlZm6uHbtlnpaqcu6Hd2mxZ21qS
         JyI9dwnESFT5jgstr+XpXLD7VbRdu0lIxyYukGzoj5TWG4ylP1o9O3leHvNT/TSVhu4m
         QGCjm/WVZ3338TVitcXvwk6R4ShYJTPv/5/KQa1jg2utmygUX3qtRUv2Qc5TGzl/HYsu
         u9l0/PqNWBIGIy93n8ref1pmDU59NY5LCuSA8kn26A+tpYTey9h3rZiPjpetmn2c1z4I
         6nqQ==
X-Forwarded-Encrypted: i=1; AJvYcCWt8JrUhhLMroU34eCfSK9zoSOH3Ggv9zxth9j3mGop5kK14fUItWjohw/10gXnjMVcGiEa8+HAVw==@lists.linux.dev
X-Gm-Message-State: AOJu0YyVfx3OpBAtzDYWHwo3Lo7+6ihmOd+SLakRprXV2U4W2Zqtey9Y
	SdyoUaYcjGQrPRhtV3JqAGa6gka0n/jwLAPf5d+SlKKUXeIymzpkrolbGFDF5zfGFzzPVQayBTN
	BV/RWprnk1/2WgiURXdmQi95BN/0gmYGF+yk=
X-Gm-Gg: ASbGncsTEuBsfqM71jkwMhNGibFYhATibgakUElyLEWsbVWRDXK1aGzgcGe84K6DxJ/
	iTy7L6QA7vekd7JiCu7WQZ50e8igw5lv0hY7W6gE/n9Rl3+iMszjAUWczqaT+5iCQUm3pPIU+i6
	LvrE51hnQrV2sMdGo48pW8RH0QGBZlccEYZlR3dSLqqfnRALn53g==
X-Google-Smtp-Source: AGHT+IFCqPiCVaci+VRuCTGYMkeXR6Umeyfg+uL/5cZ6CZxu9rQKeAcyUCvmN8ZkAAxF3uYo+5/BxaEaUOj73lEkbFo=
X-Received: by 2002:a2e:a109:0:b0:30b:d0d5:1fee with SMTP id
 38308e7fff4ca-310903d0644mr55127391fa.0.1745360204555; Tue, 22 Apr 2025
 15:16:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <16733109-69f6-e347-e1af-02af6223ca8d@redhat.com> <20250417030737.3683876-1-weilongping@oppo.com>
In-Reply-To: <20250417030737.3683876-1-weilongping@oppo.com>
From: John Stultz <jstultz@google.com>
Date: Tue, 22 Apr 2025 15:16:31 -0700
X-Gm-Features: ATxdqUF4hGAAgUeg9QYAGnS1aBi43g82V1TajRKTO1qYwRfBd33fbXMlzpJlaTQ
Message-ID: <CANDhNCrpSApv55_0LN816nNaGhPWiWZNODr-_1egjPpgGGb1-A@mail.gmail.com>
Subject: Re: [PATCH v3] dm-bufio: don't schedule in atomic context
To: LongPing Wei <weilongping@oppo.com>
Cc: mpatocka@redhat.com, dm-devel@lists.linux.dev, guoweichao@oppo.com, 
	snitzer@kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 16, 2025 at 8:07=E2=80=AFPM LongPing Wei <weilongping@oppo.com>=
 wrote:
> diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
> index 9c8ed65cd87e..3088f9f9169a 100644
> --- a/drivers/md/dm-bufio.c
> +++ b/drivers/md/dm-bufio.c
> @@ -2424,8 +2426,13 @@ static void __scan(struct dm_bufio_client *c)
>
>                         atomic_long_dec(&c->need_shrink);
>                         freed++;
> -                       cond_resched();
> -               }
> +
> +                       if (unlikely(freed % SCAN_RESCHED_CYCLE =3D=3D 0)=
) {
> +                               dm_bufio_unlock(c);
> +                               cond_resched();
> +                               dm_bufio_lock(c);
> +                       }
> +       }
>         }
>  }

I realize this has been queued by the maintainer, but in
cherry-picking it for the Android kernel, I noticed there's a
whitespace oddity with the closing bracket indentation. Might deserve
a followup fix.

thanks
-john

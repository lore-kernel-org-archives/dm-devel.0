Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C142B239E6C
	for <dm-devel@lists.linux.dev>; Mon, 10 Aug 2026 09:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786352997; cv=none; b=lCzdwj9uZE6IkiFUi9qo7x6z5Yr9oS2jphDWInh4xoWTw/xReCJ6zJJAZhOhnB1VUGXcOqBDFiECAsV+foGayCHe8g4qiPg+tjLVy9J9O5d6UvAWBUof+ecU8qqFM+lfMC1CFqyohipgPK0PhInXCbZOUXvZaZu06e5TsL6XPHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786352997; c=relaxed/simple;
	bh=y76yFbQETrO71wPlFT9QcnMmGHl89KuMWVvOS7LyFjo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a9AyR1SXjfgMt3cqw4qxXXuB05MhtV5iyLR/YtHtfWBf2B8H+kkNe4XAlrgKP4bogE7c4Tc6nlsMO/s/g8B0k7G6bpFcgxxi+46hjCAPPCXlPaAZvmLkzU9EOCAs/+jrG4UVkuL67qJZqgf3Hp9Qetn9jhX15tqdKkjCrrAyRmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VI0tXIoD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VI0tXIoD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786352994;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y76yFbQETrO71wPlFT9QcnMmGHl89KuMWVvOS7LyFjo=;
	b=VI0tXIoD+K+iG6OzUxfpmRvrxA9K4k0hWZCo/1C1nMWI18Ob1JGAFBP6fkkL3mLJcbaqYz
	3gmPdLMXxUdcCI9sf7dkdS5lDpY04gf7QT80NSZKy4ljXoPw+1vhT6ZVGcfwd6cokJCp7G
	13ruHu7RDqkWvQeMkTg7oyIUqYUUrY4=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-696-g8kc36hQMQq5_9rJ0qAvCA-1; Mon, 10 Aug 2026 05:09:48 -0400
X-MC-Unique: g8kc36hQMQq5_9rJ0qAvCA-1
X-Mimecast-MFC-AGG-ID: g8kc36hQMQq5_9rJ0qAvCA_1786352987
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-39fa97c4c0dso4057481fa.2
        for <dm-devel@lists.linux.dev>; Mon, 10 Aug 2026 02:09:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786352987; x=1786957787;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=y76yFbQETrO71wPlFT9QcnMmGHl89KuMWVvOS7LyFjo=;
        b=H0OWpfij+NSmtSESZ2mPiEbFRT3+h968z9GyLoaPV/Rvd2b0L/ciPyOama2nx7FBFL
         m4k2dxgs95NEzRT1YFG7XVoZBhI8ORk2EQD3jmyIKLmM27vZTMAzWYXRzb28V254TRVn
         vZ85dSWnhFUKXtVskrpQmAm8vKbioWyOSTX1jQXCOTUOl0yiJdpY6ba0cF6wNHNZ3J8x
         T7frOed/FuOCOKJglG7jFN73YA1dkXlYDlvlAH6xHgBnVrVvva0ATuRyXtYpempgAv5/
         xmEad0k2Ytgpwv2KkhrclCN+dLI6K+u3KmcvMQI5an0FgTkOLXjJJjiGjvKTwOpfOz73
         N/Eg==
X-Forwarded-Encrypted: i=1; AHgh+Ro1TBnpYDig7+g19NlbWJXg6i7Hs6ZSi+N1aLG2VFJeUHiqOP5ZPDtIyJmHox+N1RWwVITqtVItaw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yx2Ndrro1EOScTONiyRw7Kq4vWW2L2uL64EcLL5FSpJpKZ7fb6w
	C0N8t8iHOSXgx8Dfpf7rBqLaG2Gu0r3Fioq5h+eQDVu8LN8+qWImvJQJJrf+09IWqfZj0sbdHnz
	ZA+ZyBUKR7DQ9CE/jnGmSNgLG91cZfJy/im9+jENxgbusDEHVViDD+r0v3btUlOSrfk5GBYAB4q
	Njf5oPIWdwzhpjBkgNveyAm35GWISk6GUluA==
X-Gm-Gg: AR+sD11QzmK9gNgNKcAsZT1YeuSA1uodjYKxr7fqtJdbZCF4RDzuCyHKBXxG46juUXh
	Woi9eD33bzLV3PcliLimZlKppLQOgKffovLDnLE4cMzKJ0Sek1N4ZAUb+fi9F8Nq+lVxiRBZNDN
	BoEZ+yCuYx8pbR7VI34zSsGQJikBXLf0OkQ7Ab5ntAgN0Z3iul+YXC008=
X-Received: by 2002:a2e:b889:0:b0:39f:e8a5:2da9 with SMTP id 38308e7fff4ca-39fe8a5437cmr17385791fa.25.1786352986792;
        Mon, 10 Aug 2026 02:09:46 -0700 (PDT)
X-Received: by 2002:a2e:b889:0:b0:39f:e8a5:2da9 with SMTP id
 38308e7fff4ca-39fe8a5437cmr17385671fa.25.1786352986339; Mon, 10 Aug 2026
 02:09:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260731-b4-disp-4fd3bed9-v2-0-7b1835e4e7f6@proton.me>
 <20260731-b4-disp-4fd3bed9-v2-1-7b1835e4e7f6@proton.me> <CALjSBEvVOTpd+j3zgspvdbX2fhQwc1HoNQHFup0uEfkRM=2kVQ@mail.gmail.com>
 <20260808085943.422108-1-hexlabsecurity@proton.me>
In-Reply-To: <20260808085943.422108-1-hexlabsecurity@proton.me>
From: Ming Hung Tsai <mtsai@redhat.com>
Date: Mon, 10 Aug 2026 17:09:34 +0800
X-Gm-Features: AUfX_mww3vSlmKwcZxLipnhZIJtWuDxrD8BVK8W2Uz95er9lDzTTvK3UqR3pg38
Message-ID: <CALjSBEuVToXYPjw=phCkkFH++akBaVT+KKKRk-7QLuDY3S1kPQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] dm array: validate array block headers on read
To: Bryam Vargas <hexlabsecurity@proton.me>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
	Benjamin Marzinski <bmarzins@redhat.com>, Alasdair Kergon <agk@redhat.com>, Joe Thornber <ejt@redhat.com>, 
	dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 5ASbpgKfqx6SZtBN5b4X-HQBNhoQzM2qZ1WFymCpwZg_1786352987
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 8, 2026 at 5:00=E2=80=AFPM Bryam Vargas <hexlabsecurity@proton.=
me> wrote:
>
> On Mon, Aug 03, 2026 at 09:41:36PM +0800, Ming-Hung Tsai wrote:
> > One minor nit, which needn't hold up the patch: I'd drop "wanted %u"
> > from the error message. The wanted value is derivable from value_size,
> > so printing "%s failed: max_entries %u invalid for value_size %u"
> > carries the same information.
>
> I'd keep it. The two DMERR_LIMITs above it in array_block_check() are
> "blocknr %llu !=3D wanted %llu" and "csum %u !=3D wanted %u", so "%u !=3D=
 wanted
> %u" is the shape a reader of this function already expects. You're right
> that the wanted value follows from value_size here and doesn't there --
> what I was matching is the form, not the information content. Mikulas,
> drop it when applying if you'd rather.

Thanks for the explanation. That's the reason for the shorter form
here: the "wanted" values for csum and blocknr cannot be reproduced
from what is printed, but readers can derive the expected max_entries
from the printed value_size. Mikulas already dropped it from the
staged patches on the dm-next branch.


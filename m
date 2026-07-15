Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 962B33C1F4F
	for <dm-devel@lists.linux.dev>; Wed, 15 Jul 2026 07:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784101157; cv=none; b=c04o9jDmwId1XnJu4zFa9yzfj58tEREdeLJBGddLhBf9ZG4BOHExcGkQli3BpzWjxOv31JtGGo1VenlzIO4apPaO/RmiCQeJOsDsGsE8UgYD/5qRPtrwbCPxjWMDNG9STEcsAdCtPJ+oGL7MIfV5KTG0Di7deTWHag25Mnatp2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784101157; c=relaxed/simple;
	bh=TRuqDiBmUSduFgKaNOC3hksdAg9TyY+U1OwOjl0lQeI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kPAJYv6hKeWFh4g+HknuqSn5KRrsF6oHScliKz9koYeAbV5fY99oatHAU1CipCpeFIiQwECK+NC5TSp6P8H1iaSLKUdO+QOc0u+b+itA3Gh3ag+UcmbjUS7q7LveZYOQmjbjC1hcJEObfY3Ccc68BbAh9Pv++nDyrP8wJC6ox0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hA5DrAFn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hA5DrAFn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784101154;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oas23s+1TraUL1LFFQOTaB/MqRqWXO/izYZAf3uGB8I=;
	b=hA5DrAFnv+RzM3ufvmCsOKQockgi1Rp+EGglYc+7RCj8SEkjy92dYhh75lGn/X4cylT/me
	wtzAE36sqml8hoh6CqMiwP0nNtQZ2dYEi0IMy9DqjUjEcdpvXWGuXAHWVwEInw3jt6NKeF
	HbS99U8pS0Qcb/MRCcZHGhz2a4zNJlU=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-594-LvGHIf4zPxmNRelXYZg9yg-1; Wed, 15 Jul 2026 03:39:13 -0400
X-MC-Unique: LvGHIf4zPxmNRelXYZg9yg-1
X-Mimecast-MFC-AGG-ID: LvGHIf4zPxmNRelXYZg9yg_1784101152
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-39b1abd1026so27323211fa.2
        for <dm-devel@lists.linux.dev>; Wed, 15 Jul 2026 00:39:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784101151; x=1784705951;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oas23s+1TraUL1LFFQOTaB/MqRqWXO/izYZAf3uGB8I=;
        b=Oxz6qpOjqbSwp10iDkOHH/kG6tDCMqktB/CUm4WjielYb/rC3bKqH+ksrgne/xWR8R
         rFMB4uR1Iq+0/L2FhX0odtVAgai1w2vnwkT+A6kgOFqY9XnamEdsx9K0Y1C4GU/8oJqU
         Jo9e1FG5iPduHfZuhLGyVv1kVNtJL8/r9uC0wAsnM2tukb+nqlO8TAfLb0ipeeGToq22
         RkIM05HqRV5nVjGUe9rwp78cC3oyMgxexeIJ50smpRvyjF3BeXtfifovuQKphfMBFxoc
         0mjhwuQM+hmfZKSN2F4lLGDFnjgRYbM5WhxS8H8TpAme+GxMONeGJeEZiQlYWMQfWqos
         ioNA==
X-Forwarded-Encrypted: i=1; AHgh+RpNdCV5nud4MDL+4AgxD6PwCVMCFAvLSqnKw6JvmZPPdWQsqEu31SG/Mw6VArEel1bK5FjvnA4PtQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YyLkYKoQ1JYaUu15LaXWQI5cYqXHASdO/QnxPwaRatSViWy/p0C
	EuD70lFgwivFQ6UuxCs/QhhMLfJPOTZxrPYQihyBdUhTUD5c2rNY5AJfy3lB65CJUPGhuLZWGnN
	gNIGCz1i1u5uX8nDSkf4RsTbE543jo0Qp1egGPEjpouNoTRQzb1oMbt9+8RdKg3bDWMzHmWqRrS
	4j4SdtTkqMzQjXgHoiZ39NohiEULzmUAQIug==
X-Gm-Gg: AfdE7cnsXcon+p6Nic2/ingURjxaquO8AbrTiXAN9a1WmTlj+BBCteyg5B8wkv/hB4m
	qqs/CBVeEXTGrKM0XuOw1yvKM12G9lJx7OxcE5rYiI94YejXVBymEYr51a4yAKZHEYE3xJ8svMK
	cGnRDYPWnDXLZ2NG+aQU7LunvOlbs9jtTeX4bLMi7jjAUB0NVnOF64pRuD0za5mLo5EQ==
X-Received: by 2002:a05:651c:220f:b0:39c:6630:d7c3 with SMTP id 38308e7fff4ca-39daa75ba97mr16737661fa.8.1784101151533;
        Wed, 15 Jul 2026 00:39:11 -0700 (PDT)
X-Received: by 2002:a05:651c:220f:b0:39c:6630:d7c3 with SMTP id
 38308e7fff4ca-39daa75ba97mr16737531fa.8.1784101151121; Wed, 15 Jul 2026
 00:39:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260715001755.123939.f196d094e808.dm-cache-invalidate-cblock-truncation@trailofbits.com>
In-Reply-To: <20260715001755.123939.f196d094e808.dm-cache-invalidate-cblock-truncation@trailofbits.com>
From: Ming Hung Tsai <mtsai@redhat.com>
Date: Wed, 15 Jul 2026 15:38:59 +0800
X-Gm-Features: AUfX_mx4FQNFJBgKcFJo3u3SLZTb1qoO8CgYGHfVZR4UPlmL2oqDkck8fPy-iEA
Message-ID: <CALjSBEvfJ95UFg8xcw4+X8sO8QL2dejAtY4P91gJi3BGqA-+-g@mail.gmail.com>
Subject: Re: [PATCH v4] dm cache: parse invalidate_cblocks with kstrtouint()
To: Samuel Moelius <sam.moelius@trailofbits.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
	Mikulas Patocka <mpatocka@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>, 
	"open list:DEVICE-MAPPER (LVM)" <dm-devel@lists.linux.dev>, open list <linux-kernel@vger.kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: adLq0O8-46Pypi0HWeA0ITRK5_RwDfnOFj2QoZDR_1Q_1784101152
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 15, 2026 at 8:29=E2=80=AFAM Samuel Moelius
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
> Split ranges in place and parse each single value or range endpoint
> directly with kstrtouint() instead.  This rejects malformed values and
> values that do not fit in dm_cblock_t before they can be converted to
> cblock values.  The existing range validation continues to reject empty
> or out-of-cache ranges, including the single-value U32_MAX case whose
> exclusive end wraps to zero.
>
> Assisted-by: Codex:gpt-5.5-cyber-preview
> Signed-off-by: Samuel Moelius <sam.moelius@trailofbits.com>

Reviewed-by: Ming-Hung Tsai <mtsai@redhat.com>


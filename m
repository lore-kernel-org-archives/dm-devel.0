Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F9D236F411
	for <dm-devel@lists.linux.dev>; Mon,  3 Aug 2026 13:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785764514; cv=none; b=mLgPt2buffTh9SlAfsahYZqA/+0ymMJQzXWG1u97jp4HUpVtRalw+a1hFTs839R2cc9nRu6kMKLoZ98gaPpaTmNzpyNRsSTFfdAEUGuHkry+3Pa6pBFt6PiLqwHr6yGBosrlwQM5jjiu9uaugeriD3wp9l+U4NJpXDTSk6337/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785764514; c=relaxed/simple;
	bh=QzYE0JDFLWPcWAIy5x14hHZtnJX/w6Hh1Qn7etHkN8w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gApa1dI/SETMbDHaE32r5UNl0Tj+yfKeRvPPuv1gxF9B8oyo2jy5BkyXHCrNt4tXM9fE5pYBUP9jI+VuehavZ11ikvT9/LzUxa1OpWblUOIj7FQC0xjywz7grGo6tRi8ZyMynRvWzS6/63UqkMRGN0ZaocCbJVtE0Uw0GZe1i9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WktnuAlG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WktnuAlG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785764511;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EEHppEq5Cdk7AYRM9xArJ4bN2vI+imWgmdyF+pv0t/0=;
	b=WktnuAlGzohKC0Hg16BTyQ98fAlHLj5Dz/Q1eKjSczKj2vDev/Yio/Khnw13w9GrJlFpIB
	G6p5HWo5vbPpD9fabScQZfxCP9937elQiWZ/xtSgv2hf58R5QmDbU89fmFAu9wp8cw2STk
	X56OqobfVmV8ucvYFJkF1LOSEUE28eU=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-382-R1DdaDvzNq2gyxWjsD27DQ-1; Mon, 03 Aug 2026 09:41:50 -0400
X-MC-Unique: R1DdaDvzNq2gyxWjsD27DQ-1
X-Mimecast-MFC-AGG-ID: R1DdaDvzNq2gyxWjsD27DQ_1785764509
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-39f27a480bfso10721741fa.0
        for <dm-devel@lists.linux.dev>; Mon, 03 Aug 2026 06:41:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785764508; x=1786369308;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EEHppEq5Cdk7AYRM9xArJ4bN2vI+imWgmdyF+pv0t/0=;
        b=dWkUkl2ylX0ZgbmDRTmVtqo7umotlyWelZuTBfaiYvABsmzNvnvXHDXKnkVjHkKnEH
         I6xxbLLvw4c+Q64RVKP4Y4B5l9pY6pVkQou4FX4F5EkFAEtHN7JbNtG614infT2+naxf
         eUWI3r7WwT+ATKALLDi7f2EjcVoauvxXDHxOUhcxMzjl6VUmny6pfz20lYOL0r5dlfdz
         S2uL0YhImcyBfB1L88uXsM9lEErgYPA6xC0JYVzoES3aj/EkZXFcaBDKukXBiLZ62Iz+
         x+KBiliHgdn/HP97Q7GC6CzQl33utns/9w2Ru4MGwD8zy8lid5Au3bl8AD+BRFeA9Bja
         CPnw==
X-Forwarded-Encrypted: i=1; AHgh+RqDqtaM+Rt6qRd7cHyeF2aRU1PJP7Eb5onrsYs+t2ZgZYd5WVbPsA2GKwKAuN2IUIiEBFSjcVoSDQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YzYdtoBeeNsQLn84sn9MGGj9jzRoFaSIiHFilLUcdsuhb7ZlQcf
	enMTBc+eRQVyYIUwdxRr8PbSZdC4/+WpOfT+fadb0AYzxLc0pi/E6LbuGeG0sHU0Fd3JIzfZimq
	RR6QadyMbJoUXQ6x51xRRAjVZKbeH4tKzJ+p3murHcNMahQRUkkdRehsWfxSqwhhxRu16jYg0C/
	MLcDT5yOW6p7qylkr424TJkOvKmKCAdGYyqQ==
X-Gm-Gg: AR+sD10mP9NnqHsqO6slsIwSj172CJzzO9paGJ+W/prnBfJZPQqicYBMDax5530U7/E
	y70x7Wb9hVGQt3ofF1A79EMVCwPWzbW7coMuM6vpC7nSnpwzlC1O7pIFM7AHDQmTpEaxMV2sYC8
	JKa+SBILa73Mg4gF3r6WiQNG7eEx/eJpXR4ovFVfHow3xMSdV9fFZEgpc=
X-Received: by 2002:a05:651c:1601:b0:39e:ea4f:4202 with SMTP id 38308e7fff4ca-39f863f23b7mr19113591fa.31.1785764508528;
        Mon, 03 Aug 2026 06:41:48 -0700 (PDT)
X-Received: by 2002:a05:651c:1601:b0:39e:ea4f:4202 with SMTP id
 38308e7fff4ca-39f863f23b7mr19113471fa.31.1785764508119; Mon, 03 Aug 2026
 06:41:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260731-b4-disp-4fd3bed9-v2-0-7b1835e4e7f6@proton.me> <20260731-b4-disp-4fd3bed9-v2-1-7b1835e4e7f6@proton.me>
In-Reply-To: <20260731-b4-disp-4fd3bed9-v2-1-7b1835e4e7f6@proton.me>
From: Ming Hung Tsai <mtsai@redhat.com>
Date: Mon, 3 Aug 2026 21:41:36 +0800
X-Gm-Features: AUfX_mwoazIh-tPHwhsJhmas2iw0ExklfErDnkyVREE-9PAWDYBmN2eRXym1D7s
Message-ID: <CALjSBEvVOTpd+j3zgspvdbX2fhQwc1HoNQHFup0uEfkRM=2kVQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] dm array: validate array block headers on read
To: hexlabsecurity@proton.me
Cc: Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, 
	Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, 
	Joe Thornber <ejt@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: d3mbfoQ4gRy6JJkdFq4QiF-Vzv2jCLrPr_ssHh1010s_1785764509
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 1, 2026 at 6:55=E2=80=AFAM Bryam Vargas via B4 Relay
<devnull+hexlabsecurity.proton.me@kernel.org> wrote:
>
> From: Bryam Vargas <hexlabsecurity@proton.me>
>
> array_block_check() validates blocknr and csum and nothing else, while
> node_check(), next to it, has bounded the structural fields since both
> were written. dm_array_cursor_next() takes its loop bound from the
> on-disk nr_entries and element_at() is unguarded pointer arithmetic, so
> a count larger than the block holds keeps the cursor in one block while
> the index grows past it and the read walks off the dm-bufio buffer --
> dm_cache_load_mappings() drives it once per cache block at activation.
>
> Check the header against itself: reject a zero value_size, require
> max_entries to equal calc_max_entries() for that value_size and block
> size, and require nr_entries to fit. Equality rather than an upper bound,
> since a count below the real capacity trips BUG_ON() in fill_ablock() and
> trim_ablock(). Metadata dm-array writes satisfies all three.
>
> Fixes: 6513c29f44f2 ("dm persistent data: add transactional array")
> Suggested-by: Ming-Hung Tsai <mtsai@redhat.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>

Reviewed-by: Ming-Hung Tsai <mtsai@redhat.com>

Reproducer to validate the BUG_ON prevention using crafted metadata:
create a cache device, and reduce the max_entries of the final array
block of the mapping array. Next, expand the fast device to make the
last array block exceeds its capacity, which triggers the BUG_ON in
fill_ablock().

> +       wanted =3D calc_max_entries(value_size, size_of_block);
> +       if (max_entries !=3D wanted) {
> +               DMERR_LIMIT("%s failed: max_entries %u !=3D wanted %u for=
 value_size %u",
> +                           __func__, max_entries, wanted, value_size);
> +               return -EILSEQ;
> +       }

One minor nit, which needn't hold up the patch: I'd drop "wanted %u"
from the error message. The wanted value is derivable from value_size,
so printing "%s failed: max_entries %u invalid for value_size %u"
carries the same information.

Mikulas, if you agree, feel free to adjust when applying rather than
requesting a v3 patch. Thank you.


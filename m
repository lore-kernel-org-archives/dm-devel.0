Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF01B369D76
	for <dm-devel@lists.linux.dev>; Thu, 30 Jul 2026 18:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785436906; cv=none; b=XG9PP+6s55hZZzShAVCqWlX2gr4r/rNX6kwS9ZEZvnzGxoMDUIEQBwTlMguqRJ1lHOvdJ897PoJOS8vFvuquBdQSvECDGRmN2Vis5EdBayuPYf5UCgG3WvBRiFgbInXl2FB7vTS/fLcmL/7cRlvKtrTBhqLyNhHWrg9qmJnBpqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785436906; c=relaxed/simple;
	bh=ltZeiuEyQapLhy7Dsg/2wMi/4vXaj+s/pQpQzq2aD64=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oBHONsixg52PDw5mWvDJ3So6R8wPKR4RD100QJpAUMoW2+IQ4ybAEE6YAI6r3wdCVZAKRh5x6I+mO8ACpsaxWFt+s88K/OnxXuv1VWU3MGCFCyfzgfG5Z74Am9+uB1BdsG3ZwzP+hu9gMpq9V6NV6giWkhpkgT16Bvbonju/fy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DMjhc2es; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DMjhc2es"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785436899;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6gfN1Th1tb2tUCn0xyd8Q+ZCC+D6SLCGJcNCdGlVrQA=;
	b=DMjhc2es5w1vcohXggtbo647N9WF1qTImf8gwxrkxEPpqMm5U0Zf+nGYKfueRqwWaMBKFe
	W93cbhTMRcTAyrgGHxeUnIR6dpNcS6gruyI4UEOkmnelQ/RFBJQwHZqk1M7Qf6z4+DQF/S
	ZDdjiDB0pvl9mX5fNfqseutaxBNptSI=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-504-K-3G_BOSPIinoYfoov_opQ-1; Thu, 30 Jul 2026 14:41:38 -0400
X-MC-Unique: K-3G_BOSPIinoYfoov_opQ-1
X-Mimecast-MFC-AGG-ID: K-3G_BOSPIinoYfoov_opQ_1785436897
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-39d93e881b3so664991fa.0
        for <dm-devel@lists.linux.dev>; Thu, 30 Jul 2026 11:41:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785436897; x=1786041697;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6gfN1Th1tb2tUCn0xyd8Q+ZCC+D6SLCGJcNCdGlVrQA=;
        b=MPjM7PnNGFdclce2gwEy4pPz383NxEaf01lVWYbHHuIDaqDfPzObN1Iq/4pi+CfZBp
         f6O13a6BqFGvlBjPweTKC7Vjr7oh4qq1Te8a8Wl4dsoE0V3WvzpTO3xauDajDKCZuKam
         /RxPfC7kBYFtaNZqqsMi4yCfVB7uKSlMWLP97Hiew4VJdcOZGfOpNvbOsWdntTJ5A0fp
         HOMZw16MCEtcnHi5CFEPxsZ5kTzWWYyjSLNnby7X4ZMbQH1WKVHC3zb8DU4DtO5JKlJR
         rS7d4ZhKcVkRfjf/qvvjiEpgFTAkjP5wD226AVXWtLH3ttlGzQPaPbXanV7fZ7hWazmK
         hKHA==
X-Forwarded-Encrypted: i=1; AHgh+RqIjgfTzDa60QPmSeoo6/7YkSaGG+lxBPssNG+c41CcedgtK1uJPwpS59Jy5vlqsYax1aG5Yy0X5Q==@lists.linux.dev
X-Gm-Message-State: AOJu0YxPc1ZIa9756ALFFwO1xk1ZcFgRRMdKIVIwlr3qp5HCPF4YlcfM
	tfO1MtoTqT53eZZkC6ToP2XB/6p/DF//6Y40Par+bmo93zsbY27PfnnLQp108u6KPOTekdcrvv0
	uxPcDuL9JJIxv8+GGRARXUaEP7hOH3eou7QevsMGgXP+yciSt8K4yeo4iolyihqMzAiAXcyONVh
	m61SioFCKdODby/YAOH7bZEU1YHec/8QZwBQ==
X-Gm-Gg: AR+sD10ufvttCkz1Gd4LIwrqxXUKQGAWObOOdQ6/AChQSex4bSeyCGAhrDmpYFq4buZ
	YpOr7ZoBQBeuap9Rn26FFvjFSLY8t0YhOpuChp5vWLAMup4toD+n6B8mIgQBqXIminEyGYe/ZXb
	3pH3KYe4FGtJO5Lg3Wz3XoOu8e2sJdsJOnEzX9GEKOASuctj/r9paP8kTC2A==
X-Received: by 2002:a2e:bd06:0:b0:39e:e6d6:c999 with SMTP id 38308e7fff4ca-39f6d1900ccmr7843561fa.33.1785436896680;
        Thu, 30 Jul 2026 11:41:36 -0700 (PDT)
X-Received: by 2002:a2e:bd06:0:b0:39e:e6d6:c999 with SMTP id
 38308e7fff4ca-39f6d1900ccmr7843381fa.33.1785436896242; Thu, 30 Jul 2026
 11:41:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260727-b4-disp-0d625fe8-v1-1-be31f8611720@proton.me>
In-Reply-To: <20260727-b4-disp-0d625fe8-v1-1-be31f8611720@proton.me>
From: Ming Hung Tsai <mtsai@redhat.com>
Date: Fri, 31 Jul 2026 02:41:23 +0800
X-Gm-Features: AUfX_mzTUY2lmpwmW_KOiFA1skF9x3JenJXJ21VC1V3sTst2jtgHsSL5vqXa53g
Message-ID: <CALjSBEt-PGxY7y6tQYx6iCmFRXqVcwr633FoFsE+L13A=gre4Q@mail.gmail.com>
Subject: Re: [PATCH] dm array: validate array block headers on read
To: hexlabsecurity@proton.me
Cc: Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, 
	linux-kernel@vger.kernel.org, Joe Thornber <ejt@redhat.com>, 
	Alasdair Kergon <agk@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 986Ttss2NqfPLYgBpObLssKldvPAO4ZNk9_XH46EOXk_1785436897
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 28, 2026 at 8:16=E2=80=AFAM Bryam Vargas via B4 Relay
<devnull+hexlabsecurity.proton.me@kernel.org> wrote:
>
> From: Bryam Vargas <hexlabsecurity@proton.me>
>
> ---
> Found by reading array_block_check() next to node_check(), its opposite n=
umber for btree
> nodes in the same directory.  node_check() already bounded max_entries an=
d nr_entries when
> dm-array was added in 2013; the array validator never picked it up.
>
> Reproducer.  Create a cache on a zeroed metadata device so dm-cache forma=
ts it, tear that
> down, then set nr_entries in the first mapping array block to 0xFFFFFFFF =
and recompute the
> block checksum.  dm_bm_checksum() is crc32c(~0, data, len) ^ CSUM_XOR, so=
 the checksum costs
> nothing to forge -- it is a corruption check, not a tag.  The crafted ima=
ge differs from the
> one the kernel itself wrote by four bytes plus that checksum.
>
> A 4096-byte block with a 24-byte header and 8-byte values holds 509 entri=
es, so index 509 is
> the first one outside it.
>
> A/B on v7.2-rc4-610 with KASAN and kasan.fault=3Dreport, this patch built=
 as posted:
>
>   pristine image, unpatched:  activates, walks all 2048 cache blocks, dme=
sg empty
>   crafted image,  unpatched:  reads past the block, below
>   crafted image,  patched:    "array_block_check failed: too many entries=
", -EILSEQ
>   pristine image, patched:    activates, dmesg empty
>
>     BUG: KASAN: slab-use-after-free in dm_cache_load_mappings+0x9b1/0xb40=
 [dm_cache]
>     Read of size 8 at addr ffff888107fc8000 by task dmsetup/1667
>      dm_cache_load_mappings+0x9b1/0xb40 [dm_cache]
>      cache_preresume+0x4cd/0xd70 [dm_cache]
>      dm_table_resume_targets+0xcd/0x2e0 [dm_mod]
>      ctl_ioctl+0x512/0xa90 [dm_mod]
>      __x64_sys_ioctl+0x134/0x1c0
>     The buggy address is located 0 bytes inside of
>      freed 32-byte region [ffff888107fc8000, ffff888107fc8020)
>
> The block base was ffff888107fc7000, so that address is base + 0x1000: by=
te 4096, index 509,
> the first entry outside.
>
> Worth flagging about that KASAN line: it corroborates, it does not reprod=
uce on demand.  Two
> earlier runs of the same arm produced no report at all, even though the o=
verread happened
> both times and dm-cache said so by refusing a nonsense mapping at cache b=
lock 509.  dm-bufio
> serves this buffer from __get_free_pages(), the page allocator has no red=
zones, and byte 4096
> is the first byte of the next page, so KASAN can only speak when that pag=
e happens to be
> poisoned.  The first line is the deterministic one.
>
> The check is not conservative.  calc_max_entries() gives 509 for 8-byte v=
alues and 1018 for
> 4-byte ones, and 24 + 8*509 and 24 + 4*1018 are both exactly 4096, so met=
adata dm-array wrote
> sits right at the limit and still passes.

Thank you for the patch. I agree with validating these header fields,
and I have a slightly different proposal: compare max_entries against
"calc_max_entries(value_size, size_of_block)" in array_block_check().
This prevents callers from hitting BUG_ON in fill_ablock() or
trim_ablock() when a max_entries is smaller than the expected
calc_max_entries().

Adding the equality check has no compatibility concerns. dm-array's
calc_max_entries() is unchanged since it was introduced in 2013. Also,
the max_entries is used by dm_array_get_value() to address entries;
any further change to the max_entries formula would break addressing
on existing metadata.

Checking "!value_size" becomes necessary to avoid divide-by-zero in
calc_max_entries(). I'd prefer splitting the value_size check from
max_entries with a different error message for diagnosability. A
combined form "if (!value_size || max_entries !=3D ...)" also works, but
the shared error message needs some tweaks, maybe printing both
value_size and max_entries, not just "max_entries too large".

> There is a second hole I am not fixing here, since it wants its own repro=
ducer and this one is
> headed for stable.  A validator can only check a header against itself, s=
o a block with
> value_size 4 and max_entries 1018 is internally consistent and gets throu=
gh, but element_at()
> indexes with the caller's value size rather than the stored one -- and dm=
-cache keeps arrays of
> both, mappings at 8 and hints at 4.  Read an array block of one through t=
he other and the walk
> runs to byte 8160 of a 4096-byte block.  Closing that means comparing val=
ue_size against
> info->value_type.size in get_ablock() and in __shadow_ablock(), the two p=
laces that hold both
> the block and the caller.
>
> dm-era reaches the same accessor directly and dm-clone reaches it through=
 dm-bitset, which is
> an array underneath; dm-cache is only the shortest path from a crafted im=
age to an observable
> read.  All of them need CAP_SYS_ADMIN to load the table, which is why I'm=
 sending this as
> hardening rather than as a security report.
>
> The value_size patch follows once I have a reproducer for it.

That kind of contextual error is a concern. It could be reproduced by
a crafted metadata with swapped root nodes for mappings and hints in
superblock (with updated checksum). During device activation and
__load_mappings(), dm_array_cursor_next() iterates entries according
to the cached array block's nr_entries, while
dm_array_cursor_get_value() reads the entries in terms of
info->value_size, triggerring out-of-bounds access,

cache_check and era_check v1.0+ already detect value_size
inconsistencies, and older thin-provisioning-tools can detect the
error by checking illegal mappings and flags, that helps mitigate the
risk offline. An in-kernel follow-up patch is still worthwhile for
online validation.


> ---


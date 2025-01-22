Received: from mail-yb1-f182.google.com (mail-yb1-f182.google.com [209.85.219.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5145984A3E
	for <dm-devel@lists.linux.dev>; Wed, 22 Jan 2025 09:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737538528; cv=none; b=i8JQdRgctFCpsxvllDIy44GaCxNXzysNtE7YLnxuwRB58YqDKTLxcdjrEof8qGvJuzksvRtgn/cvK8lvofyP1hPp4zoPLtt7qkfE09ryb+Fol41cm56LzJ/9CQjTq5PV3w2w4uaVnN4RjN+21ssrCB0rt+UztIaRlc1HsCS2eTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737538528; c=relaxed/simple;
	bh=H3Rj/KZBgEg81K2R6hbgOX7FTydx6dl8gpXqUg3FwA0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VDqAg/13wyjkroNT4idRSH/Bc1Pv32xoOssuw4BMq5QOn9bf39TjE16q2TK7YVho5cUz2mMRSKRIfOZbhPOd7rPp2Hfx3KFiCMiewanR+SYkFpEF+zFYwo20D/CtrQOZCXmz44uZtXOEIeoRaU2v6s3gKwaQffFGo5pySO/7I3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m0Qs9zoK; arc=none smtp.client-ip=209.85.219.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m0Qs9zoK"
Received: by mail-yb1-f182.google.com with SMTP id 3f1490d57ef6-e3a1cfeb711so9884851276.0
        for <dm-devel@lists.linux.dev>; Wed, 22 Jan 2025 01:35:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737538526; x=1738143326; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ld7IiFOmyIP7COohEu7H9W5bnHd64duE4MAjTQdxx9U=;
        b=m0Qs9zoKEibMPzadV1AN+Xg70KoNmTkyT73LgUE+y4nBCrXaKdGafdcwKBYI0o49Rs
         EKQUgM4qn7ZBfOWyrQVqva8yA+JWVnwUqHjrT5q6tV6M4eBiMVHN7ktWhET4/mal3gzP
         yoPyrlytpzIaFCrTpN0lfZnH8LVwXG0TbPWCfXiiyuBZEMiZNVXBeziHCxuayMi26vt7
         ko9xQp0a368xDB34F51dLx29C3LIS4VgPmmQHGvvLX9DN16sG071KGB4mYTDrYr/8MED
         74m/6d5tkotIJc4axlSQAEHEdYGzAJbFqy7tnI4XoJmfGsR24vNkiDHtsATZh+67ggUq
         mEFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737538526; x=1738143326;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ld7IiFOmyIP7COohEu7H9W5bnHd64duE4MAjTQdxx9U=;
        b=sSzSQ/TxFYC8tu2E+yx/wi3WpfKsaHpqmInkswfTJX82iKDzAg49pwKYhgtUPE59k6
         MnNGmEwKmotvNJLLA1SSNq08LPQleeLurENwDhf2ciNrwu/c+Z4ny3gJhcrSdtrc4mtg
         x7O/Tje6h0wUjZO2UaHTW33jVCcSsInRACmVr5RR0GlCh+K1qzh/tSP5Vy+ClDQcwgnP
         ffu5pyE6aw2PxnBpOH8Uw+h83p6k7t5jHzbk490Ic7xU6XZ+WqnGze8rBiiwvERTsSHN
         Y1xLNFpLupVtOlpZKyao0e294wBY+B57YlGxio4QOdXqnzXvKq+RCIJHhRfCMJGtmuk9
         yebA==
X-Gm-Message-State: AOJu0YwNwENy+ZIGBCDJ4TmWKndVNbny8D4CDP90AltevNsNMuuwcg/L
	+IJwbvBZUBVaxzNOwcDhosrtC8r0o/Q6ZbUyD3+aiK5g7XAZXSd7nLoUxZNSuL8deYqwRu9+G0q
	uJA5hmSghMqOH56rShvuyhA1vpzk=
X-Gm-Gg: ASbGncvXbj8Ca3ZLin5lAKoLZUHi7SCCpCqArrXKw/YlzbiB5ILF5ejiCVz4EzM3Ae5
	2q6czTBdj0ZblJu+HVn9I3kPKH3pM8h6tJyiqxkzrKXDJcl/aRl/q
X-Google-Smtp-Source: AGHT+IHz8tXzTTfirQV8+xbyeKGzyRvp4/HMWt6LAErvsinE506Mk2b+N61bPyaiJq40EtBWKHdsmWV8ms0MgGJPzlY=
X-Received: by 2002:a05:6902:120c:b0:e3a:6bd:3f4d with SMTP id
 3f1490d57ef6-e57b1327f8emr15005208276.35.1737538526132; Wed, 22 Jan 2025
 01:35:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CAAiJnjoGn4Jn6O-SWAaAzwNk4DhEiCFUA0Q0X2RLdrHH7NR5qg@mail.gmail.com>
 <2f847044-fef9-4cfd-95c6-038c07468e0d@redhat.com>
In-Reply-To: <2f847044-fef9-4cfd-95c6-038c07468e0d@redhat.com>
From: Anton Gavriliuk <antosha20xx@gmail.com>
Date: Wed, 22 Jan 2025 11:35:16 +0200
X-Gm-Features: AbW1kvaYM_uWki0AtgwMS28jLH6uir-MnBU12zQJr7fA0dtXZc2Chhpfjl58gHY
Message-ID: <CAAiJnjpdDU9rVLag0mFTy1iYb+aPFVq+QaBMjEn4cq1fp4YbbA@mail.gmail.com>
Subject: Re: Adding zstd to VDO
To: Matthew Sakai <msakai@redhat.com>
Cc: dm-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

For storage server solutions space saving is very useful, both
compression and deduplication are important.  Deduplication is just a
part of the story.

What if the compression algorithm (lz4 or zstd) could be selected per
device basis with default lz4 ?

It also may not be a bad idea to add compression levels from --fast to --be=
st.

Combining above, users could select different algorithms (lz4, zstd),
different compression ratios and speed for each device.

For instance - there are 2 volumes, one with hot data and lz4, another
with cold data with zstd, but both volumes with deduplication.

> Switching algorithms after data has been written to the volume could make=
 older compressed data unreadable, so we don't want to allow that.

Yes, there must be a warning, that after selecting the algorithm there
is no turning back.

An example - nearly a year ago, HPE's software defined storage
solution - "Alletra MP" compression algorithm was switched to lz4 ->
zstd.

If still keeps a single compression algorithm, zstd almost always
looks better lz4 (probably except decompress speed)

Anton

=D1=81=D1=80, 22 =D1=8F=D0=BD=D0=B2. 2025=E2=80=AF=D0=B3. =D0=B2 04:59, Mat=
thew Sakai <msakai@redhat.com>:
>
> It's a reasonable idea. We've discussed it before but it hasn't been
> particularly high priority. Since VDO is mainly focused on
> deduplication, it's not clear how much it would help to use a different
> compression algorithm, but it shouldn't hurt anything, either.
>
> To make this work we'd want to add a new create-time option to specify
> the compression algorithm to use. Switching algorithms after data has
> been written to the volume could make older compressed data unreadable,
> so we don't want to allow that.
>
> Matt
>
> On 1/18/25 12:53 PM, Anton Gavriliuk wrote:
> > What if zstd can be added to VDO as a compression algorithm along with =
lz4 ?
> >
> > It could provide more flexibility for users - faster compression or
> > better compression ratio.
> >
> > Anton
> >
>

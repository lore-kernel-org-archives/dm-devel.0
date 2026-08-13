Received: from mta0.migadu.com (out-1.mta0.migadu.com [91.218.175.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD24F3A255F
	for <dm-devel@lists.linux.dev>; Thu, 13 Aug 2026 21:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786656782; cv=none; b=dVISrtXdefZuyvPLdKvnr+KmVdzQeNFKbZkjw2HMKLBdu5FYUjCS5gbgY9966eQsWte+llD6eIdU8/2tq+o5pYYepoPtOReNLgXWK08NFzacuVnt9CMyU32cSrIfWzAYkjkcPa/5nxJIyymwrIPJw9tKClzp38w3r0P2zzSN3kM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786656782; c=relaxed/simple;
	bh=LZMC25HwDdExjBm3N+ydxbcA57pvBYyS6Kl3DOLCtWo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BSCaCVjjfossbqdKmmDZYa/miEJIcI+xSsCd5HmVXNRU54FjAnjUSzZqeX4bTgddO6ymk0CmIoBL1FkBLotsjtNL27cfA8qJIxSl8zkqJYmxyHpkiH/YSFpMBAspeeB4ZCig19KZ8HUq2rw6BF2caIaPg9ZbAFi1UoP+er6Vrfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hbvGNpvo; arc=none smtp.client-ip=91.218.175.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hbvGNpvo"
X-Envelope-To: dm-devel@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=LZMC25HwDdExjBm3N+ydxbcA57pvBYyS6Kl3DOLCtWo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786656778; v=1; x=1787261578;
 b=hbvGNpvo+l29m2O1R5O/dgEvtEIxzAzWaCZGfcpkudKQe4AQXeKecERccVonbFytZL5WB6Di
 ZHY+JrMc+WiyW8C8Z64uaBpH0Er0/qYuSGWrYYBsfag6l5zsHDH0e6164VAAv3rKtV5rHzZvZrB
 cllG3qes1MJNa/k6zm+URnxE=
X-Envelope-To: dm-devel@lists.linux.dev
Received: from linux.dev (62.216.208.217)
	by mta11.migadu.com with ESMTPS id b6c41f87c7a28578;
	Thu, 13 Aug 2026 21:32:58 +0000
X-Migadu-Flow: FLOW_OUT
Date: Thu, 13 Aug 2026 23:32:56 +0200
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Mike Snitzer <snitzer@redhat.com>, dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dm-crypt: Reject malformed raw keys in crypt_set_key()
Message-ID: <an44CG_PDBM4KCCv@linux.dev>
References: <20260813081335.40282-3-thorsten.blum@linux.dev>
 <CAHp75VeXb5DhdpMo3x2dwGETC6s3hmwG1s3eZktyOd7czZOGxw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHp75VeXb5DhdpMo3x2dwGETC6s3hmwG1s3eZktyOd7czZOGxw@mail.gmail.com>

On Thu, Aug 13, 2026 at 11:39:27PM +0300, Andy Shevchenko wrote:
> On Thu, Aug 13, 2026 at 11:15 AM Thorsten Blum <thorsten.blum@linux.dev> wrote:
> >
> > dm-crypt calculates the raw key size by dividing the hex string length
> > by two. If the string has an odd number of characters, the key size is
> > rounded down and hex2bin() only decodes complete byte pairs.
> >
> > For example, a 33-character raw key string is malformed, but dm-crypt
> > treats it as a 16-byte key and ignores the last character.
> >
> > Reject raw key strings whose length does not match the expected number
> > of hex characters. This restores the trailing character check that was
> > lost when the open-coded decoder was replaced with hex2bin().
> 
> Thanks for the report and the fix.
> 
> ...
> 
> > +       if (cc->key_size && key_string_len != cc->key_size * 2)
> > +               goto out;
> 
> Okay, the original code did two things (differently to the
> implementation with hex2bin() call):
> - if key length is odd and the last character is not NUL, it failed with -EINVAL
> - if the key length is even and the last characters are \n\0, the
> string was parsed normally with the exception that the H\n part
> becomes 0x0H instead of 0xH0 if follow the order
> 
> I dunno if the second was ever supported and not theoretical (so a
> user can forge that one), but this change is only about the first. So
> if we don't care about the second part, the expectation is that the
> key always ends up with the NUL having an odd number of hex digits in
> it. So, why not simply restore that NUL-check?

The result would be the same, but I prefer the length check because it
validates before calling hex2bin() and rejects before modifying cc->key.

> >         /* Decode key from its hex representation. */
> >         if (cc->key_size && hex2bin(cc->key, key, cc->key_size) < 0)
> >                 goto out;

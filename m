Received: from mail-43102.protonmail.ch (mail-43102.protonmail.ch [185.70.43.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5180375F83
	for <dm-devel@lists.linux.dev>; Sat,  8 Aug 2026 09:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786179605; cv=none; b=sISwAqm6klvg6aRL2bsFzuuR9eh4mJRpeQ6HK9TF83qtQtMp+XdcxkK941rFkYybkkolTbTxpRJEz9F5/hK6ms3g1nLvPjflv5BgLDfbzdRvTnbJneOt//WgnNaAB6PCfeunU6D2UgnyYgB+p/uokAPt+7m0+9+ArXwzKee3bws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786179605; c=relaxed/simple;
	bh=CrWlVEh1erCHLiMxINfITxhptAPtAUQWAatZjXNCtGI=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VmyBsbQGTWPBtYdTvvF3k6IQCAKlnrsRuGvMVDSWpD4Id+6Ims4KJwmaq/ypKCEbJF7sGBGDLcjqyMRSknShkWa5WKTFsKsGHw6XO9AS7CmW8CDC2fibT6L7v2aUWqLY/hyyV0x5WFWWPPL7uQmJK/Y5e/IjlcFgPvlhOgIUVk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=BPgT+sbj; arc=none smtp.client-ip=185.70.43.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="BPgT+sbj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1786179598; x=1786438798;
	bh=1Ey2KzBzHR8n5HtTCOnSAmLs875kebCDqDtfGzXyoWA=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=BPgT+sbjtgGVkNJgAKePwVKyv6KWQ+MoxakBnIROY8skxIBf/N83y6z4MmMPeo80p
	 6cYQRHhLFjQzxczSrO81sQGwja5E7iKOeYzLYqU0eJSvi8oh7KuC7DLfEbopWddEWp
	 iWERF/FDhGoXBNBfSWJHs4+fgxoFwJFATCPZB1as6fWH5wrQDPtX+vLaCTHLrlAvMm
	 UfWVYPHcZB53ZSXavM8wyt6KfXmX7mQA+//fxkcFnVgb9VhUubfmGZ7Tp6CXGZrDU/
	 kRNCTWypphwbyzBKkN8N5R8TNI6XimvhPzo6FrJGc5bu+6+5iDD3WsH6DtslCCyj+W
	 IjpNu76WRcLYA==
Date: Sat, 08 Aug 2026 08:59:53 +0000
To: Ming-Hung Tsai <mtsai@redhat.com>
From: Bryam Vargas <hexlabsecurity@proton.me>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@kernel.org>, Benjamin Marzinski <bmarzins@redhat.com>, Alasdair Kergon <agk@redhat.com>, Joe Thornber <ejt@redhat.com>, dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] dm array: reject an array block whose value size is not the caller's
Message-ID: <20260808085950.422128-1-hexlabsecurity@proton.me>
In-Reply-To: <CALjSBEvYWGOryNrLiCM3SNivnzv_LXSFfcXonFfqrBQFQyyU=w@mail.gmail.com>
References: <20260731-b4-disp-4fd3bed9-v2-0-7b1835e4e7f6@proton.me> <20260731-b4-disp-4fd3bed9-v2-2-7b1835e4e7f6@proton.me> <CALjSBEvYWGOryNrLiCM3SNivnzv_LXSFfcXonFfqrBQFQyyU=w@mail.gmail.com>
Feedback-ID: 199661219:user:proton
X-Pm-Message-ID: ff66a2e16a75ce89eb7b8b190b26f3365aef716c
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 03, 2026 at 10:24:10PM +0800, Ming-Hung Tsai wrote:
> The fix addresses more than crafted metadata. A lost write on disk
> drives can cause a stale block that was freed as a hint block,
> triggering this out-of-bounds access issue.

You're right, and the commit message claims the opposite. Its last
sentence should read:

  Arrays only ever read their own blocks, so a mismatch means the block is
  not one this array wrote: a crafted image, or a lost write leaving a
  stale block that was freed as a hint block.

Mikulas, that is a message-only change -- fold it in when applying if you
agree.

Bryam


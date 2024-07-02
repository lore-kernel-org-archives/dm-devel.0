Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A732514C596
	for <dm-devel@lists.linux.dev>; Tue,  2 Jul 2024 07:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719905664; cv=none; b=ViDEtSeGp6sgP4SZyr3cw7iRgxTSYbVTwLbFMAoEIhCfh8m/2ChHPo7kJ+uhHdgSyyeFoHB6br72T1Puc8Ls5iuU5Uzm/QZ+HoVmcY8EXPLMMsW5omWJG4evVgmj5qnNaRrY4clCO9/RQPif50SMShoTGuZEMYMr4z4M6sNLsnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719905664; c=relaxed/simple;
	bh=RS3h3VqQqkgnQFg/OafJEkTRoPVQXruG+pD4C/rKCis=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TaGj/UWQsO1dsNVaPYqAbB2Enb3oghDl3P/7JD1OVg0LjC4BPdSOQHV7eqEzGfN7pxvkHXEk7SeqjZUM43JYV2Izv30JXuXpHmiMvjynnrtrHlDTZIzKS0+Tnl7cnW2QOXQdsi3L76XiK3bN5CMmgiz1Ql03EgnV1JUkxxCQWb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=JU3fE1rQ; arc=none smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="JU3fE1rQ"
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-2ee75ffce77so5117131fa.3
        for <dm-devel@lists.linux.dev>; Tue, 02 Jul 2024 00:34:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1719905660; x=1720510460; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=GPrvOc/ZHZABwv4V4LyekC/IhxN+k3zpWPSMoCN/d3Q=;
        b=JU3fE1rQywXw7BHX4lgURVgcOZ20mw9AiWL1N/3wFtDBbuhs0SNRAtEFsXZ5/k/WuZ
         oh9TSDZZa0ZICfbfm2Y4WkXME1EMkDB8kLf99IQ58XRSM9EO5R7dKXNPiwQ3zdgf1v2j
         ChA9c55hqPj04EsR9+EiyJgLmIs52cMn0RiG/pJaM8vlnH9IHumU2eOL4N4nDiKfv6Yy
         NjTW9MYRYSMPjlh8G4lgNrabQkbjYFXZzpbpkspkxp/VORmS9X3BxByawZMdSBU6VJy7
         defjUTrOk07v2+BoXJmQEyxaK5q+FtlJYlOioH7X3Zmy8gymW+B2lVTHaQaDfxiCU+Ud
         COTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719905660; x=1720510460;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GPrvOc/ZHZABwv4V4LyekC/IhxN+k3zpWPSMoCN/d3Q=;
        b=rL6zMQSsa2tpCqxSIAVteXvcTis76Wzo0cL2pm0q70kAn73IP9jLtosoHGK+6tB+7k
         vimzWozfvw8BjUFi7ZOslV8jimJciCTD5jptFHBqn8XvruZ0iejpAKZPNT3mNzHnmO6F
         Bp4+r0xqkRH22xI7EcZuMKob55LpoiftTMe8Bvqgcc0d7Rx4Hmzk7WCtMLNY3E8oz/Ae
         9Txda2rniL1UYNn4SElCrhIPulo972o7HOr5PV/8niPvG0yoXiuXlerQqU1vVTHYl7yL
         4SQ70hUp5WNdwFtyxvZd232TxD64J/UwoyaEvha+WVlmIYfh3xVjHcA7B6sGSjGx0ECL
         ADJw==
X-Forwarded-Encrypted: i=1; AJvYcCUiUgExoJrM3OlViEDZCDwtxOmcLDW5Jjke9aBq/4mzrol1mGVKk+xGHBiAksDOjYa2fw+851EKCEPtsdEterH5EvYRQI/qbMY=
X-Gm-Message-State: AOJu0YxrRmYZzSzFs5+zfLUStbhFdv8rWXIwJcE6jxdpO5PcoOmND2o5
	7FG3PHiyLQXaH28IzwInmSXhbL7ArKyR2gfsGozB8+/FMu1EumzZxCbl7GAdShmlvGZ0reW3kbK
	a
X-Google-Smtp-Source: AGHT+IFAPgWmtbeM7LOPuqgzDnhV04Dv+k9nuil20WNxgeajkK7bAwbP5/8LnuJ6gAbcSeWgd24NYQ==
X-Received: by 2002:a2e:ab0b:0:b0:2ec:5945:62e9 with SMTP id 38308e7fff4ca-2ee5e6f60ccmr78328601fa.32.1719905659479;
        Tue, 02 Jul 2024 00:34:19 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:d7e5:6139:e909:29dd? (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a72b0091016sm372951266b.150.2024.07.02.00.34.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jul 2024 00:34:19 -0700 (PDT)
Message-ID: <d9c5652f9f0a17db466354d4b5d10ca04a959215.camel@suse.com>
Subject: Re: [PATCH 3/7] multipathd: refresh multipath before calling
 set_no_path_retry()
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, device-mapper
 development <dm-devel@lists.linux.dev>
Date: Tue, 02 Jul 2024 09:34:17 +0200
In-Reply-To: <ZoL4TX2evkCyK4pT@redhat.com>
References: <20240605232254.623290-1-bmarzins@redhat.com>
	 <20240605232254.623290-4-bmarzins@redhat.com>
	 <7551690cc28e39dc733c57ae1a9e657c469aafb3.camel@suse.com>
	 <Zn2wW55XxNn4ju2e@redhat.com> <Zn2xzs0uxpWmIMyh@redhat.com>
	 <cd066f0b8d24626b0370e4a97dbf1471351dbab9.camel@suse.com>
	 <ZoL4TX2evkCyK4pT@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Mon, 2024-07-01 at 14:41 -0400, Benjamin Marzinski wrote:
>=20
>=20
>=20
> My purpose in writing 0f850db wasn't to cut down on ioctls. It was to
> keep set_no_path_retry() from incorrectly handling queueing in cases
> where no_path_retry was set to a number, and the device had no usable
> paths.=C2=A0 My purpose in this patch is also to make sure
> set_no_path_retry() does the right thing. Obviously, this one is more
> of
> a corner case, and if instead we were occasionally resyncing with the
> kernel even when a multipath device had no paths, that would solve
> this
> issue, and I'd be fine with dropping this patch.

That sounds good.

> So unless it conflicts with work you're already doing, I'll send a
> new
> patchset that changes checkerloop() to pull the multipath device
> updating work out of check_path(). I'm not sure that it makes a lot
> of
> sense to change how we loop through the paths, since check_path()
> does
> work on some paths that aren't assigned to a multipath device.=C2=A0
> Plus
> different paths in a multipath device will need checking at different
> times depending on their states anyway, so you can't just go through
> all
> the paths at once.

While I agree that syncing the map state just once per checkerloop and
map is the right thing, I believe we should do it as soon as we have
checked all paths that need to be checked for the given map. And that's
most easily done by looping over the mpath vector, like this:

for each mpp
    for each path in mpp
        if path needs to be checked:
            check path
    sync mpp

for each path
    if (!pp->mpp and path needs to be checked)
          check path

Of course we could do this in multiple steps and move the mpp sync out
of the path loop first, like you suggested. But if we do this, there
may be a considerable time delay between checking the paths of a given
map and syncing the related mpp state, especially on systems with a
large number of devices, and that might be problematic.

Path status changes are asynchronous by nature, and thus whatever we do
will not be perfect. IMO it makes sense to do all checks related to a
given map in as short a time interval as possible. This way we are most
likely to get a consistent picture of the current state of the map in
question in the kernel.

In the long run, I think what we should do is use asynchronous checkers
exclusively. And instead of waiting a millisecond for them to complete
synchronously, we should trigger the path check on all paths (that need
to be checked) in one go, then wait for all checkers to complete (this
is the difficult part, I know), and then go over all the results, again
without waiting for anything.

Another project I've been wanting to do for a long time :-/

Regards
Martin



Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFBE684A27
	for <dm-devel@lists.linux.dev>; Wed,  4 Sep 2024 19:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725478605; cv=none; b=nJ5Zb9nv6mS4NyTyT1fiy1IDJ2DNWAMNF+U3iYF17l/j+KbM4HTmp2pqSfETE43W2W5XbTZuWH1mvBji9D8kcyk5lJNadB5hBAEh9Te5hlVvFg8uIWJ0tkA4rqpTOzUQCMiilzMyoz4GCZngf9VMRzlLooLrnLDpB+eRvXEXRtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725478605; c=relaxed/simple;
	bh=8LpG2uyVNT88QlP5HzDVO5sKEHY5K5jYrraJooBxFME=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kPoHKIShAAM7F6ehrartd40BV9quHlbqyNkoFNuuiHIxxSrnFgD1q9HRCZsV/S+c5mlepsP5kkO0EkhkgYDlTGu/6jINv8DobiDX9j8oY88KNsKcTUunf/YA8IjOPTUHo9Hq3driT/yRIr/IvK/ilqykkMWYK4HHMIlHzOAD/WE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=eVjqurXX; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="eVjqurXX"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a8a1acb51a7so2041066b.2
        for <dm-devel@lists.linux.dev>; Wed, 04 Sep 2024 12:36:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1725478601; x=1726083401; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=8LpG2uyVNT88QlP5HzDVO5sKEHY5K5jYrraJooBxFME=;
        b=eVjqurXX7PF49LzmZdR1y1qr4YbUngSV1WNAPEDBZ+NB0exR+6WmdRHBhlO19uFsUd
         dV39E0PeXOQuDCh6LsQcC3sUzE9X0sb/oTMOIh0h4GSe/Es8J4XUyhSWIeWO8B2q6G/p
         9E7f4sDgO7lVdyzXdHwLbI68YJcvpK8awMZ0g4YHupDgmauXNAIWDpEjlFTFTBU4q5wF
         EuRWKt59I28Icom/sQfhpnUidRQOT7jMrIuemHQiS9+I6MPLvRZQ0/RRjRso5z0aEd9d
         M8rhk2QWGqlXt/w1wI73AVggWJSUthV/PGE61UO6fC9PMfAvHX4g1a7jLyQf99kt8LMJ
         J40A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725478601; x=1726083401;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8LpG2uyVNT88QlP5HzDVO5sKEHY5K5jYrraJooBxFME=;
        b=G1sSvGtzFdb+qrkWByxpzJw5R7GSNoULwZZ5DUWrhJ+UFldNJu+uDBFdbraXnd2k7o
         FkODB6eruRpFPMj/v2i1kTIn4MR7U9GRjqbHYsO4aRpT5ad6y2YSkUcTccFa3iChEYTY
         1B8obyw22GhBzBRDygNnTGepimcBOuxlv5Nifxp8OhxZtFsOCCxkjVE597DOwF8SRmwz
         OPpJmZxECc7y8Wd2Wyi6494JGXfVLE6RWQE0HdECAJU2f4jQ35kUarw9yMDO+repqD6S
         Xs0uMbIESCE1uDItn2rUEx8iw9CPDZZIV4TSBbJE2Tk20Wcynou2ptpWbZhAOc2hWuyZ
         wMfg==
X-Forwarded-Encrypted: i=1; AJvYcCWnU5O4Qie3LRaN6ajPwCaI9AUG249IIXJvz4UdrSJewZWYnDGAGtaj21r+H3t7LHj+YDhzn+yRXw==@lists.linux.dev
X-Gm-Message-State: AOJu0YwzjKrydku2yAuy5/9qpr367UG07YozNz99TBUTl97Stm7XwP7N
	1SMOgaeK3OWT3ODGGkbX7mt7aHMLdk3CmkPyscXgRMVIzvJ186DndFuXsRMVhKF7j0qPaePn4gw
	5
X-Google-Smtp-Source: AGHT+IH5yz/ZZhjBG+Ugxcr1WhFCCXil+ec30vU0Ew9NoNNJfB2edFsJHHw3/ZbP+FaYg6MN1XykXA==
X-Received: by 2002:a17:907:97d3:b0:a7a:97ca:3056 with SMTP id a640c23a62f3a-a8a1d2c7373mr735580266b.16.1725478600732;
        Wed, 04 Sep 2024 12:36:40 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:d7e5:6139:e909:29dd? (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8a61fba4bfsm29346866b.21.2024.09.04.12.36.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2024 12:36:40 -0700 (PDT)
Message-ID: <d0f8e48a5ac7e42d1643c07dd6b08a601aef8f07.camel@suse.com>
Subject: Re: [PATCH 05/15] multipath-tools tests: fix up directio tests
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, device-mapper
 development <dm-devel@lists.linux.dev>
Date: Wed, 04 Sep 2024 21:36:39 +0200
In-Reply-To: <ZtinIZY2jMe0ZDNX@redhat.com>
References: <20240828221757.4060548-1-bmarzins@redhat.com>
	 <20240828221757.4060548-6-bmarzins@redhat.com>
	 <534d539850c59ac55911bdd584737934cb24d060.camel@suse.com>
	 <ZtinIZY2jMe0ZDNX@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Wed, 2024-09-04 at 14:29 -0400, Benjamin Marzinski wrote:
> On Wed, Sep 04, 2024 at 06:12:37PM +0200, Martin Wilck wrote:
> > On Wed, 2024-08-28 at 18:17 -0400, Benjamin Marzinski wrote:
> > > Make the directio tests work with libcheck_pending() being
> > > separate
> > > from
> > > libcheck_check
> > >=20
> > > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> >=20
> > There's still something wrong with this test. I'm seeing lots of CI
> > errors with your complete series applied.
> >=20
> > https://github.com/openSUSE/multipath-tools/actions?query=3Dbranch%3Ati=
p
> > https://github.com/openSUSE/multipath-tools/actions/runs/10704501258/jo=
b/29677643779
>=20
> It looks like your "tip" brach is missing:
> [PATCH 04/15] libmultipath: remove pending wait code from
> libcheck_check calls

Yeah. That patch ended up in a different mail folder, and I didn't
notice. Weird. CI looks much better now.

Martin




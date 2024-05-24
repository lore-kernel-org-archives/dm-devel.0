Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ECED86262
	for <dm-devel@lists.linux.dev>; Fri, 24 May 2024 14:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716560967; cv=none; b=mDV9pFBHgXUtSiwhyxsHAdbQrfvsWADgUlaqnwU9imX6GJ/sN00j3BLPg65ON/oHjDpx6GYE+71jFCkIx/CR2jUMBo1d3HresJVPnLhy0Rf7m0A3CgW7Mx0MzCi0kiMENDDT8VST18JLiNwMRW+Mk2o8fB1coNyBwDyceYLhv9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716560967; c=relaxed/simple;
	bh=uWZDlxsnobClz/2+e24udBXG3NGKh5Q0SFbK2Jh0v1w=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=AmbwWyyzPCRF5Ng0BbFepNb/P2TWo7RbI6KDm3H/oYQvR6/vAD45RNUMBI8aRBdAdA6mUl3+N2tUg1dAtmzIqCcHPLk5wKmrvEoSDccjS04ItdqJeXHh6APpbAnp3fjzZ+wxCkz7QFZievP9S9pMQKZ/Hy5u2qQgl+0yQX4OIqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=QB350cHi; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="QB350cHi"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5785eab8d5dso751402a12.3
        for <dm-devel@lists.linux.dev>; Fri, 24 May 2024 07:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1716560963; x=1717165763; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=uWZDlxsnobClz/2+e24udBXG3NGKh5Q0SFbK2Jh0v1w=;
        b=QB350cHiGWCQcCNVqWKZEUTsJkmxi3R1G55MPVG9E1y/VPtDD2klMf0YHGi+PNXfqZ
         t8Dja2W7TtBwerBMb7QCkkCP6T87LMqreOX93HcpepOTBGryyZBYp/Y0YqP6XIhpAAVz
         B8q1z5cc83H9w64RNnfnZXm4F/myieUheomwy/LBL8wEO0+0nfOaTZH1yS0eUEDIcpFJ
         NmPLMMSzZFhcm9skhl8KSnrUwp8evTo9TURKTZFM2yCiJld9fyu4Ig9JXqm1mJk/Y1UL
         9LHUeR8WimXFI5T0TLUINMvkJOlUJm8JU02cKjEsBpY4QU1jXwN5MOVck8CJ6fEswicQ
         jFyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716560963; x=1717165763;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uWZDlxsnobClz/2+e24udBXG3NGKh5Q0SFbK2Jh0v1w=;
        b=EuOM0LqW89q5FJ1yv0znK7pRF6A/WZVjYYcHfPBbYVr/HWOQNEQuHT6rzjvnK7h0i/
         QuPjKms5+FfHM7xB+VJIgzSxx2+a0h4TX/ftkIJqrCBdfuYQHVGE/T+6X4B61WqRIEbd
         9T7S+ni/F88+jNvCifYWfrlUOxjgLohEKDOB9J25Xz4MAVZ4/UhqY4OJowkZ3YuTcn3U
         1aMcXQ38pFO7eut80FFdepM3qsb+KW5P8xEirf2lU5MWsQaOxeD3Q3EVjS1B9qwb19In
         3oixEi7fuyVa9LHym3nSi+tPQd3fB+gnuK36nHrb3UHeJgOMxoYXFYQiSZycP/0SMIgw
         6taQ==
X-Gm-Message-State: AOJu0YwKbynPHtI0SJx/yDhXm2v0pyOAcAq8jaG08L4CtVWzSVlHyxtd
	7g1NTCfvrO5OTD+ggoYJq7eAH4apfYYbgDkqf1Nsw/JBu2P9Bn7x4ARM3ni0ThY=
X-Google-Smtp-Source: AGHT+IHq8gG5qYZP8PEpp5mz+de32vcOvx7/J1121FBdOseCRbSaA1GDH7+8yJBsee/BbAJcp0dksA==
X-Received: by 2002:a17:907:3a14:b0:a5d:cff:25bd with SMTP id a640c23a62f3a-a62641b2e3cmr139767266b.4.1716560963354;
        Fri, 24 May 2024 07:29:23 -0700 (PDT)
Received: from ?IPv6:2003:de:371a:a400:e6fd:936f:426b:4ff8? (p200300de371aa400e6fd936f426b4ff8.dip0.t-ipconnect.de. [2003:de:371a:a400:e6fd:936f:426b:4ff8])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a626c9377e5sm139532866b.77.2024.05.24.07.29.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 May 2024 07:29:23 -0700 (PDT)
Message-ID: <ace7bf8989a401993ae517e9cb1ad0c100731652.camel@suse.com>
Subject: Re: [PATCH 7/7] multipath-tools man pages: Add format wildcard
 descriptions
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>, Nitin Yewale
	 <nyewale@redhat.com>
Date: Fri, 24 May 2024 16:29:22 +0200
In-Reply-To: <ZkJlywJBcXQku0a8@redhat.com>
References: <20240513173646.94424-1-bmarzins@redhat.com>
	 <20240513173646.94424-8-bmarzins@redhat.com> <ZkJlywJBcXQku0a8@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Mon, 2024-05-13 at 15:11 -0400, Benjamin Marzinski wrote:
> On Mon, May 13, 2024 at 01:36:46PM -0400, Benjamin Marzinski wrote:
> > Suggested-by: Nitin Yewale <nyewale@redhat.com>
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
>=20
> Oops. I forgot to update the man page date. Martin, either I can send
> a
> new patch or you can feel free to update the date when you apply this
> one, whichever you'd prefer.

No problem, I can do this.
Would you like to have this included in the 0.9.9 release?
As all these changes are small and non-controversial, I tend to include
them, unless Christophe merges 0.9.9 very quickly.

Martin


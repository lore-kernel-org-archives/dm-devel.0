Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C60D02571A1
	for <dm-devel@lists.linux.dev>; Wed, 10 Sep 2025 17:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757526336; cv=none; b=aYuJGn4JdjO9V0Ztpj35BIxlvAczdDmRU2RNHscNdXV1b6NIXnPL6ogU0CW/If3EHieWLW29q/wpwTBLmOIYSevoPrGlXUAulz5Ge8vWVFNws4bJwP9T+NBjW6N/vaUhppWfInrl9MoGwOnVwNWbWC4mdflfu3vOfUt1bgl7eC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757526336; c=relaxed/simple;
	bh=dNOWI7gSBAR/8CDRKSX9BtwfzV+PfFdf0Quy3tkARWQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=TOM1pD3ytwPKWa49/iajDtHx3+d9BSXJlTWqZDBMTF0MCXVK4z1aqFs5yzsRphI4radRTSf8mN8DXRI7rjuWJ4V0fsj+XOORCxnDpUc1wHAvSGaQMMmuSZOLv2St8D0rvE7q3D6ubiWb9C1yM1oFG00nwX2IdG4Tma8LPu8VP3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jTwJ2DOz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jTwJ2DOz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757526333;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WlcFe5oCmvjN1h1Es6PI20V1rT7RlTmmj6wUjzqcp7M=;
	b=jTwJ2DOzYqOwz4IhU3sO8Z/4mmb6el50DzR8ptdhSG5Z33V/33rNOs/7Vh6wfCLKoWg3Az
	3TuXvKB3mZV/Usn5y+dLViHnyr92z9nZ+GksaRUBIwLDPOJXPe7k20mcyeoIgD77h977mQ
	1VrNI3ffXJnJRK6izGCZdspv5QC8/oo=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-526-7e9VmO5WM_6ea1MDyOVAqA-1; Wed, 10 Sep 2025 13:45:32 -0400
X-MC-Unique: 7e9VmO5WM_6ea1MDyOVAqA-1
X-Mimecast-MFC-AGG-ID: 7e9VmO5WM_6ea1MDyOVAqA_1757526331
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45a15f10f31so5887445e9.0
        for <dm-devel@lists.linux.dev>; Wed, 10 Sep 2025 10:45:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757526331; x=1758131131;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WlcFe5oCmvjN1h1Es6PI20V1rT7RlTmmj6wUjzqcp7M=;
        b=MlPvNw8q5eO4NvtcEUpXWsCcLAcz9p62h5r4gXMBhZOYvg16S4p/iDKATH2HagWzoH
         NuSDlv0hKdSOUUy262YWHZksKQ4P9GzggJtQUoY0x+KOqT/5QmtzcqYYaqFv29uVyz/J
         ulX2yZVt1k0cQnAoZzRqIc1sN5iE4rYDZP94Mc0/1AvELcpu+PZ/u7UTOgJrJEHPwMZa
         blop6c6j7wwnWTmuxmd42FDGdjZ71Tr9FxKI6JsTj2PjGeg/kRnzVUdDyFWMMkufiCKW
         K5XlRMXrC3feTcpy9cVQX33++u8vo0qMU291z7aOLQ5Wc1wZaRUzMX6nyHh9d/UNZ+k6
         4N9A==
X-Forwarded-Encrypted: i=1; AJvYcCWV+EJaglSH0y90YK1ARU0+XVItbC8J+e+p5POu8hG43u+J2UhxDuTTamYFeHuS2AFIyLafdzkQ9g==@lists.linux.dev
X-Gm-Message-State: AOJu0YxktdRshGPQU4j1n1bOMw6DkeRDX+dcBfKhv79hZsKFTErNydj8
	ubWmz0yGlv2nSPMAS5FrDMUUCcH62/AMi1mglu4FYxPyZKwPS9BLB7bIEHLyimaKiApY2h/Tb5m
	j3n9tUCZD1ySkkoGwLAWAMq04UZRSJ67HrZagpUUNgVG5QTsQ+d2NMLVc+umcMmMVjq3rZfA=
X-Gm-Gg: ASbGncvUB5KBNoeSpLoFFpyX6GGWmsOLm68124dBGfj5eiK7OMZME1JJVa5lOT9Xyvq
	ATGrt1HMweA8fCFyrkyNkOFt/PIouSJKlhKwAMCvOJo6p6B2EFxRMrQ/a/hiyWaXG0PJift67jH
	bWo/jwJjvLVpNkqjzfElZM58lIZuGophWiQLMwm3MWxEAuWVrcIZvbR2qIvLUpMVNgeW/WCikvm
	atiigTd2PcV0VrCoi3kU6pkIj+31xH6XjdczjKqJgTmGQBzRE+EcyU5HmFYAhNtuCfnsF9g5MTp
	vC8b3BVgTY44P4Ze9lpz+TyD7BSAO4Js2bKYN8MnpaTE5683P5asDzyGhw==
X-Received: by 2002:a05:600c:c098:b0:45c:b501:795c with SMTP id 5b1f17b1804b1-45dfd5e3da8mr3261825e9.10.1757526330522;
        Wed, 10 Sep 2025 10:45:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFMyl7SOy3kBxxrDvaG0ZHwpCo+23n3nT2GR9WmBKsR0hHAuXPPpMwuMAjIh8YD03Q6O8LuqA==
X-Received: by 2002:a05:600c:c098:b0:45c:b501:795c with SMTP id 5b1f17b1804b1-45dfd5e3da8mr3261595e9.10.1757526329906;
        Wed, 10 Sep 2025 10:45:29 -0700 (PDT)
Received: from redhat.com (128.19.187.81.in-addr.arpa. [81.187.19.128])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45df81d20d2sm35623175e9.8.2025.09.10.10.45.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Sep 2025 10:45:29 -0700 (PDT)
Date: Wed, 10 Sep 2025 18:45:27 +0100
From: "Bryn M. Reeves" <bmr@redhat.com>
To: Robert Beckett <bob.beckett@collabora.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel <dm-devel@lists.linux.dev>,
	linux-block <linux-block@vger.kernel.org>,
	kernel <kernel@collabora.com>
Subject: Re: deadlock when swapping to encrypted swapfile
Message-ID: <aMG5N4nG58GHrE7K@redhat.com>
References: <1992a9545eb.1ec14bf0659281.6434647558731823661@collabora.com>
 <2d517844-b7bf-3930-e811-e073ec347d4a@redhat.com>
 <1992f628105.2bf0303b1373545.4844645742991812595@collabora.com>
 <a7872ca2-be14-0720-190c-c03d4ddf7a5d@redhat.com>
 <199343ab2a7.11b1e13e161813.4990067961195858029@collabora.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <199343ab2a7.11b1e13e161813.4990067961195858029@collabora.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: X5SWJoMgcVb7dwLVjGRbGl80x0bt8fesZq6vh8sG_6E_1757526331
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 10, 2025 at 04:24:46PM +0100, Robert Beckett wrote:
> I see that dm-loop is very old at this point. Do you know the rationale for rejection?
> was there any hope to get it included with more work?
> If the main objection was regarding file spans that they can't gurantee persist, maybe a new fallocate based
> contrace with the filesystems could aleviate the worries? 

Right: I first wrote it back in 2006. When it fimally made it onto a
mailing list in 2008 the concerns were basically threefold: "why is DM
reinventing everything?", the borrowing of the S_SWAPFILE flag to keep
the file mapping stable while dm-loop goes behind the filesystem's
back, and the greedy population of the extent table (lazily filling the
extent table reduces start up time and the amount of pinned memory, but
has the drawback that the target needs to allocate memory for unmapped
extents while it is running, reintroducing the possibility of deadlock
in low memory situations).

Most of the interesting discussions happened in this thread after Jens
posted an RFC patch taking a similar approach for /dev/loop:

  https://lkml.iu.edu/hypermail/linux/kernel/0801.1/0716.html

This used a prio tree instead of a simple table and binary search.

There have been various different approaches proposed down the years but
none have made it to mainline to date. I wrote one in 2011 that
refactored drivers/block/loop.c so that it could be reused by
device-mapper: that seemed like it might be more acceptable upstream but
we didn't pursue it at the time (it also removes the main benefit for
your case, since it uses the regular loop.c machinery for IO).

The version Mikulas posted is most closely related to a version I was
working on in 2008-9:

  https://www.sourceware.org/pub/dm/patches/2.6-unstable/editing/patches-2.6.31/dm-loop.patch

Which is the one discussed in the thread above - I think roughly the
same objections exist today.

(historical note - dmsetup still has code to generate dm-loop tables if
symlinked to the name 'dmlosetup' or 'losetup':

  # dmlosetup 
  dmlosetup: Please specify loop_device.
  Usage:
  
  dmlosetup [-d|-a] [-e encryption] [-o offset] [-f|loop_device] [file]
  
  Couldn't process command line)

Regards,
Bryn.


Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2F95267388
	for <dm-devel@lists.linux.dev>; Fri, 14 Feb 2025 15:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739548398; cv=none; b=rm2GmKnusMPB9SBmSdPDnJVMzcUgH+goNIXxoti3rLa1bNW9G25AEFPMiRZjSNeSqO32HvUJDz8ZEwLOOmgC5DS6Mea4L/VdNCHOAUoB4P+ZiQ131Jt06s/XCxVuM/+Ip96FORxCAzThCdbvh6IbDeVx9lvhgv4xfaBS2/KKKU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739548398; c=relaxed/simple;
	bh=ZT3ZnSg9B8hQGxja8MC4MAuFXjr5x5tDp/Uo5Xh3RNg=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=nUg6RPLNG5B+Am8RR7Xn08FDXeeX9a+aTtmERmTmHrk33rigq7mMal9gkvvrmfISHFRwAtc9tTbJogr9dnPTJBFIB5FpaNKgA45bAfNWSz4vV/7oNyvt9OFHH2ixlSeTREIcLj1uyzUAEvxqX9mDV+366n4eSyUfCLteWLUZzXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b4yzqdWL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b4yzqdWL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739548395;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=poV8s1UHJxNPuvAz6xPWNuQUatzMkvCzEr/rsSzmoE0=;
	b=b4yzqdWL7hyv/s2wgT57kk/hjIKlhmavEUDKfyTKU8i7HX0ZZZpf4+GKUN7l3KJHWLIijp
	WeT3nOgDELuhVL8P/Ecgr5ZRB2qGnraXbDKtwAASD6KlOxbzihpw/PuCjgPHuEG6G0sqOP
	u6qpOOX3UePuDzKS5w/GZ7OsYahl7VM=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-422-kQlIaNfFNHqbJlImLvt4BQ-1; Fri,
 14 Feb 2025 10:53:12 -0500
X-MC-Unique: kQlIaNfFNHqbJlImLvt4BQ-1
X-Mimecast-MFC-AGG-ID: kQlIaNfFNHqbJlImLvt4BQ_1739548391
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EFE6A19373D9;
	Fri, 14 Feb 2025 15:53:10 +0000 (UTC)
Received: from [10.45.225.131] (unknown [10.45.225.131])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1F5AB1955F0F;
	Fri, 14 Feb 2025 15:53:07 +0000 (UTC)
Date: Fri, 14 Feb 2025 16:53:03 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Marco Felsch <m.felsch@pengutronix.de>
cc: gmazyland@gmail.com, okozina@redhat.com, ebiggers@google.com, hare@suse.de, 
    agk@redhat.com, snitzer@kernel.org, dm-devel@lists.linux.dev, 
    Lucas Stach <lst@pengutronix.de>
Subject: Re: DM-Integrity journal replay behaviour
In-Reply-To: <20250211121138.kokiyvgh6ba3yujl@pengutronix.de>
Message-ID: <175fa15e-8bb9-d03b-9128-2b9eec61a32d@redhat.com>
References: <20250211121138.kokiyvgh6ba3yujl@pengutronix.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 1NMrsFwhYTHgzdclnuXtJtINUsI31S-20_PtWp08Ri0_1739548391
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Hi


On Tue, 11 Feb 2025, Marco Felsch wrote:

> Hi all,
> 
> as written in the subject we do see an odd dm-integrity behaviour during
> the journal replay step.
> 
> First things first, a short introduction to our setup:
>  - Linux v6.8
>  - We do have a dm-integrity+dm-crypt setup to provide an authenticated
>    encrypted ext4-based rw data partition.
>  - The setup is done with a custom script [1] since we are making use of
>    the kernel trusted-keys infrastructure which isn't supported by LUKS2
>    at the moment.
>  - The device has no power failsafe e.g. hard power-cuts can appear.
>    Therefore we use the dm-integrity J(ournal) mode.
>  - The storage backend is an eMMC with 512Byte block size.

Could you retest it with an eMMC or SDCARD from a different vendor, just 
to test if it is hardware issue?

>  - We use the dm-integrity 4K block size option to reduce the
>    tag/metadata overhead.
> 
> From time to time we do see "AEAD ERROR"s [2] while fsck tries to repair
> the filesystem which of course abort the fsck run.
> After a while within the rescue shell

So, when you run fsck again from the rescue shell (without deactivating 
and activating the device), the bug goes away? What is the time interval 
after which the bug goes away?

Could you upload somewhere the image of the eMMC storage when the bug 
happens and send me a link to it, so that I can look what kind of 
corruption is there?

> and a following reboot the fsck
> run on the same file system doesn't trigger any "AEAD ERROR".
> 
> The dm-integrity table is added twice [1] since we gather the
> provided_data_sectors information from the first call. I know that this
> isn't optimal. The provided_data_sectors should be stored and not
> gathered again but this shouldn't bother a system with a valid
> dm-integrity superblock already written.

That should work fine - there is no problem with activating the device 
twice.

> To debug the issue we uncommented the "#define DEBUG_PRINT" and noticed
> that the replay is happening twice [2] albeit this should be a
> synchronous operation and once the dm resume returned successfully the
> replay should be done.

The replay happens twice because you activate it twice - this should be 
harmless because each replay replays the same data - there is "replaying 
364 sections, starting at 143, commit seq 2" twice in the log.

> We also noticed that once we uncommented "#define DEBUG_PRINT" it was
> harder to trigger the issue.
> 
> We also checked the eMMC bus to see if the CMD23 is sent correctly (with
> the reliable write bit set) in case of a FUA request which is the case.
> So now with the above knowledge we suspect the replay path to be not
> synchronous, the dm resume is returning too early, while not all of the
> writes kicked off by copy_from_journal having reached the storage.

There is "struct journal_completion comp" in do_journal_write and 
"wait_for_completion_io(&comp.comp);" at the end of do_journal_write - 
that should wait until all I/O submitted by copy_from_journal finishes.

> Maybe you guys have some pointers we could follow or have an idea of
> what may go wrong here.
> 
> Regards,
>   Marco

I read through the dm-integrity source code and I didn't find anything.

There are two dm-crypt bugs that could cause your problems - see the 
upstream commits 8b8f8037765757861f899ed3a2bfb34525b5c065 and 
9fdbbdbbc92b1474a87b89f8b964892a63734492. Please, backport these commits 
to your kernel and re-run the tests.

Mikulas


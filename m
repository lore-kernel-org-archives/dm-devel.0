Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 306A73B2A0
	for <dm-devel@lists.linux.dev>; Thu, 27 Nov 2025 17:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764266058; cv=none; b=J8U9Q2ci3kMoCXGAPA42ZcsvwXSiG4C1MYUZzmX5syvg925jpTY43TQ9W4MxjemOyz2qHPYqmtAFW0h/Cs9iGMj2dxnovQ8DY5dbOOuPh00ccvSV8wkdGxGw1hJ1P/uY29TmRzNxo9+poJDkkS4c/CZhaoAlMRhCrEpQuH2aFzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764266058; c=relaxed/simple;
	bh=syq6ywFQZ85/owH8ti8iC3/uZDjEIyAbojJtHTMPJqQ=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=cSqnJ+jdphF3WApe1nfs0caOnxfyRCpBn+XXYHGxK8b3O97mNhqnreFGavXoxMGxUc9wg6pKoRNRBY92qDItFg2SGaljeN9iEZCG4HPVnZYkeIZxtJDnCS0YmFcLLRtzexr5q7N8xTdW42b25GVIxnuLcD64rvWFzUhU2C5XYQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aIRcwCSY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aIRcwCSY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764266056;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GSEfJvNBtdUsb/OhigVc7Yf2tt3tDvOOP3QtgGRe2CQ=;
	b=aIRcwCSYsYFo71GVrt5rXqm9L6xiw6oArzh2FSHJvANgI+Sbf44Ckk7fd5jDmFnnrMx7zM
	doDA/peO+CzjWEZx+NF68wqC5wTSMf/+0AAP2Si4loDK5C68db/7RxNEfNLHsEWq7+5xfo
	xffr7Pt4p38pw/wMP6Pp2yjI35omBcA=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-397-tuD2wo-DMeqk4iiF7eavWw-1; Thu,
 27 Nov 2025 12:54:14 -0500
X-MC-Unique: tuD2wo-DMeqk4iiF7eavWw-1
X-Mimecast-MFC-AGG-ID: tuD2wo-DMeqk4iiF7eavWw_1764266053
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AEBF81956088;
	Thu, 27 Nov 2025 17:54:12 +0000 (UTC)
Received: from [10.44.33.72] (unknown [10.44.33.72])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EB2C430001A4;
	Thu, 27 Nov 2025 17:54:09 +0000 (UTC)
Date: Thu, 27 Nov 2025 18:54:04 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Aaron Rainbolt <arraybolt3@gmail.com>, Milan Broz <gmazyland@gmail.com>
cc: linux-mm@kvack.org, cryptsetup@lists.linux.dev, 
    "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>, 
    linux-kernel@vger.kernel.org, adrelanos@whonix.org
Subject: Re: Hard system lock-ups when using encrypted swap and RAM is
 exhausted
In-Reply-To: <2b8b83fa-5cf5-4f97-b796-0c738ce3a548@gmail.com>
Message-ID: <3f3d871a-6a86-354f-f83d-a871793a4a47@redhat.com>
References: <20251111231835.1232ad8f@kf-m2g5> <2b8b83fa-5cf5-4f97-b796-0c738ce3a548@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4



On Thu, 27 Nov 2025, Milan Broz wrote:

> Hi,
> 
> On 11/12/25 6:18 AM, Aaron Rainbolt wrote:
> > Not sure if this is a memory management issue, a LUKS issue, or both,
> > so I wrote both mailing lists.
> 
> It is not a LUKS issue; cryptsetup/LUKS activates the encrypted device,
> so it is only the kernel/dm-crypt handling IOs.
> 
> Adding cc to dm-devel as this would be another combination device-mapper
> and encrypted swap that could cause issues...
> 
> However, could you please specify exactly your storage configuration?
> 
> From the subject, I expected you to have an encrypted swap, but it is
> not clear if there are other encrypted devices.
> 
> Please paste at least lsblk, lsblk -f output, and also luksDump
> (or crypttab if it is not LUKS) for LUKS/dm-crypt configuration.
> 
> Thanks,
> Milan
> 
> 
> > 
> > I'm seeing an issue with both the latest mainline kernel (6.18-rc5) and
> > Debian 13's 6.12 kernel package. When physical memory fills up, the
> > entire system locks up hard, as if it hit rather severe thrashing,
> > despite the fact that there appears to be disk cache that can still be
> > evicted, and there is ample amounts of swap space remaining (gigabytes
> > of it). This issue did not occur with the 6.1 kernel in Debian 12. I'm
> > seeing this occur in very low-memory Debian VMs, with between 512 and
> > 900 MB RAM, running under VirtualBox and KVM. (I suspect, but have not
> > verified, that I'm seeing similar behavior under Xen as well.) These
> > VMs generally use a swappiness of 1, though I have seen a lockup occur
> > even with a swappiness of 60. The filesystem in use, in case it
> > matters, is ext4.
> > 
> > To reproduce on a system running Linux 6.18-rc5, with :
> > 
> > * Follow the steps from
> >    https://gitlab.com/cryptsetup/cryptsetup/-/wikis/FrequentlyAskedQuestions,
> >    section "2.3 How do I set up encrypted swap?", but creating a
> >    swapfile rather than a swap partition.

Hi

Encrypted swap file is not supposed to work. It uses the loop device that 
routes the requests to a filesystem and the filesystem needs to allocate 
memory to process requests.

So, this is what happened to you - the machine runs out of memory, it 
needs to swap out some pages, dm-crypt encrypts the pages and generates 
write bios, the write bios are directed to the loop device, the loop 
device directs them to the filesystem, the filesystem attempts to allocate 
more memory => deadlock.

I got the deadlock with 6.18-rc4 when I used dm-crypt on a file and I 
didn't get the deadlock when I used dm-crypt on a SCSI block device. That 
is expected behavior.

Note that the in-kernel OOM killer sometimes doesn't kill the application 
and discards read-only program pages (which generates big I/O churn and 
general system slowdown) - if you are hitting this problem, I recommend 
installing userspace OOM killer, such as earlyoom.

Mikulas


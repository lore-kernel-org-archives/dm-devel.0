Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA7421411D0
	for <dm-devel@lists.linux.dev>; Tue, 28 May 2024 23:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.205.220.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716940536; cv=none; b=E15bZkdiBXPDdCr09KjaGfALikH+bXT2QoBgm33QjgHPY1GVz/jRlyDOX5pVMjbeO1qw2En241zWy7o8Vet3V/62TzwmnTn7zNuBFKUOGqkxtxwKYzP4+MJ+LB33ym7uqUHu2WLfr5iwpVM56gwsyVeD6cZEVFiD27WMbpAiEPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716940536; c=relaxed/simple;
	bh=jGmKAsNQSZ0hqCy19NxNHqZEfN/XQRZUWSbfUfZXAek=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=h4ENxB+Xwyi+Wm5Rw4V4aFo1+gUWZoorxXkMa3+Et0YCPr6awrLzYUYt5ahcnVqIfrXSHHiNvRDU6qG7UeKUzM50ieNzm0jnYMc7bD66bTggLalfOEMIgHmkpN5XhxXHcuXpTscc+g+z8/Omqks7crix/CQGl+HAblr2UOC8NA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lists.ewheeler.net; spf=none smtp.mailfrom=lists.ewheeler.net; arc=none smtp.client-ip=173.205.220.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lists.ewheeler.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=lists.ewheeler.net
Received: from localhost (localhost [127.0.0.1])
	by mx.ewheeler.net (Postfix) with ESMTP id 413A286;
	Tue, 28 May 2024 16:55:28 -0700 (PDT)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
	by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id eUt-uxGOa4ys; Tue, 28 May 2024 16:55:27 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx.ewheeler.net (Postfix) with ESMTPSA id 2984A48;
	Tue, 28 May 2024 16:55:27 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net 2984A48
Date: Tue, 28 May 2024 16:55:27 -0700 (PDT)
From: Eric Wheeler <dm-devel@lists.ewheeler.net>
To: Milan Broz <gmazyland@gmail.com>
cc: Mikulas Patocka <mpatocka@redhat.com>, Jens Axboe <axboe@kernel.dk>, 
    Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, 
    Sagi Grimberg <sagi@grimberg.me>, Mike Snitzer <snitzer@kernel.org>, 
    linux-block@vger.kernel.org, dm-devel@lists.linux.dev, 
    linux-nvme@lists.infradead.org
Subject: Re: [RFC PATCH 0/2] dm-crypt support for per-sector NVMe metadata
In-Reply-To: <f7c9e39f-b139-429b-a310-15f19dab05ec@gmail.com>
Message-ID: <b8ba9b17-3fd-5c8c-4510-1eda64d6c5c@ewheeler.net>
References: <f85e3824-5545-f541-c96d-4352585288a@redhat.com> <206cd9fc-7dd0-f633-f6a9-9a2bd348a48e@ewheeler.net> <f7c9e39f-b139-429b-a310-15f19dab05ec@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Tue, 28 May 2024, Milan Broz wrote:
> On 5/28/24 12:12 AM, Eric Wheeler wrote:
> > On Wed, 15 May 2024, Mikulas Patocka wrote:
> >> Hi
> >>
> >> Some NVMe devices may be formatted with extra 64 bytes of metadata per
> >> sector.
> >>
> >> Here I'm submitting for review dm-crypt patches that make it possible to
> >> use per-sector metadata for authenticated encryption. With these patches,
> >> dm-crypt can run directly on the top of a NVMe device, without using
> >> dm-integrity. These patches increase write throughput twice, because there
> >> is no write to the dm-integrity journal.
> >>
> >> An example how to use it (so far, there is no support in the userspace
> >> cryptsetup tool):
> >>
> >> # nvme format /dev/nvme1 -n 1 -lbaf=4
> >> # dmsetup create cr --table '0 1048576 crypt
> >> capi:authenc(hmac(sha256),cbc(aes))-essiv:sha256
> >> 01b11af6b55f76424fd53fb66667c301466b2eeaf0f39fd36d26e7fc4f52ade2de4228e996f5ae2fe817ce178e77079d28e4baaebffbcd3e16ae4f36ef217298
> >> 0 /dev/nvme1n1 0 2 integrity:32:aead sector_size:4096'
> > 
> > Thats really an amazing feature, and I think your implementation is simple
> > and elegant.  Somehow reminds me of 520/528-byte sectors that big
> > commercial filers use, but in a way the Linux could use.
> > 
> > Questions:
> > 
> > - I see you are using 32-bytes of AEAD data (out of 64).  Is AEAD always
> >    32-bytes, or can it vary by crypto mechanism?
> 
> Hi Eric,
> 
> I'll try to answer this question as this is where we headed with 
> dm-integrity+dm-crypt since the beginning - replace it with HW and 
> atomic sector+metadata handling once suitable HW becomes available.
> 
> Currently, dm-integrity allocates exact space for any AEAD you want to 
> construct (cipher-xts/hctr2 + hmac) or for native AEAD (my favourite is 
> AEGIS here).

Awesome.
 
> So it depends on configuration, the only difference to dm-integrity is 
> that HW allocates fixed 64 bytes so that crypto can use up to this 
> space, but it should be completely configurable in dm-crypt. IOW real 
> used space can vary by crypto mechanism.
> 
> Definitely, it is now enough for real AEAD compared to legacy 512+8 DIF :)
>
> Also, it opens a way to store something more (sector context) in metadata,
> but that's an idea for the future (usable in fs encryption as well, I guess).

Good idea, you could modify the SCSI layer (similarly as for NVMe meta) so 
that bio integrity payload data could be packed at the end of a sector for 
drives that have DIF room. This would make it possible to use 520/528-byte 
and 4160/4224-byte-sectored SAS drives in Linux, for the first time ever. 

Newer SAS drives like the Xeos X22 with can support the following sector 
sizes:
	 512 +  0
	 512 +  8
	 512 + 16
	4096 +  0
	4096 + 64
	4096 +128

> > - What drive are you using? I am curious what your `nvme id-ns` output
> >    looks like. Do you have 64 in the `ms` value?
> > 
> >          # nvme id-ns /dev/nvme0n1 | grep lbaf
> >          nlbaf   : 0
> >          nulbaf  : 0
> >          lbaf  0 : ms:0   lbads:9  rp:0 (in use)
> >                       ^         ^512b
> 
> This is the major issue still - I think there are only enterprisey NVMe drives
> that can do this.

For now that is fine, we only use enterprise drives anyway, and it will be 
great to use the integrity that the drives support natively. Coupled with 
MDRAID, this solves hidden bitrot quite nicely at that block layer ... and 
it may trickle down into desktop drives eventually.

-Eric

> 
> Milan
> 
> 
> 

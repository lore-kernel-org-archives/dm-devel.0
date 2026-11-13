Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591880;
	b=BgHr+4MyiYPayk9+dWJXM8xZFkJxNzONcQ5mOLHrZAi2TMCZcqDhG0B4RPfVx6v8Vdjr
	 gqPiWRNjtyOQIrj3S6QlD8+1JC2rlN8y/ZNeNeEbJfyWd2JddQqAA6ggdhPDhSOujeTNi
	 50Q06QNrIELvSYIgGViMNPAQ1aOVRUI06S3a/66WyBVmEEzzSvOCdeu2z5Q44zzQRHFXa
	 wQJFNWJxjZ2j7Sp0Vwq+S8fXWyifr5SgQvtXVR0Fy8c8wbc3hSn7qIPLGbEmLeSGtM4vS
	 FR+wsw/4z9phVm/M2LuJ4l9481rtBCFUVMd6T0cJseaxsr6HhEk/8Ln2VZd7PfYxhxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591880;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=e0IGkExqpfRXz81t32m0yM/iXDREFvyAEohwMvSxTqk=;
	b=3xkpoQFDaXeiag9rgEOCjFpQeVdgzQSdurZDPcZHHCe8PTiwicpy22UC+SwY2ZS3qxPj
	 xS4tk28JbmjC/CdbzLstCIPHkTzBLApjEEkbDmx3h9hrFkuV4CJDzwC441UW65DJicbhf
	 evidcom8+YOgdbZdu5JwjWzSmiHts6ZsD/PjPoE/DTcP6tQ59grXZlQjYt2cE4JL8dusC
	 Gl71ztc72rJDZBoFEgh7ux/2ezl8BcuDPqXQa62E5QgARTgOUqCSd1FAm5D18JvpLz89h
	 o33Gpsnt8AbFEM418bJ/Au6I+AUgBLfeo0tnhM6VPktJWwOu3Wbxnbuvq6G8hxXrmRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="IwRG/u8p";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF058606BD28;
	Fri, 13 Nov 2026 17:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IwRG/u8p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 263491F000C4;
	Fri, 13 Nov 2026 17:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794591880;
	bh=e0IGkExqpfRXz81t32m0yM/iXDREFvyAEohwMvSxTqk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IwRG/u8pa5pjUTx2Q5RKagWBSX1ftYNPmJWhXWycK1yH44UM4q7MPcj/lgvpAZWSE
	 rJHF+Sdo6zWWNGlHZHrZ7ZnMTapwaJDXleedH4V61JMOaIqr8d1Cw4YxxMiHJfZA/V
	 1az4qjc78V2wTSzfuhB3bSbfGWp2/fNNRjoi/zAfKRU9DlQ4C9FyjGb2fNfy5aUxG4
	 o8LQ+ghwnpmyoIRtIvkxP/UDbRhiSOKGgVqGXP5DOfE164MgZRir672UGUrwfU8cFQ
	 tHDSZysZ3eTHheBkQ41AW0dJc7Y6LGUQ+26h5wMVELJhUQ9QPwcK+Yx12T5tJDDk7Z
	 dx+M1xmlQg2KA==
Date: Fri, 13 Nov 2026 12:44:39 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: Christoph Hellwig <hch@infradead.org>, mpatocka@redhat.com
Cc: Keith Busch <kbusch@meta.com>, axboe@kernel.dk,
	dm-devel@lists.linux.dev, bmarzins@redhat.com,
	Keith Busch <kbusch@kernel.org>, linux-block@vger.kernel.org
Subject: Re: block: let a stacking device inherit its members' DMA alignment
Message-ID: <avdMhzSVQbRJIRLF@kernel.org>
References: <20260709161519.1559723-1-kbusch@meta.com>
 <20260709161519.1559723-2-kbusch@meta.com>
 <atpBVtPqGDWZ2AFo@kernel.org>
 <aumxcHVjVonjs6OV@infradead.org>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aumxcHVjVonjs6OV@infradead.org>

On Tue, Nov 03, 2026 at 02:03:28AM -0800, Christoph Hellwig wrote:
> On Thu, Oct 22, 2026 at 01:01:10PM -0400, Mike Snitzer wrote:
> > On Thu, Jul 09, 2026 at 09:15:17AM -0700, Keith Busch wrote:
> > > From: Keith Busch <kbusch@kernel.org>
> > > 
> > > All device mappers that want to override the dma_alignment do so.
> 
> Don't start a patch description by quoting another mail.
> 
> > Direct I/O from memory every member accepts is therefore rejected at
> > the stacking device, and callers that check the advertised alignment
> > (for instance through STATX_DIOALIGN) fall back to buffered I/O.
> > 
> > Leave dma_alignment at zero in blk_set_stacking_limits() so that the
> > stacked value is the strictest of the members'.  blk_validate_limits()
> > still applies the SECTOR_SIZE - 1 default when nothing was stacked,
> > such as for a table with no devices.  Targets that process the data
> > themselves and need logical-block-aligned memory already set
> > dma_alignment in their io_hints (dm-crypt, dm-integrity, dm-verity,
> > dm-log-writes), and NVMe multipath sets its own.
> 
> Chances are very high that this will introduce bugs somewhere,
> as a lot of drivers are historically not ready to deal with lower
> alignments, and will creeat nasty exploitable bugs.
> 
> So you'll need to audit each driver that wants to relax this
> individually, and then override the value for them.  Alternatively
> we could start with 0 in the block layer, but then you need to
> lift the current setting into each caller first, and only remove
> them one-by-one with a commit per driver explaining why that is safe
> (and sensible).
> 

Yeap, important work needed outside of DM for sure.  Mikulas, after DM,
are you willing to do this mechanical audit/change to the block
subsystem in general? ;)

Mike

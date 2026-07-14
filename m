Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D0D34ADDBF;
	Tue, 14 Jul 2026 19:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784055923; cv=none; b=pK8nLrnndaE/KftBHsGTA22Jd+cekiE9+6e/+nxsKVLMaedp9hou6TI4ObhRnSoIGvcTD30RFtu5H3f/xx7OVUovENZboT/72W/OPNdwbf2abZncf9zB0b5fKchUQGW4DldDGSjNplnsjN8IWVaI3HdfNrtwG4Rh4KQExLzp7W4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784055923; c=relaxed/simple;
	bh=feBpknGPpjc4PSn+kSHtxC4wf5CzUWJgtR/reEPxYBE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MItWyYC2mhCVQzM6CNCxIW8eDPNnCyMASpdiHfxGA+HWrNIPeYNpeUgvL6J/k6Ghy3JgoZJ7oGsXOVB6gXFbZgXFt/MF93M16rxGHnY8nLAhTVqITj74/2Ny1d3kr+znrj9qyz7proqVSMXN5XxmOI3hbLb8sY5ILeIDVv8o7v0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fxGUaSBp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fxGUaSBp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E8DB1F000E9;
	Tue, 14 Jul 2026 19:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784055920;
	bh=TzkZMEoOIqQJtVuFExx55NmdQVjsr4wSFcedNMR31AU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fxGUaSBpYqikZqOdKUiwg49GH6ArHfZh1u9t8wTEGhljyWHLm9Ido6WQ3bKpLG3hR
	 BmhcWiXBkJMjFvtOtbMMKQs0f/1Jhrw7Nf4D1Pk2drpFd8J8F9gcZjPjcir7fBFVjF
	 mqasz8RxIFCRBQF3M10sqE60ObJpFEd4ShDBswMI05upQ8VFzrXxvA7OaTFzQllND5
	 8r24mJSwo4cOdLzWAfbKKrR+uJkMluyEGbFwl7NKaEZKzbvC8mniGTOeynwK1PvnXs
	 mSY8LocVBEELooVtliWBMOSno3qx+KbI0Ik2rSjI7iu+UdsieqiMPj9impgwEV9RoX
	 hcDruX737UUhw==
Date: Tue, 14 Jul 2026 13:05:18 -0600
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, dm-devel@lists.linux.dev,
	axboe@kernel.dk, brauner@kernel.org, djwong@kernel.org,
	viro@zeniv.linux.org.uk
Subject: Re: [PATCH v3 0/5] block: validate direct I/O memory alignment
Message-ID: <alaIbgXtMerwCRk3@kbusch-mbp>
References: <20260624170905.3972095-1-kbusch@meta.com>
 <20260714043543.GA30880@lst.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260714043543.GA30880@lst.de>

On Tue, Jul 14, 2026 at 06:35:43AM +0200, Christoph Hellwig wrote:
> On Wed, Jun 24, 2026 at 10:09:00AM -0700, Keith Busch wrote:
> > From: Keith Busch <kbusch@kernel.org>
> > 
> > This addresses the misaligned direct-io problem behind various threads:
> 
> It looks like this never got merged and is still missing in 7.2-rc3.

Yeah, I think this fix is good to go even mid 7.2-rc, but if not, would
be appreciated if we can get it staged for linux-next.

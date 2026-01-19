Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13B7E23D7CF
	for <dm-devel@lists.linux.dev>; Mon, 19 Jan 2026 14:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768833639; cv=none; b=PbGY3F6pKLlnj0uZ/xzdxGzD2iVB/1ZEQqgxHwIDtVD9T4NcM22eNRQOdVBOkavqe7dZhkmyWq5gliAYRp3D2/2Lma0d2jHhXlhHzKbW/3zabr8xnqV/OjQQAJww6b1AlcdVsf5X6CtfSPHuydHW9VY4uncuQoEtHd9au3T804E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768833639; c=relaxed/simple;
	bh=FSmcCg617ijmddOVDXpVRNEa8JLrpQUtfneta1jGAXo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mpiq3yJY80/f9ybq+gDPqyy3FwWQhXqC5Ga8r4HEF1cAXiHylfXQsOnL/R5ADiAMA/3MGX5Mg/35XfqJbn3oEoy8B8tmwEfcjMjUlIAwQ4njbYl+jHJcm5UbpFHi1wmATQQWTNMOW+3TCKj2PMfjpS6m5OIR7IwgeuoYZrg3ed4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JhHRT+uE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JhHRT+uE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FC59C116C6;
	Mon, 19 Jan 2026 14:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768833638;
	bh=FSmcCg617ijmddOVDXpVRNEa8JLrpQUtfneta1jGAXo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JhHRT+uEYP1eUBRExmL2exVAfmZwnsBAf0cASeocjhD2HGyZ2GQWjrgyVqRoVu9LV
	 AIJfGdgxzevQ68sVHsb1m6V1djmwygn5rdoRvIXNhgGRVfB63mAqnz2C9Ykp/Dag1J
	 tlzs/HoA74i/pz/StsexJC9OIyIFNF9FnAkIE415Y4Uu6kSvQZZrelMDodfDX8qbol
	 3WJjhjqs7fOxvSMrlyg/aa81p62ALPSenJ9eY8SpLwa7/ia4X7WZokWRFRdc2lBN5E
	 0rR27ZPfHRGwQL43aXPe8ZcLLLXPmQ2L7CpgsEJM4fGeI7FrsQyUp48ILVcoZLKqyZ
	 3akCtR1a6scoA==
Date: Mon, 19 Jan 2026 15:40:34 +0100
From: Christian Brauner <brauner@kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
	Benjamin Marzinski <bmarzins@redhat.com>, Aleksa Sarai <cyphar@cyphar.com>, dm-devel@lists.linux.dev
Subject: Re: [PATCH 1/2] dm-verity: add dm-verity keyring
Message-ID: <20260119-dazugeben-stufen-42aa44c50f12@brauner>
References: <20260116-work-dm-verity-keyring-v1-0-0d3de29b0618@kernel.org>
 <20260116-work-dm-verity-keyring-v1-1-0d3de29b0618@kernel.org>
 <5ad502f9-2d97-8e56-72b9-67a255d95d72@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5ad502f9-2d97-8e56-72b9-67a255d95d72@redhat.com>

On Mon, Jan 19, 2026 at 03:22:58PM +0100, Mikulas Patocka wrote:
> 
> 
> On Fri, 16 Jan 2026, Christian Brauner wrote:
> 
> > Add a dedicated ".dm-verity" keyring for root hash signature
> > verification, similar to the ".fs-verity" keyring used by fs-verity.
> > 
> > By default the keyring is unused retaining the exact same old behavior.
> > For systems that provision additional keys only intended for dm-verity
> > images during boot, the dm_verity.keyring_unsealed=1 kernel parameter
> > leaves the keyring open.
> > 
> > We want to use this in systemd as a way add keys during boot that are
> > only used for creating dm-verity devices for later mounting and nothing
> > else. The discoverable disk image (DDI) spec at [1] heavily relies on
> > dm-verity and we would like to expand this even more. This will allow us
> > to do that in a fully backward compatible way.
> > 
> > Once provisioning is complete, userspace restricts and activates it for
> > dm-verity verification. If userspace fully seals the keyring then it
> > gains the guarantee that no new keys can be added.
> > 
> > Link: https://uapi-group.org/specifications/specs/discoverable_partitions_specification [1]
> > Co-developed-by: Aleksa Sarai <cyphar@cyphar.com>
> > Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
> > Signed-off-by: Christian Brauner <brauner@kernel.org>
> > ---
> >  Documentation/admin-guide/kernel-parameters.txt |  7 ++++
> >  drivers/md/dm-verity-target.c                   | 20 ++++++++++-
> >  drivers/md/dm-verity-verify-sig.c               | 45 +++++++++++++++++++++++++
> >  drivers/md/dm-verity-verify-sig.h               | 12 +++++++
> >  4 files changed, 83 insertions(+), 1 deletion(-)
> > 
> > diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> > index a8d0afde7f85..374571c7921a 100644
> > --- a/Documentation/admin-guide/kernel-parameters.txt
> > +++ b/Documentation/admin-guide/kernel-parameters.txt
> > @@ -1370,6 +1370,13 @@ Kernel parameters
> >  			For details see:
> >  			Documentation/admin-guide/hw-vuln/reg-file-data-sampling.rst
> >  
> > +	dm_verity.keyring_unsealed=
> > +			[KNL] When set to 1, leave the dm-verity keyring
> > +			unsealed after initialization so userspace can
> > +			provision keys. Once the keyring is restricted
> > +			it becomes active and is searched during signature
> > +			verification.
> > +
> >  	driver_async_probe=  [KNL]
> >  			List of driver names to be probed asynchronously. *
> >  			matches with all driver names. If * is specified, the
> > diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
> > index 5c17472d7896..835358f63d09 100644
> > --- a/drivers/md/dm-verity-target.c
> > +++ b/drivers/md/dm-verity-target.c
> > @@ -1803,7 +1803,25 @@ static struct target_type verity_target = {
> >  	.preresume	= verity_preresume,
> >  #endif /* CONFIG_SECURITY */
> >  };
> > -module_dm(verity);
> > +
> > +static int __init dm_verity_init(void)
> > +{
> > +	int r;
> > +
> > +	r = dm_verity_verify_sig_init();
> > +	if (r)
> > +		return r;
> > +
> > +	return dm_register_target(&verity_target);
> > +}
> 
> Hi
> 
> There's a bug that if dm_register_target fails, you leak the keyring. I 
> fixed it and accepted the patch.

Thank you very much, Mikulas!
Christian

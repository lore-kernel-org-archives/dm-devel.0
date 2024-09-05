Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1481715532A;
	Thu,  5 Sep 2024 22:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725575758; cv=none; b=YLPQ5V+kYjvT/TFjYL52mJ9+Hif6ebvAJGTriBRpprxP4bpxwOyWTghabvbxVOqQQh5eTQZWWiOoRj/MfKFybxrmP84+hr4vbZU2aLtlyr6HWt1gxTZxMM5y2+YidQBwzRARgyydti3SO3xJ36BA37ri3IcFENUGLCi90kL/VPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725575758; c=relaxed/simple;
	bh=ZH7eakCEqONTQG+utGtrrkQgjtVFFzSSiYzeozJllEA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SZnMET1QvuOYEaPDzoOjApPWiuxBCiXzE1g4oQ6YR/te4yB9Ek2w93GfFZmcBr864nSNtkyPMHbLygZewXucDqvBKcixE1wrKxFVxIsuxd5y1wJXvXRxtYX4yS7T1at4VV3VkyiKpWhmsBX+IyEqA/r6qrLpqS66vbCP7JXoVOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uqBjHc1v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uqBjHc1v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50422C4CEC3;
	Thu,  5 Sep 2024 22:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725575757;
	bh=ZH7eakCEqONTQG+utGtrrkQgjtVFFzSSiYzeozJllEA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uqBjHc1vPwX2LM3sHccZnVGzlDj+VO3Q6IAPs0JCljCw42+x7hzSiuWl/fGl7ITB5
	 /yamueN1OV31HWlB9WgD2cxkFcwWt4fohIUUBqJ3b0aCI/QVWGQrQhWHs3CnAm0beI
	 dJi7XmqPAgfS3s2VsWcwOpfa6sFsUDwBLCNlA+uf8XiMlZfwhuGugTZq1+3R3A1E3h
	 yu5AtTYFBYyd6CIvAVm6qjIuwqDu1GYpHxx4tyeyNjPyJGzt9wKAl/qhGK8QoAIVZ6
	 qYOpr445tekwhQAnywUGahiL2NU8NFg4u9kmQAwlrt3WFrZfY8lkczO7Kt2kcS4Kv5
	 1lgwxqS0S+piw==
Date: Thu, 5 Sep 2024 15:35:55 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@lists.linux.dev, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>, Tejun Heo <tj@kernel.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [PATCH] dm verity: don't use WQ_MEM_RECLAIM
Message-ID: <20240905223555.GA1512@sol.localdomain>
References: <20240904040444.56070-1-ebiggers@kernel.org>
 <086a76c4-98da-d9d1-9f2f-6249c3d55fe9@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <086a76c4-98da-d9d1-9f2f-6249c3d55fe9@redhat.com>

On Thu, Sep 05, 2024 at 08:21:46PM +0200, Mikulas Patocka wrote:
> 
> 
> On Tue, 3 Sep 2024, Eric Biggers wrote:
> 
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > Since dm-verity doesn't support writes, the kernel's memory reclaim code
> > will never wait on dm-verity work.  That makes the use of WQ_MEM_RECLAIM
> > in dm-verity unnecessary.  WQ_MEM_RECLAIM has been present from the
> > beginning of dm-verity, but I could not find a justification for it;
> > I suspect it was just copied from dm-crypt which does support writes.
> > 
> > Therefore, remove WQ_MEM_RECLAIM from dm-verity.  This eliminates the
> > creation of an unnecessary rescuer thread per dm-verity device.
> > 
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> 
> Hmm. I can think about a case where you have read-only dm-verity device, 
> on the top of that you have dm-snapshot device and on the top of that you 
> have a writable filesystem.
> 
> When the filesystem needs to write data, it submits some write bios. When 
> dm-snapshot receives these write bios, it will read from the dm-verity 
> device and write to the snapshot's exception store device. So, dm-verity 
> needs WQ_MEM_RECLAIM in this case.
> 
> Mikulas
> 

Yes, unfortunately that sounds correct.

This means that any workqueue involved in fulfilling block device I/O,
regardless of whether that I/O is read or write, has to use WQ_MEM_RECLAIM.

I wonder if there's any way to safely share the rescuer threads.

- Eric

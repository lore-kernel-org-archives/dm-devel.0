Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FF0014F90;
	Thu,  5 Sep 2024 14:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725546743; cv=none; b=Ugzi6DrThR6K7JbutaMt4RjS56jRbHIMXfWwJfS8kyoulTHjA/oMgaLlS/6lO/v9ydcX2n79hh52f/YVVRAsWh/nWS/6CPpbdhe0gbtdXVq4Mt7dU2c4jKk+OdYw3C8hsF0U9EhHf5nVZx6PsCghSuVWlT9CohUSMbDof6grwqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725546743; c=relaxed/simple;
	bh=BQW84hZwFEmS7SWLZzzzYJkxu62txwxLKb3iaRMFqGw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BIIJVIbxrjy6YfVdI3knotKtT0kiHERJi2/9XOOySOF7+XOnQD1JhH4sBUvdMQBN5RE4coHCMfIjfx874m/l55tXoSuDpNRn8q4RZerbTi8tGcPKG7erFWWahqIxz73HO5Tc9RIEJcGdpO8yfH6a5tz0X/UCNQIAMnmFJahXfp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k7EmstYs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k7EmstYs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CCB3C4CEC3;
	Thu,  5 Sep 2024 14:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725546743;
	bh=BQW84hZwFEmS7SWLZzzzYJkxu62txwxLKb3iaRMFqGw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=k7EmstYsha8/YxlvmdJE3En30h5WrM1gd+iaZwCA2oeDSmrjs8XYfqRAo+q5dgL6e
	 kQEos2Xq+xQQK9pYuKbGyrsdNjuj+AxzBXnfLfw0AbkB6PSAhkbRvKsE8t1V/gn7FG
	 M0en7nzZI7K3djsXbhllRFpoLBlNksDfdkYqhBLf3TVnNxlzYXHcJGqOnJv3cFPtoe
	 z5T90On3Vjjd64zwkXkCCHuazfS05ht+AXPRlO4kPVzNG3Ckb49Ik7OeRlj8m4K4jC
	 E0skKiLEItq6mNSHfjqUyU4lvJeanDSJm7b2m9qnJnNZWXLwhsdrC4FsTVRKb9i8Ra
	 hGMrxSGmy8paQ==
Date: Thu, 5 Sep 2024 10:32:22 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: dm-devel@lists.linux.dev, Alasdair Kergon <agk@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>, Tejun Heo <tj@kernel.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Sami Tolvanen <samitolvanen@google.com>
Subject: Re: dm verity: don't use WQ_MEM_RECLAIM
Message-ID: <ZtnA9gSNLnJXvA9z@kernel.org>
References: <20240904040444.56070-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240904040444.56070-1-ebiggers@kernel.org>

On Tue, Sep 03, 2024 at 09:04:44PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Since dm-verity doesn't support writes, the kernel's memory reclaim code
> will never wait on dm-verity work.  That makes the use of WQ_MEM_RECLAIM
> in dm-verity unnecessary.  WQ_MEM_RECLAIM has been present from the
> beginning of dm-verity, but I could not find a justification for it;
> I suspect it was just copied from dm-crypt which does support writes.
> 
> Therefore, remove WQ_MEM_RECLAIM from dm-verity.  This eliminates the
> creation of an unnecessary rescuer thread per dm-verity device.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Thanks!

Reviewed-by: Mike Snitzer <snitzer@kernel.org>

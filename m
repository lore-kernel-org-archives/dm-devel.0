Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C37314F70;
	Thu,  5 Sep 2024 14:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725546897; cv=none; b=H38LOCulVJvOUBlpM6hqi/dwC6LRmr/xVvqWwqi8/CgCBySEoEUx8Xq6N2KpQP8y4J0Idgf2Tv5IsbV9QwGdwV6LSQsgmbrdJNgDXc6O3G7/um7wslO5ZNyVokBWn56vZv5UH0naocwbguXpxDikjlkk39HtvmBMsFjixrdeBNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725546897; c=relaxed/simple;
	bh=PG+E5br8Dk0U5gLfRdwO3vnIVV22WYform4XPxeRVgE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vud1S0CO9YBrwKLMoOaHTYDjTAOn/tP8GELganrjhBXNiREoBy+1SPwHURmCEmIKz2aVe5UvsuF84fx4TTw97SB3SpeCEAHC6eYI5jUsmjqFzHMRyNb7gr+/73uBRoeLOttzBLgqST/IZNlSev9Wqi+xB2Td0c+gY6FfsEX4lhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YR5RXKER; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YR5RXKER"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8818EC4CEC3;
	Thu,  5 Sep 2024 14:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725546896;
	bh=PG+E5br8Dk0U5gLfRdwO3vnIVV22WYform4XPxeRVgE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YR5RXKERVoC9JAEvO5L95YUzQDbkAZy++LBCV5YZOFSS0FwoARj6IVwnQoQiwZKww
	 aFTtmqjALzFgiJWd+Legf4EoMwA4w0VP9qvon7rUWuigyvkfwpXsYSeT0GCtSmkm5v
	 LMN4/gijwWB+CLzuHrQBBezhuZEXvImVl7N+PizMh5Lq2EtIhFcC+qdcT8H+24V0TY
	 LT5JvrWMjlUpjDF0xgAdkjuR/JN1FpLFkXhjGFuv/CjVlhHyqsSUJke6kdPuKTFzx3
	 eFBWtdPnxJy4j6wyZBQygSeLgJCe8Rh7HIZplGsIsv6LUfhRAQObzyyqHWrVwf7UQa
	 CVRNS6xi34P5A==
Date: Thu, 5 Sep 2024 10:34:55 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Chen Ni <nichen@iscas.ac.cn>
Cc: agk@redhat.com, mpatocka@redhat.com, dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: dm integrity: Convert comma to semicolon
Message-ID: <ZtnBjyn8eSygoaT1@kernel.org>
References: <20240905022832.1642756-1-nichen@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240905022832.1642756-1-nichen@iscas.ac.cn>

On Thu, Sep 05, 2024 at 10:28:32AM +0800, Chen Ni wrote:
> Replace comma between expressions with semicolons.
> 
> Using a ',' in place of a ';' can have unintended side effects.
> Although that is not the case here, it is seems best to use ';'
> unless ',' is intended.
> 
> Found by inspection.
> No functional change intended.
> Compile tested only.
> 
> Signed-off-by: Chen Ni <nichen@iscas.ac.cn>

I agree, the use of comma is bizarre.  Not sure how that slipped
through but...

Reviewed-by: Mike Snitzer <snitzer@kernel.org>

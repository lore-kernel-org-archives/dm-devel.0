Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D719F340A76;
	Mon, 22 Jun 2026 17:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782150046; cv=none; b=Dnwc3NN+tsfu5CrcgjZzrHiLKSNVGdP/+zKa6YRn3NolOJTninGu9z5arQCu9sp1XNv7I7FHfW12vM11GHkP6ogxbHzhULmtXBYZet84UemHlheUqgR/FOXzQb4pDwydupOgMUk3jpz58wIP/r/fIMLNeT83GcUx7G1yN2JsdzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782150046; c=relaxed/simple;
	bh=JUSeqM1bQeVojq6ynLcv6oYJuATUJQTlI++PhCgIHeE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s3u/aZstE0nFDx2D6OJwt7YLKiD83ciETj3kuDb3OxWqDOsgVmdPMhAhXmqj2Az2JE1N0KesNbNmPds4XEm3kThz98r7jQ6EhupYCYD9yvz4FeFNBLMQDT6mtkOcfodABA5fOeCqInHE+iebgkKBGJHEMAT7zqxtZ78bcjzH+GM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FFOh0vOy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FFOh0vOy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F7E11F000E9;
	Mon, 22 Jun 2026 17:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782150045;
	bh=JUSeqM1bQeVojq6ynLcv6oYJuATUJQTlI++PhCgIHeE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FFOh0vOy/lEk9odvSia/cvS78CcrHU13GhIU0QrPqX54/lEZKEYq8WCnoXjIRdtL5
	 QprfGLQ/ZButtZ2HGqp0s1CjyPhr2+52KNxawgWzZ37a0bej/MkwsAZOr68gPDCwRz
	 boSxBdsxaZJ2p6behZTFltXtAmxpNuM/5XZO9FJCFBi0b8kzatctnT7zICdJxfLzFS
	 5vUY85oGwqrjdTv9wOmi6VYYkPozQ6/ZVEjUpPgMSr4gwxheiCsvLcexW5vSOojB9A
	 YyP3/1YzOUU/ml7ugZk+z/hP6ihGX8A8Y0Bk8NDrQEHFXtVZ5Bkr+4PGSO//W9lvhX
	 Cmjr1hL8pknZg==
Date: Mon, 22 Jun 2026 11:40:43 -0600
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, dm-devel@lists.linux.dev,
	axboe@kernel.dk, brauner@kernel.org, djwong@kernel.org,
	viro@zeniv.linux.org.uk, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] block: validate user space vectors during extraction
Message-ID: <ajlzm1V7Cr-T-A4f@kbusch-mbp>
References: <20260617233235.1016063-1-kbusch@meta.com>
 <20260617233235.1016063-2-kbusch@meta.com>
 <20260618102627.GA23200@lst.de>
 <ajPv7yOoYsR5O6kf@kbusch-mbp>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajPv7yOoYsR5O6kf@kbusch-mbp>

On Thu, Jun 18, 2026 at 07:17:35AM -0600, Keith Busch wrote:
>
> But since you mention it, __blkdev_direct_IO's handling does look wrong,
> so maybe I can clean that up first.

After careful reviewing, I think __blkdev_direct_IO() is mostly correct
in what it's doing. It looks weird, but appears to be well optimized for
the common case such that making it look more readable would produce
less efficient execution code. So I'm not going to touch it, but there is
a bug here with metadata mapping error handling that I'm going to
propose in the next version.

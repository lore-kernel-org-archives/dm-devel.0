Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AC8A82D88
	for <dm-devel@lists.linux.dev>; Fri, 23 Feb 2024 17:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708710397; cv=none; b=N+OEtIGiLMdThBL76c5hs7BtsTCx7+EvrsZRonhBM0HVnamc4xH3GkuudZFYB6WiF3HGn8W9Cbz8U6SOPY+d1XfoSSxI/397MWfl/02Kz6ORiXJdCgPIxGU7a221pMGV6xHm9Qfr3qAcl6nyuIcPWn/OzivG3pPkxBk/9x3oRMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708710397; c=relaxed/simple;
	bh=KZzKiCcoDSRXwcX9MekjoKp1MqufHTwKz3XzaXPjUmg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IK8Nc8rS6qzqk+8WtmWmcI0LEobl/XjUP28O7tM2rVKYPtccpuDM45MUC0Scvt4HDXPIYgOLVxu01EjlP3T0pzKihQBQIEMdzqRGnqU/J+wbFvnDQsD2RMaS9wz07IVEhKsSm6+iqD81DyU+xX0nss9I4nOQ18ga5kYGO2emIUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id DF81168D09; Fri, 23 Feb 2024 18:46:29 +0100 (CET)
Date: Fri, 23 Feb 2024 18:46:29 +0100
From: Christoph Hellwig <hch@lst.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Snitzer <snitzer@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
	dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
	Alasdair G Kergon <agk@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [git pull] device mapper fixes for 6.8-rc6
Message-ID: <20240223174629.GB5743@lst.de>
References: <ZdjTMZRwZ_9GjCmc@redhat.com> <CAHk-=whmiQC_F1s1bWmOhM8csz_zxL32B=sPGgaz1kiTK_T2iA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=whmiQC_F1s1bWmOhM8csz_zxL32B=sPGgaz1kiTK_T2iA@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Feb 23, 2024 at 09:42:21AM -0800, Linus Torvalds wrote:
> And honestly, "__packed" really is wrong here.  Nobody ever wanted it
> to be completely unaligned.

I'll let Ming speak, but I think the idea was to remove the padding
at the end of the structure when embedded into the bio.

> 
> I think we might be better off marking it as being 4-byte aligned.
> That would mean that instead of __packed, it is done as
> 
>    __packed __aligned(4)
>
> 
> because "__aligned" on its own only increases alignment (so without
> the __packed it would stay 8-byte aligned).
> 
> Then the only part of that structure that might be unaligned is
> "sector_t", and that would only matter on 64-bit architectures.

Does __aligned also work on struct members?  If so we could add a
__aligned(8) to bi_sector an get exactly what we want..


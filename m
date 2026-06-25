Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEEED3DC4CD
	for <dm-devel@lists.linux.dev>; Thu, 25 Jun 2026 11:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782388653; cv=none; b=kLa2gobQ3EQE/TOzQMLcBLaPAwa2E1t3mi1ee4gi1+K7wQLWVUm0+E21zYlNgoNI9ELBCiCd81DriUTl07bHrxAV6aYFJhju/nDoFZglOOqnmKywJo5IcrIibdqZOhv26GGRkV+Rpa1OET6ev6ThKuGNuh5Yq6GgMlTUJeNF+7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782388653; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XexoKfbE4W49ikFq7vcVosve4vVyeKKtKYCbjFmP5b3i0+IAZyCTSf2yPHnpWJKNrQiFztTz7l7JaAazFLN24wkm6Su/Y7bvJUzW64RHDKbEeLIee39dWLvu+l8cJWS2aHWbsVeCWU0HN7wVW0ib/w2IsCkEk3EUNT9nyiqTDEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7854868B05; Thu, 25 Jun 2026 13:57:29 +0200 (CEST)
Date: Thu, 25 Jun 2026 13:57:29 +0200
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@meta.com>
Cc: linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	dm-devel@lists.linux.dev, hch@lst.de, axboe@kernel.dk,
	brauner@kernel.org, djwong@kernel.org, viro@zeniv.linux.org.uk,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH v3 4/5] zloop: set dma_alignment from the backing files
 for direct I/O
Message-ID: <20260625115729.GD18348@lst.de>
References: <20260624170905.3972095-1-kbusch@meta.com> <20260624170905.3972095-5-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260624170905.3972095-5-kbusch@meta.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


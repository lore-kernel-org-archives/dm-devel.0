Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59DF821CC79;
	Fri, 16 May 2025 05:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747375031; cv=none; b=n6vcwONHTe/zSwJ3dxrC6FuEmpC3LnKtcnivJQHvu0vN/R7QD7suWtAaeK9GPR+8UXkA1Pc11cA+1SHZPJyzQVWkzJ38kbXCR+BB3LqPlg9e8JFtQ3nWwppxmzsCbtPrbEcTKkfIY7TfZp0KU6tRFoa6hbo3efDIsuH796+L660=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747375031; c=relaxed/simple;
	bh=9JdI+jOeuyQy4by4DCLlqp2ycKCjc71/EM4ukAm7xWs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UJ68vbmVK8ZsdAZXSORpyulMYnz0V+WIJv+D6kq3EUi/8McVC5wTL7fd9NFClJx1dkJVFyWhJfRCUZ5hJhIAiy6Fm9mmnfdc5IUSeqjGD6PFcq0VRUQVjYh/eO1bn8XaeX12Gf+n8KR0q6C/ongRloz3vL3wacmR5DW96dYHVuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=RdrVIbQs; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RdrVIbQs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=5A8B1+vuDbLdgEK1W25fWtT5e6F4vVts0Pbed2TmLZU=; b=RdrVIbQsqdO7ct10DgpGQefnvN
	Kwg8SbgpOrbW7h/9sHR1cwF1OBcdS1s6iNLRMUBUiPU9Bxzpl9QIFQSV3wO3Katf+30DuFxYolcBH
	DwEF2TzrmdrhXenHWGNd6jTKKpe4adv1E2XJHEd3+jljqpnFCirFZwS2uzwP/a67E9TQON/RVpYlX
	Od5Sca/jpAXFiJ6ho4LHONJRfSXfvsxeCIRQRRdVi9+nEwJj6diYGJlSds7xMZyTJ4AC7tAuWtFm+
	kAtmRY2NJqo6CxFW8OjfBqYirIFWZZyiW+NvpcqUZNp9gZKZrU8l2YFE7FBcAZOVZBaz5hVHjinfY
	Kru9GWGQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uFo4D-00000002XXf-2W7k;
	Fri, 16 May 2025 05:57:09 +0000
Date: Thu, 15 May 2025 22:57:09 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	Kevin Wolf <kwolf@redhat.com>, dm-devel@lists.linux.dev,
	Hanna Czenczek <hreitz@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>, snitzer@kernel.org,
	"Kernel Mailing List, Linux" <linux-kernel@vger.kernel.org>,
	Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH 0/2] dm mpath: Interface for explicit probing of active
 paths
Message-ID: <aCbTtQAM6lfPFDB-@infradead.org>
References: <aCIRUwt5BueQmlMZ@redhat.com>
 <aCLe5UT2kfzI96TQ@infradead.org>
 <aCMQ5S-gI6vZJxmq@redhat.com>
 <aCQiz88HksKg791Z@infradead.org>
 <aCTDiHMuMncwdp_X@redhat.com>
 <50beb356b4dc000446fd186ab754c87f386eaeae.camel@suse.com>
 <CABgObfaEiMN=YANk02EWini+jAXU1MxSvo8_jYWaMiu3ds7hgQ@mail.gmail.com>
 <2f0fc8ef7d04c590893bd6d54a6c0c842c4b21d7.camel@suse.com>
 <aCX6Ys9mOc441ydA@redhat.com>
 <5911e91974db637d4a3395e60244c2c52b27b4b4.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5911e91974db637d4a3395e60244c2c52b27b4b4.camel@suse.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, May 15, 2025 at 05:00:41PM +0200, Martin Wilck wrote:
> I didn't mean it this way. I was rather musing about the question
> whether doing SG_IO on multipath devices by forwarding them to the
> current path makes sense.

It doesn't, and that's the core of the problem.  Someone back in the
day though just forwarding SG_IO would solve whatever thing they had
to do back then and which didn't have a proper kernel abstraction,
and it keeps adding problems.


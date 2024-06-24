Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A42A61FEB;
	Mon, 24 Jun 2024 08:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719218593; cv=none; b=U1IXhPMWTL9dxMSkjt5ANT8BvdSfnNFT38ZrGqIsYtDI4AJGxQwQXoGRNQVDiGg9xR9IAQ9f3GfHSZLgDFWLq2/Dj5jqN94ku3lWrv6zfUm359ziiPrcXlhY0PB69KmuwXn+2GGaWubFB5acfJLbY77cih5BPTSYlLQEbgB/X3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719218593; c=relaxed/simple;
	bh=v0v6mdua10htkr5rmjnF+4yE/ELelGG2LLeUT4SmCz0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Aq5WCSDoY1/PCxDsVKlCmf6zcVUJZ7DsqJfwVLZIfZzYgtHmLRAGomNrv7s3dSszALbOi3HFkwxzuJggKFp3tHUvpEfvTUSBz/Q7NJUpKKu/XU0TS8XhItoAWpUVj0ol1BfXn/GGZWfc+qzZq4RdVUmKbfr+vnCbNWW/K9NUqCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=nIwx96pW; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nIwx96pW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=7X88en6kIJuV7GibrV5exBa9x7h2ezZRUiFA95jmMeI=; b=nIwx96pWhzjYwMhsnIUjXamBSk
	vBPDl0fnd0QWA5jzXPGtk1s8Qx1doUOm7yFPQQ1fOtK/r+/KIVwizdSZRQ2S1tomhwx2ytFXfe8fF
	PDsMC3EziK7U7ZvziO6J1+7rYx4NSceIKXWzr459sxxBZ42ORhAVsjqkv2mYOQhvO1Jr6lbN6n2Ic
	aU03Uvk4SV03LMCDRh8aSrzqmImilVzid2Y5/A4tZpCKXxINA3Bw5dqm/9T7JwFhY07pbIU4MM7Gb
	NvGvKcnkU2rJ5cB/ko16APoLb+eJNOrJRMzx4C9P3D7BOoCUgFA/ueh0WRnHUw4F2N7leqkxYkMyN
	PLdqwwCw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sLfI7-0000000G60A-1dJp;
	Mon, 24 Jun 2024 08:43:11 +0000
Date: Mon, 24 Jun 2024 01:43:11 -0700
From: "hch@infradead.org" <hch@infradead.org>
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: "hch@infradead.org" <hch@infradead.org>,
	Bryan Gurney <bgurney@redhat.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>
Subject: Re: blktests dm/002 always fails for me
Message-ID: <Znkxn7LymUjD3Wac@infradead.org>
References: <ZmqrzUyLcUORPdOe@infradead.org>
 <pysa5z7udtu2rotezahzhkxjif7kc4nutl3b2f74n3qi2sp7wr@nt5morq6exph>
 <ZmvezI1KcsyE3Unl@infradead.org>
 <42ecobcsduvlqh77iavjj2p3ewdh7u4opdz4xruauz4u5ddljz@yr7ye4fq72tr>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <42ecobcsduvlqh77iavjj2p3ewdh7u4opdz4xruauz4u5ddljz@yr7ye4fq72tr>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Jun 24, 2024 at 04:58:29AM +0000, Shinichiro Kawasaki wrote:
> Based on this guess, I guess a change below may avoid the failure.
> 
> Christoph, may I ask you to see if this change avoids the failure you observe?

Still fails in exactly the same way with that patch.


Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC05F13D52C;
	Mon, 24 Jun 2024 13:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719234528; cv=none; b=bHSGagT4YKrv6H+zmxXuO6npI3Xxcfud/oC2JGBmzAln6QZ8N7aiQPYwkmtpsURDi07MAxjubzggFj36azuK6oguJKnvIO+ovfUJrga+HN/H4eN99sKzluxnfb0ZAEJXtzlvqyO1sa3oRIrJhlNlQlMeNwFxfRsDFQAGe1e7v28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719234528; c=relaxed/simple;
	bh=elktvRmRWMFF3akLMYTbgALaJAk0J9jAD/5pgrqU9LQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tVGBpVD14dyYJqiOraGE/PVrw76QN5EDh2olXPCw3VDLSg7wO7SlS+k3HeFXa/xmJIeaSq+VS4P+uXlq5pK7LMEQIjthS3KnacqlMcuQVb+5J9Elg3P0XB5K/BnqPOC+48x9YcnLFvuGLOh52Mf/hmg/UiZl7n6+wLX3P5QHrtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1evnTsom; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1evnTsom"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=RAYpch24oHtj+2O2FrYbUvGaHv5G6WBMIUIZdXLEKU4=; b=1evnTsomBZyZR14QUzFVZobyjQ
	3IOgsgJqPrx6vY6rs0Z3YSijrHQD5TrbzvQ0knj9pownYk/hUDqJRDkFtTWWqrJZV3J9SNUQRee1p
	Aw9BGn24ATN91SBdBYXATfxOnZs5yS9tgphTAcOzsd5lUCN8MgPqsFDpOe6FEysYkmnukpMWq8F34
	3KwPPvQB13UPCWOUbPCJOs6Oo6zJyrtJdTFNNOkivqtG3RN3HNsAsYHijc8UP5YhHKwWUbZfiEk1W
	uZ645aczMJz20bMkt9Cr/JmdRc1iztzqFScq6JmcoPaCk/Ae7lQEIq3GaO6/nOwC5/DyNNo8efd9v
	b6l2jNlg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sLjR8-0000000Grz4-0J4d;
	Mon, 24 Jun 2024 13:08:46 +0000
Date: Mon, 24 Jun 2024 06:08:46 -0700
From: "hch@infradead.org" <hch@infradead.org>
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: "hch@infradead.org" <hch@infradead.org>,
	Bryan Gurney <bgurney@redhat.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>
Subject: Re: blktests dm/002 always fails for me
Message-ID: <Znlv3iR74jbi8Rc9@infradead.org>
References: <ZmqrzUyLcUORPdOe@infradead.org>
 <pysa5z7udtu2rotezahzhkxjif7kc4nutl3b2f74n3qi2sp7wr@nt5morq6exph>
 <ZmvezI1KcsyE3Unl@infradead.org>
 <42ecobcsduvlqh77iavjj2p3ewdh7u4opdz4xruauz4u5ddljz@yr7ye4fq72tr>
 <Znkxn7LymUjD3Wac@infradead.org>
 <i4skne2yegneuyuw7nqt2mziuywjwo2p54emgba3fjcg5rflhe@dvqy65je7boc>
 <ZnlcrgxYvqqy5uoK@infradead.org>
 <lkgvrxzyxf5gpxzdb5yq5epbhhxdz72rfqnjbzg4qyi6npndsw@g6wkv5jh37wj>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <lkgvrxzyxf5gpxzdb5yq5epbhhxdz72rfqnjbzg4qyi6npndsw@g6wkv5jh37wj>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Yes, it is a 4k block size device.  With your patch the test passes
fine.


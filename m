Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7630E18BC1E
	for <dm-devel@lists.linux.dev>; Mon,  4 Nov 2024 07:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730705464; cv=none; b=ZH/C8t1IlS2GqZoSglCLMqcPb2LJAZUK5XvWqpYtJbQyKp5nhiVXB/uZ6856siXyCbLMZShV4CKIP++CKlx0c7HLpvIqRJjwIfFdi47aGcYm2BXsD6DMv9LMSIFwhah+GzJOdAh8NfXtMFKW7LnCBvDhSOxiu9FmixCheoNvYOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730705464; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oTES3OlcTGKHuhsMRi6Mxc+E0qjBqf6lyVshdomQpjnaqBRLzYA/0Jx/k+JvAkOg9xrGxA3U3I/IPz14CP1zcq5anJ4TL3/UAX7iWqaON04TuATIZq/2z1+/yQvJm0KvKs98piI8fTi5DP7DTgyICpRZmDU/qUbpXyRg/w85R+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id DAA9F68AFE; Mon,  4 Nov 2024 08:30:58 +0100 (CET)
Date: Mon, 4 Nov 2024 08:30:58 +0100
From: Christoph Hellwig <hch@lst.de>
To: Benjamin Coddington <bcodding@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Christoph Hellwig <hch@lst.de>, dm-devel@lists.linux.dev,
	linux-nfs@vger.kernel.org
Subject: Re: [PATCH v2] dm: add support for get_unique_id
Message-ID: <20241104073058.GA20575@lst.de>
References: <701894fdf55ce2cb379eb26f6ee0536f96103ab9.1730387019.git.bcodding@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <701894fdf55ce2cb379eb26f6ee0536f96103ab9.1730387019.git.bcodding@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


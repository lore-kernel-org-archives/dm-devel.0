Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E112325630
	for <dm-devel@lists.linux.dev>; Fri,  5 Apr 2024 07:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712300555; cv=none; b=eEnurwn/uDMkDU2bGxP3UwwMAbhC6xbrg+v4y64YgJQI3Sfd8NaEPKEpIHqEEV3SHmWvcRpjqilfTfBWsBR55aAyAX6lFgVGAnKSWs4+/AU4qdUPxZn18IRzqtrwBlkzrALaDemv7/UEvPJFsqzcRnh7Y8Vh3TKjqdlX8ZFt/mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712300555; c=relaxed/simple;
	bh=x0VlMOo5EC4DCAaUp9PKKB+8k0MIf062fU67NkWmMbM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p4Z5v1zDXxxg+tXzsZr9ZErxEYj2hJaA+vt9VvOrh6qOppFnT6nVs4lLk7yYdo1ch/lWdRVHMicSqx+74c5WlHsUUHLXpCPXMj7o1qO1P7zj/ixjZL3j9IsNOQVnpcHwjk3yqMLSz9uz4eXCf01tNn6blHlxYYu7KTVD/aNmcLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2C8E268D07; Fri,  5 Apr 2024 09:02:30 +0200 (CEST)
Date: Fri, 5 Apr 2024 09:02:29 +0200
From: Christoph Hellwig <hch@lst.de>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, eblake@redhat.com,
	Alasdair Kergon <agk@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev,
	David Teigland <teigland@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Joe Thornber <ejt@redhat.com>
Subject: Re: [RFC 0/9] block: add llseek(SEEK_HOLE/SEEK_DATA) support
Message-ID: <20240405070229.GB4176@lst.de>
References: <20240328203910.2370087-1-stefanha@redhat.com> <20240402122617.GA30720@lst.de> <20240402130446.GA2496428@fedora>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240402130446.GA2496428@fedora>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Apr 02, 2024 at 09:04:46AM -0400, Stefan Hajnoczi wrote:
> Hi Christoph,
> There is a 1:1 mapping when when the Logical Block Provisioning Read
> Zeroes (LBPRZ) field is set to xx1b in the Logical Block Provisioning
> VPD page.

Yes.  NVMe also has a similar field, but ATA does not.


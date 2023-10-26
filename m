Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C723713FEB
	for <dm-devel@lists.linux.dev>; Thu, 26 Oct 2023 10:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by verein.lst.de (Postfix, from userid 2407)
	id 29C3B68AFE; Thu, 26 Oct 2023 12:55:01 +0200 (CEST)
Date: Thu, 26 Oct 2023 12:55:00 +0200
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>
Subject: Re: [PATCH v3] dm: error: Add support for zoned block devices
Message-ID: <20231026105500.GA31355@lst.de>
References: <20231026051205.95209-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231026051205.95209-1-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Oct 26, 2023 at 02:12:05PM +0900, Damien Le Moal wrote:
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

This new version still works fine for xfstests:

Tested--by: Christoph Hellwig <hch@lst.de>

Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 700CA18F2CD
	for <dm-devel@lists.linux.dev>; Wed,  5 Jun 2024 07:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717574131; cv=none; b=NAU21aQjyUDw4zEjD1/4GJXceHWQMizYL/EItWx8YH9D4iAr2Ud192h+nDR1cd75F5Iw6I2+FPrVaKJY/TMl6b+7xJal5233t+Y1srBOqb0gvzfIzjt7iXfBE5SBra9CwGq6PmQ3E500wS6P5YBuSzCSeTMur57oIGsaIkYIqZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717574131; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BSMOLroE8ZrlVcBq9CmC49V/DRSF5ZhBClUgsHX2fCMd7BT6KYgnPDpLSfv5vWwahS4bNhdVd+uVvLwzK/KgQy69YA6nYla2bDE7uzCuIQ/0g0y+/WzSNAeNc60orLbfm/9sZYmG02uNHq/nyQL2kjss4DMurszrHUsbOYWQG/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6DC3068D45; Wed,  5 Jun 2024 09:55:27 +0200 (CEST)
Date: Wed, 5 Jun 2024 09:55:26 +0200
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH v4 3/3] dm: Remove unused macro DM_ZONE_INVALID_WP_OFST
Message-ID: <20240605075526.GC18465@lst.de>
References: <20240605075144.153141-1-dlemoal@kernel.org> <20240605075144.153141-4-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240605075144.153141-4-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

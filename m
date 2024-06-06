Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AF6F13BC02
	for <dm-devel@lists.linux.dev>; Thu,  6 Jun 2024 07:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717660778; cv=none; b=pvf/r9c7EU6M+g7FgE/KFCeyfQF+MCALTwqOTQCJvgvY1omaOWIS4lN11HagroNT8LGSclaPctXy7aeOwKH0OJRXNVAb3zu1tKq/etbMVDXvXsl61PJ1mwE1vt69IY5lB15oxHRFbWb0ynnNBDQVDWreaihHmAxDRLEZdmWKcmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717660778; c=relaxed/simple;
	bh=VAWQ5vRCmlzmqenDauDZt+uV+cu+Elj9KTnjP+mP+rU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I+w9jqb9t7X/Hm8b1Yurz3ZGyE7ZrSTPc+Quoa1SarHPX8KEbthM3XgnV9vxBqCEz8EEoMFnsTaNALe1dhhIxpTjeGf43YSdCIn9atJFbCS50zmxnol5Ux8vAmEmWgvR/ilPeIWvHmxDbMZ5wUJIOPq8CXh18DXUS/A4H3Dr2hQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id BA01868D05; Thu,  6 Jun 2024 09:59:34 +0200 (CEST)
Date: Thu, 6 Jun 2024 09:59:34 +0200
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH v5 0/4] Fix DM zone resource limits stacking
Message-ID: <20240606075934.GC14059@lst.de>
References: <20240606073721.88621-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240606073721.88621-1-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Vaguely related:  should we add you to MAINTAINERS for
drivers/md/dm-zone* so that you always are in the loop for changes
to this code?


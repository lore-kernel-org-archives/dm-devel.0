Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A6DA54BFF
	for <dm-devel@lists.linux.dev>; Tue, 26 Mar 2024 06:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711435159; cv=none; b=TzPXTtzBeGFDatv3LkRCTbpXNY3UbMoIsStymYdu37hTOiO+0VsFyT5+dfbncqEjxeTNiOhDyhfBgfzFUFrY3vPK4oPbtkbIPvUkkwy83Hkh80pCchOfg54nkioUC8t6OxmIdYlyvSF99a570TIWVQS9xxxmXzO8RPRBYmnDSss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711435159; c=relaxed/simple;
	bh=jrfmVvT3S7W+clvvumpDWCaHkWdg/2lgMSWBhMBZGXE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tWoX1dcLMJ0F/Clmq5VrcJkLaXnSY+F87NewAxp6ehpIq+89qZ0ZsSiUPK5EK/tQM1CIqFZ5ST6ykyz3H0Pa+7keG5ndwv6oBSSc3rGReTcGuLMb6D+XbopUKPR1Xdoz+qnX1aFB4q5r6f7FXqwTBohutFhm1LVZaPkVh1TW814=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 205A968D37; Tue, 26 Mar 2024 07:39:15 +0100 (CET)
Date: Tue, 26 Mar 2024 07:39:14 +0100
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 04/28] block: Introduce bio_straddle_zones() and
 bio_offset_from_zone_start()
Message-ID: <20240326063914.GC7696@lst.de>
References: <20240325044452.3125418-1-dlemoal@kernel.org> <20240325044452.3125418-5-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240325044452.3125418-5-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Mar 25, 2024 at 01:44:28PM +0900, Damien Le Moal wrote:
> Implement the inline helper functions bio_straddle_zones() and
> bio_offset_from_zone_start() to respectively test if a BIO crosses a
> zone boundary (the start sector and last sector belong to different
> zones) and to obtain the offset of a BIO from the start sector of its
> target zone.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

(the grammar fix from Bart looks good as well)

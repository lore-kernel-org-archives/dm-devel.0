Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 595624F5E9;
	Thu, 11 Jan 2024 16:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pteigrTr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=RqU6HvZs4Kq0wnSSL88DrQTIrVl4ghYjG7xpZqYFRR0=; b=pteigrTrJgSzguI6Itz3JzRufi
	+7HE8ubR7rR9ptFbyJ6XsLdmO/cFnRrDeP+U1FY+jRV9WFU79URWsFLerw8NQ3dtsp5clOHRj+aOC
	ssfRtRhzxVJo5O3XWISniHdt/RuyjPZgq4rrU2E3WEsi0KRU3na66wOnaCOgvbch1jILW6X0qNHQg
	Dc475dh8SeNX2eYJuQsotXrChRvhE6E5wu1zcQ4ALsNLEATGSHGTMW7Ez3HSPEi5LVYqN5BOrViWp
	Hz5fH6PEedU+hDdtwV7QQL80XDBPN50/6Pkt9T3Nw6xWKd9kwPWeiWDTpsSXqcynebxKb/OLxaVCC
	HDLW8Rcg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rNxbS-000XdE-27;
	Thu, 11 Jan 2024 16:08:22 +0000
Date: Thu, 11 Jan 2024 08:08:22 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, martin.petersen@oracle.com,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev
Subject: Re: [PATCHSET 0/3] Integrity cleanups and optimization
Message-ID: <ZaASdg+NkFFy8Khx@infradead.org>
References: <20240111160226.1936351-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240111160226.1936351-1-axboe@kernel.dk>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Jan 11, 2024 at 09:00:18AM -0700, Jens Axboe wrote:
> Hi,
> 
> 1 gets rid of the dummy nop profile, 2 marks the queue as having an
> actual profile, and 3 avoids calling into bio_integrity_prep() if we
> don't have a profile. This both reduces code (getting rid of the nop
> profile) and reduces the overhead of the standard setup of having
> integrity enabled in kconfig, yet not using a device with an integrity
> profile.

Bw, can someone help with what dm_integrity_profile is for?
It is basically identical to the no-op one, just with a different
name.  With the no-op removal it is the only one outside of the pi
once, and killing it would really help with some de-virtualization
I've looked at a while ago.

Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C14C4192B95;
	Wed,  5 Feb 2025 16:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738771246; cv=none; b=DQRudB+DUX6nGPfjRmyh5AV4Yg7Nsocx59kWn4x7pF2NuguCA32WqEUs3E3jaGOIppnP0lTRC/2iQzgX2f19TajJOOq1d6K73um7TTiPgUH3TPmxPH8s99xpK9qzGFTN63O5AldYF0yaJTaEul5gdQ/RJg28bK91fyg6B1yTVAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738771246; c=relaxed/simple;
	bh=+eZI6yISLtOCNguyEuiajeh+jRXwEj3Tqhyr4xhrF/0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cv0ocfH5iBzLiRYes42DVedW6e08/atLT4mMA1ngeMQlOxn7IpMwxB3GHSly/3cEzg+4hol4f0CBai7iRRwMqJK40gCJeYlN/PSGaMA+SgaEcLC3lzY6M3GRqnt8RvQh2GqBwHiNCg4X9FShDIVdYWuGBO6JziGdnrDcoRTnag8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=G5IbGVuC; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="G5IbGVuC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=kHkOXmc0WL3fracXvIpybHt4FahneUTnJB7/Y+AClqo=; b=G5IbGVuCdXQeN9GGhWKEizwf5n
	jgZGhsG1JjkGjXUSvbGBHWtCPyIDDFPYqpcexFpYPBPiorZHz1Cng3YzJ9O+XGpQUjNngyFkNCynw
	UIBBBrB7xYuHKdkdOkLpGGLgdE4hjXWMyENPD1Y99HTdGOS/5CmwNA3n37VzbVJmatWH1tGCUHa0I
	5t4fddwmIvZTkqmepGGp0ernbZK3EzyED2eT7oNUHfF4bJgIHnZ7c4Q/s5IEVuwU22CyQocUDUsKZ
	ZdSWk5Fth/pij80JV1cxjS5vQUQlvi+OckO2huG3KyLLOLHpuTdQgsOc7QE4R1mKayfknbs/WHUqZ
	9rXImOjQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tfhpQ-00000003sxd-3RkR;
	Wed, 05 Feb 2025 16:00:40 +0000
Date: Wed, 5 Feb 2025 08:00:40 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Mikulas Patocka <mpatocka@redhat.com>, Jens Axboe <axboe@kernel.dk>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Zdenek Kabelac <zkabelac@redhat.com>,
	Milan Broz <gmazyland@gmail.com>, linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev
Subject: Re: [PATCH] blk-settings: round down io_opt to at least 4K
Message-ID: <Z6OLKInjfd1QxXRI@infradead.org>
References: <81b399f6-55f5-4aa2-0f31-8b4f8a44e6a4@redhat.com>
 <Z5CMPdUFNj0SvzpE@infradead.org>
 <e53588c8-77f0-5751-ad27-d6a3c4f88634@redhat.com>
 <yq1cyfykgng.fsf@ca-mkp.ca.oracle.com>
 <28dcf41a-db7d-f8e7-d6b7-acef325c758c@redhat.com>
 <yq1bjviflwb.fsf@ca-mkp.ca.oracle.com>
 <Z6GsWU9tt6dYfqBL@infradead.org>
 <yq1zfj1eusl.fsf@ca-mkp.ca.oracle.com>
 <Z6IbGNYoY6DjjYpG@infradead.org>
 <yq1ikppdsv3.fsf@ca-mkp.ca.oracle.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1ikppdsv3.fsf@ca-mkp.ca.oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Feb 04, 2025 at 09:36:46PM -0500, Martin K. Petersen wrote:
> 
> Christoph,
> 
> >> Quite a few SCSI devices report 0xffff to indicate that the optimal
> >> transfer length is the same as the maximum transfer length which for
> >> low-byte commands is capped at 0xffff. That's where the odd value comes
> >> from in some cases.
> >
> > Hmm, optimal == max is odd,
> 
> What they mean to convey is that "device has no constraints". As opposed
> to a value of 0 which means "not reported".

I'm pretty sure that confuses some users, given normally optimal == lba
size mean not reported.  Either way we really need to document these
somewhere.


Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD3BF2045A6;
	Tue,  4 Mar 2025 13:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741096195; cv=none; b=K1Sdmy24JGF1y31u/7uJ7r7yk7+JbfU1aJtbSIfpD1c4B5+GUUA66b8cakaS+9a/H4RIasouH5aYX7/25xOP33uqKM5IK/6N7PUDjCJZFSl+PWQeqlczvS04vKGtfclsWC1lMzvHflMuBWSbsVR/uzGGsZkPQvBlaF5EHtAp+EU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741096195; c=relaxed/simple;
	bh=KHHcDaudjfP4u0p/+Ih+DTSAdyY6lXkDxSOUsZ7Ewew=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oWF0CMP1C6FETL4XE/EwMbBgTMsgNkFCzS9F9yeu4o1+F27gqImMzfVVs9iUGIzZgHSihQcdMwKyI6ceaSkC2bPlnYVvYli7Ebybj0iRCjUbkVlnK/ksEoDMcgZxEe+oPANX2VCkThUJxrdMFWTa5IpOhXAkDPYwa189NG2yndQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GZ2pKHpZ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GZ2pKHpZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=pDnPDI97a7aET7imOLMNEqHsZIh7T+bfAPBqUaDDehI=; b=GZ2pKHpZSS5hKapeMQF+nRfLGH
	abN6Dctk9OeIScyIH1Pm2F5OJffxhFY+mx1cL7MG/eL9Upx3bKjYvglZLjNKtCyiI2tlZEjcucnVl
	ofWCt0dTk3rzrDnPvMq1a7xEpKREYrpM30r3E0e94uSiIf8f3fPGKlNHDhMWxL3xOzkAIcPUA4jAQ
	B5pdnC7+gvdeTBnp9n7vMEjwVa0jGwbtOaqFkzSwOUwZaswq2tVoWEi/yn4F6nWgFHwarDBlIXpOd
	/TKajq34mS6+BcTKlF6X4/Lr3zwOZpAg3+p9oBn5/QPSk/uUMMKiZmjBxg6y2tH3gX3xnu8r1NsGy
	uGpaInew==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tpSed-00000004qEw-1OIP;
	Tue, 04 Mar 2025 13:49:51 +0000
Date: Tue, 4 Mar 2025 05:49:51 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
	Jooyung Han <jooyung@google.com>, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Heinz Mauelshagen <heinzm@redhat.com>, zkabelac@redhat.com,
	dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] the dm-loop target
Message-ID: <Z8cE_4KSKHe5-J3e@infradead.org>
References: <7d6ae2c9-df8e-50d0-7ad6-b787cb3cfab4@redhat.com>
 <Z8W1q6OYKIgnfauA@infradead.org>
 <b3caee06-c798-420e-f39f-f500b3ea68ca@redhat.com>
 <Z8XlvU0o3C5hAAaM@infradead.org>
 <8adb8df2-0c75-592d-bc3e-5609bb8de8d8@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8adb8df2-0c75-592d-bc3e-5609bb8de8d8@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Mar 03, 2025 at 10:03:42PM +0100, Mikulas Patocka wrote:
> Swapfile does ahead of time mapping.

It does.  But it is:

 a) protected against modification by the S_SWAPFILE flag and checked
    for full allocation first
 b) something we want to get rid of because even with the above it is
    rather problematic

> And I just looked at what swapfile 
> does and copied the logic into dm-loop. If swapfile is not broken, how 
> could dm-loop be broken?

As said above, swapfile works around the brokenness in ways that you
can't.  And just blindly copying old code without understanding it is
never a good idea.

> 
> > > Would Jens Axboe agree to merge the dm-loop logic into the existing loop 
> > > driver?
> > 
> > What logic?
> 
> The ahead-of-time mapping.

As said multiple times you can't do that.  The block mapping is
file system private information.


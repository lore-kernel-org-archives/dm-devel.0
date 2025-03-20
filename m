Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A797419F103;
	Thu, 20 Mar 2025 05:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742448383; cv=none; b=WRqDmhcZwKy1JY4mtpu7BmyTRY9dWn1BpKsE11mouNZMvL8K3NzqR8XujZUx1AL00ZKisp5YZy+1hcI09Bz0pCxxekwvBa5Kp7R9RTEB18d3VxPnhWT6iRgNW+QXSqHRmkjmj5YRKQOfUnaqBNjyy3v+sfOdYgXDKM7IILufnrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742448383; c=relaxed/simple;
	bh=CMvXFlGji2WL4ZwjBmj7fOgEpQeC75Pxnu8TpGrYv+Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QcSYRCiSJwV4dQKF7QdPisk+WY8apSk8vEHW6fAEMajUs8N6lJjW6KHOCup5l6I5KoQVBQoV6cOqKB/enW36UXhaJKVbrVMLU5GLnRCVXFY6/OKffeZF/0vyj9r8RYb+t/Rs9aoGo4+IWySmaYkfiMrY8GOBip75YOOG1yZv5Ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=38zCanUF; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="38zCanUF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=kObeWsSN0DZo8q5Tjh7xRjzIZ3ERaIwegvSR1wk7ZK8=; b=38zCanUFeeI6ZNWOGJqJ7jNkZ6
	7jS7cr13EeW6+8rJ3d3QLPdnI4y5H5pnUf1T3jKl5JZQri3aR0ZXA8riD+7sqNAddgP9tMQjk6S9G
	7sZo2dOT+/Hb8CcWas5fNhNt3eHaZ+5Y7a3sQ7Oyk+nj2pT4poN7TXZniaa3TerM2amMe/Pidfa1m
	AGKmrI2nKXbTirD7k8okGOMPwnrJEqW6eCIbTlY8sVn63eEVQBSBNOOV2crvSOZJECUSYrQNZXX86
	RSqwDPWEV/V2fyZdpvqWeswZNKZkTYL3pzivq9uNjFm0uliDZ/MW/A0b8eNR37i/1sT2ZWm3F5JQK
	DZ++rHlA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tv8Q5-0000000BDTZ-0RBp;
	Thu, 20 Mar 2025 05:26:17 +0000
Date: Wed, 19 Mar 2025 22:26:17 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Ming Lei <ming.lei@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	linux-block@vger.kernel.org, dm-devel@lists.linux.dev
Subject: Re: [PATC] block: update queue limits atomically
Message-ID: <Z9um-cheiIRe_QV1@infradead.org>
References: <ee66a4f2-ecc4-68d2-4594-a0bcba7ffe9c@redhat.com>
 <Z9mJmlhmZwnOlnqT@fedora>
 <d5193df0-5944-8cf6-7eb6-26adf191269e@redhat.com>
 <Z9ocUCrvXQRJHFVY@fedora>
 <6ebdd2ae-8fc2-4072-b131-a7c0da56d3f2@kernel.dk>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6ebdd2ae-8fc2-4072-b131-a7c0da56d3f2@kernel.dk>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Mar 18, 2025 at 07:58:09PM -0600, Jens Axboe wrote:
> Agree - it'd be much better to have the bio drivers provide the same
> guarantees that we get on the request side, rather than play games with
> this and pretend that concurrent update and usage is fine.

Exactly.  That is long overdue.

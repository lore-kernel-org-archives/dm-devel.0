Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68D952500C8
	for <dm-devel@lists.linux.dev>; Mon, 25 Nov 2024 05:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732510861; cv=none; b=fDmozS7Qphdcl35/v9hCe+wMgnmlWBIcjGROA5HrDcKtxm9XA7CgjIUbeW0+M3Z1V34GkXDiLnDuYFY0L0Uda2kt2TxfXxXu4lzN1nATlTV2esQlCSUA1mbZ6QvaOUcEN6nR8ZFdtCyehWrghLZNR+kSWiGJ1u/2/Qx7/NV8q2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732510861; c=relaxed/simple;
	bh=3e+/dGuw1K4suNzZ5H2DG1e/Pd0A6YVkvt6DO/jClGA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OiOjcXyQof3zMjSJOITKRfZMAy1606qpPBbRFWLovlCrrSYk07oOU5Gx1pF6Nih40BZbMEPDdxAsTMC1pAJX4ywZicC5jEiLslT35cAl/mXP1IVyXv5hzPYH+lMvQRippZO9/VA4mY31KnQAtDv07sudm/qDirPxqiGh8L6I2RM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=d2LCLy45; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="d2LCLy45"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=51XvPGVMmSyLlKIup0mMe2tYqM2X0GrcyAo5hOyg+O0=; b=d2LCLy45aosdd+nheCFKM1hh+i
	5FHWC5ShOwQwB6mo+uux3fxZUMcNef/FDpm0wzXt+WAakNKWPj483i30DUgLeJIe8JNVkXUHgAEcj
	HuX1PmElk8fRSr4K6FSCUaBj9ecWqTPhnCx7WiyXWiWgqmlhKH8siVH5KDc5FxoppVOQFOwv7dOv3
	BMsVzrNHp4BldqV/bvB7IapxQAyXmDEJynsGO62w6T0B/eYqWrZNVOtW0C1sq8jEEplDjftViiAhr
	m/CgvLgNLocOPnl4trF4/LVn6DhOj6wViP8om5swogJ278AFXyUQ+3wr9vHr/cnla1m/rn25HFk+D
	0wVT7m6Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tFRDQ-000000073ab-3EhX;
	Mon, 25 Nov 2024 05:00:52 +0000
Date: Sun, 24 Nov 2024 21:00:52 -0800
From: Christoph Hellwig <hch@infradead.org>
To: LongPing Wei <weilongping@oppo.com>
Cc: dm-devel@lists.linux.dev, snitzer@redhat.com, dlemoal@kernel.org,
	bvanassche@acm.org, ebiggers@google.com
Subject: Re: [PATCH] dm-crypt: set max_io_len as chunk_sectors of zoned device
Message-ID: <Z0QEhGYYmH6R5QRE@infradead.org>
References: <20241125032250.1329977-1-weilongping@oppo.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241125032250.1329977-1-weilongping@oppo.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Nov 25, 2024 at 11:22:51AM +0800, LongPing Wei wrote:
> When dm level submit a bio with bi_size > max_sectors_kb of lower device,
> blk_mq_submit_bio will split it into several ones with limited bi_size.
> It may be a potential unordered issue as it breaks the ZWL design in dm
> on 6.6.

What is ZWL?  And why mention 6.6?  And why do you care about ordering?
There is no real ordering requirement in the block layer.


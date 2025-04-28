Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 889B926A1DB;
	Mon, 28 Apr 2025 13:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745845717; cv=none; b=q44NRgPM3ZEZgj63ueOPM4mrFZI9DrOre1B44JLiXeCu+MYE+UyoAWTrrTozvIxfKBrDka6mWWS4Tt9kjxx+WwUFEEQv1OlOD+7Hg02edOwWW5j+0W3tbPU34IThWn2bC41g2na+SQ3a3nxQgEZli3UZ0I4UMsE69eS/OD6Jgss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745845717; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NdtZRn5Nbbb46mSLs0fZyxwpyLI6JioQ5eQffJaZQI0FQwQ5TG8n86Fi3LpA+AujHuL/Ea7+Cx29DodZ0RH9yfJs6hbC+DMoy+SAv7sIhCAKsg66cwvCzwEFOJ8W/D6QMJ2p6FhIujNbh/ZHwv26UNESEK0AUyXXTVkjHRQdUhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xdLUZSVQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xdLUZSVQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=xdLUZSVQESXDzJk4Hprsv9hcWg
	xB4EyPkU6n1C52I+g80IWfgM528Tjmc/wg8ceUXj+kNWub0WHf2EwsDOuvyPO5JVYY/wBrMQJKGaE
	tmZvJWFx53qsVYE9vmjzQKsuk/ce0hg+D5onvjH24Aw1Qqif6ldkAOLNVttX629TXwpdT1/lI/mEF
	8nB517a3zi9JYPzWvUyibdXrGMt6ETMzL/Ld9XE5Oii9lOmpbZjbt6RTCVYYvWUGokSahsWb3Bxxz
	bVwbhVDGA7OPm5vw5BxNL53XpPWVlIEFlKJeZwKfc0u/senyYpvAoPkkJi/WVP8ni8avnUEzxMvEX
	an6jyjXQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u9ODo-00000006OOb-2ZKl;
	Mon, 28 Apr 2025 13:08:32 +0000
Date: Mon, 28 Apr 2025 06:08:32 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@infradead.org, axboe@kernel.dk, xni@redhat.com, agk@redhat.com,
	snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
	yukuai3@huawei.com, cl@linux.com, nadav.amit@gmail.com,
	ubizjak@gmail.com, akpm@linux-foundation.org,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
	yi.zhang@huawei.com, yangerkun@huawei.com, johnny.chenyi@huawei.com
Subject: Re: [PATCH v2 4/9] block: cleanup blk_mq_in_flight_rw()
Message-ID: <aA990Fi-DaEPVdUj@infradead.org>
References: <20250427082928.131295-1-yukuai1@huaweicloud.com>
 <20250427082928.131295-5-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250427082928.131295-5-yukuai1@huaweicloud.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


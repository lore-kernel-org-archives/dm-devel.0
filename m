Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F3C741441E;
	Tue, 22 Sep 2026 21:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790112918; cv=none; b=KMoPTfMQsaOwEFroXeW0kPfvK+PTLV9wISHizqA70+lLalssxm7yvjUKox4YTLuvSPoVkzE2X7nE9SjNTwUZcB7Jw32nEVMyYdAy+azE6JrRhh2nlqsNnmIuLFMks1VuZLTxZg8zHQkS1IRbroAw67sF/Aw+uevrwrgEDcFBxvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790112918; c=relaxed/simple;
	bh=CJqmSsJNgTL5Qg84jOb7bnXjffM7+hN0T0ahRGVg3Lk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mkePcfkjoTex1UGLFCOVsKlPntXEIgB8PHsiLQ6CCXrqZh05biC9ERU+lAsLqRwRMArcK+bS1VgmGqSaJwDk0gjU4l1GUQlMyCQUOsDK7jGpwdALTE1imNkmojir0k69oPjeACmRYk0hmwTjhiGeFWelRkeTtHZKFBQ5D07xhZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n2jQnxtR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n2jQnxtR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CF8A1F000FF;
	Tue, 22 Sep 2026 21:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790112898;
	bh=OgO2lUv+PN5nmIjTbBEO0TBCwATK6UQZpyPK4y04oCo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=n2jQnxtRuItYW45YelYcAUWL5h6CglGegPutrBJcavDJk73eNR7NCCziuiA5J9TdV
	 89nbMALGS3RPnjpav1pPxsirLMFxV8fnaNN7OX6LBz1GRAVvSK05Eujmk3XnzT72RG
	 2V/7h8NGKNWWkd7wCBRCGrbC1b2H1uE5ogGpH6tRkq/OSvvzR6vyDTpXb/i2fC2F/J
	 ymwbu3YBfmVKuOHs+sYoC6JSBaLD1xpujb6RJJp3WIJUlvIkHBm0/FQgp3apbqRf7Y
	 e4p6z3Y7c7swna8EME3XLqZWzHdogE6y/TDxHIOzl6PFVlSrz1LBUH24trz5jkTpFA
	 t4DdIwybHFCuQ==
Date: Tue, 22 Sep 2026 21:34:57 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Itai Handler <itai.handler@gmail.com>
Cc: Milan Broz <gmazyland@gmail.com>, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>, dm-devel@lists.linux.dev,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/1] dm-crypt: allow encryption sector size up to
 PAGE_SIZE
Message-ID: <20260922213457.GA3536981@google.com>
References: <20260922120330.127262-1-itai.handler@gmail.com>
 <07e750dc-570b-4f69-9ec3-68de51416a06@gmail.com>
 <20260922134945.667305-1-itai.handler@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260922134945.667305-1-itai.handler@gmail.com>

On Tue, Sep 22, 2026 at 04:49:45PM +0300, Itai Handler wrote:
> Storage is not the use case - crypto offload is.
> 
> Where the cipher is a hardware engine driven over DMA, the per-request
> cost is a descriptor setup and a round trip, and that cost dominates.
> Making the request sixteen times larger amortises it. With the in-tree
> qce driver on an arm64 64k-page board, plain dm-crypt over a ramdisk,
> MB/s:

That isn't a real use case, though.  Using the QCE driver is *much*
slower than just using the encryption on the CPU, even on long messages.
That's been established in many previous discussions and is now even
admitted by the maintainers of the QCE driver.  The QCE driver even
(incredibly) uses more CPU time than just doing the crypto on the CPU,
due to all its driver, scheduling, and IRQ overhead.  The pending
patches to add BAM locking will make it even slower.

The fix is to not use QCE.  (And also ensure that
CONFIG_CRYPTO_AES_ARM64_CE_BLK=y is set, to get the ARMv8 CE accelerated
code.  But even on legacy CPUs without ARMv8 CE, QCE is still slower.)

Unsurprisingly, the numbers in this patch's cover letter show this as
well, with much higher throughput reported for the CPU-based encryption.

(Also note that QCE is currently marked as BROKEN upstream.)

I really do not think dm-crypt should accept changes to further
accommodate obsolete and problematic external crypto engines like this.

- Eric

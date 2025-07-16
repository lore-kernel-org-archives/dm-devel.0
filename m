Received: from crustead.live (unknown [185.240.86.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A14CE381BA
	for <dm-devel@lists.linux.dev>; Thu, 17 Jul 2025 00:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.240.86.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752713452; cv=none; b=Q6Mrg7PuzHr6rdE79S+28HnK2bXGwBpkmj7cSOszNLqsMqrzE+HNlzILts3biktRv6a6IZN8K7V6WkNboH+yMPk2odzkXyaYkOc66B5zpjukvEH0LJA5NbF3+sjF/SUCWirOJXb4NuAKWQWxPGDC5PR/hGfVlYqIpB8tZU7j1xE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752713452; c=relaxed/simple;
	bh=YkeXptbKk1aL+Eckbf34QyKNtNNAnTcbB0UAwwnln1A=;
	h=To:Subject:Date:From:Message-ID:MIME-Version:Content-Type; b=I6Sw3nQ9DTVWsQ3jzNja0MCnJDIvQt04G8JNdfS28AfVA2/nlUzKmboJcPbvzwFMcAOdNJEJazIFsrYUNWa5lYdds9/MxbJ6KsN7T0avR7EnxWFfSXK04LNmXeyFJlNIACFRmBoGt0i4A/LUPe1jnL1kNS1ccdt6CN34Y5hz+Ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=crustead.live; spf=pass smtp.mailfrom=crustead.live; dkim=pass (1024-bit key) header.d=crustead.live header.i=@crustead.live header.b=K5b+dUay; arc=none smtp.client-ip=185.240.86.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=crustead.live
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=crustead.live
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=crustead.live header.i=@crustead.live header.b="K5b+dUay"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=crustead.live; s=mail; h=Content-Type:MIME-Version:Message-ID:Reply-To:From
	:Date:Subject:To:Sender:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=YkeXptbKk1aL+Eckbf34QyKNtNNAnTcbB0UAwwnln1A=; b=K5b+dUayLE9fDMGhDmJDaxF4zm
	D15Fu4wVNtsy8h8conOdbqM+x4oLmWTOOyA51Y7CCRAXWLS8lDN2Y/KL1tS4tRPZiU0p72GjWFIGi
	6fpU3xWZNE5h6BvJDfJ+QpH2eQgaXrm7LGjr2mlQlMz4If3ixDR6E37O0r7SzUOg3QtA=;
Received: from admin by crustead.live with local (Exim 4.90_1)
	(envelope-from <support@crustead.live>)
	id 1ubv46-000FS4-Ur
	for dm-devel@lists.linux.dev; Wed, 16 Jul 2025 05:52:26 +0000
To: dm-devel@lists.linux.dev
Subject: MDC Vendor/ Supplier Registration
Date: Wed, 16 Jul 2025 05:52:26 +0000
From: Makati Development Corporation <support@crustead.live>
Reply-To: vendorprocurement@mdcph.com
Message-ID: <a893fa9dc3026715cf1b9632d45269e3@crustead.live>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8

Greetings,

We are excited to announce that Makati Development Corporation Vendor & Supplier Registration is now open.

If you would like to be considered as one of our valued partners, just share the following details:

* Company profile

* Contact Person or company representative

Please send your reply to: vendorprocurement@mdcph.com

Looking forward to building something great together.

Warm regards,
Vendor Procurement & Contracts
Shared Services Centre | Makati Development Corporation


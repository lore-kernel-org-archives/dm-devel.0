Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [104.223.66.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CAB028691
	for <dm-devel@lists.linux.dev>; Tue,  7 Jan 2025 02:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=104.223.66.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736216091; cv=none; b=YI5FsP2W0vzJQPVoZbLdIEFezEbxzCXJt2OMdvIlbS/OMTsq4P9v7vJunfN3+4Asxkxhc2267KnNun/fa50dO0GO/qrjGdeP7Gcd5p/RE20Yle88SlT5aZ7UsjSUWfkmBNwskzCSqpWCv3w+UVChIF+l8CoRXNNlyvA6QQTD5UM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736216091; c=relaxed/simple;
	bh=LSH7k3aBsu6QWjlWU6H1nsxeGErD9YKipX9eIxwly+s=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VGRDDpenov11+jILASv/dD9861A+KqGAhnLPzw0E+PwQP88V1iFxCCy5mrAzZMZxDCD7BUR401Y+/BK2HeX36MNfVtUIGrX6PdPZISeEjiTZOKVKzOGO0UdVDb/vGzHsguVItz5ZpEg3ehgXRgLMFO+6Sq9NFox0R79a6SzLsaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=Dz2RB5jP; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=Dz2RB5jP; arc=none smtp.client-ip=104.223.66.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="Dz2RB5jP";
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="Dz2RB5jP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1736215496;
	bh=LSH7k3aBsu6QWjlWU6H1nsxeGErD9YKipX9eIxwly+s=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=Dz2RB5jPvRE5UkhxFEAt+llhnNdPJFW/yT4+gu6Yu+NN2hjU8ykQ/CffdBYf51Gg5
	 5ZzQQmSZZoUt5DkZnoeBQvRTO5dgzZ7K23UcfInHBlACX3KuJpCNRWU1uQa9qM+Fu3
	 G4cIVoRFPQx+VsEk62hS6Ebln7LApvEdO5yFx5MM=
Received: from localhost (localhost [127.0.0.1])
	by bedivere.hansenpartnership.com (Postfix) with ESMTP id AF36B12868D5;
	Mon, 06 Jan 2025 21:04:56 -0500 (EST)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
 by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavis, port 10024)
 with ESMTP id Pt944bzZ_47y; Mon,  6 Jan 2025 21:04:56 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1736215496;
	bh=LSH7k3aBsu6QWjlWU6H1nsxeGErD9YKipX9eIxwly+s=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=Dz2RB5jPvRE5UkhxFEAt+llhnNdPJFW/yT4+gu6Yu+NN2hjU8ykQ/CffdBYf51Gg5
	 5ZzQQmSZZoUt5DkZnoeBQvRTO5dgzZ7K23UcfInHBlACX3KuJpCNRWU1uQa9qM+Fu3
	 G4cIVoRFPQx+VsEk62hS6Ebln7LApvEdO5yFx5MM=
Received: from [172.20.4.117] (unknown [74.85.233.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 3E60E128636B;
	Mon, 06 Jan 2025 21:04:56 -0500 (EST)
Message-ID: <cb49d8ca786fd0e51947e83e74036a6c00f75e2e.camel@HansenPartnership.com>
Subject: Re: [discussion] proposal to bypass zero data for dm-crypt
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Yu Kuai <yukuai1@huaweicloud.com>, Alasdair Kergon <agk@redhat.com>, 
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
 dm-devel@lists.linux.dev, lkml <linux-kernel@vger.kernel.org>, "yukuai (C)"
 <yukuai3@huawei.com>
Date: Mon, 06 Jan 2025 18:04:54 -0800
In-Reply-To: <73152f2b-2a3e-37a7-4578-9a4ae7ec903f@huaweicloud.com>
References: <73152f2b-2a3e-37a7-4578-9a4ae7ec903f@huaweicloud.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Sat, 2024-12-21 at 10:34 +0800, Yu Kuai wrote:
> Background
> 
> We provide virtual machines for customers to use, which include an 
> important feature: in the initial state, the disks in the virtual 
> machine do not occupy actual storage space, and the data read by
> users is all zeros until the user writes data for the first time.
> This can save a large amount of storage.
> 
> Problem
> 
> However, after introducing dm-crypt, this feature has failed. Because
> we expect the data read by users in the initial state to be zero, we
> have to write all zeros from dm-crypt.

Why do you expect the user to read all zeros?  For DM crypt on a new
physical disk, we don't set the disk contents to an initial value
because there's no expectation on the part of the user that they can
read a sector they haven't written and get a sensible result instead of
the dm-crypt of whatever the sector contained.  Why can't your cloud
system just behave like a physical disk?

Even for an unencrypted physical disk, there's no expectation of any
particular value being in a sector, so why do your users have the
expectation of all zeros?

Regards,

James


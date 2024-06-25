Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7492517A931
	for <dm-devel@lists.linux.dev>; Tue, 25 Jun 2024 18:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719339557; cv=none; b=DuH4tWM4hrnu0W1qdxVsJVkgFvJ+G7pcwGLldduMRhF9roWLsoXtzGFslzKzY0YfW6WEFX6WNjNFApXBIuCtrxVVdXITX2HCoCkS9rWf14M4nT/DUr8eui76XIgWYKlOOuIgwFq9zM2AIL1fA2hN29RZ9SjyDxokysbs9VRKrgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719339557; c=relaxed/simple;
	bh=bKef7Avgq+mcJuGN8qxZn//nRWibbU3fWR0IDDoFJZU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p5g/ARumG9snNXKNKm7VN9blGSSrC0yAnl5PeCynZsGqYArE9vHaY8qibEsbEk9lR/8qgwIN7Ve+hjdMLOJmT2lBnTsM7qRaGMObgziAm7ourise3QwPkf5V+xc/OYyee1byBcgK4DyIBmTnAw1oWyMkx5c2WR5HNXNXLAv8JIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=VJtFrKlW; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="VJtFrKlW"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4W7tQ572yWz6Cnk9F;
	Tue, 25 Jun 2024 18:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1719339540; x=1721931541; bh=YzvkjLDvBzgff6/Y2UShPenz
	q+MiJByf5DuVF2Ma4LE=; b=VJtFrKlWbGSrbirv0j3fQqvdos967ZrYLzAxYJgm
	PXwvoE0aJJklxBf4QXD/c1iDHZop7cYBum5ylRh6MG+DHkP4noMMd9/wGUbD+CaP
	P2+4A4qB5jq3sTTummCbWw4jx3ZfypYZW6wJ1dhX8By6ha/HTnuyxALoaBdrEA0p
	9ed49lLfeZoa+DoMO2kJ5kIQUmeXeNSlZRQHnxk8jlVDNC+ffqKC8TrzL2NaI4SZ
	c+dUsSsmj8xofSXGA4qMOMyPgcvxz2uLthFm6DDhMTUpUQfNPIXmz80QQ7tfsoTm
	hIVbH9sPkKVIAXWFts/Ks3kvlDKUEl1ZmyhH2XxKcZ0voQ==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id AFhXlXXr1W3q; Tue, 25 Jun 2024 18:19:00 +0000 (UTC)
Received: from [100.96.154.26] (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4W7tPs1TX4z6Cnk97;
	Tue, 25 Jun 2024 18:18:56 +0000 (UTC)
Message-ID: <b5d93f2c-29fc-4ee4-9936-0f134abc8063@acm.org>
Date: Tue, 25 Jun 2024 11:18:56 -0700
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v20 02/12] Add infrastructure for copy offload in block
 and request layer.
To: Damien Le Moal <dlemoal@kernel.org>, Nitesh Shetty
 <nj.shetty@samsung.com>, Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Jonathan Corbet <corbet@lwn.net>,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>, Keith Busch <kbusch@kernel.org>,
 Sagi Grimberg <sagi@grimberg.me>, Chaitanya Kulkarni <kch@nvidia.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 martin.petersen@oracle.com, david@fromorbit.com, hare@suse.de,
 damien.lemoal@opensource.wdc.com, anuj20.g@samsung.com, joshi.k@samsung.com,
 nitheshshetty@gmail.com, gost.dev@samsung.com, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 dm-devel@lists.linux.dev, linux-nvme@lists.infradead.org,
 linux-fsdevel@vger.kernel.org
References: <eda6c198-3a29-4da4-94db-305cfe28d3d6@acm.org>
 <9f1ec1c1-e1b8-48ac-b7ff-8efb806a1bc8@kernel.org>
 <a866d5b5-5b01-44a2-9ccb-63bf30aa8a51@acm.org>
 <665850bd.050a0220.a5e6b.5b72SMTPIN_ADDED_BROKEN@mx.google.com>
 <abe8c209-d452-4fb5-90eb-f77b5ec1a2dc@acm.org> <20240601055931.GB5772@lst.de>
 <d7ae00c8-c038-4bed-937e-222251bc627a@acm.org>
 <20240604044042.GA29094@lst.de>
 <4ffad358-a3e6-4a88-9a40-b7e5d05aa53c@acm.org>
 <20240605082028.GC18688@lst.de>
 <CGME20240624105121epcas5p3a5a8c73bd5ef19c02e922e5829a4dff0@epcas5p3.samsung.com>
 <6679526f.170a0220.9ffd.aefaSMTPIN_ADDED_BROKEN@mx.google.com>
 <4ea90738-afd1-486c-a9a9-f7e2775298ff@acm.org>
 <de54c406-9270-4145-ab96-5fc3dd51765e@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <de54c406-9270-4145-ab96-5fc3dd51765e@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/24/24 2:55 PM, Damien Le Moal wrote:
> I am still a little confused as to why we need 2 BIOs, one for src and one for
> dst... Is it because of the overly complex scsi extended copy support ?
> 
> Given that the main use case is copy offload for data within the same device,
> using a single BIO which somehow can carry a list of LBA sources and a single
> destination LBA would be far simpler and perfectly matching nvme simple copy and
> ATA write gathered. And I think that this would also match the simplest case for
> scsi extended copy as well.

Hi Damien,

What are the implications for the device mapper code if the copy source
and destination LBAs are encoded in the bio payload instead of in
bio->bi_sector?

Thanks,

Bart.

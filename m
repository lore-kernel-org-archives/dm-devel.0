Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF4B3B79F
	for <dm-devel@lists.linux.dev>; Wed, 15 May 2024 13:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715779655; cv=none; b=QAkMFt4ANatCpoLDvrQr+GKO2RKQFwNZLtUjiOM21u0wkyIPVicqgGCiylNN0vfRsQJaC0+Y6mjdd0MJx8V+GVSPl0R4V9oFBg8ejQUloiPlWFNZffsL6V8EOauY2kfdUnbUAE8fU0n9ySH+AfzntTmsZq3MIW96K/Ywy2bX2Bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715779655; c=relaxed/simple;
	bh=7NN+p0VArzGwk72h7bf9onqlo8hFDngBzL8RjKLPj/s=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=SsMkZ2wDOEPWvkUDtwjOR6jOa0S2++8Ejv/8Lq3C2MekZwle1WeZ8QKrybGOU67HsSIODlJ4Uo8DFGH+wGsmi9hfyfUzPurarxqxW0QJHp9wT17VK7/ZYPkrR53NhGrPk9KoxQ/sa99CglphRzRprbyb9TRpL3jowoORDVOpYcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dAh1msAz; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dAh1msAz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715779651;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=g5fc8mcPKMWKuhRC4H98ePL+lLJSZdpFd80L6MUtTVs=;
	b=dAh1msAzZyYshcHUIC674A+nkrHcpX6lkfq7LmPAScyY3nhkCeLD5JIGS2P75tpo/2Ko5R
	9O+4KKlj4/UhgsxQ3lQZmWPzjXO7N9+6aQYv4J+5RNS4fghjdB3/chY/v3JNPsOnrN88JB
	m+lCzxPvrlLOWlUwXAME/lTpZBSk8Lc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-91-_pFjeoFPPYGUAvQmLQ8GsQ-1; Wed, 15 May 2024 09:27:27 -0400
X-MC-Unique: _pFjeoFPPYGUAvQmLQ8GsQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 36A918058C8;
	Wed, 15 May 2024 13:27:27 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E8D281C008BB;
	Wed, 15 May 2024 13:27:26 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id D068D30C7280; Wed, 15 May 2024 13:27:26 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id CECAF3FB52;
	Wed, 15 May 2024 15:27:26 +0200 (CEST)
Date: Wed, 15 May 2024 15:27:26 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>, 
    Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
    Mike Snitzer <snitzer@kernel.org>, Milan Broz <gmazyland@gmail.com>
cc: linux-block@vger.kernel.org, dm-devel@lists.linux.dev, 
    linux-nvme@lists.infradead.org
Subject: [RFC PATCH 0/2] dm-crypt support for per-sector NVMe metadata
Message-ID: <f85e3824-5545-f541-c96d-4352585288a@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

Hi

Some NVMe devices may be formatted with extra 64 bytes of metadata per 
sector.

Here I'm submitting for review dm-crypt patches that make it possible to 
use per-sector metadata for authenticated encryption. With these patches, 
dm-crypt can run directly on the top of a NVMe device, without using 
dm-integrity. These patches increase write throughput twice, because there 
is no write to the dm-integrity journal.

An example how to use it (so far, there is no support in the userspace 
cryptsetup tool):

# nvme format /dev/nvme1 -n 1 -lbaf=4
# dmsetup create cr --table '0 1048576 crypt 
capi:authenc(hmac(sha256),cbc(aes))-essiv:sha256 
01b11af6b55f76424fd53fb66667c301466b2eeaf0f39fd36d26e7fc4f52ade2de4228e996f5ae2fe817ce178e77079d28e4baaebffbcd3e16ae4f36ef217298 
0 /dev/nvme1n1 0 2 integrity:32:aead sector_size:4096'

Please review it - I'd like to know whether detecting the presence of 
per-sector metadata in crypt_integrity_ctr is correct whether it should be 
done differently.

Mikulas


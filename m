Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15C6617E91F
	for <dm-devel@lists.linux.dev>; Mon, 27 May 2024 15:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716824362; cv=none; b=NWXwqnH3sQZQi4xRPYfLs0L5xUtXc+NxaAJc4JQbR+hmJg4xpuROLrJMRsEgF7gcDpugKH7bNLzZaNC6bnQC67yDP56iNage+46bKnY/cKecqUaLWE19L/UJHh6Iyd/IF2jeXgMJC6E+YN5H8Z1vfoSlEvWjkjsbquiBHOehbok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716824362; c=relaxed/simple;
	bh=7jTkoRBA8HmGYXL3GZDRe66mbmyWUIgPJcv/cvwBMA0=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=sL9kJZ0wCN+r67Ac83wxBE9iLCrRERsDQLL76D2AxI3E+TvBxmiioalB05N8pPb60/dfZmX4PeXGZ+k9IoJgbLa/Lsw8VehSVzPvhw9A4C3YOLWHCBXtSMnB81tBQ0kPradDrvF9/CE0hAePQlnSZj/mRhgs+3+o3hnSPzQyEeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZdTLnq89; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZdTLnq89"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716824360;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=7jTkoRBA8HmGYXL3GZDRe66mbmyWUIgPJcv/cvwBMA0=;
	b=ZdTLnq89I5WSEVsZQWiiU2828bvp37yRiTZKN+RwafQUPWOFkZdja6woO8WwGZ0EEpQwrf
	7MNoV70eBg6nR9geQHzJwpZn/Ew7iDtzASPyKXjxMpGFV2jUEFqrspVbnCJZ7sxcyd93Zm
	RKF3drdap+CF2HTA5eLZy01iIyOmKvo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-526-IpRSvzNoO62M-rUA2ujB6Q-1; Mon, 27 May 2024 11:39:15 -0400
X-MC-Unique: IpRSvzNoO62M-rUA2ujB6Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1B06A85A58C;
	Mon, 27 May 2024 15:39:15 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 13188200A381;
	Mon, 27 May 2024 15:39:15 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id F299B30C1C33; Mon, 27 May 2024 15:39:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id EF5453C542;
	Mon, 27 May 2024 17:39:14 +0200 (CEST)
Date: Mon, 27 May 2024 17:39:14 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>, 
    Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
    Mike Snitzer <snitzer@kernel.org>, Milan Broz <gmazyland@gmail.com>, 
    Anuj gupta <anuj1072538@gmail.com>
cc: linux-block@vger.kernel.org, dm-devel@lists.linux.dev, 
    linux-nvme@lists.infradead.org
Subject: [PATCH 0/2 v4] dm-crypt support for per-sector NVMe metadata
Message-ID: <719d2e-b0e6-663c-ec38-acf939e4a04b@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

Hi

Here I'm resending the dm-crypt support for per-sector NVMe metadata. I
made some changes to the first patch as suggested by Christoph Hellwig.

The first patch fixes a bug when splitting a bio with attached metadata.
The second patch enables dm-crypt to use NVMe metadata for authenticated
encryption. dm-crypt can run directly on NVMe without using dm-integrity.

These patches increase write throughput twice, because there is no write
to the dm-integrity journal.

An example how to use it (so far, there is no support in the userspace
cryptsetup tool):

# nvme format /dev/nvme1 -n 1 -lbaf=4
# dmsetup create cr --table '0 1048576 crypt
capi:authenc(hmac(sha256),cbc(aes))-essiv:sha256
01b11af6b55f76424fd53fb66667c301466b2eeaf0f39fd36d26e7fc4f52ade2de4228e996f5ae2fe817ce178e77079d28e4baaebffbcd3e16ae4f36ef217298
0 /dev/nvme1n1 0 2 integrity:32:aead sector_size:4096'

Mikulas


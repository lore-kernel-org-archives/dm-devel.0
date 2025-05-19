Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D279426B08D
	for <dm-devel@lists.linux.dev>; Mon, 19 May 2025 10:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747649301; cv=none; b=Y6XogUtwnO+TYgdk2i/CV2lj7mRBWQo+GA88YkTqySVsWvL6hUeRXqV4zKzrYhqoOER2YZWGeEioo0Ckmnq4aLkWIG3QuRzXwnrdWiITXPsq56wIjwnbxgME25zHuyrHe457qyDXJrKSiG1hKM2SHbeVfcPZlth7Dn/SJQVb6KY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747649301; c=relaxed/simple;
	bh=/ECLeYrOgI/xDXJqLIJBFm1gkKGHXqMUme8qnKZ33zo=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=IC4Rnc49efqEurJnAXZmvbxx5NhlYk5Kzq29AYY6zNMS0iZZw0gwwwuZXFEIToamwKVpfJZibpsJMLIG3Ni+BvD5c8vR1ZFZU3eiaZyXUcMneorKVejZSAgmtXwXyI3hp81ZNre0P00mz83gnJzsqUnZvz3PCXYd34y2zUkZobM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NuACAd16; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NuACAd16"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747649298;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IPCWJVLkMaK8tJBnLZWlRM4mAht6WCbmUPQhsUB/SN0=;
	b=NuACAd16U3OzvvUVNT9y5Ob0g5ILz2WflCTi/Zz7WMs/aKTx4a1Y/HYhtsAXkK7loFzIzA
	XvEjVxldrOKEfXj5HSXOkmnmJmzVUY/iXGq5H2n/cT8hnkEARSbTYgTpf9eh5l98zkgbtb
	t0bw4YI1cg2g+ZYDQq5k9H+h0nej7TE=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-591-26_iXpUjNqa6fpI5tjrpoQ-1; Mon,
 19 May 2025 06:08:15 -0400
X-MC-Unique: 26_iXpUjNqa6fpI5tjrpoQ-1
X-Mimecast-MFC-AGG-ID: 26_iXpUjNqa6fpI5tjrpoQ_1747649294
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 70AAA1955DB3;
	Mon, 19 May 2025 10:08:13 +0000 (UTC)
Received: from [10.22.80.45] (unknown [10.22.80.45])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2D31619560AA;
	Mon, 19 May 2025 10:08:10 +0000 (UTC)
Date: Mon, 19 May 2025 12:08:05 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
cc: Song Liu <song@kernel.org>, zkabelac@redhat.com, 
    linux-raid@vger.kernel.org, dm-devel@lists.linux.dev, 
    "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: LVM2 test breakage
In-Reply-To: <98ac5772-9931-17fd-1fc4-18d2c737b079@huaweicloud.com>
Message-ID: <04231d91-cf1f-a932-f24f-996f888f0dd7@redhat.com>
References: <34fa755d-62c8-4588-8ee1-33cb1249bdf2@redhat.com> <98ac5772-9931-17fd-1fc4-18d2c737b079@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="-1463811712-405131181-1747649064=:2639866"
Content-ID: <54736a2e-0a8d-ab01-1763-d3a6667d38f6@redhat.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811712-405131181-1747649064=:2639866
Content-Type: text/plain; CHARSET=ISO-2022-JP
Content-ID: <9e4fb12c-d9b5-f586-8dde-c019a1a09af5@redhat.com>



On Mon, 19 May 2025, Yu Kuai wrote:

> Hi,
> 
> 在 2025/05/17 0:00, Mikulas Patocka 写道:
> > Hi
> > 
> > The commit e879a0d9cb086c8e52ce6c04e5bfa63825a6213c breaks the test
> > shell/lvcreate-large-raid.sh in the lvm2 testsuite.
> > 
> > The breakage is caused by removing the line "read_bio->bi_opf = op |
> > do_sync;"
> > 
> 
> Sorry that I don't undertand here, before the patch:
> 
> op = bio_op(bio);
> do_sync = bio->bi_opf & REQ_SYNC;
> read_bio->bi_opf = op | do_sync
> 
> after the patch:
> 
> read_bio = bio_alloc_clone(, bio, ...)
>  read_bio->bi_opf = bio->bi_opf
> 
> So, after the patch, other than bio_op() and REQ_SYNC, other bio flags
> are keeped, I don't see problem for now, I'll run the test later.
> 
> Thanks,
> Kuai

The problem is caused by the REQ_RAHEAD flag - bios with this flag may 
fail anytime. I presume that the bug is caused by raid1 mishandling this 
failure.

Mikulas
---1463811712-405131181-1747649064=:2639866--


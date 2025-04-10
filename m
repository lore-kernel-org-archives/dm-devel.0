Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09AC021C170
	for <dm-devel@lists.linux.dev>; Thu, 10 Apr 2025 10:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744281894; cv=none; b=KNpl3rMxPHWVI4c1TdBmL0d5FpR8pfN12LDJaJ8j6SmyO5JipORN/Xg95bCmZGXgDWYCCSIB8KQoQTiyxMRP/44QrIe11oHYY/Qu+4mwYhrwuD53FQtQtXVU3kfVhlmukYlyG/DavghlvDDJSj0o7LelJr5XS3nMAX6LrJHxSVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744281894; c=relaxed/simple;
	bh=X6lG1BsE3fdQZtm8++5BdpKGbKIGuEzwZdQQXeQT8t8=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=L8REWsbhydqulbl79ES/+i7tqlMS6iJXZ2FGVat1l2YOqc6R3vA/qErPgRjW3IC4ISY5SIu8zDgwT07C+ed/IEm6lR4j9OhSiEE5tjpmeDlZuWq23uZ/Q00MWXC259R/k05xVl2y3oTdibFNwYYT0XrhfOQhhcO1WVwCWX00xvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iXD3SbAP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iXD3SbAP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744281892;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cF1PnAy+mIJrOGN4/XJze0qznob4q28EUVwNSAuvlwI=;
	b=iXD3SbAPx5cUCgrtvLSbZkrezVwNfck4XGDowMULxUXpoSTsewLlobGCfT+Y+T50cHQW3G
	ux8tWO21Ss28P0AM8/a1OfdSgFDtAQO+GVoaie7LcVL05fmme01M7IidBsfQfKOKzfOvWQ
	P6sp9LnxAyomtzUsI7I3Jr07MjvNMPA=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-52-RySDnEwHNCK4ERPji5PdEA-1; Thu,
 10 Apr 2025 06:44:46 -0400
X-MC-Unique: RySDnEwHNCK4ERPji5PdEA-1
X-Mimecast-MFC-AGG-ID: RySDnEwHNCK4ERPji5PdEA_1744281885
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 513731800349;
	Thu, 10 Apr 2025 10:44:43 +0000 (UTC)
Received: from [10.22.82.75] (unknown [10.22.82.75])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 87C0D1828A9E;
	Thu, 10 Apr 2025 10:44:39 +0000 (UTC)
Date: Thu, 10 Apr 2025 12:44:32 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
cc: LongPing Wei <weilongping@oppo.com>, Christoph Hellwig <hch@infradead.org>, 
    snitzer@kernel.org, axboe@kernel.dk, dm-devel@lists.linux.dev, 
    linux-block@vger.kernel.org, guoweichao@oppo.com, sfr@canb.auug.org.au, 
    "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH] block: Export __blk_flush_plug to modules
In-Reply-To: <21aa6521-e814-d3f9-2ba7-eb511e4ae8d6@huaweicloud.com>
Message-ID: <a42d9917-f105-0036-8d64-a4cf1183b20e@redhat.com>
References: <20250410030903.3393536-1-weilongping@oppo.com> <Z_d07I1b71zQYS0M@infradead.org> <a3523b3c-4c89-44c5-867e-75378ebb652a@oppo.com> <21aa6521-e814-d3f9-2ba7-eb511e4ae8d6@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-1463811712-1800407510-1744281883=:1502115"
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811712-1800407510-1744281883=:1502115
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT



On Thu, 10 Apr 2025, Yu Kuai wrote:

> Hi,
> 
> 在 2025/04/10 16:06, LongPing Wei 写道:
> > On 2025/4/10 15:36, Christoph Hellwig wrote:
> > > On Thu, Apr 10, 2025 at 11:09:04AM +0800, LongPing Wei wrote:
> > > > Fix the compile error when dm-bufio is built as a module.
> > > > 
> > > > 1. dm-bufio module use blk_flush_plug();
> > > > 2. blk_flush_plug is an inline function and it calls __blk_flush_plug.
> > > 
> > > Then don't call blk_flush_plug from dm-bufio, as drivers should not
> > > micro-manage plug flushing.
> > > 
> > > Note that at least in current upstream and linux-next dm-bufio does
> > > not actually call blk_flush_plug, so I'm not sure where your
> > > report comes from.
> > > 
> > Hi, Christoph
> > 
> > Stephen reported that a compile error happened when he tried merging
> > device-mapper tree.
> > 
> > > Hi all,
> > > 
> > > After merging the device-mapper tree, today's linux-next build (powerpc
> > > ppc64_defconfig) failed like this:
> > > 
> > > ERROR: modpost: "__blk_flush_plug" [drivers/md/dm-bufio.ko] undefined!
> > > 
> > > Caused by commit
> > > 
> > >   713ff5c782f5 ("dm-bufio: improve the performance of
> > > __dm_bufio_prefetch")
> > > 
> > > I have used the device-mapper tree from next-20250409 for today.
> > 
> > 
> > More details are here.
> > 
> > https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=713ff5c782f5a497bd0e93ca19607daf5bf34005 
> 
> So, this patch has compile problem, I think it should be removed from
> dm tree.

OK, I've just removed it.

Mikulas

> BTW, I don't get it from commit message, why you need to flush plug when
> bio is not contiguous. Other than bio merge, plug is also benefit from
> batch submitting:
> 
> __blk_mq_flush_plug_list
>  q->mq_ops->queue_rqs(&plug->mq_list)
> 
> Thanks,
> Kuai
> 
> > 
> > 
> > https://lore.kernel.org/dm-devel/66bf8a8e-0a7d-47b8-9676-dc2e8c596bdb@oppo.com/T/#t 
> > 
> > Thanks
> > 
> > LongPing
> > 
> > .
> > 
> 
---1463811712-1800407510-1744281883=:1502115--


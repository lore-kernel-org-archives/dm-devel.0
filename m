Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8702D1FB4
	for <dm-devel@lists.linux.dev>; Tue, 30 Apr 2024 22:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714516558; cv=none; b=AZOg2JiNa9ClB5GbMjQXo3iptsto7MlZ/8e7saTFyEPJRWj333tk4g5+lLFhtT3gdUgOPTL0D1h1hZBPQCMNAUZ95f1NVWyA5ML/76tss/8rCUIDgvfWzriWBJdoNX6bdhdgDZUCUX6NqupUCraXqdqjXaBEMhq6fNhgWV82kPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714516558; c=relaxed/simple;
	bh=y0aBHo99+nQo6uI6GjP6caA9eEMAKHmQHNrozchkme0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=c36bvfgbIeBSf8tsDAxqkEJzcFPVjR2MiGvSTRymPOE0nR7eUIWCuU/4L71AOz4iEcsFHddDSMl42Q2Gb94HkB61LEIBjPWbcfRQbJBKxBYvRzVPDXwoDinQz2mNF1s/ihXu0qaoFc3SDPHJZfSZkHf1Fib87qdp1Auc35pjl7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=G22f+uId; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G22f+uId"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714516555;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uQjgSpiKr36z/UJnNLHs2EcJ1dKnMR6JIrp3bMkPKwA=;
	b=G22f+uIdbKwNtKuNsvPm5TBiBEiisLy6cp0cxcvVon8DcPxzBrYzlj/MAQvC1E33kzKYX5
	kYQGr7XlHVpj5FVt57FQcVUF2SWLqbkdc5uzTtAoGXcbNnbwkZAbb2fyamIwmamzPns2pW
	qJmI2VmAugvjHmOtSH05drNiAY1ooFI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-377-t82Vft6DMnygsaDfCSoOsQ-1; Tue, 30 Apr 2024 18:35:47 -0400
X-MC-Unique: t82Vft6DMnygsaDfCSoOsQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6C99E100ADE4;
	Tue, 30 Apr 2024 22:35:46 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3953140C140B;
	Tue, 30 Apr 2024 22:35:46 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 43UMZjQf2342612
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 30 Apr 2024 18:35:46 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 43UMZiRb2342611;
	Tue, 30 Apr 2024 18:35:44 -0400
Date: Tue, 30 Apr 2024 18:35:44 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Liao Yuanhong <liaoyuanhong@vivo.com>
Cc: bo.wu@vivo.com, dm-devel@lists.linux.dev, snitzer@kernel.org,
        Pankaj Raghav <p.raghav@samsung.com>, damien.lemoal@opensource.wdc.com,
        Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] dm-table:remove the restriction on zone sector being
 align to pow2
Message-ID: <ZjFyQH7gr6-_9yIL@redhat.com>
References: <Zi_sSyu7CWdFS_v7@redhat.com>
 <20240430033207.875-1-liaoyuanhong@vivo.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240430033207.875-1-liaoyuanhong@vivo.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 30, 2024 at 11:32:07AM +0800, Liao Yuanhong wrote:
> Currently, the zone size of the ZoneUFS provided by Hynix is not aligned
> to pow2. After testing on the mobile platform with this fix, we found 
> that basic functionality can be executed. May we merge this patch first?

The issue is that device-mapper makes assumptions in multiple places
that zones are power of 2 sized. Simply removing this check will allow
users to create broken device-mapper devices on top of non-power-of-2
devices.

A better solution would be to see if Pankaj Raghav's non-power-of-2 zone
size patchset can be revisited.

-Ben 


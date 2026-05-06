Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7ABB3F076F
	for <dm-devel@lists.linux.dev>; Wed,  6 May 2026 15:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778082852; cv=none; b=nynio6b7AJVrd0vJs9BEwi9GJdJIZky9Ujs1zZk4cOZpTAiN/9WSElif8IvW03u+TVMxC39E+sX5rhcgyYzXXa3sRJjY6copYFR4VqIoTQ/VA/uWtj4FW7n5i4ngVFNwUYHrQ31mcMDevOyLqX7MhHgVJLRuSalxym98apE9+tM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778082852; c=relaxed/simple;
	bh=tXnEB7Xs5nkoeyQzJEoxyOvYuu1QKmpAiqanN6iBigE=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=iIN0eY+4zbwu2UASqQwJXOKleVl5me/lhsg+5pcumobLtKIZ8cPGg+5uxj6qvivrJVdig1zccY5I1bO5JOwE0u2qTpaY2eue3xuDQ0WXL5gkZ9DSw4WldUovpvCkb0O94C1kXleftkSkW7AfSatqNbCFAG3+E12mHyI/TKOTzgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IZYEnuG1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IZYEnuG1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778082847;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VUnlcT8XYOLg/6L2AviUq36v4DVFKa9hm1+cIiyKHw0=;
	b=IZYEnuG1mbefPB8hjHbJ81iaMAsiDo/RILmCgMuT7/fGxC4z76i+jUpKhuZNCgnS6mgxfV
	MmKhjPx7b4i6OQvhC2Nbsg8dXoGdhUZHjhkmxtH2UK4uD1Ad7UprwQvL9w7tz4Or+gXhWq
	LKPn12RZs3TQRPB4ZZc4tl+SCEEAfqc=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-593-LRAdqKjGNoirGMI0QdLGiA-1; Wed,
 06 May 2026 11:54:05 -0400
X-MC-Unique: LRAdqKjGNoirGMI0QdLGiA-1
X-Mimecast-MFC-AGG-ID: LRAdqKjGNoirGMI0QdLGiA_1778082843
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4C9E418002DD;
	Wed,  6 May 2026 15:54:03 +0000 (UTC)
Received: from [10.44.34.151] (unknown [10.44.34.151])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 95FE019560A3;
	Wed,  6 May 2026 15:53:59 +0000 (UTC)
Date: Wed, 6 May 2026 17:53:54 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
cc: linux-block@vger.kernel.org, ebiggers@kernel.org, gmazyland@gmail.com, 
    bmarzins@redhat.com, linux-kernel@vger.kernel.org, adrianvovk@gmail.com, 
    dm-devel@lists.linux.dev, quic_mdalam@quicinc.com, israelr@nvidia.com, 
    hch@infradead.org, axboe@kernel.dk
Subject: Re: [PATCH v3 0/3] dm-inlinecrypt: add target for inline block device
 encryption
In-Reply-To: <20260430095244.3352446-1-linlin.zhang@oss.qualcomm.com>
Message-ID: <eca4a1af-0573-b27b-572d-043ded687b05@redhat.com>
References: <20260430095244.3352446-1-linlin.zhang@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: L57G3Kw4bSl6wPJxmC1KRamJqNSvWC9H6YUnvx5__5U_1778082843
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="-1463811712-1358702411-1778082842=:879507"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
---1463811712-1358702411-1778082842=:879507
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

I committed the patches, thanks.

Mikulas



On Thu, 30 Apr 2026, Linlin Zhang wrote:

> This patch series is based on Eric�s work posted at:
> https://lore.kernel.org/all/ecbb7ea8-11f6-30c1-ad77-bd984c52ca33@quicinc.com/
> 
> Eric�s patches introduce a new dm target, dm-inlinecrypt, to support inline
> block-device encryption. The implementation builds on the work previously done
> in Android�s dm-default-key, but intentionally drops passthrough support,
> as that functionality does not appear likely to be accepted upstream in the
> near future. With this limitation, dm-inlinecrypt is positioned as a
> practical replacement for dm-crypt, rather than a general passthrough
> mechanism.
> 
> On top of Eric�s series, keyring key support is added in dm-inlinecrypt. Thus,
> both keyring key and hex key are feasible for dm-inlinecrypt. In addition,
> dm-inlinecrypt.rst is added as the user-guide of dm-inlinecrypt.
> 
> V2:
> https://lore.kernel.org/all/20260410134031.2880675-1-linlin.zhang@oss.qualcomm.com/
> 
> V1:
> https://lore.kernel.org/all/20260304121729.1532469-1-linlin.zhang@oss.qualcomm.com/
> 
> Eric Biggers (2):
>   block: export blk-crypto symbols required by dm-inlinecrypt
>   dm-inlinecrypt: add target for inline block device encryption
> 
> Linlin Zhang (1):
>   dm: add documentation for dm-inlinecrypt target
> 
>  .../device-mapper/dm-inlinecrypt.rst          | 123 ++++
>  block/blk-crypto.c                            |   3 +
>  drivers/md/Kconfig                            |  11 +
>  drivers/md/Makefile                           |   1 +
>  drivers/md/dm-inlinecrypt.c                   | 596 ++++++++++++++++++
>  5 files changed, 734 insertions(+)
>  create mode 100644 Documentation/admin-guide/device-mapper/dm-inlinecrypt.rst
>  create mode 100644 drivers/md/dm-inlinecrypt.c
> 
> -- 
> 2.34.1
> 

---1463811712-1358702411-1778082842=:879507--


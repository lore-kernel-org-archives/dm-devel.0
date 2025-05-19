Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 610A4D515
	for <dm-devel@lists.linux.dev>; Mon, 19 May 2025 10:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747649428; cv=none; b=ZUGhglo2EGcAgyIOA4v0puH5sI0Jmrby6hPA+yyp9FvM7KegYIuthFw/DHiWA3cPjhyTpe06EuOc0cPBn5Z5r0ZHumgcIK2fMhuekQCHysvLI/2+KZETK/g5ijLR3gH/yIgdhfL4gjq2dk7DZ3Tke10xxXrumIErj3ZeqtQBOtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747649428; c=relaxed/simple;
	bh=C7dV36Qt58kddqn8NnvZ0Sb+Y/jXeOZ4G3GbasdLqBg=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=V3H6jI4OXa077y7BOhDRhp+jW5fV5UtqXxTQY2464DgpXVqF9vvow8BddMKNMMU8w9foH/g2IaKxdPF1m5eqnreYX95uiGYE3hLGQZI8v5rfRyGwLCPLNM7DFCi/bDWe3Y/jSBKeQYaPNM4163RZFwqBbfG8Pbr2InDuCCyykng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=G9cgcV5n; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G9cgcV5n"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747649426;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XhLeC5vPy5dovNtai2RBqBq64nqAGx1irKADK82KP90=;
	b=G9cgcV5nP6VaTq13uxvBRKshjpi7DsAUAygec0GxwmbeCCxsEnkIRnjaeir79JGfs7maqb
	7xW3TAI04xiNkoo0CkyMQtsOkWMDDgVn+MC55tKHtHtla5ChxQTrfnm3lHq7F/iNcVXBHg
	M/VlUTZ6ytM3RTAG4coTaMUCbKnFeTE=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-364-EJM3xDflMlyVj_vyfrBYtA-1; Mon,
 19 May 2025 06:10:25 -0400
X-MC-Unique: EJM3xDflMlyVj_vyfrBYtA-1
X-Mimecast-MFC-AGG-ID: EJM3xDflMlyVj_vyfrBYtA_1747649424
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C192218004AD;
	Mon, 19 May 2025 10:10:23 +0000 (UTC)
Received: from [10.22.80.45] (unknown [10.22.80.45])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 03FE918004A7;
	Mon, 19 May 2025 10:10:20 +0000 (UTC)
Date: Mon, 19 May 2025 12:10:18 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
cc: Song Liu <song@kernel.org>, zkabelac@redhat.com, 
    linux-raid@vger.kernel.org, dm-devel@lists.linux.dev, 
    "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: LVM2 test breakage
In-Reply-To: <73ff7f5f-6f09-66d8-9061-7840bc72d0df@huaweicloud.com>
Message-ID: <0be9be18-9488-1edc-00bb-5a1b0414fd15@redhat.com>
References: <34fa755d-62c8-4588-8ee1-33cb1249bdf2@redhat.com> <98ac5772-9931-17fd-1fc4-18d2c737b079@huaweicloud.com> <73ff7f5f-6f09-66d8-9061-7840bc72d0df@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-1463811712-1959767309-1747649423=:2639866"
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811712-1959767309-1747649423=:2639866
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT



On Mon, 19 May 2025, Yu Kuai wrote:

> Hi,
> 
> 在 2025/05/19 9:11, Yu Kuai 写道:
> > Hi,
> > 
> > 在 2025/05/17 0:00, Mikulas Patocka 写道:
> > > Hi
> > > 
> > > The commit e879a0d9cb086c8e52ce6c04e5bfa63825a6213c breaks the test
> > > shell/lvcreate-large-raid.sh in the lvm2 testsuite.
> > > 
> > > The breakage is caused by removing the line "read_bio->bi_opf = op |
> > > do_sync;"
> > > 
> > 
> > Sorry that I don't undertand here, before the patch:
> > 
> > op = bio_op(bio);
> > do_sync = bio->bi_opf & REQ_SYNC;
> > read_bio->bi_opf = op | do_sync
> > 
> > after the patch:
> > 
> > read_bio = bio_alloc_clone(, bio, ...)
> >   read_bio->bi_opf = bio->bi_opf
> > 
> > So, after the patch, other than bio_op() and REQ_SYNC, other bio flags
> > are keeped, I don't see problem for now, I'll run the test later.
> > 
> 
> Do I need some special setup to run this test? I got following
> result in my VM, and I don't understand why it failed.
> 
> Thanks,
> Kuai

Ask Zdenek Kabelac - he is expert in the testsuite.

Mikulas
---1463811712-1959767309-1747649423=:2639866--


Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A266C3783AC
	for <dm-devel@lists.linux.dev>; Wed, 29 Apr 2026 15:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777476280; cv=none; b=TmM6V5Js3jHonn7LFfsRl/j92CJi3BvESXvfI7yJGTjJX8O483frT/LfWJJTIJ8useRTAp28OK7Tcqt9Rniin5+2J2TcmGy+xDbBlGVBa2HV2+LQJVmFKK2gpirqyIyD0ZfTFCRJ6TSSW66i6Go7V8twPBQ1wWy0epJnYKJTbWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777476280; c=relaxed/simple;
	bh=hVTWOmWkKedUOB/OEaM4zwcAK5LJMw3Do/CLTzzXoJc=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=N4PzyqUikbP+wXMVH//NZ/VgKoVJkqrV2YUfmjzhDTnyycwXMEY//DQeDxan2hD0UEQiUgzMBVGibAU9zQddm2Me9FiGLVwul/3C6gczqCSpx2zW3sUA9Ck0LzFKST8lisey4ksJJ/WzOomy9XQFVY7j00MEDJ0M2NJKUK8+l1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gCILolhp; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gCILolhp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777476277;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+NrCE4WeZBcnCMinEJhD3rPeEPQJTvMbPaUc0uBBZa4=;
	b=gCILolhpMm6+M4RWQ4C21V6yGh/9KL4T8CQQj8LvmvGl0z/XoT71FWwHmVeLrDnYeKN4F4
	goSzqdlUIL/VqqXb+UK1bsm2z0IPko+6kzPY/JgNdtcKSmB4IuWfS4gqSzQ4V5qpL5l2pe
	rtfyjzOZduWfFAz39YBygJo8ZLm91nU=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-286-3IlXz3BOOM-tDHxxDjEjZg-1; Wed,
 29 Apr 2026 11:24:34 -0400
X-MC-Unique: 3IlXz3BOOM-tDHxxDjEjZg-1
X-Mimecast-MFC-AGG-ID: 3IlXz3BOOM-tDHxxDjEjZg_1777476273
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 336BE1800282;
	Wed, 29 Apr 2026 15:24:33 +0000 (UTC)
Received: from [10.44.34.100] (unknown [10.44.34.100])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 35202180034F;
	Wed, 29 Apr 2026 15:24:32 +0000 (UTC)
Date: Wed, 29 Apr 2026 17:24:29 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: "..." <439291857@qq.com>
cc: dm-devel <dm-devel@lists.linux.dev>
Subject: Re: dm vdo: add optional Intel IAA-backed compression support
In-Reply-To: <tencent_C10B5DDE03BCA1510BF6D23F384A4C120308@qq.com>
Message-ID: <a986902e-014c-2df6-4e0d-de99a62f90f2@redhat.com>
References: <tencent_C10B5DDE03BCA1510BF6D23F384A4C120308@qq.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: wRdHYPG0EHCgrmVBhOprzIUK-r7bXucL4OfeTDTxUxw_1777476273
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="-1463811712-134907032-1777476272=:538637"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
---1463811712-134907032-1777476272=:538637
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

Hi

I think the best way how to support it would be to modify the VDO target 
to use the asynchronous compression API (so that it could use arbitrary 
algorithms). Then, the support for IAA could be plugged in easily with 
little or no extra code.

It is not good to have branches like "if (iaa_enabled) ... else ...;", 
because that would just blow into unmaintainable bunch of code when other 
accelerators (maybe s390x?) would be added.

Also, it would be good (to ease reviewing), to split the patch into 
several smaller patches.

Mikulas


On Wed, 29 Apr 2026, ... wrote:

> 
> Hello,
> 
> I am following up here after an earlier reply suggested that Linux dm-vdo changes should be discussed on the device-mapper mailing list rather than as a GitHub PR.
> 
>  Intel IAA, the In-Memory Analytics Accelerator, is a built-in accelerator in recent Intel Xeon processors. One of its main uses is offloading compression and decompression
> work from CPU cores. This is relevant to dm-vdo because VDO already spends CPU time in the compressed write and read paths, and the kernel already exposes IAA compression
> through the crypto API as the deflate-iaa algorithm. The existing IAA crypto driver documentation (dm-linux/Documentation/driver-api/crypto/iaa/iaa-crypto.rst) also describes
> zswap as one consumer of this interface, so my prototype tries the same general model for dm-vdo.
> 
> Before changing dm-vdo, I compared the current LZ4 path with IAA on a set of single-thread compression tests. For compression, IAA hardware was faster than LZ4 on most tested
> datasets, withthe measured compression time often reduced by about 1.3x to 3.5x compared with LZ4. The compression ratio was also generally comparable to or better than LZ4,
> because the IAA path uses DEFLATE rather than LZ4. Decompression was more mixed: IAA hardware was close to LZ4 or faster on some datasets, but slower on others.
> [IMAGE]
> Please see figure1 in the attachments.
> 
> The prototype is in:
> 
>   https://github.com/dm-vdo/dm-linux/pull/96
> 
> It contains two commits:
> 
>   dm vdo: add minimal IAA compression support
> 
>   dm vdo: preserve compressed block format for IAA
> 
> The change is intentionally narrow and only touches the dm-vdo compression and
> 
> decompression path under `drivers/md/dm-vdo/`.The design is as shown in the figure below:
> 
> [IMAGE]
> 
> Please see figure2 in the attachments.
> 
> The current result is:
> 
> 1. dm-vdo gets an optional iaa_enabled module parameter.
> 
> 2. On writes, compress_data_vio() first tries deflate-iaa through the async compression crypto API. If IAA is disabled, unavailable, or the IAA compression attempt fails, it
> falls back to the existing LZ4 path.
> 
> 3. On reads, uncompress_data_vio() can decode data produced by the IAA path. It tries IAA-assisted DEFLATE first, then software zlib inflate, and then the existing LZ4 path.
> 
> 4. The prototype preserves the existing compressed block format. I did not add a new on-disk compressor field in this version.
> 
> 5. Data written through the IAA path is not dependent on IAA hardware being present later, because it can still be decoded by the software DEFLATE fallback.
> 
> In local testing, the prototype was able to write and read IAA-compressed VDO data correctly, including the software fallback case when IAA was not used for the read. The
> performance is as shown in the figure below. As can be seen, the performance remains largely consistent with the original after adding IAA.
> 
> Write path：
> 
> Command: dd if=../mnt_ori/SRR.fastq of=./SSR.fastq bs=1M oflag=direct
> 
> IAA: 6430986673 bytes (6.4 GB, 6.0 GiB) copied, 4.98476 s, 1.3
> GB/s                                                                                                                                             
> 
> LZ4: 6430986673 bytes (6.4 GB, 6.0 GiB) copied, 4.91684 s, 1.3 GB/s
> 
> Read path:
> 
> [IMAGE]
> 
> Please see figure3 in the attachments.
> 
> The reason I think this may be worth discussing is that IAA gives dm-vdo a way to offload compression work on systems that already have the accelerator, while keeping the
> existing LZ4 path as the compatibility and fallback path. The goal of this RFC is not to propose a final format or policy yet, but to check whether this direction is acceptable
> before I spend more time preparing a proper patch series.
> 
> I would appreciate feedback on whether using the existing kernel IAA crypto API from dm-vdo is a reasonable direction, and whether preserving the current compressed block
> format is acceptable for an initial RFC.
> 
>  
> 
> Best regards,
> 
> 
> 
> 

---1463811712-134907032-1777476272=:538637--


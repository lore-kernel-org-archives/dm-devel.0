Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76A4739DBE4
	for <dm-devel@lists.linux.dev>; Fri, 13 Mar 2026 13:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773408330; cv=none; b=GE+DJ7sGMA3L61IsuFpyz2UTEQY/7E3Lp/9YjmHD9GsXyE8Ybm7fGDt7+X5RnRKAIE7iO1cEYmJupqWUxUBZbhnHf1UF4FbfBuE8aYd1t5LQr/WCs5KOfydTPGqLd4yNtZGLFphCXreMhgEpSviUPYEGkJqxK9wNVh8sn+TqJgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773408330; c=relaxed/simple;
	bh=w0/y1BHETToQxKlqrJ2ZXLEZcMeAz/scKPa6+9WpG8Q=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=PrhBZyih7iBes3mMgwAL6NobwfGHCHe98HXZs6JZkUNzHz+D2p1p9kfw7ybtDUNMq+5xxB6U3suPbtcwezKDONqAbgoNYlaoKk7t1gRAZn5KwaJHIz0pERnLjMsqCkiaspdCy0hj6wwCxIM3z5PFsyPE9SuLHoy/1bkykctVLyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZqMpab/v; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZqMpab/v"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773408328;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4YSGv5V7H4JKjIPrQpyTAklA5LuP9lXqYM0sD2PxRM8=;
	b=ZqMpab/vOypUvm4CEplsYagB1KIBM/SMHn3tDjDyQjcMeLEGRB71Il/+qCXS3OLCo3O2o1
	ijPtZmKMuw2/lPICKcMfKr5yMHyXqZkxdNUCsS4uRAJXKPrqxO60gxNQZp+G+gwjxOWISt
	nW8FFkyMzZzLS7T0hDGvm6CJLVVHcdM=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-371-nzukWLOwM7SePLPnomyfyA-1; Fri,
 13 Mar 2026 09:25:23 -0400
X-MC-Unique: nzukWLOwM7SePLPnomyfyA-1
X-Mimecast-MFC-AGG-ID: nzukWLOwM7SePLPnomyfyA_1773408322
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0C75619560B9;
	Fri, 13 Mar 2026 13:25:22 +0000 (UTC)
Received: from [10.44.32.29] (unknown [10.44.32.29])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 34DAB19560B7;
	Fri, 13 Mar 2026 13:25:18 +0000 (UTC)
Date: Fri, 13 Mar 2026 14:25:13 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>
cc: Linlin Zhang <linlin.zhang@oss.qualcomm.com>, linux-block@vger.kernel.org, 
    linux-kernel@vger.kernel.org, adrianvovk@gmail.com, 
    dm-devel@lists.linux.dev, quic_mdalam@quicinc.com, gmazyland@gmail.com, 
    israelr@nvidia.com
Subject: Re: [PATCH v1 2/3] dm-inlinecrypt: add target for inline block device
 encryption
In-Reply-To: <20260312070110.GD2359@sol>
Message-ID: <5a310122-bd7e-d10e-653e-bc7e09681478@redhat.com>
References: <20260304121729.1532469-1-linlin.zhang@oss.qualcomm.com> <20260304121729.1532469-3-linlin.zhang@oss.qualcomm.com> <20260312070110.GD2359@sol>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: taZgg2IkITCFHS-9_HDgqAn9nEnt7pkEgxwygGBXaKE_1773408322
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Thu, 12 Mar 2026, Eric Biggers wrote:

> On Wed, Mar 04, 2026 at 04:17:27AM -0800, Linlin Zhang wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > Add a new device-mapper target "dm-inlinecrypt" that is similar to
> > dm-crypt but uses the blk-crypto API instead of the regular crypto API.
> > This allows it to take advantage of inline encryption hardware such as
> > that commonly built into UFS host controllers.
> > 
> > The table syntax matches dm-crypt's, but for now only a stripped-down
> > set of parameters is supported.  For example, for now AES-256-XTS is the
> > only supported cipher.
> > 
> > dm-inlinecrypt is based on Android's dm-default-key with the
> > controversial passthrough support removed.  Note that due to the removal
> > of passthrough support, use of dm-inlinecrypt in combination with
> > fscrypt causes double encryption of file contents (similar to dm-crypt +
> > fscrypt), with the fscrypt layer not being able to use the inline
> > encryption hardware.  This makes dm-inlinecrypt unusable on systems such
> > as Android that use fscrypt and where a more optimized approach is
> > needed.  It is however suitable as a replacement for dm-crypt.
> > 
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > Signed-off-by: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
> 
> I don't think it's plausible that this new patch was actually tested.
> The version I sent in 2024 was tested at the time
> (https://lore.kernel.org/r/20241016232748.134211-3-ebiggers@kernel.org/),
> but I see at least two things that would make this new patch not work.
> 
> First, the call to blk_crypto_init_key() will always fail, since it's
> being passed BLK_CRYPTO_KEY_TYPE_HW_WRAPPED but using a 64-byte raw key.
> 
> It needs to be BLK_CRYPTO_KEY_TYPE_RAW.  (BLK_CRYPTO_KEY_TYPE_HW_WRAPPED
> support would make sense to add as an extra feature, once the basic raw
> key support is working.  Note that when I sent the first version of this
> patch, support for wrapped keys was not yet upstream at all.)
> 
> Second, since v7.0-rc1, submitters of bios don't automatically get
> blk-crypto-fallback support; they need to request it explicitly.  So,
> this patch will not work with blk-crypto-fallback anymore.
> 
> If you'd like to continue work on this patch, it might be helpful to
> check the latest version of dm-default-key.c in "android-mainline"
> (https://android.googlesource.com/kernel/common/+/android-mainline/drivers/md/dm-default-key.c)
> and resynchronize this patch with it.  It already has the code to
> correctly support both key types and blk-crypto-fallback, for example.
> 
> Either way, this patch also needs to be re-tested with the latest
> upstream kernel, which doesn't seem to have happened unfortunately.

OK. I dropped it.

Mikulas

> - Eric
> 


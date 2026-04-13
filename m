Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9A291DDC37
	for <dm-devel@lists.linux.dev>; Mon, 13 Apr 2026 16:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096954; cv=none; b=eswh9Et0PWnuS83ZQXesA/2xkhe4Ew0pV2aPEjGT4TqE2ErylcO75oX4zJLWpx55qMZyMuHQ0U/GzcMocmgqqA/jYjXXQ0njBr2I2yTBH0IdsiLCfVgEuQRVO/OQSdW37/pDPJnwvLd7voHJXxTE2tFa1peNcuBz/yC95qiAy5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096954; c=relaxed/simple;
	bh=r1+DclhMutipfmfF2pVyaLHvci87Yn5gsjoRkhi+VZY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=kjktkq9urMPWhItEoyvKo/BER+hK2KZpQ32OOIKJNsLMb2gtJzr33mcczSRyHyIA+k1h+3Ar3jViXIol3L+1jBbbjHWEHWRUvoB2kLElMjfZ8BUBRffFCoKjs5kBdFbKCvhkG/Ut7saBBFvuSycnDnV/Ms9Pp1MmSZemkJOLQmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CVPk7Lbf; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CVPk7Lbf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776096951;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v+CK9VupehjK8MkTiwf5yTTLYnfoP2iHooSST77Dm4c=;
	b=CVPk7LbfI3iwszCdnVAmEmFRvxYuEkvJnMa0aGSvR/YhYF6Nu2ti4vq3ZBoH8EjCvSx2yU
	Z6N7THb5OjGA5QMNfYPhNxkTacxG2+8R/32HWuo69wQDQ6VnbGRURYs9CfyDPZwZgt9tt4
	wl/XYnIZfI8eZ9wQSs56vo2aRlW8c3Q=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-484-_6maWxONMJeoOq9Yhdk0gQ-1; Mon,
 13 Apr 2026 12:15:50 -0400
X-MC-Unique: _6maWxONMJeoOq9Yhdk0gQ-1
X-Mimecast-MFC-AGG-ID: _6maWxONMJeoOq9Yhdk0gQ_1776096949
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 827081801235;
	Mon, 13 Apr 2026 16:15:49 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 24C8F1800240;
	Mon, 13 Apr 2026 16:15:49 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 63DGFlAx1903018
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 13 Apr 2026 12:15:47 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 63DGFlCs1903017;
	Mon, 13 Apr 2026 12:15:47 -0400
Date: Mon, 13 Apr 2026 12:15:47 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH] libmultipath: Handle SCSI-2 style vpd page 0x83
 descriptors
Message-ID: <ad0Wsx2Af_Sh5RxB@redhat.com>
References: <20260327034136.1157685-1-bmarzins@redhat.com>
 <6fe5f3fc3894f2227a4ebda322256580fb4711c8.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <6fe5f3fc3894f2227a4ebda322256580fb4711c8.camel@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: QPbNVqr0oGfXbN7_iWbZsX5EKZhYlrqC_TqcSPebBHY_1776096949
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Mon, Apr 13, 2026 at 01:11:33PM +0200, Martin Wilck wrote:
> On Thu, 2026-03-26 at 23:41 -0400, Benjamin Marzinski wrote:
> > Some older SCSI devices return a SCSI-2 style vpd page 0x83, instead
> > of
> > a SPC-2/3 format one. The SCSI-2 page 83 format returns an IEEE WWN
> > in
> > binary encoded hexi-decimal in the 16 bytes following the initial
> > 4-byte page 83 reply header.
> > 
> > Check the 7th byte of the vpd page 83 buffer to determine whether
> > this
> > is a SCSI-2 or SPC-2/3 confomant one. Byte 7 is the 3rd byte of first
> > Identification descriptor in a SPC-2/3 confromant vpd page 83. This
> > is a
> > reserved field, and is guaranteed to be 0. If it is not zero, then it
> > is
> > likely the 3rd byte of a SCSI-2 Identifier (The first 3 bytes of the
> > ID
> > are the Organizationally Unique Identifier). Both the sg_inq and
> > scsi_id
> > commands handle vpd page 83 this way. To make sure that the WWID
> > which
> > multipath reads directly from the device matches, it should handle
> > this
> > format as well.
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  libmultipath/discovery.c | 13 +++++++++
> >  tests/vpd.c              | 58
> > ++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 71 insertions(+)
> > 
> > diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> > index 0efb8213..057ff45f 100644
> > --- a/libmultipath/discovery.c
> > +++ b/libmultipath/discovery.c
> > @@ -1208,6 +1208,18 @@ parse_vpd_pg83(const unsigned char *in, size_t
> > in_len,
> >  	if (out_len <= 1)
> >  		return 0;
> >  
> > +	/*
> > +	 * Not a valid SPC-2/3 vpd page 83. Assume it's a SCSI-2
> > style
> > +	 * descriptor.
> > +	 */
> > +	if (in[6] != 0) {
> 
> Make sure that if in_len is > 6 (or actually, large enough to hold the
> SCSI-2 ID)?
>  

Good call.

-Ben

> > +		len = 0;
> > +		vpd_type = 0x3;
> > +		vpd_len = in_len - 4;
> > +		vpd = in + 4;
> > +		goto decode;
> > +	}
> > +
> 
> Regards,
> Martin


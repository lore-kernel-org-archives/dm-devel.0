Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 885853176EE
	for <dm-devel@lists.linux.dev>; Fri, 13 Mar 2026 13:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773407997; cv=none; b=lIKmmBB9UAqBi418yMys+Y0tipc7V22xohgH5x+XNfL2nWRX5qxmljX7Xb+vieFDuCYBE3DPkRrE3HA7C6ia+sAKUtfhN+Usy2ZlZ6HKG4h3ic2wJq+W8LO65S+HI4orr7N5vN+sup7wbXB44HXDsE0H5pUIcnf+n/IWlhpVMD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773407997; c=relaxed/simple;
	bh=2bnnvrVpfqOa2DsMliubUspaClU5NpKbq4XFxBtfVms=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Ix5eQ4L6Za4eTDPWa1OUksGCWl0q7EEgjo4F154YGVENt2KERSZvNAM/VVYC9FvM39kJEAIQtFYM4AJ6D0jFLiFpknqPussd2Pv2QRcOdq/7ahqJVM4oTyU/G6SpsWwX8rBy18ctn33Zo0WkevxCzFEeGFbruyDQGSayDoKjhSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KKKUnIni; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KKKUnIni"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773407994;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PxRnPSKPtSVp5MuMrO5fXmGGCre2VuKNWiErYwV4x6I=;
	b=KKKUnIniY9j6obCcWkJek8ohmhVnw9SCiRylzNv+tsTdSRXOOvbMJnS+QWqEhSbikSdJgR
	nldToJNNVjzU3ddU0cnjPUR/jFRJRQaGMPUFy+zYUKFbcKEhiBRnf1zR3gSSnvVJxntJMJ
	n4gjkprIUdu+PHn5o3S0hYUSumfSAG8=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-93-RumOBlrJO0mB0Rho-nb3Iw-1; Fri,
 13 Mar 2026 09:19:51 -0400
X-MC-Unique: RumOBlrJO0mB0Rho-nb3Iw-1
X-Mimecast-MFC-AGG-ID: RumOBlrJO0mB0Rho-nb3Iw_1773407989
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 203AF1800561;
	Fri, 13 Mar 2026 13:19:49 +0000 (UTC)
Received: from [10.44.32.29] (unknown [10.44.32.29])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 43C7519540C2;
	Fri, 13 Mar 2026 13:19:46 +0000 (UTC)
Date: Fri, 13 Mar 2026 14:19:42 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>
cc: Linlin Zhang <linlin.zhang@oss.qualcomm.com>, linux-block@vger.kernel.org, 
    linux-kernel@vger.kernel.org, adrianvovk@gmail.com, 
    dm-devel@lists.linux.dev, quic_mdalam@quicinc.com, gmazyland@gmail.com, 
    israelr@nvidia.com
Subject: Re: [PATCH v1 3/3] dm-inlinecrypt: Expose inline crypto caps to the
 device
In-Reply-To: <20260312063534.GC2359@sol>
Message-ID: <a31a5696-83a5-f235-7774-ceab2f043e2c@redhat.com>
References: <20260304121729.1532469-1-linlin.zhang@oss.qualcomm.com> <20260304121729.1532469-4-linlin.zhang@oss.qualcomm.com> <20260312063534.GC2359@sol>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: ETO5d-k8o_ePXLSaxXyROjxcvrVp9QTdxvk3CrorPyU_1773407989
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Wed, 11 Mar 2026, Eric Biggers wrote:

> On Wed, Mar 04, 2026 at 04:17:28AM -0800, Linlin Zhang wrote:
> > Add a new DM flag, which means the inline crypto capabilities
> > from underlying devices can be exposed to the DM device, and
> > the DM device consumes these capabilities, rather pass through
> > them to the upper layer.
> > 
> > Signed-off-by: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
> > ---
> >  drivers/md/dm-inlinecrypt.c   | 2 +-
> >  drivers/md/dm-table.c         | 3 ++-
> >  include/linux/device-mapper.h | 7 +++++++
> >  3 files changed, 10 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/md/dm-inlinecrypt.c b/drivers/md/dm-inlinecrypt.c
> > index 251760da9f7e..eda56893d430 100644
> > --- a/drivers/md/dm-inlinecrypt.c
> > +++ b/drivers/md/dm-inlinecrypt.c
> > @@ -396,7 +396,7 @@ static struct target_type inlinecrypt_target = {
> >  	 * Do not set DM_TARGET_PASSES_CRYPTO, since dm-inlinecrypt consumes the
> >  	 * crypto capability itself.
> >  	 */
> > -	.features		= DM_TARGET_ZONED_HM,
> > +	.features		= DM_TARGET_CONSUME_CRYPTO | DM_TARGET_ZONED_HM,
> >  	.module			= THIS_MODULE,
> >  	.ctr			= inlinecrypt_ctr,
> >  	.dtr			= inlinecrypt_dtr,
> > diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> > index 7be1d8dc8bdd..f0580935394a 100644
> > --- a/drivers/md/dm-table.c
> > +++ b/drivers/md/dm-table.c
> > @@ -1407,7 +1407,8 @@ static int dm_table_construct_crypto_profile(struct dm_table *t)
> >  	for (i = 0; i < t->num_targets; i++) {
> >  		struct dm_target *ti = dm_table_get_target(t, i);
> >  
> > -		if (!dm_target_passes_crypto(ti->type)) {
> > +		if (!dm_target_passes_crypto(ti->type)
> > +				&& !dm_target_consume_crypto(ti->type)) {
> >  			blk_crypto_intersect_capabilities(profile, NULL);
> >  			break;
> >  		}
> > diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
> > index 38f625af6ab4..6abd1b4fcb76 100644
> > --- a/include/linux/device-mapper.h
> > +++ b/include/linux/device-mapper.h
> > @@ -306,6 +306,13 @@ struct target_type {
> >  #define dm_target_supports_mixed_zoned_model(type) (false)
> >  #endif
> >  
> > +/*
> > + * A target consumes inline crypto capabilities itself and doesn't support
> > + * passing through inline crypto support.
> > + */
> > +#define DM_TARGET_CONSUME_CRYPTO		0x00000300
> > +#define dm_target_consume_crypto(type) ((type)->features & DM_TARGET_CONSUME_CRYPTO)
> 
> This patch doesn't make any sense.  First, no new flag is needed, as the
> behavior is already correct if you just leave DM_TARGET_PASSES_CRYPTO
> unset, as far as I can tell.  Second, the new flag is numerically equal
> to DM_TARGET_PASSES_CRYPTO|CONFIG_BLK_DEV_ZONED.  Third, even if it had
> a unique bit as seems to have been intended, the behavior is the same as
> DM_TARGET_PASSES_CRYPTO, which should not be used on this target.
> 
> - Eric

OK, I'm dropping this patch from the linux-dm/for-next branch. Thanks for 
review.

Mikulas


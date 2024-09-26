Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD82282FA
	for <dm-devel@lists.linux.dev>; Thu, 26 Sep 2024 20:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727384201; cv=none; b=V318qcjQFL0roXGDzl3o8B1Uyhj17P9R2YQXBGR+a6wHl8PmiAKzncYtu7ZckF/+AfcJ3WUxiRFMxtCcfgA4KRJbp9/Fwu0rcQUu0WskTkIQDU7FkaPd7G7CLyI5fpwlp1W6WugQnnkniwGEoxsFclV/20fZzbEghTcH5oUA4cI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727384201; c=relaxed/simple;
	bh=h1GwKr99Q+8Aae1aqxv8/mxVYwcY4zpw1VyhIe7OHAA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=Mf171QfM8lRtc+r8QWHCGxksG6l0kM6CO0SsIcrCTiGaBYE4n5XjrK/tad0UXzvsvd152U285VEIMZnxw45l3KqkN7z0clpe2WMeXOTaYW8xbukPYjL2zkAYbLSZP37A27u2nHx4YnzIWK1NDC8LwJzNO7d31/clmUIvcFsqQJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L6dsmtAr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L6dsmtAr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727384199;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GNp2wXILCOupJUoFo0bMQIlOq0DDBy1FVAjFIP04ZRU=;
	b=L6dsmtArAyxun2sYesi9RtALIPhV10Uvs9o8jWseRzfFIDkg2K/7/yKhkBmrNYCECwQcpn
	OR5RlM+t26C6XpgwTzdwnxCEOFZtnFdQHmSOvZp3kwJkrNVW3E84DF1ds5ZE0D3fS3wiOW
	zDaL+zFqlV5dx17xcjMHGBNFCSfRks0=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-318-pgdlOI2gOgiNcgKOvgcf_w-1; Thu,
 26 Sep 2024 16:56:36 -0400
X-MC-Unique: pgdlOI2gOgiNcgKOvgcf_w-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (unknown [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 11E5818F38C3;
	Thu, 26 Sep 2024 20:56:35 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.12])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 96388195605A;
	Thu, 26 Sep 2024 20:56:34 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 48QKuX0J1836663
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 26 Sep 2024 16:56:33 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 48QKuXWe1836662;
	Thu, 26 Sep 2024 16:56:33 -0400
Date: Thu, 26 Sep 2024 16:56:33 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Martin Wilck <mwilck@suse.com>,
        Christophe Varoqui <christophe.varoqui@opensvc.com>,
        DM-DEVEL ML <dm-devel@lists.linux.dev>
Subject: Re: [PATCH] multipath-tools: hwtable housekeeping
Message-ID: <ZvXKgRA3x5NnChQW@redhat.com>
References: <20240924235523.56471-1-xose.vazquez@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240924235523.56471-1-xose.vazquez@gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 25, 2024 at 01:55:22AM +0200, Xose Vazquez Perez wrote:
> Update some descriptions. And limit the Dorado regex,
> because "Dorado "is used as a generic brand by Huawei.
> 
> =====================    
> HUASY   Dorado2100
> HUAWEI  Dorado2100
> HUAWEI  Dorado2100 G2
> HUASY   Dorado5100
> HUAWEI  Dorado5100
> =====================    
> 
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> ---
>  libmultipath/hwtable.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index c539a9b5..01d50303 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -819,7 +819,7 @@ static struct hwentry default_hw[] = {
>  	 */
>  	{
>  		/*
> -		 * ONTAP FAS/AFF Series
> +		 * ONTAP FAS/AFF/ASA Series
>  		 *
>  		 * Maintainer: Martin George <marting@netapp.com>
>  		 */
> @@ -1099,7 +1099,7 @@ static struct hwentry default_hw[] = {
>  	 * Pure Storage
>  	 */
>  	{
> -		/* FlashArray */
> +		/* FlashArray family */
>  		.vendor        = "PURE",
>  		.product       = "FlashArray",
>  		.pgpolicy      = GROUP_BY_PRIO,
> @@ -1120,15 +1120,15 @@ static struct hwentry default_hw[] = {
>  	 * Huawei
>  	 */
>  	{
> -		/* All, except OceanStor V3-V6 */
> +		/* Older than OceanStor V3 */
>  		.vendor        = "^(HUAWEI|HUASY|HS)",
> -		.product       = "^(Dorado|HVS8|S[23568]|V1[568]|VIS6000)",
> +		.product       = "^(Dorado[25]|HVS8|S[23568]|V1[568]|VIS6000)",
>  		.pgpolicy      = GROUP_BY_PRIO,
>  		.pgfailback    = -FAILBACK_IMMEDIATE,
>  		.no_path_retry = 15,
>  	},
>  	{
> -		/* OceanStor V3-V6 */
> +		/* OceanStor V3 or better */
>  		.vendor        = "^(HUAWEI|AnyStor|Marstor|NETPOSA|SanM|SUGON|UDsafe)",
>  		.product       = "XSG1",
>  		.pgpolicy      = GROUP_BY_PRIO,
> -- 
> 2.46.1


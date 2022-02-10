Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B43CC433F5
	for <dm-devel@archiver.kernel.org>; Thu, 10 Feb 2022 18:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1644518550;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=C0Cw0FY1f77tMhORLdT1q4eomA38xXU8Qg9j4y+1lKg=;
	b=gbJbcIkfzEJpZj/Ak9URnphd11kQy9oghl3GDInrffrJxc8YP0vllDVAMKxmcgfOHMFP3H
	KzhWH3vWFpnKjLmWXvHyhObHGJueZg3w8dh3H3HBjqIEYHEl7dITSxI4SswNGgKM6qfF1X
	ebspofDilR0ijlT6L79SRuHQUgRnRm8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-32-TRRCmGQOM0O232Il8xPPWQ-1; Thu, 10 Feb 2022 13:42:26 -0500
X-MC-Unique: TRRCmGQOM0O232Il8xPPWQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 698911091DA1;
	Thu, 10 Feb 2022 18:42:22 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4C43087941;
	Thu, 10 Feb 2022 18:42:22 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 261184BB7C;
	Thu, 10 Feb 2022 18:42:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
	[10.5.11.16])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21AIgKVI028632 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 10 Feb 2022 13:42:20 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 9FBF5838FA; Thu, 10 Feb 2022 18:42:20 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8129E838F5;
	Thu, 10 Feb 2022 18:42:10 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 21AIg87O005886; 
	Thu, 10 Feb 2022 12:42:08 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 21AIg7jj005885;
	Thu, 10 Feb 2022 12:42:07 -0600
Date: Thu, 10 Feb 2022 12:42:07 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Steffen Maier <maier@linux.ibm.com>
Message-ID: <20220210184207.GF24684@octiron.msp.redhat.com>
References: <20220209194713.56556-1-maier@linux.ibm.com>
	<20220209194713.56556-3-maier@linux.ibm.com>
MIME-Version: 1.0
In-Reply-To: <20220209194713.56556-3-maier@linux.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, ShivaKrishna Merla <shivakrishna.merla@netapp.com>,
	Martin Wilck <martin.wilck@suse.com>
Subject: Re: [dm-devel] [PATCH 2/2] libmultipath: add %L path wildcard for
	64-bit hex LUN
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Feb 09, 2022 at 08:47:13PM +0100, Steffen Maier wrote:
> Complements v0.6.0 commit
> 01ab2a468ea2 ("libmultipath: Add additional path wildcards") as well as
> ("libmultipath: support host adapter name lookup for s390x ccw bus").
> 
> With that we can easily get the full FCP addressing triplet
> (HBA, WWPN, FCPLUN) from multipath tools without additional tools
> and correlation:
> 
> $ multipathd -k'show paths format "%w|%a|%r|%L"'
> uuid                             |host adapter|target WWPN       |LUN hex
> 36005076400820293e8000000000000a0|0.0.5080    |0x500507680b25c449|0x00a0000000000000
> 36005076400820293e8000000000000a0|0.0.5080    |0x500507680b25c448|0x00a0000000000000
> 36005076400820293e8000000000000a0|0.0.50c0    |0x500507680b26c449|0x00a0000000000000
> 36005076400820293e8000000000000a0|0.0.50c0    |0x500507680b26c448|0x00a0000000000000
> 
> Likewise, add a field lun_hex for JSON path output.
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
> Signed-off-by: Steffen Maier <maier@linux.ibm.com>
> ---
>  libmultipath/print.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/libmultipath/print.c b/libmultipath/print.c
> index 221b515f23d3..4f6146e85fc9 100644
> --- a/libmultipath/print.c
> +++ b/libmultipath/print.c
> @@ -96,6 +96,7 @@
>  			     "            \"host_wwpn\" : \"%R\",\n" \
>  			     "            \"target_wwpn\" : \"%r\",\n" \
>  			     "            \"host_adapter\" : \"%a\",\n" \
> +			     "            \"lun_hex\" : \"%L\",\n" \
>  			     "            \"marginal_st\" : \"%M\""
>  
>  #define PROGRESS_LEN  10
> @@ -451,6 +452,24 @@ snprint_hcil (struct strbuf *buff, const struct path * pp)
>  			pp->sg_id.lun);
>  }
>  
> +
> +static int
> +snprint_path_lunhex (struct strbuf *buff, const struct path * pp)
> +{
> +	uint64_t lunhex = SCSI_INVALID_LUN, scsilun;
> +
> +	if (!pp || pp->sg_id.host_no < 0)
> +		return print_strbuf(buff, "0x%016" PRIx64, lunhex);
> +
> +	scsilun = pp->sg_id.lun;
> +	/* cf. Linux kernel function int_to_scsilun() */
> +	lunhex = ((scsilun & 0x000000000000ffffULL) << 48) |
> +		((scsilun & 0x00000000ffff0000ULL) << 16) |
> +		((scsilun & 0x0000ffff00000000ULL) >> 16) |
> +		((scsilun & 0xffff000000000000ULL) >> 48);
> +	return print_strbuf(buff, "0x%016" PRIx64, lunhex);
> +}
> +
>  static int
>  snprint_dev (struct strbuf *buff, const struct path * pp)
>  {
> @@ -842,6 +861,7 @@ static const struct path_data pd[] = {
>  	{'0', "failures",      snprint_path_failures},
>  	{'P', "protocol",      snprint_path_protocol},
>  	{'I', "init_st",       snprint_initialized},
> +	{'L', "LUN hex",       snprint_path_lunhex},
>  };
>  
>  static const struct pathgroup_data pgd[] = {
> -- 
> 2.27.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


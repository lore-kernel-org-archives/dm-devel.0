Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B977DC433EF
	for <dm-devel@archiver.kernel.org>; Wed,  1 Dec 2021 18:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1638383774;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=bHYzqdEPtUaw04oUMoazW5IiPloYO5RYOZuXX5p1THc=;
	b=CK9fDH8CaYR9HrlLJi9MaX6UWBVbRluwB6TDAJrley45kcaepRROJPAIOdb+rVzwYM1FG9
	3+cw+Cm0R/Y9NDx1+/1tioUshuuL57r/zJk8UE/C9kJHriYV2OHoO05LYuu76DTjxrkmjf
	s+zlqWoUFFitSMrlhuxezKORR34E+/M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-397-JJJKDXwjNj-5KLav6fKZGw-1; Wed, 01 Dec 2021 13:36:13 -0500
X-MC-Unique: JJJKDXwjNj-5KLav6fKZGw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 213F8102CC41;
	Wed,  1 Dec 2021 18:35:42 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E482E1000051;
	Wed,  1 Dec 2021 18:35:38 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 847FC4BB7C;
	Wed,  1 Dec 2021 18:35:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
	[10.5.11.13])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1B1IZVo1026543 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 1 Dec 2021 13:35:31 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id EFC6187949; Wed,  1 Dec 2021 18:35:30 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6488F84643;
	Wed,  1 Dec 2021 18:35:30 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1B1IZS0m006121; 
	Wed, 1 Dec 2021 12:35:28 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1B1IZR4Y006120;
	Wed, 1 Dec 2021 12:35:27 -0600
Date: Wed, 1 Dec 2021 12:35:27 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20211201183527.GP19591@octiron.msp.redhat.com>
References: <20211201123650.16240-1-mwilck@suse.com>
	<20211201123650.16240-6-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20211201123650.16240-6-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH v2 05/21] libmultipath (coverity): improve
 input checking in parse_vpd_pg83
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Dec 01, 2021 at 01:36:34PM +0100, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Check offsets and other obvious errors in the VPD83 data.
> 
> The original reason to do this was to fix "tained scalar"
> warnings from coverity. But this doesn't suffice for coverity
> without using a constant boundary (WWID_SIZE) for "len" in
> parse_vpd_pg80() and for "vpd_len" in parse_vpd_pg83(), even
> though the computed boundaries are tighter than the constant
> ones.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/discovery.c | 134 +++++++++++++++++++++++++--------------
>  1 file changed, 88 insertions(+), 46 deletions(-)
> 
> diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> index 36ea7b3..977aed9 100644
> --- a/libmultipath/discovery.c
> +++ b/libmultipath/discovery.c
> @@ -36,6 +36,8 @@
>  #include "print.h"
>  #include "strbuf.h"
>  
> +#define VPD_BUFLEN 4096
> +
>  struct vpd_vendor_page vpd_vendor_pages[VPD_VP_ARRAY_SIZE] = {
>  	[VPD_VP_UNDEF]	= { 0x00, "undef" },
>  	[VPD_VP_HP3PAR]	= { 0xc0, "hp3par" },
> @@ -1086,6 +1088,8 @@ parse_vpd_pg80(const unsigned char *in, char *out, size_t out_len)
>  	if (out_len == 0)
>  		return 0;
>  
> +	if (len > WWID_SIZE)
> +		len = WWID_SIZE;
>  	/*
>  	 * Strip leading and trailing whitespace
>  	 */
> @@ -1115,84 +1119,123 @@ parse_vpd_pg83(const unsigned char *in, size_t in_len,
>  	const unsigned char *d;
>  	const unsigned char *vpd = NULL;
>  	size_t len, vpd_len, i;
> -	int vpd_type, prio = -1, naa_prio;
> +	int vpd_type, prio = -1;
> +	int err = -ENODATA;
> +
> +	/* Need space at least for one digit */
> +	if (out_len <= 1)
> +		return 0;
>  
>  	d = in + 4;
> -	while (d < in + in_len) {
> +	while (d <= in + in_len - 4) {
> +		bool invalid = false;
> +		int new_prio = -1;
> +
>  		/* Select 'association: LUN' */
> -		if ((d[1] & 0x30) != 0) {
> -			d += d[3] + 4;
> -			continue;
> -		}
> +		if ((d[1] & 0x30) == 0x30) {
> +			invalid = true;
> +			goto next_designator;
> +		} else if ((d[1] & 0x30) != 0x00)
> +			goto next_designator;
> +
>  		switch (d[1] & 0xf) {
> +			unsigned char good_len;
>  		case 0x3:
>  			/* NAA: Prio 5 */
>  			switch (d[4] >> 4) {
>  			case 6:
>  				/* IEEE Registered Extended: Prio 8 */
> -				naa_prio = 8;
> +				new_prio = 8;
> +				good_len = 16;
>  				break;
>  			case 5:
>  				/* IEEE Registered: Prio 7 */
> -				naa_prio = 7;
> +				new_prio = 7;
> +				good_len = 8;
>  				break;
>  			case 2:
>  				/* IEEE Extended: Prio 6 */
> -				naa_prio = 6;
> +				new_prio = 6;
> +				good_len = 8;
>  				break;
>  			case 3:
>  				/* IEEE Locally assigned: Prio 1 */
> -				naa_prio = 1;
> +				new_prio = 1;
> +				good_len = 8;
>  				break;
>  			default:
>  				/* Default: no priority */
> -				naa_prio = -1;
> +				good_len = 0xff;
>  				break;
>  			}
> -			if (prio < naa_prio) {
> -				prio = naa_prio;
> -				vpd = d;
> -			}
> +
> +			invalid = good_len == 0xff || good_len != d[3];
>  			break;
>  		case 0x2:
>  			/* EUI-64: Prio 4 */
> -			if (prio < 4) {
> -				prio = 4;
> -				vpd = d;
> -			}
> +			invalid = (d[3] != 8 && d[3] != 12 && d[3] != 16);
> +			new_prio = 4;
>  			break;
>  		case 0x8:
>  			/* SCSI Name: Prio 3 */
> -			if (memcmp(d + 4, "eui.", 4) &&
> -			    memcmp(d + 4, "naa.", 4) &&
> -			    memcmp(d + 4, "iqn.", 4))
> -				break;
> -			if (prio < 3) {
> -				prio = 3;
> -				vpd = d;
> -			}
> +			invalid = (d[3] < 4 || (memcmp(d + 4, "eui.", 4) &&
> +						memcmp(d + 4, "naa.", 4) &&
> +						memcmp(d + 4, "iqn.", 4)));
> +			new_prio = 3;
>  			break;
>  		case 0x1:
>  			/* T-10 Vendor ID: Prio 2 */
> -			if (prio < 2) {
> -				prio = 2;
> -				vpd = d;
> -			}
> +			invalid = (d[3] < 8);
> +			new_prio = 2;
>  			break;
> +		case 0xa:
> +			condlog(2, "%s: UUID identifiers not yet supported",
> +				__func__);
> +			break;
> +		default:
> +			invalid = true;
> +			break;
> +		}
> +
> +	next_designator:
> +		if (d + d[3] + 4 - in > (ssize_t)in_len) {
> +			condlog(2, "%s: device descriptor length overflow: %zd > %zu",
> +				__func__, d + d[3] + 4 - in, in_len);
> +			err = -EOVERFLOW;
> +			break;
> +		} else if (invalid) {
> +			condlog(2, "%s: invalid device designator at offset %zd: %02x%02x%02x%02x",
> +				__func__, d - in, d[0], d[1], d[2], d[3]);
> +			/*
> +			 * We checked above that the next offset is within limits.
> +			 * Proceed, fingers crossed.
> +			 */
> +			err = -EINVAL;
> +		} else if (new_prio > prio) {
> +			vpd = d;
> +			prio = new_prio;
>  		}
>  		d += d[3] + 4;
>  	}
>  
>  	if (prio <= 0)
> -		return -ENODATA;
> -	/* Need space at least for one digit */
> -	else if (out_len <= 1)
> -		return 0;
> +		return err;
> +
> +	if (d != in + in_len)
> +		/* Should this be fatal? (overflow covered above) */
> +		condlog(2, "%s: warning: last descriptor end %zd != VPD length %zu",
> +			__func__, d - in, in_len);
>  
>  	len = 0;
>  	vpd_type = vpd[1] & 0xf;
>  	vpd_len = vpd[3];
>  	vpd += 4;
> +	/* untaint vpd_len for coverity */
> +	if (vpd_len > WWID_SIZE) {
> +		condlog(1, "%s: suspicious designator length %zu truncated to %u",
> +			__func__, vpd_len, WWID_SIZE);
> +		vpd_len = WWID_SIZE;
> +	}
>  	if (vpd_type == 0x2 || vpd_type == 0x3) {
>  		size_t i;
>  
> @@ -1206,10 +1249,6 @@ parse_vpd_pg83(const unsigned char *in, size_t in_len,
>  		for (i = 0; i < vpd_len; i++)
>  			len += sprintf(out + len,
>  				       "%02x", vpd[i]);
> -	} else if (vpd_type == 0x8 && vpd_len < 4) {
> -		condlog(1, "%s: VPD length %zu too small for designator type 8",
> -			__func__, vpd_len);
> -		return -EINVAL;
>  	} else if (vpd_type == 0x8) {
>  		if (!memcmp("eui.", vpd, 4))
>  			out[0] =  '2';
> @@ -1316,11 +1355,12 @@ parse_vpd_c0_hp3par(const unsigned char *in, size_t in_len,
>  static int
>  get_vpd_sysfs (struct udev_device *parent, int pg, char * str, int maxlen)
>  {
> -	int len, buff_len;
> -	unsigned char buff[4096];
> +	int len;
> +	size_t buff_len;
> +	unsigned char buff[VPD_BUFLEN];
>  
> -	memset(buff, 0x0, 4096);
> -	if (!parent || sysfs_get_vpd(parent, pg, buff, 4096) <= 0) {
> +	memset(buff, 0x0, VPD_BUFLEN);
> +	if (!parent || sysfs_get_vpd(parent, pg, buff, VPD_BUFLEN) <= 0) {
>  		condlog(3, "failed to read sysfs vpd pg%02x", pg);
>  		return -EINVAL;
>  	}
> @@ -1331,8 +1371,10 @@ get_vpd_sysfs (struct udev_device *parent, int pg, char * str, int maxlen)
>  		return -ENODATA;
>  	}
>  	buff_len = get_unaligned_be16(&buff[2]) + 4;
> -	if (buff_len > 4096)
> +	if (buff_len > VPD_BUFLEN) {
>  		condlog(3, "vpd pg%02x page truncated", pg);
> +		buff_len = VPD_BUFLEN;
> +	}
>  
>  	if (pg == 0x80)
>  		len = parse_vpd_pg80(buff, str, maxlen);
> @@ -1376,7 +1418,7 @@ bool
>  is_vpd_page_supported(int fd, int pg)
>  {
>  	int i, len;
> -	unsigned char buff[4096];
> +	unsigned char buff[VPD_BUFLEN];
>  
>  	len = fetch_vpd_page(fd, 0x00, buff, sizeof(buff));
>  	if (len < 0)
> @@ -1392,7 +1434,7 @@ int
>  get_vpd_sgio (int fd, int pg, int vend_id, char * str, int maxlen)
>  {
>  	int len, buff_len;
> -	unsigned char buff[4096];
> +	unsigned char buff[VPD_BUFLEN];
>  
>  	buff_len = fetch_vpd_page(fd, pg, buff, sizeof(buff));
>  	if (buff_len < 0)
> -- 
> 2.33.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


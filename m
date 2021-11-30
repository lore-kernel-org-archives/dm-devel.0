Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACD9AC433F5
	for <dm-devel@archiver.kernel.org>; Tue, 30 Nov 2021 01:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1638235113;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=pZ9nHRf97qm70GsnGiJ6s553IhRvMjFqytFGodDIs2Y=;
	b=Og+ZjHp4+WHBzr6+RPAoKB39LPK8xdTqbLhZKOBzjj0hIM+R/IDkbN3ubI7TPlZeXgCD+E
	uhOe6t8AFR6jqgWiZQf5KsZJalhJxv+QL04fez4F5PuOcEac8EHsK2MI0wQLftXbHiVnbl
	0tssGzMxVfAuqY85JpDSRiyqyNyOg1c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-260-ktkAZs32NLmmNoxfjHRu-Q-1; Mon, 29 Nov 2021 20:18:29 -0500
X-MC-Unique: ktkAZs32NLmmNoxfjHRu-Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 52DC51023F4D;
	Tue, 30 Nov 2021 01:18:25 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A2A8A608BA;
	Tue, 30 Nov 2021 01:18:23 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 95E3E1809C89;
	Tue, 30 Nov 2021 01:18:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
	[10.5.11.16])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AU1IJ4F026456 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 29 Nov 2021 20:18:19 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 73DD55C1C5; Tue, 30 Nov 2021 01:18:19 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3DC7A77E21;
	Tue, 30 Nov 2021 01:18:04 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1AU1I13j023951; 
	Mon, 29 Nov 2021 19:18:01 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1AU1I0YU023950;
	Mon, 29 Nov 2021 19:18:00 -0600
Date: Mon, 29 Nov 2021 19:17:59 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20211130011759.GG19591@octiron.msp.redhat.com>
References: <20211118231338.22358-1-mwilck@suse.com>
	<20211118231338.22358-6-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20211118231338.22358-6-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 05/21] libmultipath (coverity): improve input
 checking in parse_vpd_pg83
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

On Fri, Nov 19, 2021 at 12:13:22AM +0100, mwilck@suse.com wrote:
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

This looks fine, but I do wonder if we are being too strict.  I'm not
sure we should be failing, if sg_inq wouldn't fail.  The goal of the
fallback code is to get the WWID the udev would have gotten, and being
lenient with scsi devices that don't quite follow the standard is
usually the best policy. Thoughts?

-Ben


> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/discovery.c | 139 +++++++++++++++++++++++++--------------
>  1 file changed, 90 insertions(+), 49 deletions(-)
> 
> diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> index 5edf959..5ce9031 100644
> --- a/libmultipath/discovery.c
> +++ b/libmultipath/discovery.c
> @@ -37,6 +37,8 @@
>  #include "print.h"
>  #include "strbuf.h"
>  
> +#define VPD_BUFLEN 4096
> +
>  struct vpd_vendor_page vpd_vendor_pages[VPD_VP_ARRAY_SIZE] = {
>  	[VPD_VP_UNDEF]	= { 0x00, "undef" },
>  	[VPD_VP_HP3PAR]	= { 0xc0, "hp3par" },
> @@ -1085,6 +1087,8 @@ parse_vpd_pg80(const unsigned char *in, char *out, size_t out_len)
>  	if (out_len == 0)
>  		return 0;
>  
> +	if (len > WWID_SIZE)
> +		len = WWID_SIZE;
>  	/*
>  	 * Strip leading and trailing whitespace
>  	 */
> @@ -1114,84 +1118,122 @@ parse_vpd_pg83(const unsigned char *in, size_t in_len,
>  	const unsigned char *d;
>  	const unsigned char *vpd = NULL;
>  	size_t len, vpd_len, i;
> -	int vpd_type, prio = -1, naa_prio;
> +	int vpd_type, prio = -1;
> +	int err = -ENODATA;
>  
> -	d = in + 4;
> -	while (d < in + in_len) {
> -		/* Select 'association: LUN' */
> -		if ((d[1] & 0x30) != 0) {
> -			d += d[3] + 4;
> -			continue;
> -		}
> -		switch (d[1] & 0xf) {
> +        /* Need space at least for one digit */
> +	if (out_len <= 1)
> +		return 0;
> +
> +        d = in + 4;
> +	while (d <= in + in_len - 4) {
> +		bool invalid = false;
> +		int new_prio = -1;
> +
> +                /* Select 'association: LUN' */
> +		if ((d[1] & 0x30) == 0x30) {
> +			invalid = true;
> +			goto next_designator;
> +		} else if ((d[1] & 0x30) != 0x00)
> +			goto next_designator;
> +
> +                switch (d[1] & 0xf) {
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
> +                        invalid = good_len == 0xff || good_len != d[3];
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
> +		}
> +                if (invalid) {
> +			condlog(2, "%s: invalid device designator at offset %zd: %02x%02x%02x%02x",
> +				__func__, d - in, d[0], d[1], d[2], d[3]);
> +			err = -EINVAL;
> +			break;
> +		}
> +		if (new_prio > prio) {
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
> @@ -1205,10 +1247,6 @@ parse_vpd_pg83(const unsigned char *in, size_t in_len,
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
> @@ -1315,11 +1353,12 @@ parse_vpd_c0_hp3par(const unsigned char *in, size_t in_len,
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
> @@ -1330,8 +1369,10 @@ get_vpd_sysfs (struct udev_device *parent, int pg, char * str, int maxlen)
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
> @@ -1375,7 +1416,7 @@ bool
>  is_vpd_page_supported(int fd, int pg)
>  {
>  	int i, len;
> -	unsigned char buff[4096];
> +	unsigned char buff[VPD_BUFLEN];
>  
>  	len = fetch_vpd_page(fd, 0x00, buff, sizeof(buff));
>  	if (len < 0)
> @@ -1391,7 +1432,7 @@ int
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


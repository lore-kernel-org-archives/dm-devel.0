Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D56BC433EF
	for <dm-devel@archiver.kernel.org>; Mon, 22 Nov 2021 16:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1637598447;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=zF++cavHzKx4bPvBOQHvIcRgGnr4mkB2WgRKAaA92kY=;
	b=Ion3fYAxenwHm1PoPPVrhZpEeRtwbt/XhczXPsvI11TO+fSY/mjg3HSEMeMkPwTPzSHMSY
	cskwCN8AMc0eGmfW0iJdh7yClFCtGkIt05ESZZyUlEZwgmAO0SR2GyCBk9xrrNwdXgtiTH
	WlS8YxyXr7mp2NsLlYumBL9nWva1GHw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-257-Lya_036GOwGJqkvwWkr6cA-1; Mon, 22 Nov 2021 11:27:23 -0500
X-MC-Unique: Lya_036GOwGJqkvwWkr6cA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B374A81CAFB;
	Mon, 22 Nov 2021 16:27:18 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2FC9319E7E;
	Mon, 22 Nov 2021 16:27:18 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9D50F1832E81;
	Mon, 22 Nov 2021 16:27:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
	[10.5.11.15])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AMGRGfI024592 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 22 Nov 2021 11:27:16 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 294C456A8C; Mon, 22 Nov 2021 16:27:16 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3C72A5D6D5;
	Mon, 22 Nov 2021 16:27:02 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1AMGR0pl006907; 
	Mon, 22 Nov 2021 10:27:00 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1AMGQxrv006906;
	Mon, 22 Nov 2021 10:26:59 -0600
Date: Mon, 22 Nov 2021 10:26:59 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: lixiaokeng <lixiaokeng@huawei.com>
Message-ID: <20211122162659.GK19591@octiron.msp.redhat.com>
References: <860bf2b5-23b1-3a61-5a63-96fe5c2fe6d8@huawei.com>
	<46cc16b7-6901-3ba0-8499-090015aa156d@huawei.com>
MIME-Version: 1.0
In-Reply-To: <46cc16b7-6901-3ba0-8499-090015aa156d@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-loop: dm-devel@redhat.com
Cc: linfeilong <linfeilong@huawei.com>,
	dm-devel mailing list <dm-devel@redhat.com>,
	Martin Wilck <mwilck@suse.com>,
	"liuzhiqiang \(I\)" <liuzhiqiang26@huawei.com>
Subject: Re: [dm-devel] [PATCH v3 1/3] Fix potential null pointer dereference
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Nov 22, 2021 at 12:01:52PM +0800, lixiaokeng wrote:
> udev_device_* may return NULL, check it.
> 
> Signed-off-by: Lixiaokeng <lixiaokeng@huawei.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/discovery.c    | 8 +++++---
>  libmultipath/foreign/nvme.c | 4 +++-
>  libmultipath/util.c         | 9 ++++++++-
>  3 files changed, 16 insertions(+), 5 deletions(-)
> 
> diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> index f25fe9e3..07ebe7d5 100644
> --- a/libmultipath/discovery.c
> +++ b/libmultipath/discovery.c
> @@ -388,8 +388,10 @@ sysfs_get_tgt_nodename(struct path *pp, char *node)
>  		if (value && !strcmp(value, "usb")) {
>  			pp->sg_id.proto_id = SCSI_PROTOCOL_USB;
>  			tgtname = udev_device_get_sysname(tgtdev);
> -			strlcpy(node, tgtname, NODE_NAME_SIZE);
> -			return 0;
> +			if (tgtname) {
> +				strlcpy(node, tgtname, NODE_NAME_SIZE);
> +				return 0;
> +			}
>  		}
>  		tgtdev = udev_device_get_parent(tgtdev);
>  	}
> @@ -803,7 +805,7 @@ sysfs_set_nexus_loss_tmo(struct multipath *mpp, struct path *pp)
>  	     parent = udev_device_get_parent(parent)) {
>  		const char *ed = udev_device_get_sysname(parent);
> 
> -		if (!strncmp(ed, ed_str, sizeof(ed_str) - 1)) {
> +		if (ed && !strncmp(ed, ed_str, sizeof(ed_str) - 1)) {
>  			end_dev_id = ed;
>  			break;
>  		}
> diff --git a/libmultipath/foreign/nvme.c b/libmultipath/foreign/nvme.c
> index d40c0869..499b881d 100644
> --- a/libmultipath/foreign/nvme.c
> +++ b/libmultipath/foreign/nvme.c
> @@ -184,7 +184,9 @@ static int snprint_nvme_map(const struct gen_multipath *gmp,
>  							      "firmware_rev"));
>  	case 'r':
>  		val = udev_device_get_sysattr_value(nvm->udev, "ro");
> -		if (val[0] == 1)
> +		if (!val)
> +			return append_strbuf_str(buff, "undef");
> +		else if (val[0] == 1)
>  			return append_strbuf_str(buff, "ro");
>  		else
>  			return append_strbuf_str(buff, "rw");
> diff --git a/libmultipath/util.c b/libmultipath/util.c
> index ea858409..b3ed5ff9 100644
> --- a/libmultipath/util.c
> +++ b/libmultipath/util.c
> @@ -168,6 +168,7 @@ size_t strlcat(char * restrict dst, const char * restrict src, size_t size)
>  int devt2devname(char *devname, int devname_len, const char *devt)
>  {
>  	struct udev_device *u_dev;
> +	const char * dev_name;
>  	int r;
> 
>  	if (!devname || !devname_len || !devt)
> @@ -178,7 +179,13 @@ int devt2devname(char *devname, int devname_len, const char *devt)
>  		condlog(0, "\"%s\": invalid major/minor numbers, not found in sysfs", devt);
>  		return 1;
>  	}
> -	r = strlcpy(devname, udev_device_get_sysname(u_dev), devname_len);
> +
> +	dev_name = udev_device_get_sysname(u_dev);
> +	if (!dev_name) {
> +		udev_device_unref(u_dev);
> +		return 1;
> +	}
> +	r = strlcpy(devname, dev_name, devname_len);
>  	udev_device_unref(u_dev);
> 
>  	return !(r < devname_len);
> -- 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


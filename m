Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C0C3C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 10 Feb 2022 18:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1644518511;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=aIPrDGP9IKLXeZolTwpmq/Psh8jItqCjS/Wq2RbKWOk=;
	b=SPCQFFLWv9ZQjuNx/c1wDmKJQGuCfMYtI23FP7uXdfKNYU+wDZVf8HZluuiHHq2iLO1LDP
	r33XDOW/ownFLtNInh2mH4VAApL1jLzx7y4Qcd3LwmBUn0iepvbN1haKqm8JNVlvAdIZFM
	XFUv6/CYMj47Jqi50XPrj4VPRNqwuBI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-591-RrpyLCcYNEiwUBuymmEzLQ-1; Thu, 10 Feb 2022 13:41:48 -0500
X-MC-Unique: RrpyLCcYNEiwUBuymmEzLQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4D5C284DA46;
	Thu, 10 Feb 2022 18:41:42 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E13657747A;
	Thu, 10 Feb 2022 18:41:41 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 61EA74BB7C;
	Thu, 10 Feb 2022 18:41:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
	[10.5.11.15])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21AIfccj028561 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 10 Feb 2022 13:41:38 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 7A2E97747A; Thu, 10 Feb 2022 18:41:38 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7999F77C84;
	Thu, 10 Feb 2022 18:41:37 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 21AIfZoe005866; 
	Thu, 10 Feb 2022 12:41:35 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 21AIfYNq005865;
	Thu, 10 Feb 2022 12:41:34 -0600
Date: Thu, 10 Feb 2022 12:41:33 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Steffen Maier <maier@linux.ibm.com>
Message-ID: <20220210184133.GE24684@octiron.msp.redhat.com>
References: <20220209194713.56556-1-maier@linux.ibm.com>
	<20220209194713.56556-2-maier@linux.ibm.com>
MIME-Version: 1.0
In-Reply-To: <20220209194713.56556-2-maier@linux.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, ShivaKrishna Merla <shivakrishna.merla@netapp.com>,
	Martin Wilck <martin.wilck@suse.com>
Subject: Re: [dm-devel] [PATCH 1/2] libmultipath: support host adapter name
 lookup for s390x ccw bus
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Feb 09, 2022 at 08:47:12PM +0100, Steffen Maier wrote:
> There are also (FCP) HBAs that appear on a bus different from PCI.
> 
> Complements v0.6.0 commit
> 01ab2a468ea2 ("libmultipath: Add additional path wildcards").
> 
> With that we can easily get the full FCP addressing triplet
> (HBA, WWPN, LUN) from multipath tools without additional tools
> and correlation:
> 
> $ multipathd -k'show paths format "%w|%i|%a|%r"'
> uuid                             |hcil       |host adapter|target WWPN
> 36005076400820293e8000000000000a0|1:0:3:160  |0.0.5080    |0x500507680b25c449
> 36005076400820293e8000000000000a0|1:0:4:160  |0.0.5080    |0x500507680b25c448
> 36005076400820293e8000000000000a0|58:0:3:160 |0.0.50c0    |0x500507680b26c449
> 36005076400820293e8000000000000a0|58:0:4:160 |0.0.50c0    |0x500507680b26c448
> 
>                                               ^^^^^^^^
>                                    instead of [undef]
> 
> As a side effect this patch theoretically also enables group by
> host adapter for s390x based on v0.6.0 commit a28e61e5cc9a
> ("Crafted ordering of child paths for round robin path selector").

This looks good in general, but I have some minor issues.
 
> Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
> Signed-off-by: Steffen Maier <maier@linux.ibm.com>
> ---
>  libmultipath/discovery.c | 41 +++++++++++++++++++++++++++++++++++++++-
>  libmultipath/discovery.h |  1 +
>  2 files changed, 41 insertions(+), 1 deletion(-)
> 
> diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> index 7d939ae08004..bb4913d9b75f 100644
> --- a/libmultipath/discovery.c
> +++ b/libmultipath/discovery.c
> @@ -497,8 +497,12 @@ int sysfs_get_host_adapter_name(const struct path *pp, char *adapter_name)
>  		return sysfs_get_iscsi_ip_address(pp, adapter_name);
>  
>  	/* fetch adapter pci name for other protocols
> +	 * or try to get s390x channel subsystem FCP device bus-ID [zfcp]
>  	 */
> -	return sysfs_get_host_pci_name(pp, adapter_name);
> +	if (sysfs_get_host_pci_name(pp, adapter_name))
> +		return sysfs_get_host_ccw_name(pp, adapter_name);
> +	else
> +		return 0;
>  }
>  
>  int sysfs_get_host_pci_name(const struct path *pp, char *pci_name)
> @@ -545,6 +549,41 @@ int sysfs_get_host_pci_name(const struct path *pp, char *pci_name)
>  	return 1;
>  }
>  

I realize that sysfs_get_host_pci_name() isn't a global function, but
there's no good reason for that, since nothing calls it outside of
discovery.c. sysfs_get_host_ccw_name() should be static.
> +int sysfs_get_host_ccw_name(const struct path *pp, char *ccw_name)
> +{

This looks very much like sysfs_get_host_pci_name(). The only difference
is in grabbing the correct sysfs parent.  It seems like they could be
combined into one function that first attempts to grab the pci device,
and failing that, grabs the ccw device.

Unless, or course, there is a good reason why we might want to call
these functions outside of sysfs_get_host_adapter_name() that I'm
missing. If so, you can ignore all this. 

Thanks
-Ben

> +	struct udev_device *hostdev, *parent;
> +	char host_name[HOST_NAME_LEN];
> +	const char *value;
> +
> +	if (!pp || !ccw_name)
> +		return 1;
> +
> +	sprintf(host_name, "host%d", pp->sg_id.host_no);
> +	hostdev = udev_device_new_from_subsystem_sysname(udev,
> +			"scsi_host", host_name);
> +	if (!hostdev)
> +		return 1;
> +
> +	parent = udev_device_get_parent_with_subsystem_devtype(hostdev, "ccw",
> +							       NULL);
> +	if (parent) {
> +		/* s390x ccw FCP device found
> +		 */
> +		value = udev_device_get_sysname(parent);
> +
> +		if (!value) {
> +			udev_device_unref(hostdev);
> +			return 1;
> +		}
> +
> +		strncpy(ccw_name, value, SLOT_NAME_SIZE);
> +		udev_device_unref(hostdev);
> +		return 0;
> +	}
> +	udev_device_unref(hostdev);
> +	return 1;
> +}
> +
>  int sysfs_get_iscsi_ip_address(const struct path *pp, char *ip_address)
>  {
>  	struct udev_device *hostdev;
> diff --git a/libmultipath/discovery.h b/libmultipath/discovery.h
> index 095657bb9de4..0a58c725d700 100644
> --- a/libmultipath/discovery.h
> +++ b/libmultipath/discovery.h
> @@ -44,6 +44,7 @@ int store_pathinfo (vector pathvec, struct config *conf,
>  		    struct path **pp_ptr);
>  int sysfs_set_scsi_tmo (struct multipath *mpp, unsigned int checkint);
>  int sysfs_get_timeout(const struct path *pp, unsigned int *timeout);
> +int sysfs_get_host_ccw_name(const struct path *pp, char *ccw_name);
>  int sysfs_get_host_pci_name(const struct path *pp, char *pci_name);
>  int sysfs_get_iscsi_ip_address(const struct path *pp, char *ip_address);
>  int sysfs_get_host_adapter_name(const struct path *pp,
> 
> base-commit: d9d7ae9e2125116b465b4ff4d98ce65fe0eac3cc
> -- 
> 2.27.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


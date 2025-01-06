Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A014E18A6AC
	for <dm-devel@lists.linux.dev>; Mon,  6 Jan 2025 17:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736185185; cv=none; b=n/6Ns1I2acfRt7QWr702SVvMOnK+HJCsuf6cAQhnnex+6tsEFpYekrmqDFrTu+e9x2spZLgBwfJGsPlIkyJnDOsrLGitbfpYo6CUrRgYSZWDdBAdZkUtb+SGHJSw39l17cdhHnZhK6Y20xM4oeQ6vfat0nVFs+vjpqpNwmYhDdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736185185; c=relaxed/simple;
	bh=R0eQYhLWMqj0ekFFbgxV0fnP7R+ciTQAhMCSyKszko8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=Ny/r8uJ0JLrca/j8vJ2aoYIpbzwkYwo/6efKOvy3aIjiirfp9hUT9PDlunCophJDhbC3TlBhCuUzFHCjJsOTuVlvg0p9UttIuIWEqCC/fgfCgvMBq8b8LaG23qP6bORWPBwPAuXNirjqEeXhUkA6olCJ6L4jzFKvZBXsvV9EW40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DbecCeOK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DbecCeOK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736185182;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qM871UlWG4Aynsm7L3T0mQAX/Osb5X/GmjLw5N1vE60=;
	b=DbecCeOKtDCIiTsb0/2E1G6F1FIhiiM930weawhy/RX2StoPHqmw/Hf9kZxhB/K7t+lcii
	wpIW/C1KESORNQAdiwJwfKuVBaMJtXG1913k4CUXpXNRxPJ1QzNAxktSF4VP2k/NAwGvMB
	jCxNQgA0DGEM4cm9qqzLAdoJc1pwAVU=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-193-7v0YPEesNPO3HBxX81slow-1; Mon,
 06 Jan 2025 12:39:39 -0500
X-MC-Unique: 7v0YPEesNPO3HBxX81slow-1
X-Mimecast-MFC-AGG-ID: 7v0YPEesNPO3HBxX81slow
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0CBAA19560A3;
	Mon,  6 Jan 2025 17:39:36 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ABD073000197;
	Mon,  6 Jan 2025 17:39:35 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 506HdYO82385572
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 6 Jan 2025 12:39:34 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 506HdYIK2385571;
	Mon, 6 Jan 2025 12:39:34 -0500
Date: Mon, 6 Jan 2025 12:39:34 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Muneendra Kumar M <muneendra.kumar@broadcom.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: [PATCH 2/2] multipathd: set rport port_state to marginal for
 NVMe devices
Message-ID: <Z3wVVg0AgLLq4EUN@redhat.com>
References: <20241220020235.1759375-1-bmarzins@redhat.com>
 <20241220020235.1759375-3-bmarzins@redhat.com>
 <c7641dfc68b568dc78297c60c56a9ee8@mail.gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <c7641dfc68b568dc78297c60c56a9ee8@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: y5Nhj7i82hfeEHvpvclwvqInCrzrTiSt3ECANrJPmmk_1736185176
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 20, 2024 at 04:25:22PM +0530, Muneendra Kumar M wrote:
> Hi Benjamin,
> Thanks for the changes.
> But below is the reason why we didn't add support to set the rport
> port_state to marginal for NVMe devices
> 
> In the case of SCSI  once rport-state is set to Marginal ,
> If any pending I/O's on the marginal path hit's the scsi-timeout (after
> abort success) the scsi-layer checks the rport-state  and If the
> rport-state is set to Marginal it will not do any retries on the Marginal
> path instead the I/O
> Will be retried on the other Active paths.
> 
> 
> This particular functionality(checking the rport-state and acting
> accordingly) we didn't add( as far I know) in the case of NVME and we need
> to check how we can handle this in the case of NVME .
> That's the reason we didn't set the port state to Marginal in the case of
> NVMe.
> 
> 
> In a brief SCSI layer handles the case when the rport-state is set to
> Marginal whereas in NVMe it doesn't(AFIK).
> 
> Atleast with the below changes we make sure that once we get the FPIN-LI
> notification we will set the affected path , as well as the rport-state to
> Marginal irrespective of SCSI and NVMe.
> 
> I am just thinking that until we have some changes in the NVME driver to
> handle (the rport-state to marginal) this changes doesn't show any impact
> in the case of NVMe
>  other then keeping it  on par with SCSI implementation.
> 
> Please let me know your opinion on the same.

The request to do this came because the user wanted to see which target
ports were effected, but when they looked, none of them we in the
Marginal state. So there is some value in this for users, even if the
systems behavior doesn't change because of it.

-Ben

> 
> 
> Regards,
> Muneendra.
> 
> 
> 
> -----Original Message-----
> From: Benjamin Marzinski <bmarzins@redhat.com>
> Sent: Friday, December 20, 2024 7:33 AM
> To: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@lists.linux.dev>; Martin Wilck
> <Martin.Wilck@suse.com>; Muneendra Kumar <muneendra.kumar@broadcom.com>
> Subject: [PATCH 2/2] multipathd: set rport port_state to marginal for NVMe
> devices
> 
> When a scsi path device is set to marginal, it updates the rport state.
> Do this for NVMe devices as well.
> 
> Fixes: 1cada778 ("multipathd: Added support to handle FPIN-Li events for
> FC-NVMe")
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  multipathd/fpin_handlers.c | 74 ++++++++++++++++++++++++++++++++++----
>  1 file changed, 68 insertions(+), 6 deletions(-)
> 
> diff --git a/multipathd/fpin_handlers.c b/multipathd/fpin_handlers.c index
> 6b56f9b7..8b436067 100644
> --- a/multipathd/fpin_handlers.c
> +++ b/multipathd/fpin_handlers.c
> @@ -15,6 +15,7 @@
>  #include "debug.h"
>  #include "util.h"
>  #include "sysfs.h"
> +#include "discovery.h"
> 
>  #include "fpin.h"
>  #include "devmapper.h"
> @@ -253,7 +254,7 @@ static int  extract_nvme_addresses_chk_path_pwwn(const
> char *address,
>   * with the els wwpn ,attached_wwpn and sets the path state to
>   * Marginal
>   */
> -static void fpin_check_set_nvme_path_marginal(uint16_t host_num, struct
> path *pp,
> +static bool fpin_check_set_nvme_path_marginal(uint16_t host_num, struct
> +path *pp,
>  		uint64_t els_wwpn, uint64_t attached_wwpn)  {
>  	struct udev_device *ctl = NULL;
> @@ -263,21 +264,79 @@ static void
> fpin_check_set_nvme_path_marginal(uint16_t host_num, struct path *pp
>  	ctl = udev_device_get_parent_with_subsystem_devtype(pp->udev,
> "nvme", NULL);
>  	if (ctl == NULL) {
>  		condlog(2, "%s: No parent device for ", pp->dev);
> -		return;
> +		return false;
>  	}
>  	address = udev_device_get_sysattr_value(ctl, "address");
>  	if (!address) {
>  		condlog(2, "%s: unable to get the address ", pp->dev);
> -		return;
> +		return false;
>  	}
>  	condlog(4, "\n address %s: dev :%s\n", address, pp->dev);
>  	ret = extract_nvme_addresses_chk_path_pwwn(address, els_wwpn,
> attached_wwpn);
>  	if (ret <= 0)
> -		return;
> +		return false;
>  	ret = fpin_add_marginal_dev_info(host_num, pp->dev);
>  	if (ret < 0)
> -		return;
> +		return false;
>  	fpin_path_setmarginal(pp);
> +	return true;
> +}
> +
> +static void fpin_nvme_set_rport_marginal(uint16_t host_num, uint64_t
> +els_wwpn) {
> +	struct udev_enumerate *udev_enum = NULL;
> +	struct udev_list_entry *entry;
> +
> +	pthread_cleanup_push(cleanup_udev_enumerate_ptr, &udev_enum);
> +	udev_enum = udev_enumerate_new(udev);
> +	if (!udev_enum) {
> +		condlog(0, "fpin: rport udev_enumerate_new() failed: %m");
> +		goto out;
> +	}
> +	if (udev_enumerate_add_match_subsystem(udev_enum,
> "fc_remote_ports") < 0 ||
> +	    udev_enumerate_add_match_is_initialized(udev_enum) < 0 ||
> +	    udev_enumerate_scan_devices(udev_enum) < 0) {
> +		condlog(0, "fpin: error setting up rport enumeration:
> %m");
> +		goto out;
> +	}
> +	udev_list_entry_foreach(entry,
> +				udev_enumerate_get_list_entry(udev_enum))
> {
> +		const char *devpath;
> +		const char *rport_id, *value;
> +		struct udev_device *rport_dev = NULL;
> +		uint16_t rport_hostnum;
> +		uint64_t rport_wwpn;
> +		unsigned int unused;
> +
> +		pthread_cleanup_push(cleanup_udev_device_ptr, &rport_dev);
> +		devpath = udev_list_entry_get_name(entry);
> +		if (!devpath)
> +			goto next;
> +		rport_id = libmp_basename(devpath);
> +		if (sscanf(rport_id, "rport-%hu:%u-%u", &rport_hostnum,
> &unused,
> +			   &unused) != 3 || rport_hostnum != host_num)
> +			goto next;
> +
> +		rport_dev = udev_device_new_from_syspath(udev, devpath);
> +		if (!rport_dev) {
> +			condlog(0, "%s: error getting rport dev: %m",
> rport_id);
> +			goto next;
> +		}
> +		value = udev_device_get_sysattr_value(rport_dev,
> "port_name");
> +		if (!value) {
> +			condlog(0, "%s: error getting port_name: %m",
> rport_id);
> +			goto next;
> +		}
> +
> +		rport_wwpn = strtol(value, NULL, 16);
> +		/* If the rport wwpn matches, set the port state to
> marginal */
> +		if (rport_wwpn == els_wwpn)
> +			fpin_set_rport_marginal(rport_dev);
> +next:
> +		pthread_cleanup_pop(1);
> +	}
> +out:
> +	pthread_cleanup_pop(1);
>  }
> 
>  /*
> @@ -338,6 +397,7 @@ static int  fpin_chk_wwn_setpath_marginal(uint16_t
> host_num,  struct vectors *ve
>  	struct multipath *mpp;
>  	int i, k;
>  	int ret = 0;
> +	bool found_nvme = false;
> 
>  	pthread_cleanup_push(cleanup_lock, &vecs->lock);
>  	lock(&vecs->lock);
> @@ -348,7 +408,7 @@ static int  fpin_chk_wwn_setpath_marginal(uint16_t
> host_num,  struct vectors *ve
>  			continue;
>  		/*checks if the bus type is nvme  and the protocol is
> FC-NVMe*/
>  		if ((pp->bus == SYSFS_BUS_NVME) && (pp->sg_id.proto_id ==
> NVME_PROTOCOL_FC)) {
> -			fpin_check_set_nvme_path_marginal(host_num, pp,
> els_wwpn, attached_wwpn);
> +			found_nvme =
> fpin_check_set_nvme_path_marginal(host_num, pp,
> +els_wwpn, attached_wwpn) || found_nvme;
>  		} else if ((pp->bus == SYSFS_BUS_SCSI) &&
>  			(pp->sg_id.proto_id == SCSI_PROTOCOL_FCP) &&
>  			(host_num ==  pp->sg_id.host_no)) {
> @@ -356,6 +416,8 @@ static int  fpin_chk_wwn_setpath_marginal(uint16_t
> host_num,  struct vectors *ve
>  			fpin_check_set_scsi_path_marginal(host_num, pp,
> els_wwpn);
>  		}
>  	}
> +	if (found_nvme)
> +		fpin_nvme_set_rport_marginal(host_num, els_wwpn);
>  	/* walk backwards because reload_and_sync_map() can remove mpp */
>  	vector_foreach_slot_backwards(vecs->mpvec, mpp, i) {
>  		if (mpp->fpin_must_reload) {
> --
> 2.46.2
> 
> -- 
> This electronic communication and the information and any files transmitted 
> with it, or attached to it, are confidential and are intended solely for 
> the use of the individual or entity to whom it is addressed and may contain 
> information that is confidential, legally privileged, protected by privacy 
> laws, or otherwise restricted from disclosure to anyone else. If you are 
> not the intended recipient or the person responsible for delivering the 
> e-mail to the intended recipient, you are hereby notified that any use, 
> copying, distributing, dissemination, forwarding, printing, or copying of 
> this e-mail is strictly prohibited. If you received this e-mail in error, 
> please return the e-mail to the sender, delete it from your computer, and 
> destroy any printed copy of it.



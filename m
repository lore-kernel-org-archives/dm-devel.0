Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F84F25949C
	for <dm-devel@lists.linux.dev>; Thu,  9 Jan 2025 06:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736402645; cv=none; b=czzGPJMbJ+G2K5lIK9gu2G/iZK6ncPjty8ce+HWnlKUn6yCmRWf5vk31R7605A7su8jGqbdnKMn8I1kiqEsyl9yoS5mAyqTMARRc1/XdSWQitdh5seqrhuoVk3syE5sOxCJTBUfwWXj/40YOnzyurpPClu0EVEgeX/BkvLbvb5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736402645; c=relaxed/simple;
	bh=w4iaCwuoOn0GLuJxB9Ca6St7YvrgkVGPCeYlrxV3uzA=;
	h=From:References:In-Reply-To:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eg7e7ZiMfe8o6/CN2LU6ivX8wEMdKcy55Mrfy3jhg3eHXkAIHNDuXCS6sJoT/HNmcLXPYkEqmHFFd6CBbNCVFmE5ACTFl//QZmRQeoYQZkiyVpwhrGA7iA7lHGUddxoGM2aUHfCba4wXvm2iF9pIgr/eZrLBbX131ozfsRRjnBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=Jdi1Kt/n; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Jdi1Kt/n"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-21669fd5c7cso7368125ad.3
        for <dm-devel@lists.linux.dev>; Wed, 08 Jan 2025 22:04:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1736402643; x=1737007443; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:thread-index:mime-version:in-reply-to
         :references:from:from:to:cc:subject:date:message-id:reply-to;
        bh=21mDUENU/F4PcsLomjVMZ3Wut5RXnjN3ezTZwA36cLU=;
        b=Jdi1Kt/n2vx9yh/gxDpoal7HRTAnbJLgs4m+IlrbUxOcKZoweqFNCRL918PWHa+C2F
         QDt4vJ/lCsWMOpu+6TabqsuWkL8pfwlp/qeI39X2q6lUhTkTeyeRHq+fDmHusI3i8cwm
         yH6BK5cWks5MoHYahMVaRXQLAsnGCCXfKBiVA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736402643; x=1737007443;
        h=cc:to:subject:message-id:date:thread-index:mime-version:in-reply-to
         :references:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=21mDUENU/F4PcsLomjVMZ3Wut5RXnjN3ezTZwA36cLU=;
        b=R1KBgrXBVE1QS5KneH3kS20JBgi6sB7VNG07Wp0pLjKFsk2n++phNVpECYsov73atX
         FtVKBCtZtr3P3OyuLhhEi8Eqj7pK7/fIwphZr+4KMu5SHu7sQvfglI9NRDgGBmQ6QAzn
         2EBEy0OYBXSBncThtDaJSdKeTY3youc3u1+a/ekqf/J6qIytAtJMxc4xjiqumoflCISA
         0HEtQRlkA7UyEaJRGOMl/wuxhHgc+whxzTxpAPCnCK7bf1jKfm110GovMjA48Q5BVxsZ
         LEQhWuFSBGs692ZjQN6XHfqB/pMqnxNP4n7i1tKZHgYmks94obMmUeu5S2RRAaYVhIl+
         P7ww==
X-Forwarded-Encrypted: i=1; AJvYcCWu30hh8WovnGzQ2ADk0PdNubZhMYTPydA6LOgvPOATgBZ7h8XH4MGBxROPJPTmHDld67q6AhcUjQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YwCEcDcpSQ1J1u1FmknvSkOxxdzTbY+ZHYeEIg1OPEUVWNhqlgE
	UV428QpUM/7ZEtbDsNe13kiQaPY/NawR3iflcdbjOUn1Qmkj2keK+unjWS8MRxAAvJlO1F5zdGL
	m7xZKfXy9/oEgKFzfJ50MUqpFgFzX4dU/pgC0uaIqtD8dzoWyyzwR0U43Zl3KtGA9O5qWw50k+b
	SyC9BybF5PpCHF5o6sLaDbZhgZMt2ySz8=
X-Gm-Gg: ASbGnculwtL1wqM1g5usXI7+hw+/abp8luc6aC+BqmGKFoJnkdpX83bqLYq9Jjay05Z
	P2rB8acA5kKsK8BLc5ljbgtZ16PQ0r/iIuc5uAM0=
X-Google-Smtp-Source: AGHT+IH6R4b2s1biGyFrkl/JBal1+BWXy6VEaNtlTVa9cVREbAYvwZ+JqoagFj9I5erAK/WmkZ+Chz+GtRg7tn8k9VM=
X-Received: by 2002:a17:902:ecc7:b0:216:760c:3879 with SMTP id
 d9443c01a7336-21a83fdf2d0mr67483715ad.46.1736402642825; Wed, 08 Jan 2025
 22:04:02 -0800 (PST)
From: Muneendra Kumar M <muneendra.kumar@broadcom.com>
References: <20241220020235.1759375-1-bmarzins@redhat.com> <20241220020235.1759375-3-bmarzins@redhat.com>
 <c7641dfc68b568dc78297c60c56a9ee8@mail.gmail.com> <Z3wVVg0AgLLq4EUN@redhat.com>
In-Reply-To: <Z3wVVg0AgLLq4EUN@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQK+UvY9qFv7vwQ9njHSAGX1b/VgggHju/x/AdKr010Bc7c9gLEewU7g
Date: Thu, 9 Jan 2025 11:33:58 +0530
X-Gm-Features: AbW1kvZ79-bSQbC8qdgG3I3J4w78CJOqAe8Noak6z2mbF0gP5rf0K7fr1I4gqBg
Message-ID: <343e7de82e800e453699728b03ad82d5@mail.gmail.com>
Subject: RE: [PATCH 2/2] multipathd: set rport port_state to marginal for NVMe devices
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, 
	device-mapper development <dm-devel@lists.linux.dev>, Martin Wilck <Martin.Wilck@suse.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000bc3cd9062b3fbe3a"

--000000000000bc3cd9062b3fbe3a
Content-Type: text/plain; charset="UTF-8"

Hi Benjamin,

>>The request to do this came because the user wanted to see which target
ports were effected, but when they looked, none of them we in the Marginal
state. So there is some value in this for users, even if the systems
behavior doesn't change because of it.

Thanks for the clarification.
The changes looks good.

Regards,
Muneendra.

-----Original Message-----
From: Benjamin Marzinski <bmarzins@redhat.com>
Sent: Monday, January 6, 2025 11:10 PM
To: Muneendra Kumar M <muneendra.kumar@broadcom.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>; device-mapper
development <dm-devel@lists.linux.dev>; Martin Wilck
<Martin.Wilck@suse.com>
Subject: Re: [PATCH 2/2] multipathd: set rport port_state to marginal for
NVMe devices

On Fri, Dec 20, 2024 at 04:25:22PM +0530, Muneendra Kumar M wrote:
> Hi Benjamin,
> Thanks for the changes.
> But below is the reason why we didn't add support to set the rport
> port_state to marginal for NVMe devices
>
> In the case of SCSI  once rport-state is set to Marginal , If any
> pending I/O's on the marginal path hit's the scsi-timeout (after abort
> success) the scsi-layer checks the rport-state  and If the rport-state
> is set to Marginal it will not do any retries on the Marginal path
> instead the I/O Will be retried on the other Active paths.
>
>
> This particular functionality(checking the rport-state and acting
> accordingly) we didn't add( as far I know) in the case of NVME and we
> need to check how we can handle this in the case of NVME .
> That's the reason we didn't set the port state to Marginal in the case
> of NVMe.
>
>
> In a brief SCSI layer handles the case when the rport-state is set to
> Marginal whereas in NVMe it doesn't(AFIK).
>
> Atleast with the below changes we make sure that once we get the
> FPIN-LI notification we will set the affected path , as well as the
> rport-state to Marginal irrespective of SCSI and NVMe.
>
> I am just thinking that until we have some changes in the NVME driver
> to handle (the rport-state to marginal) this changes doesn't show any
> impact in the case of NVMe  other then keeping it  on par with SCSI
> implementation.
>
> Please let me know your opinion on the same.

The request to do this came because the user wanted to see which target
ports were effected, but when they looked, none of them we in the Marginal
state. So there is some value in this for users, even if the systems
behavior doesn't change because of it.

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
> <Martin.Wilck@suse.com>; Muneendra Kumar
> <muneendra.kumar@broadcom.com>
> Subject: [PATCH 2/2] multipathd: set rport port_state to marginal for
> NVMe devices
>
> When a scsi path device is set to marginal, it updates the rport state.
> Do this for NVMe devices as well.
>
> Fixes: 1cada778 ("multipathd: Added support to handle FPIN-Li events
> for
> FC-NVMe")
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  multipathd/fpin_handlers.c | 74
> ++++++++++++++++++++++++++++++++++----
>  1 file changed, 68 insertions(+), 6 deletions(-)
>
> diff --git a/multipathd/fpin_handlers.c b/multipathd/fpin_handlers.c
> index
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
> @@ -253,7 +254,7 @@ static int
> extract_nvme_addresses_chk_path_pwwn(const
> char *address,
>   * with the els wwpn ,attached_wwpn and sets the path state to
>   * Marginal
>   */
> -static void fpin_check_set_nvme_path_marginal(uint16_t host_num,
> struct path *pp,
> +static bool fpin_check_set_nvme_path_marginal(uint16_t host_num,
> +struct path *pp,
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
FC-NVMe*/
>  		if ((pp->bus == SYSFS_BUS_NVME) && (pp->sg_id.proto_id ==
> NVME_PROTOCOL_FC)) {
> -			fpin_check_set_nvme_path_marginal(host_num, pp,
> els_wwpn, attached_wwpn);
> +			found_nvme =
> fpin_check_set_nvme_path_marginal(host_num, pp,
> +els_wwpn, attached_wwpn) || found_nvme;
>  		} else if ((pp->bus == SYSFS_BUS_SCSI) &&
>  			(pp->sg_id.proto_id == SCSI_PROTOCOL_FCP) &&
>  			(host_num ==  pp->sg_id.host_no)) { @@ -356,6
+416,8 @@ static int
> fpin_chk_wwn_setpath_marginal(uint16_t
> host_num,  struct vectors *ve
>  			fpin_check_set_scsi_path_marginal(host_num, pp,
els_wwpn);
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
> This electronic communication and the information and any files
> transmitted with it, or attached to it, are confidential and are
> intended solely for the use of the individual or entity to whom it is
> addressed and may contain information that is confidential, legally
> privileged, protected by privacy laws, or otherwise restricted from
> disclosure to anyone else. If you are not the intended recipient or
> the person responsible for delivering the e-mail to the intended
> recipient, you are hereby notified that any use, copying,
> distributing, dissemination, forwarding, printing, or copying of this
> e-mail is strictly prohibited. If you received this e-mail in error,
> please return the e-mail to the sender, delete it from your computer,
and destroy any printed copy of it.

-- 
This electronic communication and the information and any files transmitted 
with it, or attached to it, are confidential and are intended solely for 
the use of the individual or entity to whom it is addressed and may contain 
information that is confidential, legally privileged, protected by privacy 
laws, or otherwise restricted from disclosure to anyone else. If you are 
not the intended recipient or the person responsible for delivering the 
e-mail to the intended recipient, you are hereby notified that any use, 
copying, distributing, dissemination, forwarding, printing, or copying of 
this e-mail is strictly prohibited. If you received this e-mail in error, 
please return the e-mail to the sender, delete it from your computer, and 
destroy any printed copy of it.

--000000000000bc3cd9062b3fbe3a
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
ys9fYL+GlV3PS9wS3h0MI90cAfs5ZQjER5eWqMBARhfrW70fFVMSdZzBpXljqRjD+GOJm711FgvN
RsH9iq2Ndn7XY7jpnxND6cwSKympBXWuvQ54YyFDLr0m9eC6BNU5bQIDAQABo4IB3TCCAdkwDgYD
VR0PAQH/BAQDAgWgMIGjBggrBgEFBQcBAQSBljCBkzBOBggrBgEFBQcwAoZCaHR0cDovL3NlY3Vy
ZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3J0MEEG
CCsGAQUFBzABhjVodHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWdu
MmNhMjAyMDBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93
d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBJBgNVHR8EQjBAMD6gPKA6
hjhodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNy
bDAnBgNVHREEIDAegRxtdW5lZW5kcmEua3VtYXJAYnJvYWRjb20uY29tMBMGA1UdJQQMMAoGCCsG
AQUFBwMEMB8GA1UdIwQYMBaAFJYz0eZYF1s0dYqBVmTVvkjeoY/PMB0GA1UdDgQWBBTJvvnIS4Qf
Z+gEeC51xAB2l3lqOzANBgkqhkiG9w0BAQsFAAOCAQEAE6G8pLIpwrdO0Dmi603StqsNLN3t3i5m
SU/J+ZHnSeVNQFmfJjYSlZHSeAYrw+nsLEw08xiT4N2dPLbnowDKw0cVDRV5hL6+Uis2nqNkp9Kk
dXMVNlGeqGqBo98QRdRdzLgc/3FBQp3XIGUo2VDOMYW/RPbI1muHQOBKaVx4q8jqitNbqThvZkt/
t8KBiojEq4d7/scDRRtEsaL6Hl7cAYNMrS5EpijZrYjNYercaQNHcHP38l/XM9n36jllylt12koc
Dfj3D142STRRnexoNURmkc9EAKyZPRv/JRGz6YP0i2y1JqgpjF8CggD2osV3pA9e8ecXWQ7/ZJly
zHlFgjGCAm0wggJpAgEBMGswWzELMAkGA1UEBhMCQkUxGTAXBgNVBAoTEEdsb2JhbFNpZ24gbnYt
c2ExMTAvBgNVBAMTKEdsb2JhbFNpZ24gR0NDIFIzIFBlcnNvbmFsU2lnbiAyIENBIDIwMjACDEnR
Sel9Ku9INR0BhDANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgA7q5JpmrleMSRomO
AaCBXgFKr9xXyNrV+A5sI0prYrYwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0B
CQUxDxcNMjUwMTA5MDYwNDAzWjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcw
CwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAHWVtTSlsYuExALSnnjoWL1ZN0uUTsE8cNfH
Q8LHsZyqk/pl8VmQ0EMEh6GFuQ7tqhvq1LEYiQg5CJT1Nrb7eEGhXwhrvoyd+al6M43tmfz4b53L
oGZEFwCoVvdR6osciusLccZxYWL1i1sW4AuFNDVrRcBDIsT2rY81vaVs5fyTDAzgFhUzxF/TS7i3
PuFdH5iUnt/oIcP02E117556t+dfbs4vvnVzdxzodC9Yh1ZBbXU+it8qTgZh90YCKi+7ik0xOBqP
9jjORXpatgSAYM7TZhwPDxIdRPN/o4qKdbXhqvinG1mNvUHp14UBaALPQ8NXYQByHaoriEvzYhou
3Ps=
--000000000000bc3cd9062b3fbe3a--

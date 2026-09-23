Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AC473E4C96
	for <dm-devel@lists.linux.dev>; Wed, 23 Sep 2026 18:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790189574; cv=none; b=aOntOiucs1CXVNWOFUBOQz7fepU/gRXohnbTYk54zs6kREFnX0NtfZlMT6hMRIrNdVVOfI0ysv01ta2+zYKGnwylGU3DB1y2bva5BPaA/5BbUaEM9zVZFesVzPCNRdWSZlReyRnEh0KUbMk1as1+kIEkCa+qZBPcNTX+8hMUFXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790189574; c=relaxed/simple;
	bh=lEzLIQRxIlCTvxvT5iKhLhs3xbMRRtcxk4lMzlWZCaE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=cCW4xw2jFY9MKG8UZXBDgkfBXqIJ8+YA3YIbx5gtThx4U9VO3jaAWl2oRGDPXxHPyd3Wqe1qR+2SJaZIa77KYTbTWZ+EzDnPTyCtlFh/pcNtRRPdBlIpcuUj5aMle4RLNOl32io7B7br5QJwHLhaLL+VORIaxdJYNTjfUTqqd04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=H08L0VQj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H08L0VQj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790189571;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9+K5bFwX9R5Nh+hXQLnRhgdTjOkZ1p0xvFEtGuA4TZg=;
	b=H08L0VQjgQ21C7FllCS2QCFulG88Ur0ANnh7Im12gHFJ1LtFDz2JxGRq8NprJqfUO+rRwD
	6oB6hrKYetTTLc05PUds9Av6W5L2zoQPBHANhskXu85sgkqGmGww01bUNqx/WYnA9sdfgm
	Ts3IGqjfMOwsp/590y0XyAjpjvjD2Z4=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-627-kVef6ZP-PhqSaV00kwbJXQ-1; Wed,
 23 Sep 2026 14:52:48 -0400
X-MC-Unique: kVef6ZP-PhqSaV00kwbJXQ-1
X-Mimecast-MFC-AGG-ID: kVef6ZP-PhqSaV00kwbJXQ_1790189566
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7CCD81801BD5;
	Wed, 23 Sep 2026 18:52:46 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 12A331800351;
	Wed, 23 Sep 2026 18:52:45 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 68NIqihF1103311
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 23 Sep 2026 14:52:44 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 68NIqiV31103310;
	Wed, 23 Sep 2026 14:52:44 -0400
Date: Wed, 23 Sep 2026 14:52:44 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: By <xiaobai050@gmail.com>
Cc: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
        dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        syzbot+bdff1ecf726d2af66afd@syzkaller.appspotmail.com,
        syzbot+665bae0a102933788e1a@syzkaller.appspotmail.com
Subject: Re: [PATCH] usb: dwc3: pci: reject matches without software-node data
Message-ID: <arQf_IY2KbiQPyqZ@redhat.com>
References: <20260923081021.89508-1-xiaobai050@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260923081021.89508-1-xiaobai050@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: MAF2n-1AvyrzEVp9oJ1CfCdvJP6EhoQdUgSsEFXDg4I_1790189566
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

These aren't the appropriate people or list to send this patch to.

scripts/get_maintainer.pl is your friend here.

repos/linux$ scripts/get_maintainer.pl 0001-usb-dwc3-pci-reject-matches-without-software-node-da.patch 
Thinh Nguyen <Thinh.Nguyen@synopsys.com> (maintainer:DESIGNWARE USB3 DRD IP DRIVER)
Greg Kroah-Hartman <gregkh@linuxfoundation.org> (maintainer:USB SUBSYSTEM,blamed_fixes:1/1=100%)
Heikki Krogerus <heikki.krogerus@linux.intel.com> (blamed_fixes:1/1=100%)
Felipe Balbi <balbi@kernel.org> (blamed_fixes:1/1=100%)
linux-usb@vger.kernel.org (open list:DESIGNWARE USB3 DRD IP DRIVER)
linux-kernel@vger.kernel.org (open list)
USB SUBSYSTEM status: Supported

So Thinh Nguyen <Thinh.Nguyen@synopsys.com> is the maintainer for this
driver, Greg Kroah-Hartman <gregkh@linuxfoundation.org> is the
maintainer for the subsystem, linux-usb@vger.kernel.org is the mailing
list for this driver, and Heikki Krogerus
<heikki.krogerus@linux.intel.com>, Greg Kroah-Hartman
<gregkh@linuxfoundation.org>, and Felipe Balbi <balbi@kernel.org> all
have something to do with e492ce9bcaa1 ("usb: dwc3: pci: Register a
software node for the dwc3 platform device").

-Ben

On Wed, Sep 23, 2026 at 04:10:21PM +0800, By wrote:
> A PCI driver_override bind can reach dwc3_pci_probe() with the dummy ID
> from pci_match_device(). Its driver_data is zero, so dwc3_pci_quirks()
> passes NULL to device_add_software_node(), which crashes in
> software_node_register().
> 
> Reject the match before enabling the device or allocating resources.
> All static DWC3 PCI IDs provide software-node data.
> 
> Build-tested with ARCH=arm64 defconfig and dwc3-pci.o. The runtime
> reproducer could not be run in this environment.
> 
> Fixes: e492ce9bcaa1 ("usb: dwc3: pci: Register a software node for the dwc3 platform device")
> Reported-by: syzbot+665bae0a102933788e1a@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=665bae0a102933788e1a
> Assisted-by: LLM
> Signed-off-by: By <xiaobai050@gmail.com>
> ---
>  drivers/usb/dwc3/dwc3-pci.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
> index 6c1cbb722..d7fdf6ca6 100644
> --- a/drivers/usb/dwc3/dwc3-pci.c
> +++ b/drivers/usb/dwc3/dwc3-pci.c
> @@ -335,6 +335,9 @@ static int dwc3_pci_probe(struct pci_dev *pci, const struct pci_device_id *id)
>  	int			ret;
>  	struct device		*dev = &pci->dev;
>  
> +	if (!id->driver_data)
> +		return -ENODEV;
> +
>  	ret = pcim_enable_device(pci);
>  	if (ret) {
>  		dev_err(dev, "failed to enable pci device\n");
> -- 
> 2.55.0


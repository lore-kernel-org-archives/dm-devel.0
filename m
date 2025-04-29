Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E588242D80
	for <dm-devel@lists.linux.dev>; Tue, 29 Apr 2025 23:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745968968; cv=none; b=rg0+TMrFP6mMg/blRZPtoi/n5XUkGiUKi2NXSNjITZc0PEjm7lKN/w1FlDsHO+MD1tdQ7t2D0xOR/k6anwlTZj0aK6n85gPBSeIEMK5ctJDwbYRONgPsDjjsM23GKQVzDVVoAg3dvdHVPUdjKXb0Xlu5sQBJqk0HKJGL8CAuc7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745968968; c=relaxed/simple;
	bh=aQbB1Z96AXc3OR1lYM8d5LueOp+q4mAg76B0s25oJWI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kkf2WwxwMuA5Fz83gxAqyKSNO2eyafZNptYvDwVrFmD0ODFNeHr6hqlyMi57uDQ1h0vjSd0+EXF4a/e+KXmkmCceafUit6tNYhup5FWY6KHqh/FW3z1T/V7dMyY9b6nAraonB8yGpC6uy+SLJtvar3ear2g76GkgXW+SKUekNmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iLgwguzW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iLgwguzW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745968965;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+kwb9rMjhhR05tXgbyU06kvQsgWUDgylOH5JOrli2iI=;
	b=iLgwguzWlpUGoTQuhCmA8paRiOPbYzV7q50gdncmUb22or1IDtPWizbp7zMYPnt75cDpTt
	VUI9xKiQ9lKU6BB+RwXAN7RPnNmq2SfYj2zHymxyo3oixhi6SccEzqMIOG6elEoHOA536v
	XU/h8U8aJcjK9s+kOPVqG6dJFuA5LHo=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-133-13I32tYROqmJ8jYTT8QIGg-1; Tue,
 29 Apr 2025 19:22:42 -0400
X-MC-Unique: 13I32tYROqmJ8jYTT8QIGg-1
X-Mimecast-MFC-AGG-ID: 13I32tYROqmJ8jYTT8QIGg_1745968961
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 886E719560AB;
	Tue, 29 Apr 2025 23:22:41 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1D841195608D;
	Tue, 29 Apr 2025 23:22:41 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 53TNMdid1956533
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 29 Apr 2025 19:22:40 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 53TNMdel1956532;
	Tue, 29 Apr 2025 19:22:39 -0400
Date: Tue, 29 Apr 2025 19:22:39 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Kevin Wolf <kwolf@redhat.com>
Cc: dm-devel@lists.linux.dev, hreitz@redhat.com, mpatocka@redhat.com,
        snitzer@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] dm mpath: Interface for explicit probing of active
 paths
Message-ID: <aBFfP-XaHHAs4vE_@redhat.com>
References: <20250429165018.112999-1-kwolf@redhat.com>
 <20250429165018.112999-3-kwolf@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250429165018.112999-3-kwolf@redhat.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Tue, Apr 29, 2025 at 06:50:18PM +0200, Kevin Wolf wrote:
> Multipath cannot directly provide failover for ioctls in the kernel
> because it doesn't know what each ioctl means and which result could
> indicate a path error. Userspace generally knows what the ioctl it
> issued means and if it might be a path error, but neither does it know
> which path the ioctl took nor does it necessarily have the privileges to
> fail a path using the control device.
> 
> In order to allow userspace to address this situation, implement a
> DM_MPATH_PROBE_PATHS ioctl that prompts the dm-mpath driver to probe all
> active paths in the current path group to see whether they still work,
> and fail them if not. If this returns success, userspace can retry the
> ioctl and expect that the previously hit bad path is now failed (or
> working again).
> 
> The immediate motivation for this is the use of SG_IO in QEMU for SCSI
> passthrough. Following a failed SG_IO ioctl, QEMU will trigger probing
> to ensure that all active paths are actually alive, so that retrying
> SG_IO at least has a lower chance of failing due to a path error.
> However, the problem is broader than just SG_IO (it affects any ioctl),
> and if applications need failover support for other ioctls, the same
> probing can be used.
> 
> This is not implemented on the DM control device, but on the DM mpath
> block devices, to allow all users who have access to such a block device
> to make use of this interface, specifically to implement failover for
> ioctls. For the same reason, it is also unprivileged. Its implementation
> is effectively just a bunch of reads, which could already be issued by
> userspace, just without any guarantee that all the rights paths are
> selected.
> 
> The probing implemented here is done fully synchronously path by path;
> probing all paths concurrently is left as an improvement for the future.
> 
> Co-developed-by: Hanna Czenczek <hreitz@redhat.com>
> Signed-off-by: Hanna Czenczek <hreitz@redhat.com>
> Signed-off-by: Kevin Wolf <kwolf@redhat.com>

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>


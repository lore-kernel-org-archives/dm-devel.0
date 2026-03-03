Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00E9030B53E
	for <dm-devel@lists.linux.dev>; Tue,  3 Mar 2026 05:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772515925; cv=none; b=OM7uAGukfwv8//8I64DplfLObSi+Vm3cNKYW4QB+DrM7Q45SloVhaE8HQ4VBW9K8WSWXS+K53AmkM/KCGRuoHT7HXa5Hj8zEvImYnug/9bNHoet5EU+1B5m9m9qifQ8HxWr92uJVrcda5EaFdysZrhqNXkhT6/lksZcBNSFMY8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772515925; c=relaxed/simple;
	bh=C8yJhHxPL64zlBkc4SFPQfPBrFzw3wXhpcuOs1Ru1pA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=oQnU+40050CKyn4iZIiMH0+J7B91WpNOKJMwSECf+lXtorV669Vsy0Q5dffovmNxemkjP3wvKTAXCfFXWwjsTwhVqA8JtTZiW7RyCpCn1Dzz3vINsykNDo6yfIRgHPEbw1xxX9W7psXOnPhuEAsAKEDeG4c+8G94+gITBYuSg9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WBMOdWXA; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WBMOdWXA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772515922;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rk8SfGWznxs8PCnNuzIOKZoorLz2mCPwrChTHvdhTxs=;
	b=WBMOdWXA2vb4CzZUjlBBP+p1Sk1RMHYmOV75EyFxPry1FPvXZ1dDXWLboyhSrkAHyIgPL4
	yy/8DhyThIP4kedbQNSOlm5Pc82w/IvUKjRBmzOaBacG6GUONs43WxpCzxY4ZPspVzGEHU
	HVKH0vv0qOM826RmrujG7hBvlpcrJds=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-695-3y5x-f46Mfu3DVitalfYUw-1; Tue,
 03 Mar 2026 00:31:59 -0500
X-MC-Unique: 3y5x-f46Mfu3DVitalfYUw-1
X-Mimecast-MFC-AGG-ID: 3y5x-f46Mfu3DVitalfYUw_1772515917
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 81A4119560B2;
	Tue,  3 Mar 2026 05:31:55 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A608130001B9;
	Tue,  3 Mar 2026 05:31:53 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 6235VqTB1875154
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 3 Mar 2026 00:31:52 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 6235Vp3B1875151;
	Tue, 3 Mar 2026 00:31:51 -0500
Date: Tue, 3 Mar 2026 00:31:51 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: John Garry <john.g.garry@oracle.com>
Cc: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/24] scsi-multipath: provide callbacks for path state
Message-ID: <aaZyR5FZJRbbwdI-@redhat.com>
References: <20260225153627.1032500-1-john.g.garry@oracle.com>
 <20260225153627.1032500-13-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260225153627.1032500-13-john.g.garry@oracle.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: BHVbs4iDLaQtC90iFUDRSm0FQkIG8e1rQc3JyiuRFSs_1772515917
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 25, 2026 at 03:36:15PM +0000, John Garry wrote:
> Until ALUA is supported, just always say that the path is optimized. In
> addition, just add basic scsi_device state tests for checking on path
> state.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>  drivers/scsi/scsi_multipath.c | 45 +++++++++++++++++++++++++++++++++++
>  1 file changed, 45 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
> index 36f13605b44e7..6aeac20a350ff 100644
> --- a/drivers/scsi/scsi_multipath.c
> +++ b/drivers/scsi/scsi_multipath.c
> @@ -340,8 +340,53 @@ static int scsi_mpath_ioctl(struct block_device *bdev,
>  	return err;
>  }
>  
> +static bool scsi_mpath_is_disabled(struct mpath_device *mpath_device)
> +{
> +	struct scsi_mpath_device *scsi_mpath_dev =
> +				to_scsi_mpath_device(mpath_device);
> +	struct scsi_device *sdev = scsi_mpath_dev->sdev;
> +	enum scsi_device_state sdev_state = sdev->sdev_state;
> +
> +	if (sdev_state == SDEV_RUNNING || sdev_state == SDEV_CANCEL)
> +		return false;
> +
> +	return true;
> +}
> +
> +static bool scsi_mpath_is_optimized(struct mpath_device *mpath_device)
> +{
> +	if (scsi_mpath_is_disabled(mpath_device))
> +		return false;
> +	return true;
> +}
> +
> +/* Until we have ALUA support, we're always optimised */
> +static enum mpath_access_state scsi_mpath_get_access_state(
> +				struct mpath_device *mpath_device)
> +{
> +	if (scsi_mpath_is_disabled(mpath_device))
> +		return MPATH_STATE_INVALID;
> +	return MPATH_STATE_OPTIMIZED;
> +}
> +
> +static bool scsi_mpath_available_path(struct mpath_device *mpath_device, bool *available)
> +{
> +	struct scsi_mpath_device *scsi_mpath_dev =
> +				to_scsi_mpath_device(mpath_device);
> +	struct scsi_device *sdev = scsi_mpath_dev->sdev;
> +
> +	if (scsi_device_blocked(sdev))
> +		return false;
> +
> +	return scsi_device_online(sdev);
> +}

Here's another vote for redoing the mpath_available_path() interface.
scsi_mpath_available_path() is already ignoring the available pointer,
and treating the return value like it determines whether the path is
available.

-Ben


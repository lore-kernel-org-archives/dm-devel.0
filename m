Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87A58433CB
	for <dm-devel@lists.linux.dev>; Mon, 14 Apr 2025 13:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744636772; cv=none; b=W5nzsEBPyEzMkx1VuajP5O3oYv3Ae9F6zqxjFNODbDRYlptt19/F8Cy/8o3qS41P6HbBwfmkcEKFlaZW1k6vB7xyEET7xk5ypRV6pklAxrpKETFQEtFRXc6sGDGi9i7M7YWQ3PgT0tmBzUGkTS2Smt5oBOrTqziHubKTta7JohQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744636772; c=relaxed/simple;
	bh=XFcmVKfl/murXq1FOltyjI0RZClONBYZsora0YeqTqc=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Ax+ZZku0jGODPWOI6FMHqKKFRnq0u4ehYK5f3sn0BpossLnqwN+Z7zYL78xbQ0oqrnzCaRAC+7azokMJ0pgKWVXP4ZjTWDwsX/4xJG79RnFQWhmsyvy4u/lX7uDIo4wBy8W+eUxmcwZkF6K32UdtVdETh5fefoF32EPcTj6gRYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VT1br+hl; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VT1br+hl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744636769;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=p3jx3ZvHp10mqTC4aZ8136TKAVA3Z9xsT7LVpk7QStU=;
	b=VT1br+hl0VZYQU2JUTIPeHe4L90/DlHdBOW3GarXtYcJaQtg4kZnJK/2XbywPibPpRof1f
	CusdAhXyLlONbN4JR+0+O6N2Vo6EtEUpHFEZRINr2SWxqhDPEBgixWv8R3V7prromfFquX
	io61BajMnfH5olOBm8uqQZ/CpqRQ6J4=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-210-cxnEgnuMMr-t4BHoc1MYng-1; Mon,
 14 Apr 2025 09:19:26 -0400
X-MC-Unique: cxnEgnuMMr-t4BHoc1MYng-1
X-Mimecast-MFC-AGG-ID: cxnEgnuMMr-t4BHoc1MYng_1744636765
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DD5DB180AB1C;
	Mon, 14 Apr 2025 13:19:24 +0000 (UTC)
Received: from [10.22.80.44] (unknown [10.22.80.44])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0D0E5195609D;
	Mon, 14 Apr 2025 13:19:22 +0000 (UTC)
Date: Mon, 14 Apr 2025 15:19:19 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Damien Le Moal <dlemoal@kernel.org>
cc: dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>, 
    Christoph Hellwig <hch@lst.de>, Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH v2] dm-delay: Prevent zoned write reordering on suspend
In-Reply-To: <20250411000435.1007720-1-dlemoal@kernel.org>
Message-ID: <81bd6eca-6d62-6934-9007-28eaef465bb7@redhat.com>
References: <20250411000435.1007720-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: h6PI7CvNcgqMHCbYJph694YfcjyDX2oSuNv4XHkgweE_1744636765
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Fri, 11 Apr 2025, Damien Le Moal wrote:

> When a dm-delay device is being suspended, the .presuspend() operation
> is first executed (delay_presuspend()) to immediately issue all the BIOs
> present in the delayed list of the device and also sets the device
> may_delay boolean to false. At the same time, if any new BIO is issued
> to the device will not be delayed and immediately issued with
> delay_bio() returning DM_MAPIO_REMAPPED. This creates a situation where
> potentially 2 different contexts may be issuing write BIOs to the same
> zone of a zone device without respecting the issuing order from the
> user, that is, a newly issued write BIO may be issued before other write
> BIOs for the same target zone that are in the device delayed list. If
> such situation occurs, write BIOs may be failed by the underlying zoned
> device due to an unaligned write error.
> 
> Prevent this situation from happening by always handling newly issued
> write BIOs using the delayed list of BIOs, even when the device is being
> suspended. This is done by forcing the use of the worker kthread for
> zoned devices, and by modifying flush_worker_fn() to always flush all
> delayed BIOs if the device may_delay boolean is false.
> 
> Reported-by: Benjamin Marzinski <bmarzins@redhat.com>
> Fixes: d43929ef65a6 ("dm-delay: support zoned devices")
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
> Changes from v1:
>  - Fixed typo in commit message
>  - Added reported-by tag
> 
>  drivers/md/dm-delay.c | 29 +++++++++++++++++++++--------
>  1 file changed, 21 insertions(+), 8 deletions(-)

Hi

I looked at the generic device mapper code and it seems that ordering of 
write bios is not guaranteed with any target in case of suspend/resume.

* we suspend the device:
* received bios are added to md->deferred in queue_io

* we resume the device:
* __dm_resume calls dm_queue_flush
* dm_queue_flush clears DMF_BLOCK_IO_FOR_SUSPEND and submits work item 
  &md->work (dm_wq_work)
* dm_resume clears DMF_SUSPENDED
* the device starts accepting new bios in dm_submit_bio
* dm_wq_work runs concurrently with new bios that are received, so 
  ordering of bios is not preserved

So it doesn't make much sense to try to fix it in dm-delay, if it isn't 
supposed to work at all.

Mikulas


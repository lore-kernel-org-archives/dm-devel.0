Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 675EC79CD
	for <dm-devel@lists.linux.dev>; Mon,  5 Oct 2026 17:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791223187; cv=none; b=iZqTD5kZM78zoKDrLs/sh12hFfwcITNtoYfPcH0wwWHi2CckdpL/O/WCYt3kARnOVVkZIwZI1xdGGqMXOdNHAQRwZP2wHtGX+T0VEGbAzEqdO8uKcdsAZeCPNJ9R+sMwSJVItAq/O58lsPwekthAC/MQfbGJqJMPzvkn10lBK34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791223187; c=relaxed/simple;
	bh=47FyqqZAhMN3qzzAAz9Wjr5SrAQqE1/Cz8d6iqnEYEw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=rbSmsq/+QM+BWsuu8HMzE13Cb61QYrCc1c56zTZHDW76VFEPbPholBcWtia0PhyDrBmamAZlOarYEsvLKQbEvrRgU722QK8AymxmP9MnYRuXp1u/v0MHzquuS/hs1Uz17rv1/j9D9FjLdKnWlj5tXmi1eM/d31iiJkW0KLNQ+8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SZlE7cdt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SZlE7cdt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791223177;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fgLMtQMohgY1Sds7dkWD+oZLh7uiKFgcpTwdcRNhnjA=;
	b=SZlE7cdtYLzFqYdMFWcWU5qajYWyOTVAoPxs76Q4xWF5JjV/OS5AYjLc1ZO3v07/DlykSl
	naDE5Lw/D4AIk7Ra57MBGE3BVLtEAdFXrvsxZGUq+hQgWOMfY2w19LtbcnfNf0KYp3XtA9
	rXrbIgb17Hxucq66rYDvglKP48sLV7U=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-60-XSe7ofGsMJq-r9P3MWtwRg-1; Mon,
 05 Oct 2026 13:59:34 -0400
X-MC-Unique: XSe7ofGsMJq-r9P3MWtwRg-1
X-Mimecast-MFC-AGG-ID: XSe7ofGsMJq-r9P3MWtwRg_1791223173
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1FEA21955F27;
	Mon,  5 Oct 2026 17:59:33 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C08B53001D29;
	Mon,  5 Oct 2026 17:59:32 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 695HxVdC2267373
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 5 Oct 2026 13:59:31 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 695HxVa42267372;
	Mon, 5 Oct 2026 13:59:31 -0400
Date: Mon, 5 Oct 2026 13:59:31 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Suresh Thelkar <suresh.thelkar@yahoo.com>
Cc: dm-devel@lists.linux.dev, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 2/2] libmultipath: dm_flush_map__: retry the resume after
 a failed remove
Message-ID: <asPlg6j25piNdNW_@redhat.com>
References: <20261005045726.71858-1-suresh.thelkar@yahoo.com>
 <20261005045726.71858-3-suresh.thelkar@yahoo.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20261005045726.71858-3-suresh.thelkar@yahoo.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: P36L6cXiwUmbQrda1M0nXGucvEi5K5u7oChfeKd2TLQ_1791223173
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 05, 2026 at 04:57:26AM +0000, Suresh Thelkar wrote:
> After a failed DM_DEVICE_REMOVE the map was suspended earlier in
> dm_flush_map__(), and the recovery path issued a single fire-and-forget
> DM_DEVICE_RESUME whose result was ignored. If that resume ioctl failed
> (possible under an ioctl storm) the map stayed suspended, which wedges
> any later task in uninterruptible D state and, because sync() walks
> every block device, hangs I/O node-wide until reboot.
> 
> Since the map is known to have been suspended at the start of the loop,
> the DM_DEVICE_RESUME return value is authoritative. Simply retry the
> resume once if the ioctl fails, so a transient failure does not leave
> the map suspended. The remove is still retried by the enclosing loop
> when retries are requested.
> 
> Signed-off-by: Suresh Thelkar <suresh.thelkar@yahoo.com>

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>


Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0F93800
	for <dm-devel@lists.linux.dev>; Tue,  7 Jul 2026 00:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783382911; cv=none; b=u2htFSGOSzF5AeGnig430u7MSfCyzZ4DsMwB4lM63gv6ccIavfIQ6tdH0Rt/krN3RkTEEnE3u0M0Ni2q3Cdsj27bVvh35T2VGnAfFy552qZgy1CJzXbqgPXcD68UXCXOHyQ7PWgy8CKvkN/3LRzW2aAJ0QnGINkSqIQR8bEI8n8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783382911; c=relaxed/simple;
	bh=7C82F5gc61PWvKBdbj//5Ga93Zw3Z3HWVHC/iBWkHLM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=UBo/bxZDWKgTmfn879gMFffWrkUoM70s2oGrFV/jLr9Es0/fMpyHyCnUEKi4URu9MzDF9wSW40H3OB87i6ZV9NE+QYJVxsTHz9LZaK2hgUvC8tbykfqkAv4vctxNZq+n2mvWLK8oK9LzHUKBQd31mb7iEXV7/REhhPHM6eLUuVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=drqSy78J; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="drqSy78J"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783382908;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=c82sGCS57Y50Dpnb8dLOgOyihJlkyENJf9x0PYcr+QE=;
	b=drqSy78J0nJIe3M4c7FxEhM+yF8TJg7IFjilQzNAbqzC7XeoO2WOh0VvSsorpz1OadzJv7
	9Ezx1Xe4Zr6buvnsDVSOp9W+//QCi4+yAYHpzKGbZZYtLjDjAb1+K645I4RF6SBYeVV0ea
	wUWA2NM6mGtke1jdc6UlItaPf9scxdA=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-226-wDuqIll_ODumKeltEI5inQ-1; Mon,
 06 Jul 2026 20:08:27 -0400
X-MC-Unique: wDuqIll_ODumKeltEI5inQ-1
X-Mimecast-MFC-AGG-ID: wDuqIll_ODumKeltEI5inQ_1783382906
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 094E81955DBA;
	Tue,  7 Jul 2026 00:08:26 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 88AD73000B7D;
	Tue,  7 Jul 2026 00:08:25 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 66708OTO1955391
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 6 Jul 2026 20:08:24 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 66708NdR1955390;
	Mon, 6 Jul 2026 20:08:23 -0400
Date: Mon, 6 Jul 2026 20:08:23 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        Xose Vazquez Perez <xose.vazquez@gmail.com>, dm-devel@lists.linux.dev,
        Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH] multipath.conf.in: Update path_checker and force_sync
 documentation
Message-ID: <akxDd23q6CnxTOqB@redhat.com>
References: <20260706135049.724071-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260706135049.724071-1-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 9D6iPF6HKlKZn8KKDgv3-j4S98zW4wEsDp8ZigL3s30_1783382906
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 06, 2026 at 03:50:49PM +0200, Martin Wilck wrote:
> Document the fact that all path checkers are now asynchronous by default.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> ---
>  multipath/multipath.conf.5.in | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/multipath/multipath.conf.5.in b/multipath/multipath.conf.5.in
> index e6b4fc0..2ea78fc 100644
> --- a/multipath/multipath.conf.5.in
> +++ b/multipath/multipath.conf.5.in
> @@ -504,12 +504,11 @@ The default is: \fB0\fR
>  .
>  .TP
>  .B path_checker
> -The default method used to determine the path's state. The synchronous
> -checkers (all except \fItur\fR and \fIdirectio\fR) will cause multipathd to
> -pause most activity, waiting up to \fIchecker_timeout\fR seconds for the path
> -to respond. The asynchronous checkers (\fItur\fR and \fIdirectio\fR) will not
> -pause multipathd. Instead, multipathd will check for a response once per
> -second, until \fIchecker_timeout\fR seconds have elapsed. Possible values are:
> +The default method used to determine the path's state. Since multipath-tools
> +0.15.0, all path checkers run in asynchronous mode by default, so that
> +unresponsive devices don't pause multipathd. Use the \fIforce_sync\fR parameter
> +to enforce synchronous path checking instead.
> +Possible values are:
>  .RS
>  .TP
>  .I readsector0
> @@ -905,7 +904,8 @@ The default is: \fByes\fR
>  If set to
>  .I yes
>  , multipathd will call the path checkers in sync mode only.  This means that
> -only one checker will run at a time.  This is useful in the case where many
> +only one checker will run at a time, and that multipathd may pause operating
> +while it is waiting for a device to respond. This is useful in the case where many
>  multipathd checkers running in parallel causes significant CPU pressure.
>  .RS
>  .TP
> -- 
> 2.54.0


Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A6E41A08A3
	for <dm-devel@lists.linux.dev>; Wed, 10 Jun 2026 22:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781131617; cv=none; b=IHgFLPn8F8jwm9dJNr5KmB8BjKNoYvyTYv7IHL5S3+lVw1eFCi4pnqQcAlcP562EDJNxfaTVJGlR019ionUOSQXtXDstIEFqGmmooQMQOxp/u1CwbD72VdhtPTkWrnx7/5zTtJc4ZEZBmWarDIOCG4Z2AfBh7ge2XtHGxvJylUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781131617; c=relaxed/simple;
	bh=/3BTjbM/BlSa7WMgy8IpdQuMW2WdZuKzTjch8FCqYJY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=aOunYd9u+ukgbs9xWkhBhfslzAx/IBLhwTRBCEC7TJEEWeZduDVt2/JDZA0oZby6TCYoMJq+qqhPK3s42nx3XFnEp3qUM7LqpHHK7lprqSxg7lvgouBBB7AnPNLlmgDhYdZ1KSZo9J6rvDnlyV7eXcQAnQkeR9hB7ZgP9NFW5y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y/Ccsp8U; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y/Ccsp8U"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781131615;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1R0XEJOt12Q4I12G2/xZBr+Jh+mbaYUVvfxViv7lqVw=;
	b=Y/Ccsp8U0797yLYs4aFwDdxwaSPX2sbPfvB2RiHWmbHtZVWq6JcEC88VE/fu3zvnHsLga0
	Sn8J31wujhU4vnXLHV0sEkWxH/vfueB+hY80SzPd+DlEj+1CcYqUKlTjFZuSXSexFxwDo9
	Z6GmmZQEMSVYLDOAXPrUJYIjsaiFExA=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-186-HaOd8m1tOle9ur1GHLli3g-1; Wed,
 10 Jun 2026 18:46:47 -0400
X-MC-Unique: HaOd8m1tOle9ur1GHLli3g-1
X-Mimecast-MFC-AGG-ID: HaOd8m1tOle9ur1GHLli3g_1781131606
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 51F2E1955E89;
	Wed, 10 Jun 2026 22:46:46 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 01E8F27A;
	Wed, 10 Jun 2026 22:46:45 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 65AMkiu4617354
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 10 Jun 2026 18:46:44 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 65AMki4X617353;
	Wed, 10 Jun 2026 18:46:44 -0400
Date: Wed, 10 Jun 2026 18:46:44 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Martin Wilck <mwilck@suse.com>,
        Christophe Varoqui <christophe.varoqui@opensvc.com>,
        DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 1/3] multipath-tools: delete obsolete information from
 multipath.conf.5
Message-ID: <ainpVKRJH91bsAQc@redhat.com>
References: <20260607103831.336833-1-xose.vazquez@gmail.com>
 <20260607103831.336833-2-xose.vazquez@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260607103831.336833-2-xose.vazquez@gmail.com>
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: OUNmxze58w0n8v9xXbgtGbL58d6pjDKEPT-nThHej_I_1781131606
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jun 07, 2026 at 12:38:21PM +0200, Xose Vazquez Perez wrote:
> repeat_count (rr_min_io, rr_min_io_rq, rr_weight) has been unsupported
> since kernel 4.6 ( commits 90a4323ccfea and  21136f89d76d ).
> 
> And also clean up other deprecated entries.
> 
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  multipath/multipath.conf.5.in | 69 +++--------------------------------
>  1 file changed, 6 insertions(+), 63 deletions(-)
> 
> diff --git a/multipath/multipath.conf.5.in b/multipath/multipath.conf.5.in
> index 84cd1a0a..e3a9811c 100644
> --- a/multipath/multipath.conf.5.in
> +++ b/multipath/multipath.conf.5.in
> @@ -6,7 +6,7 @@
>  .\" Update the date below if you make any significant change.
>  .\" ----------------------------------------------------------------------------
>  .
> -.TH MULTIPATH.CONF 5 2025-09-12 Linux
> +.TH MULTIPATH.CONF 5 2026-05-27 Linux
>  .
>  .
>  .\" ----------------------------------------------------------------------------
> @@ -198,9 +198,8 @@ kernel multipath target:
>  .TP 12
>  .I "round-robin 0"
>  Choose the path for the next bunch of I/O by looping through every path in the
> -path group, sending \fBthe same number of I/O requests\fR to each path. Some
> -aspects of behavior can be controlled with the attributes: \fIrr_min_io\fR,
> -\fIrr_min_io_rq\fR and \fIrr_weight\fR.
> +path group, sending \fBthe same number of I/O requests\fR to each path.
> +

For the path selectors, we know the number of I/O requests that will
be sent, and it's 1. So instead of saying "the next bunch of I/O", we
should probably just say "the next I/O request". And we can probably
just drop the "sending the same number of  I/O  requests to each path"
part of the round-robin definition.

>  .TP
>  .I "queue-length 0"
>  (Since 2.6.31 kernel) Choose the path for the next bunch of I/O based on \fBthe lowest
> @@ -598,24 +597,12 @@ The default is: \fBmanual\fR
>  .
>  .TP
>  .B rr_min_io
> -Number of I/O requests to route to a path before switching to the next in the
> -same path group. This is only for \fIBlock I/O\fR(BIO) based multipath and
> -only apply to \fIround-robin\fR path_selector.
> -.RS
> -.TP
> -The default is: \fB1000\fR
> -.RE
> +(Deprecated since kernel 4.6) This option is not supported anymore, and will be ignored.
>  .
>  .
>  .TP
>  .B rr_min_io_rq
> -Number of I/O requests to route to a path before switching to the next in the
> -same path group. This is only for \fIRequest\fR based multipath and
> -only apply to \fIround-robin\fR path_selector.
> -.RS
> -.TP
> -The default is: \fB1\fR
> -.RE
> +(Deprecated since kernel 4.6) This option is not supported anymore, and will be ignored.
>  .
>  .
>  .TP
> @@ -634,16 +621,7 @@ The default is: \fBmax\fR
>  .
>  .TP
>  .B rr_weight
> -If set to \fIpriorities\fR the multipath configurator will assign path weights
> -as "path prio * rr_min_io". Possible values are
> -.I priorities
> -or
> -.I uniform .
> -Only apply to \fIround-robin\fR path_selector.
> -.RS
> -.TP
> -The default is: \fBuniform\fR
> -.RE
> +(Deprecated since kernel 4.6) This option is not supported anymore, and will be ignored.
>  .
>  .
>  .TP
> @@ -821,28 +799,16 @@ The default is: \fB<unset>\fR
>  .TP
>  .B bindings_file
>  (Deprecated) This option is not supported anymore, and will be ignored.
> -.RS
> -.TP
> -The compiled-in value is: \fB@STATE_DIR@/bindings\fR
> -.RE
>  .
>  .
>  .TP
>  .B wwids_file
>  (Deprecated) This option is not supported anymore, and will be ignored.
> -.RS
> -.TP
> -The compiled-in value is: \fB@STATE_DIR@/wwids\fR
> -.RE
>  .
>  .
>  .TP
>  .B prkeys_file
>  (Deprecated) This option is not supported anymore, and will be ignored.
> -.RS
> -.TP
> -The compiled-in value is: \fB@STATE_DIR@/prkeys\fR
> -.RE
>  .
>  .
>  .TP
> @@ -1008,10 +974,6 @@ The default is: \fB<unset>\fR
>  .TP
>  .B config_dir
>  (Deprecated) This option is not supported anymore, and will be ignored.
> -.RS
> -.TP
> -The compiled-in value is: \fB@CONFIGDIR@\fR
> -.RE

We don't actually specify the location of these files and directories
elsewhere in this man page (except for the bindings file), and we do
refer to them by these config option names. We should probably
replace the references to these option names with the actual file
locations, and probably also list the files in a FILES section.

-Ben


Return-Path: <SRS0=t70f=OG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49FDEC433EF
	for <dm-devel@archiver.kernel.org>; Thu, 16 Sep 2021 04:32:46 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E621F60F23
	for <dm-devel@archiver.kernel.org>; Thu, 16 Sep 2021 04:32:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E621F60F23
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1631766765;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=3bGHILCaPtVYTTJ+IMSeSK7y7zvGCak4TqeHAZlc3zQ=;
	b=U0rPxXwaAOCdfpwtub/JUvO4yhZBzmDcpBOeanvW7xK6uMJlRP5xJSTYXGrPIEG2NzRhi3
	AmPz+aWlacQzR2aV8J3aSzhexjWVAYpgRDDyx1yRqxLB1a1qHr6iyAK4vZNxCWqK4dvVol
	7DHYwTvR2q4r9Ym88oky67TMvD1CDAo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-444-l2Z3xvf3MBi4riagzolNww-1; Thu, 16 Sep 2021 00:32:41 -0400
X-MC-Unique: l2Z3xvf3MBi4riagzolNww-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 554B7800FF4;
	Thu, 16 Sep 2021 04:32:37 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 018B71000358;
	Thu, 16 Sep 2021 04:32:37 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 79FBE4EA2A;
	Thu, 16 Sep 2021 04:32:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
	[10.5.11.16])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18G4OavU004964 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 16 Sep 2021 00:24:36 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 3F7D25C1D1; Thu, 16 Sep 2021 04:24:36 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5F4FD5C1A1;
	Thu, 16 Sep 2021 04:24:33 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 18G4OVKn007932; 
	Wed, 15 Sep 2021 23:24:31 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 18G4OVcW007931;
	Wed, 15 Sep 2021 23:24:31 -0500
Date: Wed, 15 Sep 2021 23:24:30 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20210916042430.GU3087@octiron.msp.redhat.com>
References: <20210910114120.13665-1-mwilck@suse.com>
	<20210910114120.13665-36-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20210910114120.13665-36-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com,
	Chongyun Wu <wu.chongyun@h3c.com>
Subject: Re: [dm-devel] [PATCH 35/35] multipathd: uxclt: allow client mode
 for non-root, too
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Sep 10, 2021 at 01:41:20PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> The server checks for root permissions anyway. "multipathd -k"
> should work for ordinary users as long as no priviledged commands
> are executed.
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipathd/main.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/multipathd/main.c b/multipathd/main.c
> index ec4bcc3..ff5b600 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -3329,11 +3329,6 @@ main (int argc, char *argv[])
>  
>  	logsink = LOGSINK_SYSLOG;
>  
> -	if (getuid() != 0) {
> -		fprintf(stderr, "need to be root\n");
> -		exit(1);
> -	}
> -
>  	/* make sure we don't lock any path */
>  	if (chdir("/") < 0)
>  		fprintf(stderr, "can't chdir to root directory : %s\n",
> @@ -3420,6 +3415,11 @@ main (int argc, char *argv[])
>  		return err;
>  	}
>  
> +	if (getuid() != 0) {
> +		fprintf(stderr, "need to be root\n");
> +		exit(1);
> +	}
> +
>  	if (foreground) {
>  		if (!isatty(fileno(stdout)))
>  			setbuf(stdout, NULL);
> -- 
> 2.33.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


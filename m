Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA2B5C433F5
	for <dm-devel@archiver.kernel.org>; Tue, 29 Mar 2022 20:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1648586096;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=iPeE/+bW2pka8SkZWFqT2qlc+Y11AraUO0Q9+v4kAK4=;
	b=B4CZWzDKDlrZtGE540HHTJ7ummNvfv29oUumWX/evWRsa/Ga0s76jN2wrPo9S+XetvMyzV
	LnEYhkyeBkaCGivta4rpuox+VH0IV6oNygCteFrAnEApuW9CDfjiGi0jfDdcO7ppSzsyjh
	nWgde2y8jLUj4DrgbHgYDTJqxzgH/Ko=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-479-PNukb03OOhWmxmxrLY0-_A-1; Tue, 29 Mar 2022 16:34:55 -0400
X-MC-Unique: PNukb03OOhWmxmxrLY0-_A-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A7D8A802E5B;
	Tue, 29 Mar 2022 20:34:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8F509401DBF;
	Tue, 29 Mar 2022 20:34:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2A7161940345;
	Tue, 29 Mar 2022 20:34:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2DC011940342
 for <dm-devel@listman.corp.redhat.com>; Tue, 29 Mar 2022 20:34:50 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EEFE6141DC5F; Tue, 29 Mar 2022 20:34:49 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DEB361400B1C;
 Tue, 29 Mar 2022 20:34:49 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 22TKYmxr026954;
 Tue, 29 Mar 2022 15:34:48 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 22TKYm1G026953;
 Tue, 29 Mar 2022 15:34:48 -0500
Date: Tue, 29 Mar 2022 15:34:48 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20220329203448.GP24684@octiron.msp.redhat.com>
References: <20220324211927.7152-1-mwilck@suse.com>
 <20220324211927.7152-3-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20220324211927.7152-3-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH v3 12/12] multipathd: decrease verbosity of
 handle_signal()
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: dm-devel@redhat.com, Guozhonghua <guozh88@chinatelecom.cn>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Mar 24, 2022 at 10:19:27PM +0100, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> The "reset log" message isn't very important, and the others will
> be followed by more meaningful messages when multipathd actually
> exits, or reconfigures itself.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> ---
>  multipathd/main.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/multipathd/main.c b/multipathd/main.c
> index aee0953..1406251 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -2927,18 +2927,18 @@ void
>  handle_signals(bool nonfatal)
>  {
>  	if (exit_sig) {
> -		condlog(2, "exit (signal)");
> +		condlog(3, "exit (signal)");
>  		exit_sig = 0;
>  		exit_daemon();
>  	}
>  	if (!nonfatal)
>  		return;
>  	if (reconfig_sig) {
> -		condlog(2, "reconfigure (signal)");
> +		condlog(3, "reconfigure (signal)");
>  		schedule_reconfigure(FORCE_RELOAD_WEAK);
>  	}
>  	if (log_reset_sig) {
> -		condlog(2, "reset log (signal)");
> +		condlog(3, "reset log (signal)");
>  		if (logsink == LOGSINK_SYSLOG)
>  			log_thread_reset();
>  	}
> -- 
> 2.35.1
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


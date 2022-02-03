Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92E30C433F5
	for <dm-devel@archiver.kernel.org>; Thu,  3 Feb 2022 00:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1643848955;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=6MQRRp7s09CfPld4ATNf41oXXo+GyqSQhG743yOKLME=;
	b=Zz316l3ytOxXgFEWa/Q3G5XXmcqWxwal48h0rnArfT4QiLlpRmlrOfSwuPlsfz/Zci4J3M
	fn1gzVSqm2J/sxtVnMfKC/hqeNnxbB1ONNCOGQ0KhIW4qFnPleDuw+wt8Tb/14newh9JZS
	zpGWXaUUn7wz+5SeOtCbQnfNIFA/2uY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-103-RoVIo6HjNnS0XY183uXsiA-1; Wed, 02 Feb 2022 19:42:32 -0500
X-MC-Unique: RoVIo6HjNnS0XY183uXsiA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A51DC100CCC2;
	Thu,  3 Feb 2022 00:42:27 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1BBEE7A22B;
	Thu,  3 Feb 2022 00:42:27 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E07DE4BB7C;
	Thu,  3 Feb 2022 00:42:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
	[10.5.11.22])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 2130dTYv003597 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 2 Feb 2022 19:39:29 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B668E104C519; Thu,  3 Feb 2022 00:39:29 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9613B10495B0;
	Thu,  3 Feb 2022 00:39:26 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 2130dNUe027396; 
	Wed, 2 Feb 2022 18:39:24 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 2130dNI6027395;
	Wed, 2 Feb 2022 18:39:23 -0600
Date: Wed, 2 Feb 2022 18:39:23 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20220203003923.GQ24684@octiron.msp.redhat.com>
References: <20220201234024.27675-1-mwilck@suse.com>
	<20220201234024.27675-2-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20220201234024.27675-2-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 1/6] multipath/Makefile: use $(udevrulesdir)
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Feb 02, 2022 at 12:40:19AM +0100, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  multipath/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/multipath/Makefile b/multipath/Makefile
> index 7673553..c690368 100644
> --- a/multipath/Makefile
> +++ b/multipath/Makefile
> @@ -22,7 +22,7 @@ install:
>  	$(INSTALL_PROGRAM) -m 755 $(EXEC) $(DESTDIR)$(bindir)/
>  	$(INSTALL_PROGRAM) -d $(DESTDIR)$(udevrulesdir)
>  	$(INSTALL_PROGRAM) -m 644 11-dm-mpath.rules $(DESTDIR)$(udevrulesdir)
> -	$(INSTALL_PROGRAM) -m 644 $(EXEC).rules $(DESTDIR)$(libudevdir)/rules.d/56-multipath.rules
> +	$(INSTALL_PROGRAM) -m 644 $(EXEC).rules $(DESTDIR)$(udevrulesdir)/56-multipath.rules
>  	$(INSTALL_PROGRAM) -d $(DESTDIR)$(man8dir)
>  	$(INSTALL_PROGRAM) -m 644 $(EXEC).8 $(DESTDIR)$(man8dir)
>  	$(INSTALL_PROGRAM) -d $(DESTDIR)$(man5dir)
> -- 
> 2.34.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


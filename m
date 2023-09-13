Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 886F0EE0211
	for <dm-devel@archiver.kernel.org>; Wed, 13 Sep 2023 22:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694645198;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=+EcdjQ2QG+k7fv6jp4V1CCpQgGpJB/Lgc9rJMYB/VCk=;
	b=OKIdQpMwA54nYtA5RDh1mRUfc9pTiTo+CW6MTvQd5+AZ0LRlYF/SC1AWRMNFix9tukMALc
	zwwNXWZZ18XW/azkXlJJecLUCiEyv5Ll+1zJ/eCH3h0ikdX/a1gAUqjVIZCv+3YOqcbWEd
	t/BxEvdm3v9Jnxx1HB6buNoZwiuCzOc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-52-KkGbNGDkNeKFMlZVdmHERw-1; Wed, 13 Sep 2023 18:46:34 -0400
X-MC-Unique: KkGbNGDkNeKFMlZVdmHERw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0797E81B194;
	Wed, 13 Sep 2023 22:46:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 98278403F4E0;
	Wed, 13 Sep 2023 22:46:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5C38519465B5;
	Wed, 13 Sep 2023 22:46:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 82D0B19465B1
 for <dm-devel@listman.corp.redhat.com>; Wed, 13 Sep 2023 22:46:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5E4617B62; Wed, 13 Sep 2023 22:46:15 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4473864671;
 Wed, 13 Sep 2023 22:46:15 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 38DMk6LX004516;
 Wed, 13 Sep 2023 17:46:07 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 38DMk6VY004515;
 Wed, 13 Sep 2023 17:46:06 -0500
Date: Wed, 13 Sep 2023 17:46:06 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20230913224606.GC7412@octiron.msp.redhat.com>
References: <20230911163846.27197-1-mwilck@suse.com>
 <20230911163846.27197-33-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20230911163846.27197-33-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH v2 32/37] libdmmp/Makefile: fix bug in
 install section
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
Cc: dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Sep 11, 2023 at 06:38:41PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libdmmp/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/libdmmp/Makefile b/libdmmp/Makefile
> index 078eca8..172ba04 100644
> --- a/libdmmp/Makefile
> +++ b/libdmmp/Makefile
> @@ -44,7 +44,7 @@ install:
>  		$(DESTDIR)$(pkgconfdir)/$(PKGFILE)
>  	$(Q)sed -i 's|__INCLUDEDIR__|$(includedir)|g' \
>  		$(DESTDIR)$(pkgconfdir)/$(PKGFILE)
> -	$(Q)$(INSTALL_PROGRAM) -d 755 $(DESTDIR)$(mandir)/man3
> +	$(Q)$(INSTALL_PROGRAM) -m 755 -d $(DESTDIR)$(mandir)/man3
>  	$(Q)$(INSTALL_PROGRAM) -m 644 -t $(DESTDIR)$(mandir)/man3 docs/man/*.3
>  
>  uninstall:
> -- 
> 2.42.0
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


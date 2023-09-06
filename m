Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BB81EE14AA
	for <dm-devel@archiver.kernel.org>; Wed,  6 Sep 2023 22:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694040340;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=i3ejkPMaL3cxowBtFhgghJSdds0+h7m7RN4WVfxHtlo=;
	b=grdRbMaUUPdKGR2H2cLkZkCwEYsL6Oc3FnooGRcmuOFlyeN9Gk4W35+AuF8hOwCfcmVz3V
	oJEKW+Q1TyBwcLTXQ5pvPa+mWSCtsE40Nn0laF5An8SynVcqWMAs5WnLObFh3w4MYFb2xZ
	CnIeS+xBBtWU/BWGEJtWCpFW1Yce/dQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-228-0bMLFyIoP-Ka2R2vXGK9fQ-1; Wed, 06 Sep 2023 18:45:37 -0400
X-MC-Unique: 0bMLFyIoP-Ka2R2vXGK9fQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 68AC38015AA;
	Wed,  6 Sep 2023 22:45:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5625DC03292;
	Wed,  6 Sep 2023 22:45:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3652B194658D;
	Wed,  6 Sep 2023 22:45:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 00677194658C
 for <dm-devel@listman.corp.redhat.com>; Wed,  6 Sep 2023 22:45:33 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DFE1D1121318; Wed,  6 Sep 2023 22:45:33 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C47561121314;
 Wed,  6 Sep 2023 22:45:33 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 386MjPf6028991;
 Wed, 6 Sep 2023 17:45:25 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 386MjPu9028990;
 Wed, 6 Sep 2023 17:45:25 -0500
Date: Wed, 6 Sep 2023 17:45:25 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20230906224524.GA7412@octiron.msp.redhat.com>
References: <20230901180235.23980-1-mwilck@suse.com>
 <20230901180235.23980-17-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20230901180235.23980-17-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH 16/21] libmultipath: update_bindings_file:
 don't log temp file name
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Sep 01, 2023 at 08:02:29PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> The name of the temp file is unlikely to be helpful for uses,
> and hard to predict in the unit test. Omit it.
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/alias.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/libmultipath/alias.c b/libmultipath/alias.c
> index c26f37c..9ca5da8 100644
> --- a/libmultipath/alias.c
> +++ b/libmultipath/alias.c
> @@ -167,8 +167,7 @@ static int update_bindings_file(const Bindings *bindings,
>  	rc = write_bindings_file(bindings, fd);
>  	pthread_cleanup_pop(1);
>  	if (rc == -1) {
> -		condlog(1, "failed to write new bindings file %s",
> -			tempname);
> +		condlog(1, "failed to write new bindings file");
>  		unlink(tempname);
>  		return rc;
>  	}
> -- 
> 2.41.0
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 172FAEB64D7
	for <dm-devel@archiver.kernel.org>; Fri, 30 Jun 2023 17:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688145606;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=20WS6VLcBYdgGg0DB0dZOMwDnkZXDmgX8t4xxDpKGaE=;
	b=e1DciwzjaseFIgHLEe87j4+n/JI5R1XFexuc62w6Gl9u0riFEOYXsomUOSCo0Dov2VHj71
	pi6v66sC4jlO/W4sADbZEQm0yGx9g6xt8ccMLRhXmZSjhuD0oUWQTBHfHZ8XEGtPeDNmy+
	RP1yNYAzZeGIckLUkRj8zP2SC6Hprus=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-601-bp7LFVd1MS-zwX_3yh94Ww-1; Fri, 30 Jun 2023 13:20:02 -0400
X-MC-Unique: bp7LFVd1MS-zwX_3yh94Ww-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 24350894EE3;
	Fri, 30 Jun 2023 17:20:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5C884492C13;
	Fri, 30 Jun 2023 17:19:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 16C4B19465B6;
	Fri, 30 Jun 2023 17:19:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6B5A019465B3
 for <dm-devel@listman.corp.redhat.com>; Fri, 30 Jun 2023 17:00:11 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A349A40C2072; Fri, 30 Jun 2023 17:00:11 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8C9E340C2063;
 Fri, 30 Jun 2023 17:00:11 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 35UH07tK007906;
 Fri, 30 Jun 2023 12:00:08 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 35UH077S007905;
 Fri, 30 Jun 2023 12:00:07 -0500
Date: Fri, 30 Jun 2023 12:00:07 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20230630170007.GB7412@octiron.msp.redhat.com>
References: <20230630155510.22843-1-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20230630155510.22843-1-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH] libmultipath: fix dev_loss_tmo even if not
 set in configuration
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Jun 30, 2023 at 05:55:10PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> If pp->dev_loss_tmo == DEV_LOSS_TMO_UNSET, sysfs_set_scsi_tmo() would
> not set it to min_dev_loss_tmo, causing the system dev_loss_tmo value
> (by default, 30s) to remain unchanged. Fix it.
> 
> Fixes: 6ad77db ("libmultipath: Set the scsi timeout parameters by path")
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/discovery.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> index 2dcafe5..285cbd6 100644
> --- a/libmultipath/discovery.c
> +++ b/libmultipath/discovery.c
> @@ -895,9 +895,8 @@ sysfs_set_scsi_tmo (struct config *conf, struct multipath *mpp)
>  			continue;
>  		}
>  
> -		if (pp->dev_loss != DEV_LOSS_TMO_UNSET &&
> -		    pp->dev_loss < min_dev_loss) {
> -			warn_dev_loss = true;
> +		if (pp->dev_loss < min_dev_loss) {
> +			warn_dev_loss = (pp->dev_loss != DEV_LOSS_TMO_UNSET);
>  			pp->dev_loss = min_dev_loss;
>  		}
>  		if (pp->dev_loss != DEV_LOSS_TMO_UNSET &&

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> -- 
> 2.41.0
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1134C433EF
	for <dm-devel@archiver.kernel.org>; Thu,  9 Jun 2022 15:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1654788160;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=mIS6ABFFIlMhojooTTYCpaJZHusUtnF56iZt2jS0RkA=;
	b=iMU/sBse1Kf8qn+gtl8BwYlN4oBVk2B4myOlnHmYI8qsl4zMYsMXxFdbWug//hmMepID1j
	0UWMMhwOGsGYj3L2eDLpJBE+XnPocuDzf4w8AtpnAW1hogwUbqGYRLljdGkfmRpbyY8Frf
	v485Sq7hI7Z8lo7DNM7dOrMWcb7u8NM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-635-keE3wS9lNsytGcNQ0-cBLQ-1; Thu, 09 Jun 2022 11:22:38 -0400
X-MC-Unique: keE3wS9lNsytGcNQ0-cBLQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E137C811E80;
	Thu,  9 Jun 2022 15:22:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 88AF92026D64;
	Thu,  9 Jun 2022 15:22:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 31D48194705B;
	Thu,  9 Jun 2022 15:22:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 41B821947040
 for <dm-devel@listman.corp.redhat.com>; Thu,  9 Jun 2022 15:22:34 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2A8292166B29; Thu,  9 Jun 2022 15:22:34 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 156D32166B26;
 Thu,  9 Jun 2022 15:22:34 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 259FMWpM030876;
 Thu, 9 Jun 2022 10:22:32 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 259FMWhM030875;
 Thu, 9 Jun 2022 10:22:32 -0500
Date: Thu, 9 Jun 2022 10:22:31 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20220609152231.GA5254@octiron.msp.redhat.com>
References: <20220609090554.13487-1-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20220609090554.13487-1-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH] libmultipath: hwtable: remove ETERNUS AB/HB
 NVMe
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
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel@redhat.com,
 Xose Vazquez Perez <xose.vazquez@gmail.com>,
 Steven Schremmer <Steve.Schremmer@netapp.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Jun 09, 2022 at 11:05:54AM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> The previous patch "libmultipath: hwtable: remove obsolete NVMe entries"
> removed the entry for NetApp E-Series NVMe, but not the corresponding OEM
> entry for ETERNUS AB/HB NVMe. Fix it.
> 
> Cc: Steven Schremmer <Steve.Schremmer@netapp.com>
> Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> ---
>  libmultipath/hwtable.c | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index fd4573f..513fa67 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -468,12 +468,6 @@ static struct hwentry default_hw[] = {
>  		.pgfailback    = -FAILBACK_IMMEDIATE,
>  		.no_path_retry = 30,
>  	},
> -	{
> -		/* ETERNUS AB/HB NVMe */
> -		.vendor        = "NVME",
> -		.product       = "Fujitsu ETERNUS AB/HB Series",
> -		.no_path_retry = 30,
> -	},
>  	/*
>  	 * Hitachi Vantara
>  	 *
> -- 
> 2.36.1
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


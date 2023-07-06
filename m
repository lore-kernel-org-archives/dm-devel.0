Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBD4CEB64D9
	for <dm-devel@archiver.kernel.org>; Thu,  6 Jul 2023 17:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688663565;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=03iIqsfd9VpnHI+ZPawIUkwSenrxNjjH5fArue7j+60=;
	b=Fs4n/cYhCip4PnPSOKODH/RYIqnD7/zBsaJ3lEN+WF3iU3jd7OY8ZpBayOZc54u62mKodl
	WNFoh0fIiUWgMyghy3tCwHKa2SJfhJAMQRK3tzbX/AiIUNYN1QnwJTJ+TXZy29HNadGCVO
	1zrJm4G8Y8hFed16F3VQ69FP67jFFI8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-564-YEUT-O9cOqCOzcTKNrU2MQ-1; Thu, 06 Jul 2023 13:12:41 -0400
X-MC-Unique: YEUT-O9cOqCOzcTKNrU2MQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4A90B1C2BD6B;
	Thu,  6 Jul 2023 17:12:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BDD6EF6431;
	Thu,  6 Jul 2023 17:12:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8EADD194658F;
	Thu,  6 Jul 2023 17:12:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8401C1946589
 for <dm-devel@listman.corp.redhat.com>; Thu,  6 Jul 2023 17:12:36 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 18B7340C6CCD; Thu,  6 Jul 2023 17:12:36 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id F337740C6F5A;
 Thu,  6 Jul 2023 17:12:35 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 366HCWu2015350;
 Thu, 6 Jul 2023 12:12:32 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 366HCVAT015349;
 Thu, 6 Jul 2023 12:12:31 -0500
Date: Thu, 6 Jul 2023 12:12:31 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20230706171231.GK7412@octiron.msp.redhat.com>
References: <20230627143350.18056-1-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20230627143350.18056-1-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH] libmultipath: dm_get_maps(): remove spurious
 assignment
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Jun 27, 2023 at 04:33:50PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Issue found by coverity:
>   CID 393674:  Code maintainability issues  (UNUSED_VALUE)
>   Assigning value "NULL" to "mpp" here, but that stored value is overwritten before it can be
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/devmapper.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> index a49db3b..248c373 100644
> --- a/libmultipath/devmapper.c
> +++ b/libmultipath/devmapper.c
> @@ -1359,7 +1359,6 @@ dm_get_maps (vector mp)
>  		}
>  
>  		vector_set_slot(mp, mpp);
> -		mpp = NULL;
>  next:
>  		next = names->next;
>  		names = (void *) names + next;
> -- 
> 2.41.0
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


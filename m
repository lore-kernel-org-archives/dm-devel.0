Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27B8BEE14A9
	for <dm-devel@archiver.kernel.org>; Wed,  6 Sep 2023 22:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694040465;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Z+TOgulCURH8M4AcnhqZY9E7GG4v7q5xEd3Vl9/1zfo=;
	b=REthehn6ku12ZhA5iJn5IQIQM/sQldaT6UGmfP3OB4ZbNb2u22iOBfforEQlrXprqzpY1u
	pNZ96Tk8YXr8sRzu8kOsb37YMi4CiartZ5FhSO91laMP4HzHJoXQXiRFtdALp4AllNk72y
	u2sjdTivZ1+whGpYWB46dDHP2iYCwjU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-196-Z48pHrFhMcGGwfpLJ0ityw-1; Wed, 06 Sep 2023 18:47:41 -0400
X-MC-Unique: Z48pHrFhMcGGwfpLJ0ityw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F1E108015AA;
	Wed,  6 Sep 2023 22:47:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E285F1121314;
	Wed,  6 Sep 2023 22:47:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BA37E1946594;
	Wed,  6 Sep 2023 22:47:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 24AC8194658C
 for <dm-devel@listman.corp.redhat.com>; Wed,  6 Sep 2023 22:47:38 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0CB3B493112; Wed,  6 Sep 2023 22:47:38 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E933E493110;
 Wed,  6 Sep 2023 22:47:37 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 386MlT5u029018;
 Wed, 6 Sep 2023 17:47:29 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 386MlTDe029017;
 Wed, 6 Sep 2023 17:47:29 -0500
Date: Wed, 6 Sep 2023 17:47:29 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20230906224729.GE7412@octiron.msp.redhat.com>
References: <20230901180235.23980-1-mwilck@suse.com>
 <20230901180235.23980-21-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20230901180235.23980-21-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH 20/21] libmultipath: dm_get_uuid(): return
 emtpy UUID for non-existing maps
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Sep 01, 2023 at 08:02:33PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> libdevmapper will most probably not return a UUID for non-existing
> maps anyway. But it's cheap to double-check here.
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/devmapper.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> index 248c373..9be82f4 100644
> --- a/libmultipath/devmapper.c
> +++ b/libmultipath/devmapper.c
> @@ -706,12 +706,16 @@ dm_get_prefixed_uuid(const char *name, char *uuid, int uuid_len)
>  {
>  	struct dm_task *dmt;
>  	const char *uuidtmp;
> +	struct dm_info info;
>  	int r = 1;
>  
>  	dmt = libmp_dm_task_create(DM_DEVICE_INFO);
>  	if (!dmt)
>  		return 1;
>  
> +	if (uuid_len > 0)
> +		uuid[0] = '\0';
> +
>  	if (!dm_task_set_name (dmt, name))
>  		goto uuidout;
>  
> @@ -720,11 +724,13 @@ dm_get_prefixed_uuid(const char *name, char *uuid, int uuid_len)
>  		goto uuidout;
>  	}
>  
> +	if (!dm_task_get_info(dmt, &info) ||
> +	    !info.exists)
> +		goto uuidout;
> +
>  	uuidtmp = dm_task_get_uuid(dmt);
>  	if (uuidtmp)
>  		strlcpy(uuid, uuidtmp, uuid_len);
> -	else
> -		uuid[0] = '\0';
>  
>  	r = 0;
>  uuidout:
> -- 
> 2.41.0
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


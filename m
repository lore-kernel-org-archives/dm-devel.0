Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90D3AC433EF
	for <dm-devel@archiver.kernel.org>; Mon, 21 Feb 2022 16:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1645461776;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=98gHHkxZbr5qDVk1HbCuRAneBerB96Fe3h60fjd+MXI=;
	b=FX3YCoxybQ+Yr/EFYKED0PWHaCzB/uVAhM6d2Mr6sSCDYXnfgzfJd1D4TsfZfISTnAry4l
	huX0lV3p9ViKQ1wdfXS57zZ2GZ8PINpeD+R+vS6Rrvt/U0SkiAxrbnzK2yryMpiDLOIRU8
	lsqaAvmmgvskczDusM2WqLHJR+3LUz8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-516-OXsOjL_UNISzn_TPnCT9_Q-1; Mon, 21 Feb 2022 11:42:52 -0500
X-MC-Unique: OXsOjL_UNISzn_TPnCT9_Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 07B681091DA2;
	Mon, 21 Feb 2022 16:42:48 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D9C5B75521;
	Mon, 21 Feb 2022 16:42:47 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 339A41826D01;
	Mon, 21 Feb 2022 16:42:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21LGgi0C001499 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 21 Feb 2022 11:42:44 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 8735340D2969; Mon, 21 Feb 2022 16:42:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8257840D2962
	for <dm-devel@redhat.com>; Mon, 21 Feb 2022 16:42:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 694A1800882
	for <dm-devel@redhat.com>; Mon, 21 Feb 2022 16:42:44 +0000 (UTC)
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
	[209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-593-pGJxdMAKO3egXTWAicZpAA-1; Mon, 21 Feb 2022 11:42:43 -0500
X-MC-Unique: pGJxdMAKO3egXTWAicZpAA-1
Received: by mail-qv1-f70.google.com with SMTP id
	kl13-20020a056214518d00b0042cb237f86bso17848498qvb.0
	for <dm-devel@redhat.com>; Mon, 21 Feb 2022 08:42:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=Rc1Qppaw2L0OGmsDB0z5fBH1sQJhXx2jCYeAkzZOEHI=;
	b=qlpBIFMeH+VjLTLLdXpK7iMvN6A2gL0iVy1TbYkSau2CY+dAoH3go4TWmARVKvX2iv
	2x00fssYLhW79zxLiYL+EVbU5TfPjaUlRG4SO6YVv1x8y+P3IuvxSjltx4OHwEjj1tbM
	Nv6gdjil1az8SvAkWTBoqkiZhvWhLGYwGO4qf7GNNS9iCSk2lMnCanWatsbp2Ed7cDS9
	kqNEFH3FkbgwVSk6It4wKp+yb6jA63qemkpJdGqrzoPz3uGPDn4nEL4I4nrbMiZLOKlG
	foYw+XBMVVnu0pWS+hgUk7E1RGtcV3u6tUjRoYN4C19XujV3ch5CfmNLdXk0KmS0sbLl
	qQ0w==
X-Gm-Message-State: AOAM533AHcPWihtQbQhowtjp+rUd3Wzm09BAVwgdZc6bKoRhQOZumj5j
	Fls/gabcUdQyxWGcqFuKAj0+qN/N23qvGN3jdMDjdB2RaLjknlGnxpWZ0FBmF+4FD+ZWKeatU5F
	uRsmrIbLjX8Sipw==
X-Received: by 2002:a05:622a:58f:b0:2dd:2295:5acf with SMTP id
	c15-20020a05622a058f00b002dd22955acfmr18372914qtb.305.1645461762621;
	Mon, 21 Feb 2022 08:42:42 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwAsKUklrVCG8Ma83vO0ASbNLheb3R+NMhCtDg0fLsUsAIRZ1oRjpkFREGNGzwNARSfR4U+ZA==
X-Received: by 2002:a05:622a:58f:b0:2dd:2295:5acf with SMTP id
	c15-20020a05622a058f00b002dd22955acfmr18372896qtb.305.1645461762369;
	Mon, 21 Feb 2022 08:42:42 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	y28sm9873236qkj.73.2022.02.21.08.42.41
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Mon, 21 Feb 2022 08:42:42 -0800 (PST)
Date: Mon, 21 Feb 2022 11:42:41 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Faqiang Zhu <faqiang.zhu@nxp.com>
Message-ID: <YhPBAc9tnJ1iuPbM@redhat.com>
References: <AM9PR04MB811322427E328C435FE9489FED3A9@AM9PR04MB8113.eurprd04.prod.outlook.com>
MIME-Version: 1.0
In-Reply-To: <AM9PR04MB811322427E328C435FE9489FED3A9@AM9PR04MB8113.eurprd04.prod.outlook.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "hch@lst.de" <hch@lst.de>,
	"agk@redhat.com" <agk@redhat.com>
Subject: Re: [dm-devel] a potential issue for bow_target after "dm: delay
 registering the gendisk" applied
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Feb 21 2022 at  5:36P -0500,
Faqiang Zhu <faqiang.zhu@nxp.com> wrote:

> Hi Christoph,
> 
>  
> 
> Recently when I use kernel5.15 with android, an issue related to bow_target
> is found with below log:
> 
>  
> 
> [    8.935429][    T1] kobject_add_internal failed for bow (error: -2
> parent: (null))
> 
>  
> 
> The call trace to the preceding log is as below:
> 
> dm_ctl_ioctl
> 
>  -> ctl_ioctl
> 
>    -> lookup_ioctl    // returns the table_load function pointer
> 
>       table_load
> 
>         -> populate_table
> 
>              -> dm_table_add_target
> 
>                   -> dm_bow_ctr
> 
>                        -> kobject_init_and_add
> 
>                             -> kobject_add_varg
> 
>                                  -> kobject_add_internal
> 
>  
> 
>  
> 
> Compared to kernel5.10, then I found it's related to below patch. The
> gendisk, it's not registered yet, its kobject is not in sysfs, so its child
> "bow" kobject cannot be added to the kernel.
> 
> commit 89f871af1b26d98d983cba7ed0e86effa45ba5f8
> 
> Author: Christoph Hellwig  <mailto:hch@lst.de> hch@lst.de
> 
> Date:   Wed Aug 4 11:41:46 2021 +0200
> 
>  
> 
>     dm: delay registering the gendisk
> 
>  
> 
>  
> 
> Is this an issue? if it is, is there any patch to fix it? if it is not, then
> what is the right way to use the bow_target in userspace?
> 

It is an issue for this out-of-tree dm-bow target.  Likely needs to be
fixed by adding a new DM target operation to 'struct target_type' that
would get called by DM core at end of dm_setup_md_queue().

Or dm-bow discontinues using sysfs for whatever and convert to using
DM messages (with .message) and exposing associated state via .status

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


Return-Path: <SRS0=KYOW=J2=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 675C1C433B4
	for <dm-devel@archiver.kernel.org>; Thu, 29 Apr 2021 16:20:50 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B1ACA6143B
	for <dm-devel@archiver.kernel.org>; Thu, 29 Apr 2021 16:20:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B1ACA6143B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=acm.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-524-CUHEnkzeM7mXwRDhbiOOXg-1; Thu, 29 Apr 2021 12:20:46 -0400
X-MC-Unique: CUHEnkzeM7mXwRDhbiOOXg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AF518501EC;
	Thu, 29 Apr 2021 16:20:39 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7E4CF19C59;
	Thu, 29 Apr 2021 16:20:39 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C866C1809C82;
	Thu, 29 Apr 2021 16:20:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13TGKa0b014014 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 29 Apr 2021 12:20:36 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 6961720877CC; Thu, 29 Apr 2021 16:20:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 60B6621EE583
	for <dm-devel@redhat.com>; Thu, 29 Apr 2021 16:20:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 00159805C1D
	for <dm-devel@redhat.com>; Thu, 29 Apr 2021 16:20:31 +0000 (UTC)
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com
	[209.85.210.172]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-397-3S-pmSwKPsC2iKsDemszWA-1; Thu, 29 Apr 2021 12:20:28 -0400
X-MC-Unique: 3S-pmSwKPsC2iKsDemszWA-1
Received: by mail-pf1-f172.google.com with SMTP id 10so3905003pfl.1;
	Thu, 29 Apr 2021 09:20:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=COFP3FkG7wCZ9Q7qjD+oYcbCyfgxSbMKoarlA1biSQg=;
	b=UfrFxO1EFlKw3Nw9kYdhb6c/CSh2blT28zGwVpQeiFQmIk9FApJEvz2PAguNCVlEFY
	AKK0t+frMmSAekUOPpoCM7qFsFfPx8jS+Y/DSw4hHEXKokXCr12hAOULFZNnlbWOS8tr
	NvKThpHHzxQvzPvhbRygfpJu/QlhZjNAhN5J+uBBlK539LHn09qZ0UDTA4TXZuVpMX/w
	cD0Q1hAzUwISrK4U8wzXINajB5Cpt6FqSLAkuudOjvuZBKFfTUzLxvO1xoGJtaaTmbE8
	vkoKUiZ0k10VGIXyNY77oE9Xy1ho4+2upBSMkmNbU6CzLmq+6deJvgBkvzwh+ThNGnbp
	si7Q==
X-Gm-Message-State: AOAM532uCevjrT9JhGclm6P69bId9+dP6ci5nKDDuDf84DKONS6L1pbj
	vr7XkmhuescZiq25sYsmCYs=
X-Google-Smtp-Source: ABdhPJyp4eINbI2edHrZic2B2jw1Ivn+vMkb0GULEekk+q9VxPLPXTHNr6KNtEMdotd0IijKcW4spw==
X-Received: by 2002:aa7:9f5d:0:b029:265:e8b5:ecd0 with SMTP id
	h29-20020aa79f5d0000b0290265e8b5ecd0mr463836pfr.26.1619713227106;
	Thu, 29 Apr 2021 09:20:27 -0700 (PDT)
Received: from [192.168.3.219] (c-73-241-217-19.hsd1.ca.comcast.net.
	[73.241.217.19]) by smtp.gmail.com with ESMTPSA id
	h20sm2828418pfh.192.2021.04.29.09.20.25
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Thu, 29 Apr 2021 09:20:26 -0700 (PDT)
To: mwilck@suse.com, Mike Snitzer <snitzer@redhat.com>,
	Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com,
	Hannes Reinecke <hare@suse.de>
References: <20210429155024.4947-1-mwilck@suse.com>
	<20210429155024.4947-2-mwilck@suse.com>
From: Bart Van Assche <bvanassche@acm.org>
Message-ID: <08440651-6e8f-734a-ef43-561d9c2596a6@acm.org>
Date: Thu, 29 Apr 2021 09:20:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210429155024.4947-2-mwilck@suse.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
	Christoph Hellwig <hch@lst.de>, Daniel Wagner <dwagner@suse.de>
Subject: Re: [dm-devel] [RFC PATCH v2 1/2] scsi: convert
 scsi_result_to_blk_status() to inline
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 4/29/21 8:50 AM, mwilck@suse.com wrote:
> This makes it possible to use scsi_result_to_blk_status() from
> code that shouldn't depend on scsi_mod (e.g. device mapper).

I think that's the wrong reason to make a function inline. Please
consider moving scsi_result_to_blk_status() into one of the block layer
source code files that already deals with SG I/O, e.g. block/scsi_ioctl.c.

> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
> index 83f7e520be48..ba1e69d3bed9 100644
> --- a/include/scsi/scsi_cmnd.h
> +++ b/include/scsi/scsi_cmnd.h
> @@ -311,24 +311,44 @@ static inline struct scsi_data_buffer *scsi_prot(struct scsi_cmnd *cmd)
>  #define scsi_for_each_prot_sg(cmd, sg, nseg, __i)		\
>  	for_each_sg(scsi_prot_sglist(cmd), sg, nseg, __i)
>  
> +static inline void __set_status_byte(int *result, char status)
> +{
> +	*result = (*result & 0xffffff00) | status;
> +}
> +
>  static inline void set_status_byte(struct scsi_cmnd *cmd, char status)
>  {
> -	cmd->result = (cmd->result & 0xffffff00) | status;
> +	__set_status_byte(&cmd->result, status);
> +}
> +
> +static inline void __set_msg_byte(int *result, char status)
> +{
> +	*result = (*result & 0xffff00ff) | (status << 8);
>  }
>  
>  static inline void set_msg_byte(struct scsi_cmnd *cmd, char status)
>  {
> -	cmd->result = (cmd->result & 0xffff00ff) | (status << 8);
> +	__set_msg_byte(&cmd->result, status);
> +}
> +
> +static inline void __set_host_byte(int *result, char status)
> +{
> +	*result = (*result & 0xff00ffff) | (status << 16);
>  }
>  
>  static inline void set_host_byte(struct scsi_cmnd *cmd, char status)
>  {
> -	cmd->result = (cmd->result & 0xff00ffff) | (status << 16);
> +	__set_host_byte(&cmd->result, status);
> +}
> +
> +static inline void __set_driver_byte(int *result, char status)
> +{
> +	*result = (*result & 0x00ffffff) | (status << 24);
>  }
>  
>  static inline void set_driver_byte(struct scsi_cmnd *cmd, char status)
>  {
> -	cmd->result = (cmd->result & 0x00ffffff) | (status << 24);
> +	__set_driver_byte(&cmd->result, status);
>  }

The layout of the SCSI result won't change since it is used in multiple
UAPI data structures. I'd prefer to open-code host_byte() in
scsi_result_to_blk_status() instead of making the above changes.

Thanks,

Bart.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


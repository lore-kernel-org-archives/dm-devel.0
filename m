Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87C07C4321E
	for <dm-devel@archiver.kernel.org>; Wed, 30 Nov 2022 17:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1669829098;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=2YmKpSvbW3d4c7nHsO6llHAx7FZDPMJyVzvaqBpDGSk=;
	b=KBI4oZB+8kvMRCr0OpbYNVEnkvDXrk35O0n+aUWytpXEqwrmcPr0MuC3sMKIphl2T8nio9
	GlOkCuqjdPrDxuTrrJispa1f4S/afrKbJQNVS/bry5CCMFzjb7TK7IcZyO7/RlEl9+aoUx
	HpQ8LyrYWg/W2MMAPLiopLuCJB9I3NE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-612-5lYdpssAOt2Zn2V3OKrJOQ-1; Wed, 30 Nov 2022 12:24:57 -0500
X-MC-Unique: 5lYdpssAOt2Zn2V3OKrJOQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7CE72806001;
	Wed, 30 Nov 2022 17:24:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D8CE02166B26;
	Wed, 30 Nov 2022 17:24:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B09A919465A4;
	Wed, 30 Nov 2022 17:24:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C8E9C1946586
 for <dm-devel@listman.corp.redhat.com>; Wed, 30 Nov 2022 16:25:51 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B1AA540C83EE; Wed, 30 Nov 2022 16:25:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AB08940C83ED
 for <dm-devel@redhat.com>; Wed, 30 Nov 2022 16:25:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8F8B42999B54
 for <dm-devel@redhat.com>; Wed, 30 Nov 2022 16:25:51 +0000 (UTC)
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-221-ND0MckV2ON6yT3B65dOw4A-1; Wed, 30 Nov 2022 11:25:50 -0500
X-MC-Unique: ND0MckV2ON6yT3B65dOw4A-1
Received: by mail-qv1-f69.google.com with SMTP id
 nn2-20020a056214358200b004bb7bc3dfdcso27233532qvb.23
 for <dm-devel@redhat.com>; Wed, 30 Nov 2022 08:25:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=esffUcF9TlJFELLQVw88/RnS7S6rdsC2lFTOy4sZQrU=;
 b=q+GmeoFMADLhuGTVgrB6q6RWsr60STtZkW/brv/M6FdmpESCN8uDK/VpTwWDft7VKa
 LyxXV0o4lpf/fJnS3hk9XrTBlRi0rBMnG/nNI1vnyNaEltwVRnfk45pL5+gdsAL7LNdx
 1azjcdkQj2WOyktalj2mDpsEjAVZTI3y4ciJzTfrByyUxOrTmXGCoQAr8i0xaMT2l/fH
 CmSdLBjx91d20ygephkJBgwpGfhFidAIMb6vAC1y4VD4jQlqipNziEyAaGP6HfuZFcOh
 V3PUg3Ehap1Je3wiHzAN5GUhrQdFXetqu3ZmtGhJ57duaJP+HMx5o7M8epLG/8jBm0kW
 zU+Q==
X-Gm-Message-State: ANoB5pkfLTuvc2sgJbd9OMx+tk2+d2/Dt0PVOWJA4qgLyRkHX5+QI4CA
 3njR127TuarswVaUQyO7ILc0tNvuqtoeExg0v7Z4sbErbQ0Ng42+8z9zJTqkRYNMokB6uKGKClj
 5cqUQS866K0VtcQ==
X-Received: by 2002:ae9:c017:0:b0:6fc:65f8:33d9 with SMTP id
 u23-20020ae9c017000000b006fc65f833d9mr18959923qkk.39.1669825549249; 
 Wed, 30 Nov 2022 08:25:49 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4m9QtWA4pXquhn2sbV3unD2cp+RDJ22Mm7DK2GZ0OJ+Z+oqi1SrApE4E7wPiDLoVb/MS82XQ==
X-Received: by 2002:ae9:c017:0:b0:6fc:65f8:33d9 with SMTP id
 u23-20020ae9c017000000b006fc65f833d9mr18959902qkk.39.1669825549015; 
 Wed, 30 Nov 2022 08:25:49 -0800 (PST)
Received: from localhost (pool-68-160-173-162.bstnma.fios.verizon.net.
 [68.160.173.162]) by smtp.gmail.com with ESMTPSA id
 u6-20020a05620a430600b006fc5a1d9cd4sm1483667qko.34.2022.11.30.08.25.48
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 30 Nov 2022 08:25:48 -0800 (PST)
Date: Wed, 30 Nov 2022 11:25:47 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: zhang.songyi@zte.com.cn
Message-ID: <Y4eEC48JUauAZuio@redhat.com>
References: <202211301535171577902@zte.com.cn>
MIME-Version: 1.0
In-Reply-To: <202211301535171577902@zte.com.cn>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH linux-next] dm: remove redundant sz variable
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
Cc: dm-devel@redhat.com, snitzer@kernel.org, linux-kernel@vger.kernel.org,
 agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Nov 30 2022 at  2:35P -0500,
zhang.songyi@zte.com.cn <zhang.songyi@zte.com.cn> wrote:

> From: zhang songyi <zhang.songyi@zte.com.cn>
> 
> Return value from hst_status() directly instead of taking
> this in another redundant variable.
> 
> Signed-off-by: zhang songyi <zhang.songyi@zte.com.cn>
> ---
>  drivers/md/dm-ps-historical-service-time.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/md/dm-ps-historical-service-time.c b/drivers/md/dm-ps-historical-service-time.c
> index 1d82c95d323d..6c8e83ad2662 100644
> --- a/drivers/md/dm-ps-historical-service-time.c
> +++ b/drivers/md/dm-ps-historical-service-time.c
> @@ -237,7 +237,6 @@ static void hst_destroy(struct path_selector *ps)
>  static int hst_status(struct path_selector *ps, struct dm_path *path,
>                      status_type_t type, char *result, unsigned int maxlen)
>  {
> -       unsigned int sz = 0;
>         struct path_info *pi;
> 
>         if (!path) {
> @@ -261,7 +260,7 @@ static int hst_status(struct path_selector *ps, struct dm_path *path,
>                 }
>         }
> 
> -       return sz;
> +       return 0;
>  }
> 
>  static int hst_add_path(struct path_selector *ps, struct dm_path *path,
> --
> 2.15.2
> 

NACK

This sz variable is needed! (see DMEMIT)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


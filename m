Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 362B4C43334
	for <dm-devel@archiver.kernel.org>; Thu,  9 Jun 2022 18:16:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-267-Lw3rk0bhO022qbyAcY2w-A-1; Thu, 09 Jun 2022 14:16:20 -0400
X-MC-Unique: Lw3rk0bhO022qbyAcY2w-A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D85DE1C06902;
	Thu,  9 Jun 2022 18:16:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5AC7C1730C;
	Thu,  9 Jun 2022 18:16:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 284631947062;
	Thu,  9 Jun 2022 18:16:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4A4461947040
 for <dm-devel@listman.corp.redhat.com>; Thu,  9 Jun 2022 18:16:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 32489404E4AD; Thu,  9 Jun 2022 18:16:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2DD564010E32
 for <dm-devel@redhat.com>; Thu,  9 Jun 2022 18:16:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1688B294EDEA
 for <dm-devel@redhat.com>; Thu,  9 Jun 2022 18:16:15 +0000 (UTC)
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com
 [209.85.160.171]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-624--NIy73JiMBO3rZsMbtMbtA-1; Thu, 09 Jun 2022 14:16:13 -0400
X-MC-Unique: -NIy73JiMBO3rZsMbtMbtA-1
Received: by mail-qt1-f171.google.com with SMTP id t21so10735821qtw.11
 for <dm-devel@redhat.com>; Thu, 09 Jun 2022 11:16:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=IqBa9uKPuzMBYw7EO8+JYWz3LeyC2Z89LKKu3TPj9R0=;
 b=Zuu20LB7yE9hGQdkRE7wcMMFucZw8fusKJn55VcaOActO0In251Wrd94BJm+O3zow/
 wLTHWwAMG4w67NHGjRdzZN/0plybJjg80vAXkIhhZPxX6AB2zfbq85v3INuZ8SXRbs/B
 a1IIlFQmMEZTQheD1h9YiKfJD3fFVZZ2c9IG3FV6xLdYLzgwch2cre6QOO3/HiI4v8k8
 oLnSSJ/JTQEpcCrD+baoQWS+SAbgTvfz8Yin4gixr/+YgGPsLXQqTZ1H1/ra/Ike+iq0
 Fm0p4gI/2E9zcejlXqaVL7aaTLShZRyXyjXEDqzWSTnPHOOQfk5lou9IfQJjq+wiQLDt
 gYkA==
X-Gm-Message-State: AOAM5320LIBAmimDl0ktWje0LuwjPxsCxvTiV/9GJq2Fv5Fw5UR4HoWE
 3AENzEVXPRE4sk5/JZQzm5zR24B5uS7xhpQ=
X-Google-Smtp-Source: ABdhPJytzPNfgq8ZJoYGppEW1woIaioYo1mXF5NBN1eY+hf5YvYEfiA0kUdl0ynUP975PfILGVrNaA==
X-Received: by 2002:a05:622a:47:b0:305:1ab:e52d with SMTP id
 y7-20020a05622a004700b0030501abe52dmr7932244qtw.688.1654798572745; 
 Thu, 09 Jun 2022 11:16:12 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 d19-20020a05620a241300b006a6c230f5e0sm10910899qkn.31.2022.06.09.11.16.12
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 09 Jun 2022 11:16:12 -0700 (PDT)
Date: Thu, 9 Jun 2022 14:16:11 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <YqI460bUfFdsn3I5@redhat.com>
References: <20220608063409.1280968-1-hch@lst.de> <YqDneqyp33PvkCLm@redhat.com>
 <20220609041149.GA31649@lst.de>
MIME-Version: 1.0
In-Reply-To: <20220609041149.GA31649@lst.de>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: Re: [dm-devel] fix and cleanup device mapper bioset initialization
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Jun 09 2022 at 12:11P -0400,
Christoph Hellwig <hch@lst.de> wrote:

> On Wed, Jun 08, 2022 at 02:16:26PM -0400, Mike Snitzer wrote:
> > All looks good to me.  Are you OK with me picking up the first 3 to
> > send to Linus for 5.19-rc2 (given the integrity bioset fix)?
> > 
> > And hold patch 4 until 5.20 merge?
> 
> Sounds good to me.
> 
> > Or would you prefer that cleanup to land now too?
> 
> I don't think Linus would like that :)  In fact even patch 3 might be
> 5.20 material.

Ha, yeah I agree.  I'll just send the first 2 (likely tomorrow after
more testing today).

Thanks.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


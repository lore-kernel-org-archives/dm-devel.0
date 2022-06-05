Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75431C43334
	for <dm-devel@archiver.kernel.org>; Sun,  5 Jun 2022 04:01:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-207-FBEHb5EaOb6i0j1yfDPUBw-1; Sun, 05 Jun 2022 00:01:40 -0400
X-MC-Unique: FBEHb5EaOb6i0j1yfDPUBw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4E29B29AB3EB;
	Sun,  5 Jun 2022 04:01:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3D8BAC27E92;
	Sun,  5 Jun 2022 04:01:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 17F361947056;
	Sun,  5 Jun 2022 04:01:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 084951947052
 for <dm-devel@listman.corp.redhat.com>; Sun,  5 Jun 2022 04:01:37 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D0093C23DC9; Sun,  5 Jun 2022 04:01:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CC3DFC23DC1
 for <dm-devel@redhat.com>; Sun,  5 Jun 2022 04:01:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B406929AB3EB
 for <dm-devel@redhat.com>; Sun,  5 Jun 2022 04:01:36 +0000 (UTC)
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com
 [209.85.215.171]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-137-Ngaj9ihYMrSpphIrdeVg8w-1; Sun, 05 Jun 2022 00:01:34 -0400
X-MC-Unique: Ngaj9ihYMrSpphIrdeVg8w-1
Received: by mail-pg1-f171.google.com with SMTP id 129so10344676pgc.2
 for <dm-devel@redhat.com>; Sat, 04 Jun 2022 21:01:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:references:from:in-reply-to
 :content-transfer-encoding;
 bh=kuBV28makeSJfzsiM72bJh6iWdW/+SIKOX/bljICWXs=;
 b=cmZLcRpGf+z2H6UnTmw750qHqtXQHR7cwsRrA7eZc7NapdmbOOcA8IQUtq0e/0Tqgd
 EdjpMGrQ/kOPpsQlj6c8C1yTC0L4/8qUalAlDr7TOHKBdrJH2953QzcRppIFhNWwn7kj
 CvwVQQFFYUnMTXPEevYiV4k+ZZ8ZAhZoY1+hwqTsfXy/oqGajIgZYLqtpqRhttrtkZP0
 VyRUULN+8Y47imhpxjG7aDklpw9dCJlXUsvVw3ElCVXj1EnkYCdh+VHf+zR2AnZ9tLDV
 k5sCmqgDMGDTj6vKVbfdiVHwsz/8Db7XpA/jRhs0Ivu9CZDYE21ayNkDgB+IKNCSUmp1
 rbeQ==
X-Gm-Message-State: AOAM5331acmh8uk+QO6b3gPn0cDHHlvxpGDxPcupAwhs1toKay8KoF8V
 QGkMMNZLy+32VOvUnZynFKI=
X-Google-Smtp-Source: ABdhPJwYW0FtIavUiAKHq2ahwqUsR7QXrUYXGE2TjFS43H3ZZMXLSDtjSEEEhAGF0VfBDFPuWNQxzw==
X-Received: by 2002:a63:f5e:0:b0:3fd:23e1:e086 with SMTP id
 30-20020a630f5e000000b003fd23e1e086mr9499008pgp.61.1654401692985; 
 Sat, 04 Jun 2022 21:01:32 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd?
 ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
 by smtp.gmail.com with ESMTPSA id
 s7-20020a170902988700b0015e8d4eb267sm8148225plp.177.2022.06.04.21.01.31
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Sat, 04 Jun 2022 21:01:32 -0700 (PDT)
Message-ID: <923053d3-adf8-e4b4-9ef3-8e920ae90a79@acm.org>
Date: Sat, 4 Jun 2022 21:01:30 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
To: Mike Christie <michael.christie@oracle.com>, linux-block@vger.kernel.org, 
 dm-devel@redhat.com, snitzer@kernel.org, hch@lst.de, axboe@kernel.dk,
 martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
 linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20220603065536.5641-1-michael.christie@oracle.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220603065536.5641-1-michael.christie@oracle.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH 0/8] Use block pr_ops in LIO
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
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 6/2/22 23:55, Mike Christie wrote:
> The following patches were built over Linus's tree. They allow us to use
> the block pr_ops with LIO's target_core_iblock module to support cluster
> applications in VMs.
> 
> Currently, to use something like windows clustering in VMs with LIO and
> vhost-scsi, you have to use tcmu or pscsi or use a cluster aware
> FS/framework for the LIO pr file. Setting up a cluster FS/framework is
> pain and waste when your real backend device is already a distributed
> device, and pscsi and tcmu are nice for specific use cases, but iblock
> gives you the best performance and allows you to use stacked devices
> like dm-multipath. So these patches allow iblock to work like pscsi/tcmu
> where they can pass a PR command to the backend module. And then iblock
> will use the pr_ops to pass the PR command to the real devices similar
> to what we do for unmap today.
> 
> Note that this is patchset does not attempt to support every PR SCSI
> feature in iblock. It has the same limitations as tcmu and pscsi where
> you can have a single I_T nexus per device and only supports what is
> needed for windows clustering right now.

How has this patch series been tested? Does LIO pass the libiscsi 
persistent reservation tests with this patch series applied?

Thanks,

Bart.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


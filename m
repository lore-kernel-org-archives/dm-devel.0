Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C4ACC433F5
	for <dm-devel@archiver.kernel.org>; Wed, 30 Mar 2022 06:09:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-312-MiuSBCw7NCu6sDEIJfHtsw-1; Wed, 30 Mar 2022 02:09:21 -0400
X-MC-Unique: MiuSBCw7NCu6sDEIJfHtsw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8D1F83804514;
	Wed, 30 Mar 2022 06:09:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DBF6E7AC3;
	Wed, 30 Mar 2022 06:09:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C51641949761;
	Wed, 30 Mar 2022 06:08:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 94AF91940342
 for <dm-devel@listman.corp.redhat.com>; Tue, 29 Mar 2022 15:15:07 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4C163C15E74; Tue, 29 Mar 2022 15:15:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 48166C15E71
 for <dm-devel@redhat.com>; Tue, 29 Mar 2022 15:15:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0EA77899ECB
 for <dm-devel@redhat.com>; Tue, 29 Mar 2022 15:15:07 +0000 (UTC)
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com
 [209.85.167.50]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-669-1axPJWaROnKyfmZov1tc-Q-1; Tue, 29 Mar 2022 11:15:01 -0400
X-MC-Unique: 1axPJWaROnKyfmZov1tc-Q-1
Received: by mail-lf1-f50.google.com with SMTP id h7so30863096lfl.2
 for <dm-devel@redhat.com>; Tue, 29 Mar 2022 08:14:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=TCWrlmneGOD7IIFil77Bp2XL5E/ZrBLzGSn/OUyCQN0=;
 b=w52c/RkoGC9g/IOQm5TavghUrn1jM6zo+4eQCTtIFyBKCXuOsdEjKfWCJz79Dm5ZuT
 jisPFQJoad6aydvxBxLFHQsT0aKfSqmcpFRyuM4Ogyp/oh8TiGklNJjJFwY8kid+b23s
 eVwr+IoK0DdohAll3X+f7vz8g9tnuYeJrFtHOFG5EhL6SjVNnLFNCLtmwcK1vJGBW6fB
 Ww+tHWaBEjRGNbh28RR0EOev6yhGTjfWySSgOrLiZWrqx1Qp+Dgz6P7gGLtAOBQYXFiX
 C7AotqEjZ1H6RDvC+y07Y5sW9vYlS7+fGSMoUfLQNY1B0LWBKCEe2ea737mRoQaCdWPL
 +4eA==
X-Gm-Message-State: AOAM5325FSWJg3alVmNb5OfcVEeQIOlWxeVkfQtjjqPTRCnoxPyLI+Sj
 fgkMvtRAnpdse/m48/7bXXSCvg==
X-Google-Smtp-Source: ABdhPJxWSF7zpEgBOOCeivx+pQN3jDM+rv6d44kgAKyIFW8havUT3LmsKKoQ3S9eXl9h7KTZgf/AwQ==
X-Received: by 2002:a05:6512:128f:b0:44a:2b70:91e3 with SMTP id
 u15-20020a056512128f00b0044a2b7091e3mr3211444lfs.160.1648566896888; 
 Tue, 29 Mar 2022 08:14:56 -0700 (PDT)
Received: from [192.168.0.120] ([2.92.192.13])
 by smtp.gmail.com with ESMTPSA id
 y24-20020a199158000000b0044a76a4808esm1462330lfj.22.2022.03.29.08.14.55
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 29 Mar 2022 08:14:56 -0700 (PDT)
Message-ID: <ccd18622-9c38-2252-27d8-25bb8538ac26@openvz.org>
Date: Tue, 29 Mar 2022 18:14:55 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
To: Christoph Hellwig <hch@infradead.org>
References: <164846619932.251310.3668540533992131988.stgit@pro>
 <YkME5ZS2CpXuNmN6@infradead.org>
From: Kirill Tkhai <kirill.tkhai@openvz.org>
In-Reply-To: <YkME5ZS2CpXuNmN6@infradead.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Mailman-Approved-At: Wed, 30 Mar 2022 06:08:49 +0000
Subject: Re: [dm-devel] [PATCH 0/4] dm: Introduce dm-qcow2 driver to attach
 QCOW2 files as block device
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
Cc: snitzer@redhat.com, linux-kernel@vger.kernel.org, song@kernel.org,
 dm-devel@redhat.com, agk@redhat.com, khorenko@virtuozzo.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 29.03.2022 16:08, Christoph Hellwig wrote:
> On Mon, Mar 28, 2022 at 02:18:16PM +0300, Kirill Tkhai wrote:
>> This patchset adds a new driver allowing to attach QCOW2 files
>> as block devices. Its idea is to implement in kernel only that
>> features, which affect runtime IO performance (IO requests
>> processing functionality).
> 
> From a quick looks it seems to be like this should be a block driver
> just like the loop driver and not use device mapper.  Why would
> you use device mapper to basically reimplement a fancy loop driver
> to start with?

This is a driver for containers and virtual machines. One of basic features
for them is migration and backups. There are several drives for that, which
are already implemented in device-mapper. For example, dm-era and dm-snap.
Instead of implementing such the functionality in QCOW2 driver once again,
the sane behavior is to use already implemented drivers. The module-approach
is better for support and errors eliminating just because of less code.

1)A device-mapper based driver does not require migration and backup devices
  are built in a stack for the whole device lifetime:

  a)Normal work, almost 100% of time: there is only /dev/mapper/qcow2_dev.
  b)Migration: /dev/mapper/qcow2_dev is reloaded with a migration device,
    which points to new qcow2_dev.real:

    /dev/mapper/qcow2_dev          [migration driver]
      /dev/mapper/qcow2_dev.real   [dm-qcow2 driver]
    
   After migration is completed, we reload /dev/mapper/qcow2_dev back
   to use dm-qcow2 driver. So, there is no excess dm layers during normal work.

2)In case of the driver is not a device-mapper based, it's necessary to have
  the stack built for the whole device lifetime, since it's impossible to reload
  bare block driver with dm-based driver on demand:

    /dev/mapper/qcow2_dev          [migration driver]
       /dev/qcow2_dev.real         [bare qcow2 driver]

  So, we would have excess dm layer during whole device lifetime.

Our performance tests show, that a single dm layer may cause up to 10% performance
decrease on NVME, so the reason is to eliminate such the fall. Also, the general
reasoning say that excess layer is a wrong way.

Other reason is previous experience of implementing file-backed block drivers.
We had ploop driver before. Ploop format is much simpler that QCOW2 format, but
there are about 17K strings, while dm-qcow2 driver took about 6K strings.
Device mapper allows to avoid writing a lot of code, the only thing you need
is to implement proper .ctr and .dtr functions, while the rest of configuration
actions are done by simple device-mapper reload.

>> The maintenance operations are
>> synchronously processed in userspace, while device is suspended.
>>
>> Userspace is allowed to do only that operations, which never
>> modifies virtual disk's data. It is only allowed to modify
>> QCOW2 file metadata providing that disk's data. The examples
>> of allowed operations is snapshot creation and resize.
> 
> And this sounds like a pretty fragile design.  It basically requires
> both userspace and the kernel driver to access metadata on disk, which
> sounds rather dangerous.

I don't think so. Device-mapper already allows to replace a device driver with
another driver. Nobody blames dm-linear, that it may be reloaded to point wrong
partition, while it can. Nobody blames loop, that someone in userspace may corrupt
its blocks, and filesystem on that device will become broken.

The thing is kernel and userspace never access the file at the same time.
It case of maintenance actions may be called in userspace, they must be, since
this reduces the kernel code.
 
>> This example shows the way of device-mapper infrastructure
>> allows to implement drivers following the idea of
>> kernel/userspace components demarcation. Thus, the driver
>> uses advantages of device-mapper instead of implementing
>> its own suspend/resume engine.
> 
> What do you need more than a queue freeze?

Theoretically, I can, in case of this flushes all pending requests. But this
will increase driver code significantly, since there won't be possible to use
reload mechanism, and there are other problems like problems with performance
like I wrote above. So, this approach look significantly worse.

Kirill

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


Return-Path: <SRS0=mcEr=MU=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49413C4338F
	for <dm-devel@archiver.kernel.org>; Wed, 28 Jul 2021 03:10:53 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id AD01460F91
	for <dm-devel@archiver.kernel.org>; Wed, 28 Jul 2021 03:10:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org AD01460F91
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-332-mceumQs9O2ic-53pnOAwSA-1; Tue, 27 Jul 2021 23:10:49 -0400
X-MC-Unique: mceumQs9O2ic-53pnOAwSA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D7AAC87D541;
	Wed, 28 Jul 2021 03:10:43 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E37A927C20;
	Wed, 28 Jul 2021 03:10:42 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1162D4BB7C;
	Wed, 28 Jul 2021 03:10:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 16S3AcVo014732 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 27 Jul 2021 23:10:38 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 37E34ED17B; Wed, 28 Jul 2021 03:10:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 32501ED146
	for <dm-devel@redhat.com>; Wed, 28 Jul 2021 03:10:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BA03789C7DB
	for <dm-devel@redhat.com>; Wed, 28 Jul 2021 03:10:35 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-450-E0C0TBAXMQqsHAJQLvCkew-1;
	Tue, 27 Jul 2021 23:10:31 -0400
X-MC-Unique: E0C0TBAXMQqsHAJQLvCkew-1
Received: from [192.168.86.34] (c-71-197-163-6.hsd1.wa.comcast.net
	[71.197.163.6])
	by linux.microsoft.com (Postfix) with ESMTPSA id ACC712043B96;
	Tue, 27 Jul 2021 20:10:29 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com ACC712043B96
To: Thore Sommer <public@thson.de>, agk@redhat.com, dm-devel@redhat.com,
	linux-integrity@vger.kernel.org, nramas@linux.microsoft.com,
	snitzer@redhat.com, zohar@linux.ibm.com
References: <c833339e-c4bf-6e78-5719-cd902fa8426f@linux.microsoft.com>
	<20210727101802.779067-1-public@thson.de>
	<20210727203337.GA81220@agk-cloud1.hosts.prod.upshift.rdu2.redhat.com>
From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
Message-ID: <a30c8208-f255-d0f0-0bfb-c037367e638c@linux.microsoft.com>
Date: Tue, 27 Jul 2021 20:10:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210727203337.GA81220@agk-cloud1.hosts.prod.upshift.rdu2.redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 0/7] device mapper target measurements using
 IMA
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

Hi Thore,

On 7/27/21 1:33 PM, Alasdair G Kergon wrote:
>> Creating a dm-verity device with mount then removing it and now if you create it
>> again no measurement is generated. Is that the expected behavior?
> Each of the relevant dm ioctls should be logged separately each time.  If that's
> not happening it might need fixing.
> 
Most likely this is because you haven't set CONFIG_IMA_DISABLE_HTABLE=y.

See "IMA: support for duplicate measurement records" [1] for details.

Please let us know if you still see this behavior after setting
CONFIG_IMA_DISABLE_HTABLE=y.

Thanks,
Tushar

[1] 
https://github.com/torvalds/linux/commit/52c208397c246f0c31d031eb8c41f9c7e9fdec0e

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


Return-Path: <SRS0=CWIS=MG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A39C8C12002
	for <dm-devel@archiver.kernel.org>; Wed, 14 Jul 2021 20:20:27 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3DC72613C3
	for <dm-devel@archiver.kernel.org>; Wed, 14 Jul 2021 20:20:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3DC72613C3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-228-G0boN5usPIaG9UBbttDvXQ-1; Wed, 14 Jul 2021 16:20:24 -0400
X-MC-Unique: G0boN5usPIaG9UBbttDvXQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C398F801107;
	Wed, 14 Jul 2021 20:20:19 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BADB61962F;
	Wed, 14 Jul 2021 20:20:18 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D0CD31809C99;
	Wed, 14 Jul 2021 20:20:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 16EKKD87012460 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 14 Jul 2021 16:20:13 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 8513B115D7A0; Wed, 14 Jul 2021 20:20:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7FA54115D7AB
	for <dm-devel@redhat.com>; Wed, 14 Jul 2021 20:20:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 89BDB858EEC
	for <dm-devel@redhat.com>; Wed, 14 Jul 2021 20:20:06 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-146-k0wWoargOlmVPRXWI8x4pg-1;
	Wed, 14 Jul 2021 16:20:04 -0400
X-MC-Unique: k0wWoargOlmVPRXWI8x4pg-1
Received: from [10.106.164.77] (unknown [131.107.8.205])
	by linux.microsoft.com (Postfix) with ESMTPSA id C1E9B20B6C50;
	Wed, 14 Jul 2021 13:20:02 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com C1E9B20B6C50
To: Thore Sommer <public@thson.de>
References: <20210713004904.8808-1-tusharsu@linux.microsoft.com>
	<20210714113241.28580-1-public@thson.de>
From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
Message-ID: <c833339e-c4bf-6e78-5719-cd902fa8426f@linux.microsoft.com>
Date: Wed, 14 Jul 2021 13:20:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210714113241.28580-1-public@thson.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: snitzer@redhat.com, zohar@linux.ibm.com, nramas@linux.microsoft.com,
	dm-devel@redhat.com, linux-integrity@vger.kernel.org, agk@redhat.com
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

Hello Thore,
On 7/14/21 4:32 AM, Thore Sommer wrote:
> Thank you for bringing IMA support to device mapper. The addition of dm-verity
> to IMA is very useful for the project I'm working on where we boot
> our distribution from removable USB media.
Thank you for the positive ack. Appreciate it.
> One of our goals is to detect tampering of the root file system remotely.
> Therefore we enabled dm-verity support but implementing remote attestation for
> dm-verity from userland is not ideal which was our initial plan.
Yes, remote attestation from userland is not ideal.
> This patch set enables us to leverage to already implemented IMA attestation
> infrastructure by the remote attestation service that we are using (Keylime)
> without trying to roll a custom solution.
I am glad that DM-IMA functionality is useful for your scenario.
> We tested the initial RFC patch set and will continue testing with 
> this one to see if it fully works in our environment and with our use 
> case. 
Thank you for testing the RFC patch set.
Please let me know if you discover any bugs in this one, or have any 
other feedback.

Thanks again.

Regards,
Tushar
> Thore Sommer 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


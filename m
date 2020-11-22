Return-Path: <SRS0=JGfJ=E5=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7CC7C56202
	for <dm-devel@archiver.kernel.org>; Mon, 23 Nov 2020 08:40:50 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 42A0620729
	for <dm-devel@archiver.kernel.org>; Mon, 23 Nov 2020 08:40:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 42A0620729
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-579-mbDgO7zcMyKtdaSYLUWgxg-1; Mon, 23 Nov 2020 03:40:46 -0500
X-MC-Unique: mbDgO7zcMyKtdaSYLUWgxg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E71E61074642;
	Mon, 23 Nov 2020 08:40:38 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C531D1E2C8;
	Mon, 23 Nov 2020 08:40:38 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 95D0E1809CA8;
	Mon, 23 Nov 2020 08:40:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AMKrhXS011696 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 22 Nov 2020 15:53:44 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id BCFB92166B2B; Sun, 22 Nov 2020 20:53:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B7E882166B27
	for <dm-devel@redhat.com>; Sun, 22 Nov 2020 20:53:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6DE14811E76
	for <dm-devel@redhat.com>; Sun, 22 Nov 2020 20:53:41 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-199-E-XbmVK5OcWSfD7W83ZwCg-1;
	Sun, 22 Nov 2020 15:53:38 -0500
X-MC-Unique: E-XbmVK5OcWSfD7W83ZwCg-1
Received: from [192.168.86.31] (c-71-197-163-6.hsd1.wa.comcast.net
	[71.197.163.6])
	by linux.microsoft.com (Postfix) with ESMTPSA id B7AFB20B717A;
	Sun, 22 Nov 2020 12:53:36 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B7AFB20B717A
To: Pavel Machek <pavel@ucw.cz>
References: <20201119232611.30114-1-tusharsu@linux.microsoft.com>
	<20201120124657.GA31468@duo.ucw.cz>
From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
Message-ID: <aadf6e35-39bc-74d4-6ca3-d708860738a5@linux.microsoft.com>
Date: Sun, 22 Nov 2020 12:53:35 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201120124657.GA31468@duo.ucw.cz>
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
X-Mailman-Approved-At: Mon, 23 Nov 2020 03:39:39 -0500
Cc: sashal@kernel.org, paul@paul-moore.com, snitzer@redhat.com,
	selinux@vger.kernel.org, stephen.smalley.work@gmail.com,
	jmorris@namei.org, zohar@linux.ibm.com,
	linux-kernel@vger.kernel.org, nramas@linux.microsoft.com,
	linux-security-module@vger.kernel.org,
	tyhicks@linux.microsoft.com, casey@schaufler-ca.com,
	linux-integrity@vger.kernel.org, dm-devel@redhat.com,
	gmazyland@gmail.com, agk@redhat.com
Subject: Re: [dm-devel] [PATCH v6 0/8] IMA: support for measuring kernel
 integrity critical data
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

Thanks Pavel for looking at this series.

On 2020-11-20 4:46 a.m., Pavel Machek wrote:
> On Thu 2020-11-19 15:26:03, Tushar Sugandhi wrote:
>> Kernel integrity critical data can be defined as the in-memory kernel
>> data which if accidentally or maliciously altered, can compromise the
>> integrity of the system.
> 
> Is that an useful definition?
I will rework on the definition in the next iteration.
Meanwhile, if you have any feedback on what can we add to the
definition, that would help is.

> 
>> There are several kernel subsystems that contain integrity critical
>> data - e.g. LSMs like SELinux, or AppArmor; or device-mapper targets
>> like dm-crypt, dm-verity etc. Examples of critical data could be kernel
>> in-memory r/o structures, hash of the memory structures, or data that
>> represents a linux kernel subsystem state.
>>
>> This patch set defines a new IMA hook namely ima_measure_critical_data()
>> to measure the critical data. Kernel subsystems can use this
>> functionality, to take advantage of IMA's measuring and quoting
>> abilities - thus ultimately enabling remote attestation for the
>> subsystem specific information stored in the kernel memory.
> 
> How is it supposed to be useful?
> 
> I'm pretty sure there are critical data that are not measured by
> proposed module... and that are written under normal circumstances.
> 
The goal of this series is to introduce the IMA hook
measure_critical_data() and the necessary policies to use it; and
illustrate that use with one example (SELinux). It is not scalable to 
identify and update all the critical data sources to use the proposed
module at once.

A piecemeal approach to add more critical data measurement in subsequent
patches would be easy to implement and review.

Please let me know if you have more thoughts on this. (what critical
data you think would be useful to measure etc.)

~Tushar

> Best regards,
> 
> 									Pavel
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


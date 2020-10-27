Return-Path: <SRS0=VcJp=EE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F2E3C55179
	for <dm-devel@archiver.kernel.org>; Thu, 29 Oct 2020 09:07:50 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 731792072C
	for <dm-devel@archiver.kernel.org>; Thu, 29 Oct 2020 09:07:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 731792072C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-403-ayC6GRFEPtOhQstg8aCy0Q-1; Thu, 29 Oct 2020 05:07:44 -0400
X-MC-Unique: ayC6GRFEPtOhQstg8aCy0Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 42676184214B;
	Thu, 29 Oct 2020 09:07:39 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DB04D610F3;
	Thu, 29 Oct 2020 09:07:38 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2E5B958111;
	Thu, 29 Oct 2020 09:07:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09RHUcP3027790 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 27 Oct 2020 13:30:38 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 9D4DF2156A36; Tue, 27 Oct 2020 17:30:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 961C12156A37
	for <dm-devel@redhat.com>; Tue, 27 Oct 2020 17:30:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 562D6802D3D
	for <dm-devel@redhat.com>; Tue, 27 Oct 2020 17:30:36 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-487-ZinP6m_IONiWH0LbqCbKhg-1;
	Tue, 27 Oct 2020 13:30:31 -0400
X-MC-Unique: ZinP6m_IONiWH0LbqCbKhg-1
Received: from [192.168.86.21] (c-71-197-163-6.hsd1.wa.comcast.net
	[71.197.163.6])
	by linux.microsoft.com (Postfix) with ESMTPSA id EF0D620B4905;
	Tue, 27 Oct 2020 10:30:28 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com EF0D620B4905
To: Mimi Zohar <zohar@linux.ibm.com>, stephen.smalley.work@gmail.com,
	casey@schaufler-ca.com, agk@redhat.com, snitzer@redhat.com,
	gmazyland@gmail.com
References: <20200923192011.5293-1-tusharsu@linux.microsoft.com>
	<2c7da61fbeb17c577253b117829b3bd544d8cf44.camel@linux.ibm.com>
From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
Message-ID: <d3bfb2ec-357a-411d-956c-0e305245f6ec@linux.microsoft.com>
Date: Tue, 27 Oct 2020 10:30:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <2c7da61fbeb17c577253b117829b3bd544d8cf44.camel@linux.ibm.com>
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
X-Mailman-Approved-At: Thu, 29 Oct 2020 05:07:35 -0400
Cc: sashal@kernel.org, dm-devel@redhat.com, selinux@vger.kernel.org,
	jmorris@namei.org, linux-kernel@vger.kernel.org,
	nramas@linux.microsoft.com, linux-security-module@vger.kernel.org,
	tyhicks@linux.microsoft.com, linux-integrity@vger.kernel.org
Subject: Re: [dm-devel] [PATCH v4 0/6] IMA: Infrastructure for measurement
 of critical kernel data
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

Hi Mimi,
Thanks a lot for your continual engagement and
providing us valuable feedback on this work.

On 2020-10-24 8:35 p.m., Mimi Zohar wrote:
> Hi Tushar,
> 
> On Wed, 2020-09-23 at 12:20 -0700, Tushar Sugandhi wrote:
>> There are several kernel components that contain critical data which if
>> accidentally or maliciously altered, can compromise the security of the
>> kernel. Example of such components would include LSMs like SELinux, or
>> AppArmor; or device-mapper targets like dm-crypt, dm-verity etc.
> 
> ^"the integrity of the system."
> 
Ok. I will revisit this cover letter again, when we post the next
version of the series. We also need to update the cover letter to
include the description for new patches to be added in this series, as
per your suggestion below. {built-in policy patch (by Lakshmi) and an
example measurement patch (SeLinux by Lakshmi)}

> This cover letter needs to be re-written from a higher perspective,
> explaining what is meant by "critical data" (e.g. kernel subsystem
> specific information only stored in kernel memory).
> 
>>
>> Many of these components do not use the capabilities provided by kernel
>> integrity subsystem (IMA), and thus they don't use the benefits of
>> extended TPM PCR quotes and ultimately the benefits of remote attestation.
> 
> True, up until recently IMA only measured files, nothing else.  Why is
> this paragraph needed?  What new information is provided?
> 
Here, I was attempting to describe the problem (what needs to be
solved), before proposing a solution below. But maybe it is not adding
value. I will get rid of the above paragraph in the next iteration.

>> This series bridges this gap, so that potential kernel components that
>> contain data critical to the security of the kernel could take advantage
>> of IMA's measuring and quoting abilities - thus ultimately enabling
>> remote attestation for their specific data.
> 
> Perhaps, something more along the lines, "This patch set defines a new
> IMA hook named ... to measure critical data."
> 
Will do.
>>
>> System administrators may want to pick and choose which kernel
>> components they would want to enable for measurements, quoting, and
>> remote attestation. To enable that, a new IMA policy is introduced.
> 
> Reverse the order of this paragraph and the following one, describing
> the new feature and only afterwards explaining how it may be
> constrained.
> 
Makes total sense. Will do.
>>
>> And lastly, the functionality is exposed through a function
>> ima_measure_critical_data(). The functionality is generic enough to
>> measure the data of any kernel component at run-time. To ensure that
>> only data from supported sources are measured, the kernel component
>> needs to be added to a compile-time list of supported sources (an
>> "allowed list of components"). IMA validates the source passed to
>> ima_measure_critical_data() against this allowed list at run-time.
> 
> This patch set must include at least one example of measuring critical
> data, before it can be upstreamed.  Tushar, please coordinate with
> Lakshmi and Raphael.
> 
Yes. I am coordinating with Lakshmi/Raphael on including one of the
examples. (SeLinux as per your feedback)

BTW, we also have one more data source (dm-crypt) currently in review,
that uses critical data measurement infrastructure to measure its kernel
in-memory data.
https://patchwork.kernel.org/patch/11844817/

Thanks again for all the help and support with the patches.

~Tushar

> thanks,
> 
> Mimi
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


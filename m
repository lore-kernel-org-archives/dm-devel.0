Return-Path: <SRS0=Ey+N=GS=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C3B6C433E0
	for <dm-devel@archiver.kernel.org>; Fri, 15 Jan 2021 08:29:26 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 670E722597
	for <dm-devel@archiver.kernel.org>; Fri, 15 Jan 2021 08:29:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 670E722597
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-29-9AdnmaHsPDWJLh0qX6F_kw-1; Fri, 15 Jan 2021 03:29:22 -0500
X-MC-Unique: 9AdnmaHsPDWJLh0qX6F_kw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7A315801FCC;
	Fri, 15 Jan 2021 08:29:17 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5C8595D9C2;
	Fri, 15 Jan 2021 08:29:17 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 273F25002C;
	Fri, 15 Jan 2021 08:29:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10EGMw8l006133 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 14 Jan 2021 11:22:58 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 793392166B2A; Thu, 14 Jan 2021 16:22:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 746D52166B2C
	for <dm-devel@redhat.com>; Thu, 14 Jan 2021 16:22:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 23FFF858280
	for <dm-devel@redhat.com>; Thu, 14 Jan 2021 16:22:56 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-75-oqQPh7BBPTa99Ah3xMQT7g-1;
	Thu, 14 Jan 2021 11:22:51 -0500
X-MC-Unique: oqQPh7BBPTa99Ah3xMQT7g-1
Received: from [192.168.0.104] (c-73-42-176-67.hsd1.wa.comcast.net
	[73.42.176.67])
	by linux.microsoft.com (Postfix) with ESMTPSA id E852C20B6C40;
	Thu, 14 Jan 2021 08:22:49 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com E852C20B6C40
To: Mimi Zohar <zohar@linux.ibm.com>, Paul Moore <paul@paul-moore.com>
References: <20210108040708.8389-1-tusharsu@linux.microsoft.com>
	<20210108040708.8389-9-tusharsu@linux.microsoft.com>
	<CAHC9VhSJk0wG=WzO3bwsueiy19mMi9m6MamTrQfH8C=gXUtvGw@mail.gmail.com>
	<97328fc71687a0e1c327f6821548be9ba35bb193.camel@linux.ibm.com>
	<CAHC9VhTzaQ_q8gJ0oeok_yJ54XLETNvOuhhKnyRwgqsqvpBLCw@mail.gmail.com>
	<71cddb6c8676ccd63c89364d805cfca76d32cb6e.camel@linux.ibm.com>
	<CAHC9VhRhYWEcK7TepZ=LK1m=9Zn_gtOZyAYfamP-TFU3rRH+zw@mail.gmail.com>
	<e29a618645b0e73ec06960a02b6da465614689ff.camel@linux.ibm.com>
	<CAHC9VhTHqwKem=MyQBY4TNAq-DOVhwEZS8pjrSE=4OxdEVm-GA@mail.gmail.com>
	<3746bc7673df25354411151442a7772b867be396.camel@linux.ibm.com>
From: Lakshmi Ramasubramanian <nramas@linux.microsoft.com>
Message-ID: <fc80b1a1-ff4d-3bf2-59bd-2cb56135bf0f@linux.microsoft.com>
Date: Thu, 14 Jan 2021 08:22:44 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <3746bc7673df25354411151442a7772b867be396.camel@linux.ibm.com>
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
X-Mailman-Approved-At: Fri, 15 Jan 2021 03:28:56 -0500
Cc: sashal@kernel.org, dm-devel@redhat.com, snitzer@redhat.com,
	selinux@vger.kernel.org, Stephen Smalley <stephen.smalley.work@gmail.com>,
	James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
	casey@schaufler-ca.com, linux-security-module@vger.kernel.org,
	tyhicks@linux.microsoft.com,
	Tushar Sugandhi <tusharsu@linux.microsoft.com>,
	linux-integrity@vger.kernel.org, gmazyland@gmail.com, agk@redhat.com
Subject: Re: [dm-devel] [PATCH v10 8/8] selinux: include a consumer of the
 new IMA critical data hook
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 1/13/21 6:49 PM, Mimi Zohar wrote:

Hi Mimi,

>>>>>>>> I remain concerned about the possibility of bypassing a measurement by
>>>>>>>> tampering with the time, but I appear to be the only one who is
>>>>>>>> worried about this so I'm not going to block this patch on those
>>>>>>>> grounds.
>>>>>>>>
>>>>>>>> Acked-by: Paul Moore <paul@paul-moore.com>
>>>>>>>
>>>>>>> Thanks, Paul.
>>>>>>>
>>>>>>> Including any unique string would cause the buffer hash to change,
>>>>>>> forcing a new measurement.  Perhaps they were concerned with
>>>>>>> overflowing a counter.
>>>>>>
>>>>>> My understanding is that Lakshmi wanted to force a new measurement
>>>>>> each time and felt using a timestamp would be the best way to do that.
>>>>>> A counter, even if it wraps, would have a different value each time
>>>>>> whereas a timestamp is vulnerable to time adjustments.  While a
>>>>>> properly controlled and audited system could be configured and
>>>>>> monitored to detect such an event (I *think*), why rely on that if it
>>>>>> isn't necessary?
>>>>>
>>>>> Why are you saying that even if the counter wraps a new measurement is
>>>>> guaranteed.   I agree with the rest of what you said.
>>>>
>>>> I was assuming that the IMA code simply compares the passed
>>>> "policy_event_name" value to the previous value, if they are different
>>>> a new measurement is taken, if they are the same the measurement
>>>> request is ignored.  If this is the case the counter value is only
>>>> important in as much as that it is different from the previous value,
>>>> even simply toggling a single bit back and forth would suffice in this
>>>> case.  IMA doesn't keep a record of every previous "policy_event_name"
>>>> value does it?  Am I misunderstanding how
>>>> ima_measure_critical_data(...) works?
>>>
>>> Originally, there was quite a bit of discussion as to how much or how
>>> little should be measured for a number of reasons.  One reason is that
>>> the TPM is relatively slow.  Another reason is to limit the size of the
>>> measurement list.  For this reason, duplicate hashes aren't added to
>>> the measurement list or extended into the TPM.
>>>
>>> When a dentry is removed from cache, its also removed from IMA's iint
>>> cache.  A subsequent file read would result in adding the measurement
>>> and extending the TPM again.  ima_lookup_digest_entry() is called to
>>> prevent adding the duplicate entry.
>>>
>>> Lakshmi is trying to address the situation where an event changes a
>>> value, but then is restored to the original value.  The original and
>>> subsequent events are measured, but restoring to the original value
>>> isn't re-measured.  This isn't any different than when a file is
>>> modified and then reverted.
>>>
>>> Instead of changing the name like this, which doesn't work for files,
>>> allowing duplicate measurements should be generic, based on policy.
>>
>> Perhaps it is just the end of the day and I'm a bit tired, but I just
>> read all of the above and I have no idea what your current thoughts
>> are regarding this patch.
> 
> Other than appending the timestamp, which is a hack, the patch is fine.
> Support for re-measuring an event can be upstreamed independently.
> 

Thanks for clarifying the details related to duplicate measurement 
detection and re-measuring.

I will keep the timestamp for the time being, even though its a hack, as 
it helps with re-measuring state changes in SELinux. We will add support 
for "policy driven" re-measurement as a subsequent patch series.

thanks,
  -lakshmi

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


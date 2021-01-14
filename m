Return-Path: <SRS0=Ey+N=GS=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15128C433E6
	for <dm-devel@archiver.kernel.org>; Fri, 15 Jan 2021 08:29:28 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6D11222287
	for <dm-devel@archiver.kernel.org>; Fri, 15 Jan 2021 08:29:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6D11222287
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-221-MnL_Q8nPM1GOkqoNRyRIzg-1; Fri, 15 Jan 2021 03:29:24 -0500
X-MC-Unique: MnL_Q8nPM1GOkqoNRyRIzg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AA7D4806666;
	Fri, 15 Jan 2021 08:29:19 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 865CD648A1;
	Fri, 15 Jan 2021 08:29:19 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2AAD25002E;
	Fri, 15 Jan 2021 08:29:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10EHmikr016843 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 14 Jan 2021 12:48:44 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 536A41031F5B; Thu, 14 Jan 2021 17:48:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4F6BE10F1CB1
	for <dm-devel@redhat.com>; Thu, 14 Jan 2021 17:48:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0D4A485828A
	for <dm-devel@redhat.com>; Thu, 14 Jan 2021 17:48:41 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-123-q_Z77JXPN0ifxs7ST6XoMA-1;
	Thu, 14 Jan 2021 12:48:38 -0500
X-MC-Unique: q_Z77JXPN0ifxs7ST6XoMA-1
Received: from [192.168.0.104] (c-73-42-176-67.hsd1.wa.comcast.net
	[73.42.176.67])
	by linux.microsoft.com (Postfix) with ESMTPSA id 0549E20B6C40;
	Thu, 14 Jan 2021 09:48:36 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 0549E20B6C40
To: Mimi Zohar <zohar@linux.ibm.com>, Paul Moore <paul@paul-moore.com>,
	Sasha Levin <sashal@kernel.org>
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
	<fc80b1a1-ff4d-3bf2-59bd-2cb56135bf0f@linux.microsoft.com>
	<99be76345f375bb2f485f08a53dcb8ed806dc538.camel@linux.ibm.com>
	<f42d49d2e876379c0ef6e31a34027be95ffb1375.camel@linux.ibm.com>
From: Lakshmi Ramasubramanian <nramas@linux.microsoft.com>
Message-ID: <e883298b-1027-2a58-dcf8-fc940ebc27ff@linux.microsoft.com>
Date: Thu, 14 Jan 2021 09:48:35 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <f42d49d2e876379c0ef6e31a34027be95ffb1375.camel@linux.ibm.com>
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
X-Mailman-Approved-At: Fri, 15 Jan 2021 03:28:56 -0500
Cc: dm-devel@redhat.com, snitzer@redhat.com, selinux@vger.kernel.org,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 1/14/21 8:50 AM, Mimi Zohar wrote:
> On Thu, 2021-01-14 at 11:44 -0500, Mimi Zohar wrote:
>> [Cc'ing Sasha]
>>
>> Hi Lakshmi,
>>
>> On Thu, 2021-01-14 at 08:22 -0800, Lakshmi Ramasubramanian wrote:
>>> On 1/13/21 6:49 PM, Mimi Zohar wrote:
>>
>>>>>> Lakshmi is trying to address the situation where an event changes a
>>>>>> value, but then is restored to the original value.  The original and
>>>>>> subsequent events are measured, but restoring to the original value
>>>>>> isn't re-measured.  This isn't any different than when a file is
>>>>>> modified and then reverted.
>>>>>>
>>>>>> Instead of changing the name like this, which doesn't work for files,
>>>>>> allowing duplicate measurements should be generic, based on policy.
>>>>>
>>>>> Perhaps it is just the end of the day and I'm a bit tired, but I just
>>>>> read all of the above and I have no idea what your current thoughts
>>>>> are regarding this patch.
>>>>
>>>> Other than appending the timestamp, which is a hack, the patch is fine.
>>>> Support for re-measuring an event can be upstreamed independently.
>>>>
>>>
>>> Thanks for clarifying the details related to duplicate measurement
>>> detection and re-measuring.
>>>
>>> I will keep the timestamp for the time being, even though its a hack, as
>>> it helps with re-measuring state changes in SELinux. We will add support
>>> for "policy driven" re-measurement as a subsequent patch series.
>>
>> Once including the timestamp is upstreamed, removing it will be
>> difficult, especially if different userspace applications are dependent
>> on it.  Unless everyone is on board that removing the timestamp
>> wouldn't be considered a regression, it cannot be upstreamed.
> 
> Feel free to just re-post just this one patch.  Otherwise the patch set
> looks good.
> 
> thanks,
> 

Sounds good Mimi - I will remove the timestamp and re-post the selinux 
patch.

thanks,
  -lakshmi


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


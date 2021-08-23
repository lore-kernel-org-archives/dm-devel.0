Return-Path: <SRS0=PruR=NO=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1213DC432BE
	for <dm-devel@archiver.kernel.org>; Mon, 23 Aug 2021 17:18:45 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9D61461528
	for <dm-devel@archiver.kernel.org>; Mon, 23 Aug 2021 17:18:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9D61461528
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-338-uCweeckZM_CnD6UgWjZlvA-1; Mon, 23 Aug 2021 13:18:42 -0400
X-MC-Unique: uCweeckZM_CnD6UgWjZlvA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BA59F107ACF5;
	Mon, 23 Aug 2021 17:18:36 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A1E6D5D740;
	Mon, 23 Aug 2021 17:18:35 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id AD185181A2A6;
	Mon, 23 Aug 2021 17:18:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17NHIVmF000931 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 23 Aug 2021 13:18:31 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 071891111C8C; Mon, 23 Aug 2021 17:18:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 02E601111C8B
	for <dm-devel@redhat.com>; Mon, 23 Aug 2021 17:18:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3C8B418A6581
	for <dm-devel@redhat.com>; Mon, 23 Aug 2021 17:18:28 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-580-1a-7BoH4NaalmX2tYxeKuQ-1;
	Mon, 23 Aug 2021 13:18:19 -0400
X-MC-Unique: 1a-7BoH4NaalmX2tYxeKuQ-1
Received: from [192.168.86.34] (c-71-197-163-6.hsd1.wa.comcast.net
	[71.197.163.6])
	by linux.microsoft.com (Postfix) with ESMTPSA id 9C64920C343B;
	Mon, 23 Aug 2021 10:18:18 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 9C64920C343B
To: Mike Snitzer <snitzer@redhat.com>
References: <20210813213801.297051-1-tusharsu@linux.microsoft.com>
	<YSAOTX+TQwaCUeCn@redhat.com>
From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
Message-ID: <d68666b2-7ae7-3932-e86e-abab0a2255ee@linux.microsoft.com>
Date: Mon, 23 Aug 2021 10:18:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YSAOTX+TQwaCUeCn@redhat.com>
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
Cc: sfr@canb.auug.org.au, zohar@linux.ibm.com, linux-block@vger.kernel.org,
	nramas@linux.microsoft.com, dm-devel@redhat.com, public@thson.de,
	linux-integrity@vger.kernel.org, agk@redhat.com
Subject: Re: [dm-devel] [PATCH 0/6] updates to device mapper target
	measurement using ima
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

Hello Mike,

On 8/20/21 1:19 PM, Mike Snitzer wrote:
> On Fri, Aug 13 2021 at  5:37P -0400,
> Tushar Sugandhi <tusharsu@linux.microsoft.com> wrote:
> 
>>
>> There were several improvements suggested for the original device mapper
>> target measurement patch series [1].
>>
>> Those improvement suggestions include:
>>   - Prefixing hashes for the DM tables being measured in ima log with the
>>     hash algorithm.
>>   - Adding version information for DM related events being measured in the
>>     ima log.
>>   - Prefixing DM related event names with "dm_".
>>   - Including the verity target attribute - "root_hash_sig_key_desc"
>>     in the ima measurement log.
>>
>> This series incorporates the above suggestions.
>>
>> This series also has the following fixes:
>>   - Adding a one-time warning to dmesg during dm_init if
>>     CONFIG_IMA_DISABLE_HTABLE is set to 'n'.
>>   - Updating 'integrity' target to remove the duplicate measurement of
>>     the attribute "mode=%c".
>>   - Indexing various attributes in 'multipath' target, and adding
>>     "nr_priority_groups=%u" attribute to the measurements.
>>   - Fixing 'make htmldocs' warnings in dm-ima.rst.
>>   - Adding missing documentation for the targets - 'cache', 'integrity',
>>     'multipath', and 'snapshot' in dm-ima.rst.
>>   - Updating dm-ima.rst documentation with the grammar for various DM
>>     events and targets in Backus Naur form.
>>   - Updating dm-ima.rst documentation to be consistent with the code
>>     changes described above.
>>
>> This series is based on top of the following git repo/branch/commit:
>>   Repo: https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git
>>   Branch: dm-5.15
>>   Commit: commit 5a2a33884f0b ("dm crypt: Avoid percpu_counter spinlock contention in crypt_page_alloc()")
>>
>>
>> [1] https://patchwork.kernel.org/project/dm-devel/cover/20210713004904.8808-1-tusharsu@linux.microsoft.com/
>>
>> Tushar Sugandhi (6):
>>    dm ima: prefix dm table hashes in ima log with hash algorithm
>>    dm ima: add version info to dm related events in ima log
>>    dm ima: prefix ima event name related to device mapper with dm_
>>    dm ima: add a warning in dm_init if duplicate ima events are not
>>      measured
>>    dm ima: update dm target attributes for ima measurements
>>    dm ima: update dm documentation for ima measurement support
> 
> Hi,
> 
> I reviewed and staged these changes in dm-5.15 (and for-next) with
> minimal tweaks. Really just some whitespace and a simplification of
> the conditional for the warning in dm_init().
> 
> Please make sure that you manually apply Christoph's fix for the issue
> you reported earlier in the week, you were cc'd on the ultimate fix
> which has a different patch header than this patch but on a code level
> it is identical (and only patch that landed on a public mailing list
> due to typo in linux-block email address when hch sent the final fix):
> https://listman.redhat.com/archives/dm-devel/2021-August/msg00154.html
> 
> It is an issue that'll linger in the dm-5.15 because I cannot rebase
> at this late hour even once Jens picks the fix up into the
> linux-block tree.
> 
Thank you. I will apply Christoph's fix at my end and test the scenario 
again.

Thanks,
Tushar
> Thanks,
> Mike
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


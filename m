Return-Path: <SRS0=mVW8=H2=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41835C433E0
	for <dm-devel@archiver.kernel.org>; Wed, 24 Feb 2021 01:27:30 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6B42C64E6B
	for <dm-devel@archiver.kernel.org>; Wed, 24 Feb 2021 01:27:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6B42C64E6B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-600-lyvreGrpObaauysrPdYpdA-1; Tue, 23 Feb 2021 20:27:25 -0500
X-MC-Unique: lyvreGrpObaauysrPdYpdA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 919421936B69;
	Wed, 24 Feb 2021 01:27:21 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 18C1710016F0;
	Wed, 24 Feb 2021 01:27:20 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 24C9E18095CB;
	Wed, 24 Feb 2021 01:27:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11O1RG1S031714 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 23 Feb 2021 20:27:17 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id CCB3E202E941; Wed, 24 Feb 2021 01:27:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C74CB202E940
	for <dm-devel@redhat.com>; Wed, 24 Feb 2021 01:27:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1EE318CBAA4
	for <dm-devel@redhat.com>; Wed, 24 Feb 2021 01:27:14 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-393-MirRm82oMQOHaPHXfMPw3g-1;
	Tue, 23 Feb 2021 20:27:11 -0500
X-MC-Unique: MirRm82oMQOHaPHXfMPw3g-1
Received: from [192.168.86.31] (c-71-197-163-6.hsd1.wa.comcast.net
	[71.197.163.6])
	by linux.microsoft.com (Postfix) with ESMTPSA id 130C820B6C40;
	Tue, 23 Feb 2021 17:27:10 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 130C820B6C40
To: Mimi Zohar <zohar@linux.ibm.com>, Petr Vorel <pvorel@suse.cz>,
	ltp@lists.linux.it
References: <20210223225930.27095-1-pvorel@suse.cz>
	<0a25f4b7ed53566b13211d5aeea18e7f13f12bd7.camel@linux.ibm.com>
From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
Message-ID: <e8232b66-8081-090e-4e26-0e1d2544e752@linux.microsoft.com>
Date: Tue, 23 Feb 2021 17:27:09 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <0a25f4b7ed53566b13211d5aeea18e7f13f12bd7.camel@linux.ibm.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: snitzer@redhat.com, Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
	dm-devel@redhat.com, linux-integrity@vger.kernel.org,
	Mimi Zohar <zohar@linux.vnet.ibm.com>, gmazyland@gmail.com, agk@redhat.com
Subject: Re: [dm-devel] [PATCH v3 0/2] IMA: Add test for dm-crypt measurement
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

Hi Petr,

On 2021-02-23 4:43 p.m., Mimi Zohar wrote:
> Hi Petr,
> 
> On Tue, 2021-02-23 at 23:59 +0100, Petr Vorel wrote:
>> Hi!
>>
>> I updated Tushar's patchset to speedup things.
>>
Thank you. :)

>> Changes v2->v3
>> * rename function s/check_ima_ascii_log_for_policy/test_policy_measurement/
>> * move tst_res TPASS/TFAIL into test_policy_measurement()
>> * drop template=ima-buf (see Lakshmi's patch [1] and discussion about
>>    it, it will be removed from ima_keys.sh as well)
Makes sense.

>> * moved ima_dm_crypt.sh specific changes to second commit
>> * further API and style related cleanup
>>
>> Could you please check this patchset?
I reviewed the patchset.
Patch 1 looks ok. (generalize key measurement tests)
Patch 2 won't work as is, since the dm kernel code is not upstreamed
yet. (see my comments below for more context)

> 
> I'm not sure about the status of the associated IMA dm-crypt kernel
> patch set.  It hasn't even been reviewed, definitely not upstreamed.
>   I would hold off on upstreaming the associated ltp test.
> 
That is correct.

The device mapper measurement work is being revisited - to cover aspects
like more DM targets (not just dm-crypt), better memory management, more
relevant attributes from the DM targets, other corner cases etc.

Therefore, even though the first patch of the series "generalize key
measurement tests", would be useful for other tests; I will have to
revisit the second patch, "dm-crypt measurements", to address the
DM side changes I mentioned above.

To summarize,
  - you may upstream the first patch (generalizing the key
    measurements). It would be useful for us while writing more tests in
    this space.

  - but please hold off upstreaming the second patch (dm-crypt test)
    as Mimi has suggested.

Thanks,
Tushar

> thanks,
> 
> Mimi
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


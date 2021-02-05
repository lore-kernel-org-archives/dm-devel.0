Return-Path: <SRS0=nVuD=HH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FDB8C433E0
	for <dm-devel@archiver.kernel.org>; Fri,  5 Feb 2021 00:28:38 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 71BEF64FB3
	for <dm-devel@archiver.kernel.org>; Fri,  5 Feb 2021 00:28:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 71BEF64FB3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-354-DldtH6enN0efcwQYHVGqgQ-1; Thu, 04 Feb 2021 19:28:34 -0500
X-MC-Unique: DldtH6enN0efcwQYHVGqgQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 89BD5804022;
	Fri,  5 Feb 2021 00:28:28 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A352560937;
	Fri,  5 Feb 2021 00:28:26 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4403B4E58D;
	Fri,  5 Feb 2021 00:28:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1150SKYN012269 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 4 Feb 2021 19:28:21 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id DBF8E110E99E; Fri,  5 Feb 2021 00:28:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D83DE110E9AB
	for <dm-devel@redhat.com>; Fri,  5 Feb 2021 00:28:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2FC4C811E87
	for <dm-devel@redhat.com>; Fri,  5 Feb 2021 00:28:18 +0000 (UTC)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99]) (Using TLS)
	by relay.mimecast.com with ESMTP id us-mta-397-1DiS17KbMJ-vl0kXEjY2Bw-1;
	Thu, 04 Feb 2021 19:28:13 -0500
X-MC-Unique: 1DiS17KbMJ-vl0kXEjY2Bw-1
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25E8D64D9D;
	Fri,  5 Feb 2021 00:28:12 +0000 (UTC)
Date: Thu, 4 Feb 2021 19:28:11 -0500
From: Sasha Levin <sashal@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Message-ID: <20210205002811.GV4035784@sasha-vm>
References: <20210120012704.770095-1-sashal@kernel.org>
	<20210120012704.770095-3-sashal@kernel.org>
	<YAfD81Jw/0NU0eWN@sol.localdomain>
MIME-Version: 1.0
In-Reply-To: <YAfD81Jw/0NU0eWN@sol.localdomain>
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
Cc: Mike Snitzer <snitzer@redhat.com>, Anthony Iliopoulos <ailiop@suse.com>,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	linux-raid@vger.kernel.org, dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH AUTOSEL 5.4 03/26] dm integrity: select
 CRYPTO_SKCIPHER
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
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On Tue, Jan 19, 2021 at 09:47:31PM -0800, Eric Biggers wrote:
>On Tue, Jan 19, 2021 at 08:26:40PM -0500, Sasha Levin wrote:
>> From: Anthony Iliopoulos <ailiop@suse.com>
>>
>> [ Upstream commit f7b347acb5f6c29d9229bb64893d8b6a2c7949fb ]
>>
>> The integrity target relies on skcipher for encryption/decryption, but
>> certain kernel configurations may not enable CRYPTO_SKCIPHER, leading to
>> compilation errors due to unresolved symbols. Explicitly select
>> CRYPTO_SKCIPHER for DM_INTEGRITY, since it is unconditionally dependent
>> on it.
>>
>> Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
>> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  drivers/md/Kconfig | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
>> index aa98953f4462e..7dd6e98257c72 100644
>> --- a/drivers/md/Kconfig
>> +++ b/drivers/md/Kconfig
>> @@ -565,6 +565,7 @@ config DM_INTEGRITY
>>  	select BLK_DEV_INTEGRITY
>>  	select DM_BUFIO
>>  	select CRYPTO
>> +	select CRYPTO_SKCIPHER
>>  	select ASYNC_XOR
>>  	---help---
>>  	  This device-mapper target emulates a block device that has
>
>CRYPTO_SKCIPHER doesn't exist in 5.4 and earlier because it was renamed from
>CRYPTO_BLKCIPHER in 5.5.  If this patch is really important enough to backport,
>CRYPTO_SKCIPHER will need to be changed to CRYPTO_BLKCIPHER.

I'll just drop it, thanks!

-- 
Thanks,
Sasha

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


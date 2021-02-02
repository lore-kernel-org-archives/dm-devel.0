Return-Path: <SRS0=/TsO=HF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CD22C433E0
	for <dm-devel@archiver.kernel.org>; Wed,  3 Feb 2021 09:50:48 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D730764F61
	for <dm-devel@archiver.kernel.org>; Wed,  3 Feb 2021 09:50:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D730764F61
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-377-XJ7rLUysO_qoERRZsRYxwA-1; Wed, 03 Feb 2021 04:50:43 -0500
X-MC-Unique: XJ7rLUysO_qoERRZsRYxwA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8D63E9CC02;
	Wed,  3 Feb 2021 09:50:38 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 70BFE57;
	Wed,  3 Feb 2021 09:50:38 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D05174EA32;
	Wed,  3 Feb 2021 09:50:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 112FCdPn004208 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 2 Feb 2021 10:12:39 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 2182DA37DF; Tue,  2 Feb 2021 15:12:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 197D9AC95A
	for <dm-devel@redhat.com>; Tue,  2 Feb 2021 15:12:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C7726803474
	for <dm-devel@redhat.com>; Tue,  2 Feb 2021 15:12:32 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de
	[85.220.165.71]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-436--YXDB0diOGmZfx-Sati2Ow-1; Tue, 02 Feb 2021 10:12:30 -0500
X-MC-Unique: -YXDB0diOGmZfx-Sati2Ow-1
Received: from gallifrey.ext.pengutronix.de
	([2001:67c:670:201:5054:ff:fe8d:eefb] helo=[IPv6:::1])
	by metis.ext.pengutronix.de with esmtp (Exim 4.92)
	(envelope-from <a.fatoum@pengutronix.de>)
	id 1l6xLu-0002oq-Ri; Tue, 02 Feb 2021 16:12:26 +0100
From: Ahmad Fatoum <a.fatoum@pengutronix.de>
To: Jarkko Sakkinen <jarkko@kernel.org>, Mike Snitzer <snitzer@redhat.com>
References: <20210122084321.24012-1-a.fatoum@pengutronix.de>
	<20210122084321.24012-2-a.fatoum@pengutronix.de>
	<YAsT/N8CHHNTZcj3@kernel.org> <YAsW8DAt3vc68rLA@kernel.org>
	<5d44e50e-4309-830b-79f6-f5d888b1ef69@pengutronix.de>
Message-ID: <8cd946c4-558d-ca66-7026-a574034b4757@pengutronix.de>
Date: Tue, 2 Feb 2021 16:12:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <5d44e50e-4309-830b-79f6-f5d888b1ef69@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: a.fatoum@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de);
	SAEximRunCond expanded to false
X-PTX-Original-Recipient: dm-devel@redhat.com
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
X-Mailman-Approved-At: Wed, 03 Feb 2021 04:50:36 -0500
Cc: Sumit Garg <sumit.garg@linaro.org>,
	=?UTF-8?Q?Jan_L=c3=bcbbe?= <jlu@pengutronix.de>, linux-doc@vger.kernel.org,
	Dmitry Baryshkov <dbaryshkov@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org, Song Liu <song@kernel.org>,
	dm-devel@redhat.com, keyrings@vger.kernel.org,
	kernel@pengutronix.de, linux-integrity@vger.kernel.org,
	Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH 2/2] dm crypt: support using trusted keys
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 22.01.21 20:04, Ahmad Fatoum wrote:
> On 22.01.21 19:18, Jarkko Sakkinen wrote:
>> On Fri, Jan 22, 2021 at 08:05:51PM +0200, Jarkko Sakkinen wrote:
>>> On Fri, Jan 22, 2021 at 09:43:21AM +0100, Ahmad Fatoum wrote:
>>>> Commit 27f5411a718c ("dm crypt: support using encrypted keys") extended
>>>> dm-crypt to allow use of "encrypted" keys along with "user" and "logon".
>>>>
>>>> Along the same lines, teach dm-crypt to support "trusted" keys as well.

Gentle ping.
Is there anything further you require from me regarding these two patches?

>>>>
>>>> Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
>>>> ---
>>>
>>> Is it possible to test run this with tmpfs? Would be a good test
>>> target for Sumit's ARM-TEE trusted keys patches.
> 
> I tested these on top of Sumit's patches with TPM and a CAAM blobifier
> backend, I am preparing. The system I am developing these patches against
> doesn't have a TEE.  Steps to test these changes:
> 
> #!/bin/sh
> 
> DEV=/dev/loop0
> ALGO=aes-cbc-essiv:sha256
> KEYNAME=kmk
> BLOCKS=20
> 
> fallocate -l $((BLOCKS*512)) /tmp/loop0.img
> losetup -P $DEV /tmp/loop0.img
> mount -o remount,rw /
> KEY="$(keyctl add trusted $KEYNAME 'new 32' @s)"
> keyctl pipe $KEY >$HOME/kmk.blob
> 
> TABLE="0 $BLOCKS crypt $ALGO :32:trusted:$KEYNAME 0 $DEV 0 1 allow_discards"
> echo $TABLE | dmsetup create mydev
> echo $TABLE | dmsetup load mydev
> dd if=/dev/zero of=/dev/mapper/mydev
> echo "It works!" 1<> /dev/mapper/mydev
> cryptsetup close mydev
> 
> reboot
> 
> DEV=/dev/loop0
> ALGO=aes-cbc-essiv:sha256
> KEYNAME=kmk
> BLOCKS=20
> 
> losetup -P $DEV $HOME/loop0.img
> keyctl add trusted $KEYNAME "load $(cat $HOME/kmk.blob)" @s
> TABLE="0 $BLOCKS crypt $ALGO :32:trusted:$KEYNAME 0 $DEV 0 1 allow_discards"
> echo $TABLE | dmsetup create mydev
> echo $TABLE | dmsetup load mydev
> 
> # should print that It works!
> hexdump -C /dev/mapper/mydev
> 
>>> https://lore.kernel.org/linux-integrity/1604419306-26105-1-git-send-email-sumit.garg@linaro.org/
>>
>> Also, I would hold merging *this* patch up until we are able to
>> test TEE trusted keys with TEE trusted keys.
> 
> Which blocks which? I tested this with TPM-Trusted keys, so it's usable
> as is. For convenient usage, it would be nice to have cryptsetup
> support for trusted and encrypted keys. I intended to look at this next week.
> 
> Cheers,
> Ahmad
> 
>>
>> /Jarkko
>>
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


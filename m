Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE0E8C433EF
	for <dm-devel@archiver.kernel.org>; Mon, 21 Feb 2022 17:17:37 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-561-mAmJierHOVqIlRFAB9RVrA-1; Mon, 21 Feb 2022 12:17:33 -0500
X-MC-Unique: mAmJierHOVqIlRFAB9RVrA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7B888814246;
	Mon, 21 Feb 2022 17:17:28 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 28FE384A3A;
	Mon, 21 Feb 2022 17:17:28 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9DD0D4A7C8;
	Mon, 21 Feb 2022 17:17:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
	[10.11.54.8])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21LHHPDA005179 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 21 Feb 2022 12:17:25 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 97F44C0809D; Mon, 21 Feb 2022 17:17:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 93C63C0809B
	for <dm-devel@redhat.com>; Mon, 21 Feb 2022 17:17:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7A49885A5BC
	for <dm-devel@redhat.com>; Mon, 21 Feb 2022 17:17:25 +0000 (UTC)
Received: from box.fidei.email (box.fidei.email [71.19.144.250]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-92-NL_BvjpdO0C9WweykVAv4A-1; Mon, 21 Feb 2022 12:17:23 -0500
X-MC-Unique: NL_BvjpdO0C9WweykVAv4A-1
Received: from authenticated-user (box.fidei.email [71.19.144.250])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	by box.fidei.email (Postfix) with ESMTPSA id A0BA5803AC
	for <dm-devel@redhat.com>; Mon, 21 Feb 2022 12:10:10 -0500 (EST)
Message-ID: <535b50f2-45a3-1900-48ad-ba68caa05b92@dorminy.me>
Date: Mon, 21 Feb 2022 12:10:09 -0500
MIME-Version: 1.0
To: dm-devel@redhat.com
References: <AM9PR04MB811322427E328C435FE9489FED3A9@AM9PR04MB8113.eurprd04.prod.outlook.com>
	<YhPBAc9tnJ1iuPbM@redhat.com>
From: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
In-Reply-To: <YhPBAc9tnJ1iuPbM@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-loop: dm-devel@redhat.com
Subject: Re: [dm-devel] a potential issue for bow_target after "dm: delay
 registering the gendisk" applied
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"


On 2/21/22 11:42, Mike Snitzer wrote:
> On Mon, Feb 21 2022 at  5:36P -0500,
> Faqiang Zhu <faqiang.zhu@nxp.com> wrote:
>
>> Hi Christoph,
>>
>>   
>>
>> Recently when I use kernel5.15 with android, an issue related to bow_target
>> is found with below log:
>>
>>   
>>
>> [    8.935429][    T1] kobject_add_internal failed for bow (error: -2
>> parent: (null))
>>
>>   
>>
>> The call trace to the preceding log is as below:
>>
>> dm_ctl_ioctl
>>
>>   -> ctl_ioctl
>>
>>     -> lookup_ioctl    // returns the table_load function pointer
>>
>>        table_load
>>
>>          -> populate_table
>>
>>               -> dm_table_add_target
>>
>>                    -> dm_bow_ctr
>>
>>                         -> kobject_init_and_add
>>
>>                              -> kobject_add_varg
>>
>>                                   -> kobject_add_internal
>>
>>   
>>
>>   
>>
>> Compared to kernel5.10, then I found it's related to below patch. The
>> gendisk, it's not registered yet, its kobject is not in sysfs, so its child
>> "bow" kobject cannot be added to the kernel.
>>
>> commit 89f871af1b26d98d983cba7ed0e86effa45ba5f8
>>
>> Author: Christoph Hellwig  <mailto:hch@lst.de> hch@lst.de
>>
>> Date:   Wed Aug 4 11:41:46 2021 +0200
>>
>>   
>>
>>      dm: delay registering the gendisk
>>
>>   
>>
>>   
>>
>> Is this an issue? if it is, is there any patch to fix it? if it is not, then
>> what is the right way to use the bow_target in userspace?
>>
> It is an issue for this out-of-tree dm-bow target.  Likely needs to be
> fixed by adding a new DM target operation to 'struct target_type' that
> would get called by DM core at end of dm_setup_md_queue().


Might also be able to just move the sysfs initialization to first 
preresume time, as the out-of-tree module VDO does? 
https://github.com/dm-vdo/kvdo/commit/27bf63255af9e01736ca657df2fa1a03dcf124b8 


Sweet Tea

>
> Or dm-bow discontinues using sysfs for whatever and convert to using
> DM messages (with .message) and exposing associated state via .status
>
> Mike
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://listman.redhat.com/mailman/listinfo/dm-devel

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


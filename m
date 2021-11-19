Return-Path: <SRS0=IN2R=QG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E4FFC433EF
	for <dm-devel@archiver.kernel.org>; Fri, 19 Nov 2021 08:41:44 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id EF0F361994
	for <dm-devel@archiver.kernel.org>; Fri, 19 Nov 2021 08:41:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org EF0F361994
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-574-deamIOzHPyu8Z0CbI_9Quw-1; Fri, 19 Nov 2021 03:41:39 -0500
X-MC-Unique: deamIOzHPyu8Z0CbI_9Quw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1037987D546;
	Fri, 19 Nov 2021 08:41:34 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C9CEB5D6B1;
	Fri, 19 Nov 2021 08:41:32 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BF6504A703;
	Fri, 19 Nov 2021 08:41:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AJ8fQqB015251 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 19 Nov 2021 03:41:27 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id BE60340CFD12; Fri, 19 Nov 2021 08:41:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B9CB240CFD02
	for <dm-devel@redhat.com>; Fri, 19 Nov 2021 08:41:26 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A1C87181B7A2
	for <dm-devel@redhat.com>; Fri, 19 Nov 2021 08:41:26 +0000 (UTC)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com
	[45.249.212.188]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-506-23o8dRCrMFir5L8FThtGIQ-1; Fri, 19 Nov 2021 03:41:20 -0500
X-MC-Unique: 23o8dRCrMFir5L8FThtGIQ-1
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HwVPb49TbzbhsX;
	Fri, 19 Nov 2021 16:36:19 +0800 (CST)
Received: from kwepemm600010.china.huawei.com (7.193.23.86) by
	dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
	15.1.2308.20; Fri, 19 Nov 2021 16:41:16 +0800
Received: from [10.174.179.176] (10.174.179.176) by
	kwepemm600010.china.huawei.com (7.193.23.86) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
	15.1.2308.15; Fri, 19 Nov 2021 16:41:15 +0800
To: Benjamin Marzinski <bmarzins@redhat.com>
References: <78637f61-851d-cf9d-d308-9c22396d2071@huawei.com>
	<adf675e0-1ed6-f395-e428-548fe145ea64@huawei.com>
	<20211118165727.GH19591@octiron.msp.redhat.com>
From: lixiaokeng <lixiaokeng@huawei.com>
Message-ID: <7d53681e-e828-d789-55d1-bc36b60e69e1@huawei.com>
Date: Fri, 19 Nov 2021 16:41:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20211118165727.GH19591@octiron.msp.redhat.com>
X-Originating-IP: [10.174.179.176]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
	kwepemm600010.china.huawei.com (7.193.23.86)
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-loop: dm-devel@redhat.com
Cc: linfeilong <linfeilong@huawei.com>,
	dm-devel mailing list <dm-devel@redhat.com>,
	Martin Wilck <mwilck@suse.com>, "liuzhiqiang
	\(I\)" <liuzhiqiang26@huawei.com>
Subject: Re: [dm-devel] [PATCH 5/5] add prflag to path
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
Content-Language: en-GB
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On 2021/11/19 0:57, Benjamin Marzinski wrote:
> On Tue, Nov 16, 2021 at 10:01:15PM +0800, lixiaokeng wrote:
>> The update_map will frequently be called and there will be
>> unnecessary checks of reseravtion. We add prflag to path
>> to avoid this.
>>
>> The pp->state changes from others to up or ghost, the
>> mpath_pr_event_handle should be called. The
>> mpath_pr_event_handle in ev_add_path may not be called,
>> so set pp->prkey PRKEY_NO when path is removed.
> 
> This patch kind of confuses me.  You only check pp->prkey before calling
> mpath_pr_event_handle() in update_map(). I get from your commit message
> that you are doing this to keep from frequent, unnecessary calls. But
> isn't update_map() only called when a multipath device is first created,
> or when multipathd stops waiting for something that it noticed during
> device creation? I don't see how this can be frequently called on a
> multipath device. What am I missing?
> 
> -Ben
> 

Discussed in the previous patch (multipathd: fix missing persistent
reseravtion for active path) as follows:

On Mon, 2021-09-13 at 10:32 -0500, Benjamin Marzinski wrote:
> On Mon, Sep 13, 2021 at 09:01:11AM +0200, Martin Wilck wrote:
>> Hello lixiaokeng,
>>
>> On Mon, 2021-09-13 at 10:43 +0800, lixiaokeng wrote:
>>> There are two paths(sucu as sda and adb) for one LUN. The two
>>> paths log in, but before the two uevents have been processed
>>> (for example there are many uevent), users use multipathd add
>>> path /dev/sda to cause mpatha and use mpathpersist -o -I to
>>> register prkey for mpatha. The add map uevent is after add path
>>> uevent, the the uevent(add sdb) will delay and missing persistent
>>> reseravtion check.
>>>
>>> Here, we add persistent reseravtion check in update_map() which
>>> is called ev_add_map().
>>>
>>> Signed-off-by: Lixiaokeng <lixiaokeng@huawei.com>
>>
>> Thank you, this looks ok to me. Have you tested it?
>>
>> I'll wait for Ben's opinion nonetheless, because he's more
>> exprerienced
>> with this part of the code than myself.
>>
>> This said, I would like to have multipathd record which paths have
>> already registered the key, to avoid doing that repeatedly.
>>
> Other than adding this, the patch looks fine.

There may be some mistakes. I mistakenly thought update_map would
be called multiple times

In check_path, mpath_pr_event_handle is only called pp->state
changes from others to up. Some prkey changes may happen when
pp->state is down, so mpath_pr_event_handle should be called
even pp->prkey is PRKEY_OK.

As Ben said, update_map will not be called repetitively. I think
this patch should be removed.

Thank Ben and Martin.

Regards,
Lixiaokeng

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


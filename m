Return-Path: <SRS0=naIC=OE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B243EC433F5
	for <dm-devel@archiver.kernel.org>; Tue, 14 Sep 2021 07:56:44 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0C67461283
	for <dm-devel@archiver.kernel.org>; Tue, 14 Sep 2021 07:56:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0C67461283
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-509-LGR7Ma1tNO-4DM9s4TAyxA-1; Tue, 14 Sep 2021 03:56:41 -0400
X-MC-Unique: LGR7Ma1tNO-4DM9s4TAyxA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C680C1006AA1;
	Tue, 14 Sep 2021 07:56:34 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E9AF85C25A;
	Tue, 14 Sep 2021 07:56:33 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 10CF71800B9E;
	Tue, 14 Sep 2021 07:56:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18E7uRfT009962 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 14 Sep 2021 03:56:28 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id CA260AEC8B; Tue, 14 Sep 2021 07:56:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C4393AEC8E
	for <dm-devel@redhat.com>; Tue, 14 Sep 2021 07:56:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D41B718812C7
	for <dm-devel@redhat.com>; Tue, 14 Sep 2021 07:56:23 +0000 (UTC)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com
	[45.249.212.188]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-306-yCneG3f9N3KqXqt2o8n5og-1; Tue, 14 Sep 2021 03:56:19 -0400
X-MC-Unique: yCneG3f9N3KqXqt2o8n5og-1
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4H7wXk2Tk9z8yVq;
	Tue, 14 Sep 2021 15:51:50 +0800 (CST)
Received: from dggema759-chm.china.huawei.com (10.1.198.201) by
	dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
	15.1.2308.8; Tue, 14 Sep 2021 15:56:15 +0800
Received: from [10.174.179.176] (10.174.179.176) by
	dggema759-chm.china.huawei.com (10.1.198.201) with Microsoft SMTP
	Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
	15.1.2308.8; Tue, 14 Sep 2021 15:56:15 +0800
To: Martin Wilck <mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>
References: <c0ee4284-c2af-e7d4-29c0-fc800a8d2c94@huawei.com>
	<d8fa8e17f4ec92eba1e51c1054283688b294c9f0.camel@suse.com>
	<20210913153239.GL3087@octiron.msp.redhat.com>
	<75acb52e2c012812a5b3145992281aa6f0aead24.camel@suse.com>
From: lixiaokeng <lixiaokeng@huawei.com>
Message-ID: <4d6d59a1-3304-4596-b9a2-e6fd551e4703@huawei.com>
Date: Tue, 14 Sep 2021 15:56:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <75acb52e2c012812a5b3145992281aa6f0aead24.camel@suse.com>
X-Originating-IP: [10.174.179.176]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
	dggema759-chm.china.huawei.com (10.1.198.201)
X-CFilter-Loop: Reflected
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
Cc: linfeilong <linfeilong@huawei.com>,
	dm-devel mailing list <dm-devel@redhat.com>,
	"liuzhiqiang \(I\)" <liuzhiqiang26@huawei.com>
Subject: Re: [dm-devel] [PATCH v2] multipathd: fix missing persistent
 reseravtion for active path
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-GB
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On 2021/9/14 0:32, Martin Wilck wrote:
> On Mon, 2021-09-13 at 10:32 -0500, Benjamin Marzinski wrote:
>> On Mon, Sep 13, 2021 at 09:01:11AM +0200, Martin Wilck wrote:
>>> Hello lixiaokeng,
>>>
>>> On Mon, 2021-09-13 at 10:43 +0800, lixiaokeng wrote:
>>>> There are two paths(sucu as sda and adb) for one LUN. The two
>>>> paths log in, but before the two uevents have been processed
>>>> (for example there are many uevent), users use multipathd add
>>>> path /dev/sda to cause mpatha and use mpathpersist -o -I to
>>>> register prkey for mpatha. The add map uevent is after add path
>>>> uevent, the the uevent(add sdb) will delay and missing persistent
>>>> reseravtion check.
>>>>
>>>> Here, we add persistent reseravtion check in update_map() which
>>>> is called ev_add_map().
>>>>
>>>> Signed-off-by: Lixiaokeng <lixiaokeng@huawei.com>
>>>
>>> Thank you, this looks ok to me. Have you tested it?
>>>
>>> I'll wait for Ben's opinion nonetheless, because he's more
>>> exprerienced
>>> with this part of the code than myself.
>>>
>>> This said, I would like to have multipathd record which paths have
>>> already registered the key, to avoid doing that repeatedly.
>>>
>> Other than adding this, the patch looks fine.
> 
> I would say we can take the patch, then. We can add the record-keeping
> later, I suppose it needs some deeper considerations. I wouldn't be
> against lixiaokeng giving it a shot ;-)
> 

Hello Martin,

Thanks for your trust. I will try to do it. But as you said, it needs some
deeper considerations and may take some time. If you have good solution
for it firstly, please fix it.

Regards
Lixiaokeng

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


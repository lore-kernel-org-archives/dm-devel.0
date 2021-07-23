Return-Path: <SRS0=GHLL=MP=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F403C4338F
	for <dm-devel@archiver.kernel.org>; Fri, 23 Jul 2021 06:28:25 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 13A9F60E0C
	for <dm-devel@archiver.kernel.org>; Fri, 23 Jul 2021 06:28:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 13A9F60E0C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-466-LJ8L64BbMZ-7doUXDt4zcw-1; Fri, 23 Jul 2021 02:28:22 -0400
X-MC-Unique: LJ8L64BbMZ-7doUXDt4zcw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B55DA801AE3;
	Fri, 23 Jul 2021 06:28:17 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0D66818432;
	Fri, 23 Jul 2021 06:28:16 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7407B180B7A2;
	Fri, 23 Jul 2021 06:28:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 16N6SBng003383 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 23 Jul 2021 02:28:11 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 3B7701182E9; Fri, 23 Jul 2021 06:28:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 34B7C1182F3
	for <dm-devel@redhat.com>; Fri, 23 Jul 2021 06:28:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B56191064FAE
	for <dm-devel@redhat.com>; Fri, 23 Jul 2021 06:28:07 +0000 (UTC)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com
	[45.249.212.187]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-515-fW29q6BoO-yDWtiqRYR4bA-1; Fri, 23 Jul 2021 02:28:03 -0400
X-MC-Unique: fW29q6BoO-yDWtiqRYR4bA-1
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GWK6W2m6QzZrsT;
	Fri, 23 Jul 2021 14:24:35 +0800 (CST)
Received: from dggema759-chm.china.huawei.com (10.1.198.201) by
	dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
	15.1.2176.2; Fri, 23 Jul 2021 14:27:59 +0800
Received: from [10.174.177.108] (10.174.177.108) by
	dggema759-chm.china.huawei.com (10.1.198.201) with Microsoft SMTP
	Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
	15.1.2176.2; Fri, 23 Jul 2021 14:27:58 +0800
To: Benjamin Marzinski <bmarzins@redhat.com>
References: <37767722-8e6c-4176-d234-87134c21cd4c@huawei.com>
	<20210722214253.GC3087@octiron.msp.redhat.com>
From: lixiaokeng <lixiaokeng@huawei.com>
Message-ID: <85cb30a7-a873-b33d-4105-6e3e9675f105@huawei.com>
Date: Fri, 23 Jul 2021 14:27:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210722214253.GC3087@octiron.msp.redhat.com>
X-Originating-IP: [10.174.177.108]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
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
	Martin Wilck <mwilck@suse.com>,
	"liuzhiqiang \(I\)" <liuzhiqiang26@huawei.com>
Subject: Re: [dm-devel] [Question] multipathd.service start failed when
 /var/run isn't mount
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



On 2021/7/23 5:42, Benjamin Marzinski wrote:
> On Thu, Jul 22, 2021 at 10:51:22AM +0800, lixiaokeng wrote:
>> When we enable multipathd.service with systemctl and reboot,
>> multipathd doesn't start and log "failed to create pidfile".
>>
>> The reason is following:
>>
>> The RUN is /var/run in multipath-tools. When we start linux, we
>> mount a disk to /var. So if multipathd.service start before mount,
>> it will fail to activate.(If mount firstly, multipathd will start
>> successfully)
>>
>> The RUN is defined in Makefile.inc:
>>
>> ifndef RUN
>>         ifeq ($(shell test -L /var/run -o ! -d /var/run && echo 1),1)
>>                 RUN=run
>>         else
>>                 RUN=var/run
>>         endif
>> endif
>>
>> Can it always be defined as run?
> 
> I believe all modern distributions make /var/run a symlink to /run.
> However, if that's the case, then I don't understand why you are running
> into this issue at all, since multipath should be using /run. What
> multipath packages are you using?
Yes, there is a symlink to /run in /var. But it is in the disk (such as
sdb) mounted on /var actually. When reboot, systemd start multipathd
service firstly then mount sdb to /var. In this way, the multipath
service will not start.

After sdb mounted to /var, we can start multipathd service successfully.

> 
> -Ben
> 
>>
>> Regards,
>> Lixiaokeng
> 
> .
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


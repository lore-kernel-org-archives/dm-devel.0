Return-Path: <SRS0=gpIH=ND=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA195C4338F
	for <dm-devel@archiver.kernel.org>; Thu, 12 Aug 2021 12:52:53 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2D49A6109D
	for <dm-devel@archiver.kernel.org>; Thu, 12 Aug 2021 12:52:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2D49A6109D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-103-wzLCdhtQNPWjheoYwKwlQw-1; Thu, 12 Aug 2021 08:52:49 -0400
X-MC-Unique: wzLCdhtQNPWjheoYwKwlQw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 000CD1091447;
	Thu, 12 Aug 2021 12:52:19 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9CF586EA14;
	Thu, 12 Aug 2021 12:52:17 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 60CEF4BB7C;
	Thu, 12 Aug 2021 12:52:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17CCgUGC027777 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 12 Aug 2021 08:42:30 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 42791103F268; Thu, 12 Aug 2021 12:42:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3E3CD103F27A
	for <dm-devel@redhat.com>; Thu, 12 Aug 2021 12:42:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 67B25800B28
	for <dm-devel@redhat.com>; Thu, 12 Aug 2021 12:42:27 +0000 (UTC)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com
	[45.249.212.188]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-539-lvNDBMn1PSys052uI4X5nQ-1; Thu, 12 Aug 2021 08:42:23 -0400
X-MC-Unique: lvNDBMn1PSys052uI4X5nQ-1
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GlmSt75FYzcnCy;
	Thu, 12 Aug 2021 20:38:38 +0800 (CST)
Received: from dggema759-chm.china.huawei.com (10.1.198.201) by
	dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
	15.1.2176.2; Thu, 12 Aug 2021 20:42:19 +0800
Received: from [10.174.177.52] (10.174.177.52) by
	dggema759-chm.china.huawei.com (10.1.198.201) with Microsoft SMTP
	Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
	15.1.2176.2; Thu, 12 Aug 2021 20:42:18 +0800
To: Martin Wilck <mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>
References: <37767722-8e6c-4176-d234-87134c21cd4c@huawei.com>
	<20210722214253.GC3087@octiron.msp.redhat.com>
	<85cb30a7-a873-b33d-4105-6e3e9675f105@huawei.com>
	<20210723165603.GE3087@octiron.msp.redhat.com>
	<02cba2a5-3fcf-bca9-d887-f8a3c0300582@huawei.com>
	<20210726162827.GH3087@octiron.msp.redhat.com>
	<65c25c39b00a37f88403d3a32dfdc154c1b8ec3b.camel@suse.com>
From: lixiaokeng <lixiaokeng@huawei.com>
Message-ID: <f6667759-d7df-d4a5-6746-e1c6dea86e73@huawei.com>
Date: Thu, 12 Aug 2021 20:42:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <65c25c39b00a37f88403d3a32dfdc154c1b8ec3b.camel@suse.com>
X-Originating-IP: [10.174.177.52]
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 17CCgUGC027777
X-loop: dm-devel@redhat.com
Cc: linfeilong <linfeilong@huawei.com>,
	dm-devel mailing list <dm-devel@redhat.com>,
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
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable



On 2021/8/12 19:09, Martin Wilck wrote:
> On Mo, 2021-07-26 at 11:28 -0500, Benjamin Marzinski wrote:
>> On Mon, Jul 26, 2021 at 08:22:49PM +0800, lixiaokeng wrote:
>>>
>>>>> After sdb mounted to /var, we can start multipathd service
>>>>> successfully.
>>>>
>>>> But when the binaries were compiled, if /var/run existed and was
>>>> a
>>>> symlink in your build environment, then RUN should equal "run",
>>>> and
>>>> multipath should should be using /run instead of /var/run, right?
>>>>
>>>> This is why I asked what multipath packages are you using.
>>>>
>>> This problem is found in 0.7.7.
>>
>> Sorry. I wasn't very clear with what I was asking for.=A0 Unless I'm
>> missing something here, if multipathd is trying to use /var/run, that
>> means that when the multipathd binary was compiled, it was compiled
>> on a
>> machine where /var/run was not a symlink.=20
>>
>> So, I'm wondering where your multipathd binary got compiled. Are you
>> using a packaged version from a distribution like RHEL, SLES, Fedora,
>> Ubuntu, etc? Did you compile it yourself?
>>
>> When I run multipathd under strace, I can see:
>>
>> openat(AT_FDCWD, "/run/multipathd.pid", O_WRONLY|O_CREAT, 0644) =3D 3
>>
>> The multipathd binary I'm using was compiled on a machine where
>> /var/run
>> is a symlink to /run, so multipathd directly uses /run, instead of
>> using
>> /var/run. I'm assuming that whatever machine your multipathd binary
>> was
>> compiled on, /var/run was a directory. Do you know if that's
>> possible?
>=20
> Ack. Lixiaokeng, can you answer Ben's question?
>=20
> Regards,
> Martin
>=20

Hi Martin, Ben:
I'm sorry for missing reply. The situation is the same as ben said.
The /var/run in compile machine is a directory, but it is a symlink
in using machine.

Thanks Ben's help again.

Regards,
Lixiaokeng


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


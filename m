Return-Path: <SRS0=H596=GL=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4451C433DB
	for <dm-devel@archiver.kernel.org>; Fri,  8 Jan 2021 03:13:36 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9D280208B3
	for <dm-devel@archiver.kernel.org>; Fri,  8 Jan 2021 03:13:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9D280208B3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=chinatelecom.cn
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-489-bVhIJCTSP6WkZyaC5S9Q7A-1; Thu, 07 Jan 2021 22:13:32 -0500
X-MC-Unique: bVhIJCTSP6WkZyaC5S9Q7A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 959EE15720;
	Fri,  8 Jan 2021 03:13:26 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B370A19C66;
	Fri,  8 Jan 2021 03:13:23 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 42FA44BB7B;
	Fri,  8 Jan 2021 03:13:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1083DD8Y002290 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 7 Jan 2021 22:13:16 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B8EF694655; Fri,  8 Jan 2021 03:13:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B3567D7DE2
	for <dm-devel@redhat.com>; Fri,  8 Jan 2021 03:13:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8673B8007D9
	for <dm-devel@redhat.com>; Fri,  8 Jan 2021 03:13:11 +0000 (UTC)
Received: from chinatelecom.cn (prt-mail.chinatelecom.cn [42.123.76.220]) by
	relay.mimecast.com with ESMTP id us-mta-403-Yz3rWMF8OH6P8VnJhyyORA-1;
	Thu, 07 Jan 2021 22:13:08 -0500
X-MC-Unique: Yz3rWMF8OH6P8VnJhyyORA-1
HMM_SOURCE_IP: 172.18.0.48:2526.610695259
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-202.80.192.21?logid-0753db9c0e6e467a995a2978d078436c
	(unknown [172.18.0.48])
	by chinatelecom.cn (HERMES) with SMTP id 72D0B28009D;
	Fri,  8 Jan 2021 11:13:03 +0800 (CST)
X-189-SAVE-TO-SEND: wucy11@chinatelecom.cn
Received: from  ([172.18.0.48])
	by App0024 with ESMTP id 0753db9c0e6e467a995a2978d078436c for
	zhangzijian@chinatelecom.cn; Fri Jan  8 11:13:05 2021
X-Transaction-ID: 0753db9c0e6e467a995a2978d078436c
X-filter-score: filter<0>
X-Real-From: wucy11@chinatelecom.cn
X-Receive-IP: 172.18.0.48
X-MEDUSA-Status: 0
To: Martin Wilck <mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>, 
	"dm-devel@redhat.com" <dm-devel@redhat.com>
References: <4ca7da32-5777-9089-1e96-a5dbb46c585a@chinatelecom.cn>
	<4c7286abbdd79fc0c726fd119fdda3b7a140e056.camel@suse.com>
	<ffb39ebe-ab7e-f82a-f4cb-5b8353bfda2a@chinatelecom.cn>
	<bdeb04efcac09880451505ca2970c6d322c48da5.camel@suse.com>
From: Chongyun Wu <wucy11@chinatelecom.cn>
Message-ID: <13b96493-5e48-8c56-9e56-b5d42f4a3b07@chinatelecom.cn>
Date: Fri, 8 Jan 2021 11:13:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
	Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <bdeb04efcac09880451505ca2970c6d322c48da5.camel@suse.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1083DD8Y002290
X-loop: dm-devel@redhat.com
Cc: yubin1@chinatelecom.cn, zhangzijian@chinatelecom.cn
Subject: Re: [dm-devel] [PATCH] multipathd: LUN protection by checking
 path's wwid change status
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-15"; Format="flowed"

Thanks Martin, I will try to reproduce this issue with the latest version w=
hen=20
the enviroments ready, if reproduce it again I will let you know, thanks ag=
ain~

On 2021/1/7 19:27, Martin Wilck wrote:
> On Thu, 2021-01-07 at 10:23 +0800, Chongyun Wu wrote:
>> Hello Martin,
>> Thanks for view this patch.
>>
>> On 2021/1/7 5:10, Martin Wilck wrote:
>>> Hello Chongyun,
>>>
>>> On Mon, 2020-12-28 at 11:34 +0800, Chongyun Wu wrote:
>>>>  =A0=A0From 37c74873acfc1587e79a6504ca3d42b8fa00d49e Mon Sep 17
>>>> 00:00:00
>>>> 2001
>>>>
>>>> From: Chongyun Wu <wucy11@chinatelecom.cn>
>>>> Date: Mon, 21 Dec 2020 09:51:20 +0800
>>>> Subject: [PATCH] multipathd: LUN data protection by checking
>>>> path's
>>>> wwid
>>>>  =A0=A0=A0change status
>>>>
>>>> Issue description:
>>>> A) Device sda and sdb correspend to LUN1 and LUN2 in storage
>>>> backend
>>>> and
>>>> the upper layer application uses those two devices.
>>>> B) Doing illegal operation: unmapping LUN1 and LUN2 in storage
>>>> backend,
>>>> and export LUN2 and LUN1 to host with exchanged assignment
>>>> relation
>>>> between sda and sdb.
>>>> C) The upper layer application run for a while and found that the
>>>> data
>>>> in both LUN1 and LUN2 has been corrupted.
>>>
>>> Can you please be explicit about which multipath-tools version you
>>> have
>>> tested? I thought we had the wwid change issues covered. Ben and I
>>> have
>>> been putting quite some effort into this recently. Of course we can
>>> be
>>> wrong, but I'd like to understand the issue fully.
>>>
>> The test version is 0.8.3.
>=20
> A test with 0.8.5 would be in necessary, then. The INIT_REMOVED logic
> has been added after 0.8.4.
>>>
>>> Please confirm that you've been using the latest version from
>>> Christophe's repo (or better even, from my upstream-queue), and
>>> provide
>>> -v3 logs showing what goes wrong.
>> Sorry Martin, I haven't save the logs and the enviroment is
>> unavailable now.
>=20
> Well, please report back if you can reproduce the issue with current
> upstream.
>=20
> Regards,
> Martin
>=20
>=20

--=20
Best Regard,
Chongyun Wu


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


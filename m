Return-Path: <SRS0=gpIH=ND=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEF5AC4338F
	for <dm-devel@archiver.kernel.org>; Thu, 12 Aug 2021 12:53:13 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 26AA461059
	for <dm-devel@archiver.kernel.org>; Thu, 12 Aug 2021 12:53:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 26AA461059
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-125-xdve-75UMy2vCCJMzlVcEQ-1; Thu, 12 Aug 2021 08:53:10 -0400
X-MC-Unique: xdve-75UMy2vCCJMzlVcEQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 461DB100830A;
	Thu, 12 Aug 2021 12:52:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1F61010013C1;
	Thu, 12 Aug 2021 12:52:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B14B2181A0F0;
	Thu, 12 Aug 2021 12:52:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17CCjHpq027954 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 12 Aug 2021 08:45:18 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id BEDC321602B5; Thu, 12 Aug 2021 12:45:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BA59E2160297
	for <dm-devel@redhat.com>; Thu, 12 Aug 2021 12:45:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A11388D1397
	for <dm-devel@redhat.com>; Thu, 12 Aug 2021 12:45:13 +0000 (UTC)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com
	[45.249.212.188]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-20-DPLk_KqKNZaaHpH9j3yW7g-1; Thu, 12 Aug 2021 08:45:09 -0400
X-MC-Unique: DPLk_KqKNZaaHpH9j3yW7g-1
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GlmX53bcPzcnCW;
	Thu, 12 Aug 2021 20:41:25 +0800 (CST)
Received: from dggema759-chm.china.huawei.com (10.1.198.201) by
	dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
	15.1.2176.2; Thu, 12 Aug 2021 20:45:05 +0800
Received: from [10.174.177.52] (10.174.177.52) by
	dggema759-chm.china.huawei.com (10.1.198.201) with Microsoft SMTP
	Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
	15.1.2176.2; Thu, 12 Aug 2021 20:45:05 +0800
To: Martin Wilck <mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>, 
	Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel mailing list
	<dm-devel@redhat.com>
References: <30798fdf-a112-ff8c-73ac-a37a87b99bd0@huawei.com>
	<04731456fed935e1167d1f48febf2a21df8cb586.camel@suse.com>
From: lixiaokeng <lixiaokeng@huawei.com>
Message-ID: <a4fa2732-3acd-fe63-feed-c452b96cabb9@huawei.com>
Date: Thu, 12 Aug 2021 20:45:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <04731456fed935e1167d1f48febf2a21df8cb586.camel@suse.com>
X-Originating-IP: [10.174.177.52]
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 17CCjHpq027954
X-loop: dm-devel@redhat.com
Cc: linfeilong <linfeilong@huawei.com>,
	"liuzhiqiang \(I\)" <liuzhiqiang26@huawei.com>
Subject: Re: [dm-devel] [PATCH] libmultipath: fix compile error with
	glibc-2.34+
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
Content-Language: en-GB
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable



On 2021/8/12 19:17, Martin Wilck wrote:
> Hello Lixiaokeng,
>=20
> On Mi, 2021-08-11 at 21:11 +0800, lixiaokeng wrote:
>> There is an error when complie with glibc-2.34:
>> comparison of integer expressions of different signedness:
>> 'size_t' {aka 'long unsigned int'} and 'long int'
>> [-Werror=3Dsign-compare]
>>
>> The reason is that PTHREAD_STACK_MIN may be defined
>> long int which is=A0 signed in glibc-2.34+. Explicitly assign
>> it to the size_t variable to=A0 fix it.
>>
>> Signed-off-by: Lixiaokeng <lixiaokeng@huawei.com>
>> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
>=20
> Thanks! Ben had already submitted a patch for this in
> https://listman.redhat.com/archives/dm-devel/2021-July/msg00159.html.
>=20
> Ben's patch handles the error case (-1) more correctly.
>=20
> Regards
> Martin
>=20
>=20

Thanks for reply, I will using Ben's patch to replace my patch.

Regards,
Lixiaokeng


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


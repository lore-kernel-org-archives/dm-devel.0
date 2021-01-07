Return-Path: <SRS0=1Ivj=GK=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C760C433DB
	for <dm-devel@archiver.kernel.org>; Thu,  7 Jan 2021 02:24:23 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5A9B9230FC
	for <dm-devel@archiver.kernel.org>; Thu,  7 Jan 2021 02:24:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5A9B9230FC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=chinatelecom.cn
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-132-LTQCEZpZNpuKBDScEwk6Lw-1; Wed, 06 Jan 2021 21:24:18 -0500
X-MC-Unique: LTQCEZpZNpuKBDScEwk6Lw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D55C68015A4;
	Thu,  7 Jan 2021 02:24:12 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5A1F160C15;
	Thu,  7 Jan 2021 02:24:11 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A2BDA180954D;
	Thu,  7 Jan 2021 02:24:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1072O4HX018868 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 6 Jan 2021 21:24:05 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B96852166B29; Thu,  7 Jan 2021 02:24:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B40932166B28
	for <dm-devel@redhat.com>; Thu,  7 Jan 2021 02:24:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8038E101A560
	for <dm-devel@redhat.com>; Thu,  7 Jan 2021 02:24:01 +0000 (UTC)
Received: from chinatelecom.cn (prt-mail.chinatelecom.cn [42.123.76.227]) by
	relay.mimecast.com with ESMTP id us-mta-28-5ulk7FXBNQy1orB7YNomlA-1;
	Wed, 06 Jan 2021 21:23:54 -0500
X-MC-Unique: 5ulk7FXBNQy1orB7YNomlA-1
HMM_SOURCE_IP: 172.18.0.92:49891.1241481143
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-202.80.192.21?logid-ef0259e47f9f42e595c84cfa650f6833
	(unknown [172.18.0.92])
	by chinatelecom.cn (HERMES) with SMTP id 0B4DC2800DE;
	Thu,  7 Jan 2021 10:23:48 +0800 (CST)
X-189-SAVE-TO-SEND: wucy11@chinatelecom.cn
Received: from  ([172.18.0.92])
	by App0021 with ESMTP id ef0259e47f9f42e595c84cfa650f6833 for
	zhangzijian@chinatelecom.cn; Thu Jan  7 10:23:50 2021
X-Transaction-ID: ef0259e47f9f42e595c84cfa650f6833
X-filter-score: filter<0>
X-Real-From: wucy11@chinatelecom.cn
X-Receive-IP: 172.18.0.92
X-MEDUSA-Status: 0
To: Martin Wilck <mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>, 
	"dm-devel@redhat.com" <dm-devel@redhat.com>
References: <4ca7da32-5777-9089-1e96-a5dbb46c585a@chinatelecom.cn>
	<4c7286abbdd79fc0c726fd119fdda3b7a140e056.camel@suse.com>
From: Chongyun Wu <wucy11@chinatelecom.cn>
Message-ID: <ffb39ebe-ab7e-f82a-f4cb-5b8353bfda2a@chinatelecom.cn>
Date: Thu, 7 Jan 2021 10:23:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
	Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <4c7286abbdd79fc0c726fd119fdda3b7a140e056.camel@suse.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1072O4HX018868
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-15"; Format="flowed"

Hello Martin,
Thanks for view this patch.

On 2021/1/7 5:10, Martin Wilck wrote:
> Hello Chongyun,
>=20
> On Mon, 2020-12-28 at 11:34 +0800, Chongyun Wu wrote:
>>  =A0From 37c74873acfc1587e79a6504ca3d42b8fa00d49e Mon Sep 17 00:00:00
>> 2001
>>
>> From: Chongyun Wu <wucy11@chinatelecom.cn>
>> Date: Mon, 21 Dec 2020 09:51:20 +0800
>> Subject: [PATCH] multipathd: LUN data protection by checking path's
>> wwid
>>  =A0=A0change status
>>
>> Issue description:
>> A) Device sda and sdb correspend to LUN1 and LUN2 in storage backend
>> and
>> the upper layer application uses those two devices.
>> B) Doing illegal operation: unmapping LUN1 and LUN2 in storage
>> backend,
>> and export LUN2 and LUN1 to host with exchanged assignment relation
>> between sda and sdb.
>> C) The upper layer application run for a while and found that the
>> data
>> in both LUN1 and LUN2 has been corrupted.
>=20
> Can you please be explicit about which multipath-tools version you have
> tested? I thought we had the wwid change issues covered. Ben and I have
> been putting quite some effort into this recently. Of course we can be
> wrong, but I'd like to understand the issue fully.
>=20
The test version is 0.8.3.

> In particular, I wonder what happens if when "unmapping LUN1 and LUN2
> in storage". I would expect that this would cause "remove" uevents, and
> multipathd would set these devices in INIT_REMOVED state. That should
> make multipathd realize that the path WWID changed when the path
> reappears.
The issue is caused by wrong opertion in storage backend, it is very easy
to be reproduced by the metioned steps. There are no remove event sometimes
(maybe manual operation have differrent time windows), in this situation th=
e
INIT_REMOVED state prodection might not been involved.

>=20
> Please confirm that you've been using the latest version from
> Christophe's repo (or better even, from my upstream-queue), and provide
> -v3 logs showing what goes wrong.
Sorry Martin, I haven't save the logs and the enviroment is unavailable now=
.
>=20
> Martin
>=20
>=20
>=20

--=20
Best Regard,
Chongyun Wu


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


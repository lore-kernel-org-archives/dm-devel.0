Return-Path: <SRS0=hwRu=LS=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F246C48BDF
	for <dm-devel@archiver.kernel.org>; Thu, 24 Jun 2021 12:31:57 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 98D796054E
	for <dm-devel@archiver.kernel.org>; Thu, 24 Jun 2021 12:31:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 98D796054E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-194-fMkRrCH6MiGVzOdgooipoQ-1; Thu, 24 Jun 2021 08:31:52 -0400
X-MC-Unique: fMkRrCH6MiGVzOdgooipoQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 147648C5EC0;
	Thu, 24 Jun 2021 12:31:47 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EE43060871;
	Thu, 24 Jun 2021 12:31:45 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C2F261809C99;
	Thu, 24 Jun 2021 12:31:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15OCVfAB010012 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 24 Jun 2021 08:31:42 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 92617208AB7A; Thu, 24 Jun 2021 12:31:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 87388208AB91
	for <dm-devel@redhat.com>; Thu, 24 Jun 2021 12:31:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E32D0108C1C2
	for <dm-devel@redhat.com>; Thu, 24 Jun 2021 12:31:38 +0000 (UTC)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com
	[45.249.212.187]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-596-1nKkvNBcMwagWBhESrR8lQ-1; Thu, 24 Jun 2021 08:31:34 -0400
X-MC-Unique: 1nKkvNBcMwagWBhESrR8lQ-1
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G9fWF2JtWzXkjD;
	Thu, 24 Jun 2021 20:26:17 +0800 (CST)
Received: from dggema759-chm.china.huawei.com (10.1.198.201) by
	dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
	15.1.2176.2; Thu, 24 Jun 2021 20:31:29 +0800
Received: from [10.174.179.68] (10.174.179.68) by
	dggema759-chm.china.huawei.com (10.1.198.201) with Microsoft SMTP
	Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
	15.1.2176.2; Thu, 24 Jun 2021 20:31:28 +0800
To: Martin Wilck <mwilck@suse.com>, Christophe Varoqui
	<christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel mailing list <dm-devel@redhat.com>
References: <74753cee-a5c9-7655-2779-baad5786b66a@huawei.com>
	<4f2a3b45c0e9466a69708be7f0f06227dbf695f2.camel@suse.com>
From: lixiaokeng <lixiaokeng@huawei.com>
Message-ID: <a99e097a-2ea0-637c-cd5b-748437f27ac5@huawei.com>
Date: Thu, 24 Jun 2021 20:31:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <4f2a3b45c0e9466a69708be7f0f06227dbf695f2.camel@suse.com>
X-Originating-IP: [10.174.179.68]
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 15OCVfAB010012
X-loop: dm-devel@redhat.com
Cc: linfeilong <linfeilong@huawei.com>,
	"liuzhiqiang \(I\)" <liuzhiqiang26@huawei.com>
Subject: Re: [dm-devel] [PATCH] multipathd: fix no checking persistent
 reservation registration
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
Content-Language: en-GB
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

Hi Martin,

You are right!! This problem was found in 0.7.7. Now I know it
is fixed with commit 9b715bf9 in 0.8.1.
I will use the commit 9b715bf9 to fix it. Thanks for your
review and answer very much.

Regarts
Lixiaokeng

On 2021/6/24 18:19, Martin Wilck wrote:
> On Do, 2021-06-24 at 16:47 +0800, lixiaokeng wrote:
>> If one multipath device has two paths, the first is down (network
>> failure) and the second is up, then we register a prkey to the
>> device. The first path will register successfully but the second
>> won't. Then fix the network. The uev_update_path will race with
>> check_path. If uev_update_path -> pathinfo is called before
>> check_path, the state of the first path will be set PATH_UP
>> without checking persistent reservation registration.
>>
>> Here we add checking in uev_update_path.
>>
>> Signed-off-by: Lixiaokeng <lixiaokeng@huawei.com>
>> ---
>> =A0multipathd/main.c | 14 ++++++++++++++
>> =A01 file changed, 14 insertions(+)
>>
>> diff --git a/multipathd/main.c b/multipathd/main.c
>> index 2251e02c..0948bf81 100644
>> --- a/multipathd/main.c
>> +++ b/multipathd/main.c
>> @@ -1316,6 +1316,7 @@ uev_update_path (struct uevent *uev, struct
>> vectors * vecs)
>> =A0=A0=A0=A0=A0=A0=A0=A0struct path * pp;
>> =A0=A0=A0=A0=A0=A0=A0=A0struct config *conf;
>> =A0=A0=A0=A0=A0=A0=A0=A0int needs_reinit =3D 0;
>> +=A0=A0=A0=A0=A0=A0=A0int oldstate;
>>
>> =A0=A0=A0=A0=A0=A0=A0=A0switch ((rc =3D change_foreign(uev->udev))) {
>> =A0=A0=A0=A0=A0=A0=A0=A0case FOREIGN_OK:
>> @@ -1366,9 +1367,22 @@ uev_update_path (struct uevent *uev, struct
>> vectors * vecs)
>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
pp->udev =3D udev_device_ref(uev->udev);
>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
conf =3D get_multipath_config();
>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
pthread_cleanup_push(put_multipath_config,
>> conf);
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ol=
dstate =3D pp->state;
>> +
>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
if (pathinfo(pp, conf, DI_SYSFS|DI_NOIO) !=3D
>> PATHINFO_OK)
>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0condlog(1, "%s: pathinfo failed after
>> change uevent",
>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0uev->kernel);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if=
 (pp->state !=3D oldstate && (pp->state =3D=3D
>> PATH_UP || pp->state =3D=3D PATH_GHOST)) {
>=20
>=20
> I don't understand. pathinfo(DI_SYSFS|DI_NOIO) doesn't modify=20
> pp->state.  So your first condition should always be false.
> Am I overlooking something?
>=20
> Regards
> Martin
>=20
>=20
> .
>=20


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


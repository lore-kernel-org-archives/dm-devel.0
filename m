Return-Path: <SRS0=gcKN=OB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 070D9C433EF
	for <dm-devel@archiver.kernel.org>; Sat, 11 Sep 2021 03:28:29 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8A5DF611BD
	for <dm-devel@archiver.kernel.org>; Sat, 11 Sep 2021 03:28:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8A5DF611BD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-334--ujS7knVNxugFil1SJtcAg-1; Fri, 10 Sep 2021 23:28:26 -0400
X-MC-Unique: -ujS7knVNxugFil1SJtcAg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3490B814244;
	Sat, 11 Sep 2021 03:28:20 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E758218428;
	Sat, 11 Sep 2021 03:28:17 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 09BA84E58E;
	Sat, 11 Sep 2021 03:28:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18B3SBiH023610 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 10 Sep 2021 23:28:12 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id C355E20614C1; Sat, 11 Sep 2021 03:28:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BE3B821686A5
	for <dm-devel@redhat.com>; Sat, 11 Sep 2021 03:28:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 09A8D185A7A4
	for <dm-devel@redhat.com>; Sat, 11 Sep 2021 03:28:09 +0000 (UTC)
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com
	[45.249.212.255]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-457-yKXC2a0bOta5VnhDyeTnbg-1; Fri, 10 Sep 2021 23:28:04 -0400
X-MC-Unique: yKXC2a0bOta5VnhDyeTnbg-1
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4H5ypf2GbZz1DGlL;
	Sat, 11 Sep 2021 11:27:06 +0800 (CST)
Received: from dggema759-chm.china.huawei.com (10.1.198.201) by
	dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
	15.1.2308.8; Sat, 11 Sep 2021 11:28:01 +0800
Received: from [10.174.177.129] (10.174.177.129) by
	dggema759-chm.china.huawei.com (10.1.198.201) with Microsoft SMTP
	Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
	15.1.2308.8; Sat, 11 Sep 2021 11:28:00 +0800
To: Martin Wilck <mwilck@suse.com>, Christophe Varoqui
	<christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel mailing list <dm-devel@redhat.com>
References: <298ae89f-6d47-546d-a87e-42e6563a17f2@huawei.com>
	<421bf852fdf9298bb5c0fd41e53adc1bff4e4050.camel@suse.com>
From: lixiaokeng <lixiaokeng@huawei.com>
Message-ID: <49a7d28b-697f-c862-1642-eac02adbaf42@huawei.com>
Date: Sat, 11 Sep 2021 11:28:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <421bf852fdf9298bb5c0fd41e53adc1bff4e4050.camel@suse.com>
X-Originating-IP: [10.174.177.129]
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 18B3SBiH023610
X-loop: dm-devel@redhat.com
Cc: linfeilong <linfeilong@huawei.com>,
	"liuzhiqiang \(I\)" <liuzhiqiang26@huawei.com>
Subject: Re: [dm-devel] [PATCH] multipathd: fix missing persistent
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-GB
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable



On 2021/9/11 0:17, Martin Wilck wrote:
> Hello lixiaokeng,
>=20
> thanks for your patch.
>=20
> On Fri, 2021-09-10 at 20:31 +0800, lixiaokeng wrote:
>> There are two paths(sucu as sda and adb) for one LUN. The two
>> paths log in, but before the two uevents have been processed
>> (for example there are many uevent), users use multipathd add
>> path /dev/sda to cause mpatha and use mpathpersist -o -I to
>> register prkey for mpatha. The add map uevent is after add path
>> uevent, the the uevent(add sdb) will delay and missing persistent
>> reseravtion check.
>>
>> Here, we add persistent reseravtion check in ev_add_map if
>> mpp->wait_for_udev > 1.
>>
>> Signed-off-by: Lixiaokeng <lixiaokeng@huawei.com>
>> ---
>> =A0multipathd/main.c | 9 +++++++++
>> =A01 file changed, 9 insertions(+)
>>
>> diff --git a/multipathd/main.c b/multipathd/main.c
>> index 3aff241d..ef456c34 100644
>> --- a/multipathd/main.c
>> +++ b/multipathd/main.c
>> @@ -706,6 +706,8 @@ ev_add_map (char * dev, const char * alias,
>> struct vectors * vecs)
>> =A0=A0=A0=A0=A0=A0=A0=A0struct multipath * mpp;
>> =A0=A0=A0=A0=A0=A0=A0=A0int delayed_reconfig, reassign_maps;
>> =A0=A0=A0=A0=A0=A0=A0=A0struct config *conf;
>> +=A0=A0=A0=A0=A0=A0=A0struct path *pp;
>> +=A0=A0=A0=A0=A0=A0=A0int i;
>>
>> =A0=A0=A0=A0=A0=A0=A0=A0if (dm_is_mpath(alias) !=3D 1) {
>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(4, "%s: not a mu=
ltipath map", alias);
>> @@ -721,6 +723,13 @@ ev_add_map (char * dev, const char * alias,
>> struct vectors * vecs)
>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
if (update_map(mpp, vecs, 0))
>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0/* setup multipathd removed the map
>> */
>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0return 1;
>=20
> Should you make this conditional on mpp->prflag, perhaps?
> After all, sda has already been added, sp prflag should should be set
> if that was successful.
>=20
Hi Martin:

Thanks for your reply. I will add conditional on mpp->prflag.

> I think this should rather be added to update_map(). Ben?

I have considered putting it after adopt_paths() in update_map().
But I'm not sure which one is better. If you and Ben think adding
to update_map() is better, I will move it to there.

Here is anotherthing. If two new paths(sdc) for maptha
(with sda sdb path) log in. mpathpersist -o -I for mpatha, the
sda and sdb will be registered. Before update_prflag() and
update_prkey() in do_mpath_persistent_reserve_out, the uevent
(add sdc) is finshed, then sdc will missing registering.

This is just my theoretical analysis. I'm not sure if this is
a real problem.

>=20
>=20
>> +
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ve=
ctor_foreach_slot(mpp->paths, pp, i) {
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0if ((pp->state =3D=3D PATH_UP)=A0 || (pp-
>>> state =3D=3D PATH_GHOST)) {
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* persistent reseravtion
>> check*/
>=20
> Typo above.
>=20
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mpath_pr_event_handle(pp);
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0}
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0conf =3D get_multipath_c=
onfig();
>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0delayed_reconfig =3D con=
f->delayed_reconfig;
>=20
>=20
> Thanks,
> Martin
>=20
> .
>=20


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


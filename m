Return-Path: <SRS0=uUVj=HD=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63A0EC433E0
	for <dm-devel@archiver.kernel.org>; Mon,  1 Feb 2021 14:55:26 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B59DB64DAD
	for <dm-devel@archiver.kernel.org>; Mon,  1 Feb 2021 14:55:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B59DB64DAD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-229-utpJ_42LNN-r3QMz_AOZog-1; Mon, 01 Feb 2021 09:55:19 -0500
X-MC-Unique: utpJ_42LNN-r3QMz_AOZog-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E0A521005D44;
	Mon,  1 Feb 2021 14:55:12 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A3D6C19CB6;
	Mon,  1 Feb 2021 14:55:11 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D55AD1809CA1;
	Mon,  1 Feb 2021 14:55:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 111EofHW003799 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 1 Feb 2021 09:50:41 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 329096D9F4; Mon,  1 Feb 2021 14:50:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2D6237D280
	for <dm-devel@redhat.com>; Mon,  1 Feb 2021 14:50:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D59E91010431
	for <dm-devel@redhat.com>; Mon,  1 Feb 2021 14:50:37 +0000 (UTC)
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-586-0kIyY16fMXelyUauoWMFhQ-1; Mon, 01 Feb 2021 09:50:32 -0500
X-MC-Unique: 0kIyY16fMXelyUauoWMFhQ-1
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4DTrSF5CM0zjGRx;
	Mon,  1 Feb 2021 22:49:17 +0800 (CST)
Received: from [10.174.178.113] (10.174.178.113) by
	DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server
	id 14.3.498.0; Mon, 1 Feb 2021 22:50:09 +0800
To: Martin Wilck <mwilck@suse.com>, Christophe Varoqui
	<christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel mailing list <dm-devel@redhat.com>
References: <d6652b08-2d6c-ac46-9d73-b252bc26f41a@huawei.com>
	<3992c887b6b9a00c4faad17c1d381d2afb4a2e86.camel@suse.com>
	<b9824ac2-7c64-95e0-d352-1aed99eacb12@huawei.com>
	<035279e085cb7e4f53b00755f491103b9c92ba67.camel@suse.com>
From: lixiaokeng <lixiaokeng@huawei.com>
Message-ID: <b7c44c2a-d401-36de-0384-52bd11e812f8@huawei.com>
Date: Mon, 1 Feb 2021 22:50:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <035279e085cb7e4f53b00755f491103b9c92ba67.camel@suse.com>
X-Originating-IP: [10.174.178.113]
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
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 111EofHW003799
X-loop: dm-devel@redhat.com
Cc: linfeilong <linfeilong@huawei.com>
Subject: Re: [dm-devel] libmultipath: fix NULL dereference in get_be64
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-GB
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable


>>
>> cli_add_path
>> =A0=A0 ->ev_add_path
>> =A0=A0=A0=A0=A0 ->add_map_with_path
>> =A0=A0=A0=A0=A0=A0=A0=A0 ->adopt_paths
>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ->pathinfo
>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ->filter_property
>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ->return PATHINFO_SKIPPED,
>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ->pp->mpp is NULL and not be set
>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ->return 0
>=20
> This returns 0, but add_map_with_path() has this code to check whether
> the path passed to it was actually added to the new map:
>=20
> =09if (adopt_paths(vecs->pathvec, mpp) ||
> =09    find_slot(vecs->pathvec, pp) =3D=3D -1)
> =09=09goto out;  -> return NULL
>=20
> So ev_add_path() should have seen a NULL return from
> add_map_with_path(), should not have set start_waiter, and failed.=A0
>=20

I'm sorry for a big mistake in my stack. As the code is optimized, pathinfo
return PATHINFO_SKIPPED after finish filter_property when I use gdb. It
happens acctualy in:
2141=09=09=09if (pp->bus =3D=3D SYSFS_BUS_SCSI &&
2142=09=09=09    pp->sg_id.proto_id =3D=3D SCSI_PROTOCOL_USB &&
2143=09=09=09    !conf->allow_usb_devices) {
2144=09=09=09=09condlog(3, "%s: skip USB device %s", pp->dev,
2145=09=09=09=09=09pp->tgt_node_name);
2146=09=09=09=09return PATHINFO_SKIPPED;
2147=09=09=09}
2148=09=09}

Stack:
cli_add_path
   ->ev_add_path
      ->add_map_with_path
         ->adopt_paths
            ->pathinfo
               ->pp->bus =3D=3D SYSFS_BUS_SCSI
               ->return PATHINFO_SKIPPED,
            ->pp->mpp is NULL and not be set
            ->return 0
      ->mpath_pr_event_handle
         ->get_be64 //pp->mpp is dereference

If you think my patch is ok, I will resend it.

Regards
Lixiaokeng


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


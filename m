Return-Path: <SRS0=XDEt=G7=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64874C433E6
	for <dm-devel@archiver.kernel.org>; Thu, 28 Jan 2021 08:28:31 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id AAD726146D
	for <dm-devel@archiver.kernel.org>; Thu, 28 Jan 2021 08:28:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AAD726146D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-202-T4IMaBNmOJmGbF15ydJH-Q-1; Thu, 28 Jan 2021 03:28:27 -0500
X-MC-Unique: T4IMaBNmOJmGbF15ydJH-Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7ED001842140;
	Thu, 28 Jan 2021 08:28:22 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 034C66F923;
	Thu, 28 Jan 2021 08:28:21 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0143D1809C9F;
	Thu, 28 Jan 2021 08:28:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10S8SFWN014201 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 28 Jan 2021 03:28:15 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 0ECD1EE85C; Thu, 28 Jan 2021 08:28:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 096A9EE84C
	for <dm-devel@redhat.com>; Thu, 28 Jan 2021 08:28:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 95024100B164
	for <dm-devel@redhat.com>; Thu, 28 Jan 2021 08:28:11 +0000 (UTC)
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com
	[45.249.212.190]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-467-xNchLuPHNEKa15X_CWPUWw-1; Thu, 28 Jan 2021 03:28:08 -0500
X-MC-Unique: xNchLuPHNEKa15X_CWPUWw-1
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DRD8P6PfszlBvS;
	Thu, 28 Jan 2021 16:26:29 +0800 (CST)
Received: from [10.174.178.113] (10.174.178.113) by
	DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server
	id 14.3.498.0; Thu, 28 Jan 2021 16:27:52 +0800
To: Martin Wilck <mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>, 
	Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel mailing list
	<dm-devel@redhat.com>
References: <063bbeeb-15aa-f7c0-b881-7526c3a2720c@huawei.com>
	<f86753b17cc7e85e7e0f7e711adec349323a7c5a.camel@suse.com>
	<d8ba8118-ce98-249a-cafd-021f0c1831a5@huawei.com>
	<f1961d4104b14c80183b161a53262e1766e0df70.camel@suse.com>
	<c52487a2-5c15-977c-704b-7cad5f6e275e@huawei.com>
	<cd3cae852bffc2d4a9be2e7f4334eb346cfaae8d.camel@suse.com>
	<ef4f29d8-a20b-2b4d-97ab-a83fb4bca5ac@huawei.com>
	<5440d76a18994a7a214321c30fe8a1e99c0a3988.camel@suse.com>
From: lixiaokeng <lixiaokeng@huawei.com>
Message-ID: <7d64e510-029e-dd4b-9afc-58721a37cf30@huawei.com>
Date: Thu, 28 Jan 2021 16:27:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <5440d76a18994a7a214321c30fe8a1e99c0a3988.camel@suse.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 10S8SFWN014201
X-loop: dm-devel@redhat.com
Cc: linfeilong <linfeilong@huawei.com>,
	"liuzhiqiang \(I\)" <liuzhiqiang26@huawei.com>, lihaotian9@huawei.com
Subject: Re: [dm-devel] [QUESTION]: multipath device with wrong path lead to
	metadata err
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


>=20
>>
>> (1)multipath -r: The sdf is found as a path of
>> 36001405b7679bd96b094bccbf971bc90
>> (iscsi node is 4:0:0:2)
>>

   Here is a log "dm destory name dm-5; majir:minor 253:5; dm-5"
(dm-5 36001405b7679bd96b094bccbf971bc90) in system time
[1202538.163972]. I add this print in dm_destroy.

>> (2)iscsi logout: The sdf is removed in iscsi in system time
>> [1202538.467014].
>>

   I add refcount print in put_disk instead of put_disk_and_module.
The refcount of sdf will be reduced to zero even the fd to /dev/sdf
is opened (there is no "Couldn't open device node for sdf in log)
when 36001405b7679bd96b094bccbf971bc90 is destoried and iscsi
logout.

   I don't know why dm-5 is destoried. I doubt there may be some
issue in the kernel that I add some print. I have test this in
three computers, but the other two have no problem (they have been
runing for 96h and for 48h respectively).

   I will replace the kernel of the computer with this issue and test
it again.

   Do you have any great idea about dm-5 destruction? Thanks.

Regards,
Lixiaokeng



>> (3)iscsi login: The sdf appears in iscsi in system time
>> [1202538.825745].
>> It is a path of 3600140584e11eb1818c4afab12c17800 (iscsi node
>> 2:0:0:0)
>>
>> Here I have a doubt. When I stop in domap using gdb and iscsi log
>> out/in,
>> the sdf will not=A0 be used again becasue the disk refcount is not
>> zero. I
>> add a print if the disk refcount is zero in put_disk_and_module (for
>> example lxk ref put after: name sdi; count 0), but there is not this
>> print
>> about sdf.
>=20
> Yes, this is a very good point, and it's indeed strange. multipathd
> should have opened a file descriptor to /dev/sdf in pathinfo(), and as
> long as that file is open, the use count shouldn't drop to 0, the disk
> devices (block device and scsi_disk device) shouldn't be released, and
> the major/minor number shouldn't be reused. Unless I'm missing
> something essential, that is.


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


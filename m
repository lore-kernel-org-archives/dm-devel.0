Return-Path: <SRS0=nVuD=HH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B262C433DB
	for <dm-devel@archiver.kernel.org>; Fri,  5 Feb 2021 11:49:49 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id F307A64E43
	for <dm-devel@archiver.kernel.org>; Fri,  5 Feb 2021 11:49:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F307A64E43
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-554-A9SvoJuLP2aEyOUMuBXaiA-1; Fri, 05 Feb 2021 06:49:45 -0500
X-MC-Unique: A9SvoJuLP2aEyOUMuBXaiA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C5E9B15721;
	Fri,  5 Feb 2021 11:49:40 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 76F755D6AB;
	Fri,  5 Feb 2021 11:49:40 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 121F018095CB;
	Fri,  5 Feb 2021 11:49:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 115BnaRY027371 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 5 Feb 2021 06:49:37 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 80A51200A4F4; Fri,  5 Feb 2021 11:49:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 72B18200E1F1
	for <dm-devel@redhat.com>; Fri,  5 Feb 2021 11:49:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 10AEC8032E3
	for <dm-devel@redhat.com>; Fri,  5 Feb 2021 11:49:34 +0000 (UTC)
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com
	[45.249.212.190]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-5-pMtGpwxCMTepNU_j8gt6iQ-1; Fri, 05 Feb 2021 06:49:31 -0500
X-MC-Unique: pMtGpwxCMTepNU_j8gt6iQ-1
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DXDDx16KmzlFCf;
	Fri,  5 Feb 2021 19:47:45 +0800 (CST)
Received: from [10.174.178.113] (10.174.178.113) by
	DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server
	id 14.3.498.0; Fri, 5 Feb 2021 19:49:17 +0800
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
	<342183ae-ead1-a13f-9384-459d09c04e6c@huawei.com>
	<d8e5a777991a31200e6aa85870b5b38b586bc765.camel@suse.com>
From: lixiaokeng <lixiaokeng@huawei.com>
Message-ID: <d440352a-eda6-301a-154a-e6de3271a20a@huawei.com>
Date: Fri, 5 Feb 2021 19:49:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <d8e5a777991a31200e6aa85870b5b38b586bc765.camel@suse.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-GB
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Martin,

I have removed multipathd_query in my test script. And a flock is added
before/after reonfigure() and  iscsi login/out.


Sequence of events:

(1)iscsi log out
/dev/sdi(36001405b7679bd96b094bccbf971bc90) is removed.

multipath -r:
sdi->fd is closed.
ref of sdi becomes 0.

(2)iscsi log in
/dev/sdi(3600140531f063b3e19349bc82028e0cc) is added.

(3)multipath -r:
/dev/sdi is discovered but added to 36001405b7679bd96b094bccbf971bc90.

This is very confusing. The reason I can think of is that get_uid() in
pathinfo() gets the wrong wwid.

What do you think of this phenomenon?

Regards,
Lixiaokeng

The kernel log:
84087 Feb  5 16:13:12 client1 kernel: [618082.728130] sd 1:0:0:2: [sdi] Synchronizing SCSI cache

multipath -r (first)
84103 Feb  5 16:13:12 client1 kernel: [618082.992107] lxk kernel params 0 1 alua 1 1 service-time 0 1 1 8:96 1
84104 Feb  5 16:13:12 client1 kernel: [618082.992109] name dm-6; majir:minor 253:6; dm-6

84153 Feb  5 16:13:12 client1 kernel: [618083.244950] sd 2:0:0:1: [sdi] Attached SCSI disk

multipath -r (second)
84200 Feb  5 16:13:12 client1 kernel: [618084.453983] lxk kernel params 0 1 alua 1 1 service-time 0 1 1 8:128 1
84201 Feb  5 16:13:12 client1 kernel: [618084.453985] name dm-6; majir:minor 253:6; dm-6

The userspace log:
multipath -r (first)
 84334 Feb  5 16:13:12 client1 multipathd[3816730]: lock .mul_iscsi.lock
 84335 Feb  5 16:13:12 client1 multipathd[3816730]: 36001405ca5165367d67447ea68108e1d: remove multipath map
 84336 Feb  5 16:13:12 client1 multipathd[3816730]: sdh: orphan path, map flushed
 84337 Feb  5 16:13:12 client1 multipathd[3816730]: BUG: orphaning path sdh that holds hwe of 36001405ca5165367d67447ea68108e1d
 84338 Feb  5 16:13:12 client1 multipathd[3816730]: close sdh pp->fd
 84339 Feb  5 16:13:12 client1 multipathd[3816730]: 3600140531f063b3e19349bc82028e0cc: remove multipath map
 84340 Feb  5 16:13:12 client1 multipathd[3816730]: sdj: orphan path, map flushed
 84341 Feb  5 16:13:12 client1 multipathd[3816730]: BUG: orphaning path sdj that holds hwe of 3600140531f063b3e19349bc82028e0cc
 84342 Feb  5 16:13:12 client1 multipathd[3816730]: close sdj pp->fd
 84343 Feb  5 16:13:12 client1 multipathd[3816730]: 3600140584e11eb1818c4afab12c17800: remove multipath map
 84344 Feb  5 16:13:12 client1 multipathd[3816730]: sde: orphan path, map flushed
 84345 Feb  5 16:13:12 client1 multipathd[3816730]: BUG: orphaning path sde that holds hwe of 3600140584e11eb1818c4afab12c17800
 84346 Feb  5 16:13:12 client1 multipathd[3816730]: close sde pp->fd
 84347 Feb  5 16:13:12 client1 systemd[3714763]: opt-test-3600140584e11eb1818c4afab12c17800.mount: Succeeded.
 84348 Feb  5 16:13:12 client1 multipathd[3816730]: 36001405b7679bd96b094bccbf971bc90: remove multipath map
 84349 Feb  5 16:13:12 client1 systemd[1]: opt-test-3600140584e11eb1818c4afab12c17800.mount: Succeeded.
 84350 Feb  5 16:13:12 client1 multipathd[3816730]: sdi: orphan path, map flushed
 84351 Feb  5 16:13:12 client1 multipathd[3816730]: BUG: orphaning path sdi that holds hwe of 36001405b7679bd96b094bccbf971bc90
 84352 Feb  5 16:13:12 client1 multipathd[3816730]: close sdi pp->fd
 84353 Feb  5 16:13:12 client1 multipathd[3816730]: 8:144: cannot find block device
 84354 Feb  5 16:13:12 client1 multipathd[3816730]: 3600140531f063b3e19349bc82028e0cc: remove multipath map
 84355 Feb  5 16:13:12 client1 multipathd[3816730]: 8:112: cannot find block device
 84356 Feb  5 16:13:12 client1 multipathd[3816730]: 36001405ca5165367d67447ea68108e1d: remove multipath map
 84357 Feb  5 16:13:12 client1 multipathd[3816730]: 8:64: cannot find block device
 84358 Feb  5 16:13:12 client1 multipathd[3816730]: 3600140584e11eb1818c4afab12c17800: remove multipath map
 84359 Feb  5 16:13:12 client1 multipathd[3816730]: 8:128: cannot find block device
 84360 Feb  5 16:13:12 client1 multipathd[3816730]: 36001405b7679bd96b094bccbf971bc90: remove multipath map
 84361 Feb  5 16:13:12 client1 multipathd[3816730]: sda: orphan path, blacklisted
 84362 Feb  5 16:13:12 client1 multipathd[3816730]: sdb: orphan path, blacklisted
 84363 Feb  5 16:13:12 client1 multipathd[3816730]: 3600140584e11eb1818c4afab12c17800: set ACT_CREATE (map does not exist)
 84364 Feb  5 16:13:12 client1 multipathd[3816730]: 3600140584e11eb1818c4afab12c17800: load table [0 20971520 multipath 0 1 alua 1 1 service-time 0 1 1 8:32 1]
 84365 Feb  5 16:13:12 client1 multipathd[3816730]: 36001405b7679bd96b094bccbf971bc90: set ACT_CREATE (map does not exist)
 84366 Feb  5 16:13:12 client1 multipathd[3816730]: 36001405b7679bd96b094bccbf971bc90: load table [0 20971520 multipath 0 1 alua 1 1 service-time 0 1 1 8:96 1]
 84367 Feb  5 16:13:12 client1 multipathd[3816730]: 36001405ca5165367d67447ea68108e1d: set ACT_CREATE (map does not exist)
 84368 Feb  5 16:13:12 client1 iscsid[294822]: Connection61647:0 to [target: iqn.2003-01.org.linux-iscsi.openeuler.aarch64:sn.155b59349631, portal: 100.1.2.1,3260] through [iface: default] is shutdown.
 84369 Feb  5 16:13:12 client1 multipathd[3816730]: 36001405ca5165367d67447ea68108e1d: load table [0 20971520 multipath 0 1 alua 1 1 service-time 0 1 1 8:48 1]
 84370 Feb  5 16:13:12 client1 multipathd[3816730]: lock .mul_iscsi.lock
 84371 Feb  5 16:13:12 client1 multipath[73791]: lock .mul_iscsi.lock

multipath -r (second)
 84439 Feb  5 16:13:12 client1 multipathd[3816730]: reconfigure (operator)
 84440 Feb  5 16:13:12 client1 multipath[73858]: loading /lib64/multipath/libchecktur.so checker
 84441 Feb  5 16:13:12 client1 multipathd[3816730]: lock .mul_iscsi.lock
 84442 Feb  5 16:13:12 client1 multipathd[3816730]: 3600140584e11eb1818c4afab12c17800: remove multipath map
 84443 Feb  5 16:13:12 client1 multipathd[3816730]: sdc: orphan path, map flushed
 84444 Feb  5 16:13:12 client1 multipathd[3816730]: BUG: orphaning path sdc that holds hwe of 3600140584e11eb1818c4afab12c17800
 84445 Feb  5 16:13:12 client1 multipathd[3816730]: close sdc pp->fd
 84446 Feb  5 16:13:12 client1 multipathd[3816730]: 36001405b7679bd96b094bccbf971bc90: remove multipath map
 84447 Feb  5 16:13:12 client1 multipathd[3816730]: sdg: orphan path, map flushed
 84448 Feb  5 16:13:12 client1 multipathd[3816730]: BUG: orphaning path sdg that holds hwe of 36001405b7679bd96b094bccbf971bc90
 84449 Feb  5 16:13:12 client1 multipathd[3816730]: close sdg pp->fd
 84450 Feb  5 16:13:12 client1 multipathd[3816730]: 36001405ca5165367d67447ea68108e1d: remove multipath map
 84451 Feb  5 16:13:12 client1 multipathd[3816730]: sdd: orphan path, map flushed
 84452 Feb  5 16:13:12 client1 multipathd[3816730]: BUG: orphaning path sdd that holds hwe of 36001405ca5165367d67447ea68108e1d
 84453 Feb  5 16:13:12 client1 multipathd[3816730]: close sdd pp->fd
 84454 Feb  5 16:13:12 client1 multipathd[3816730]: 8:144: cannot find block device
 84455 Feb  5 16:13:12 client1 multipathd[3816730]: 3600140531f063b3e19349bc82028e0cc: remove multipath map
 84456 Feb  5 16:13:12 client1 multipathd[3816730]: 8:48: cannot find block device
 84457 Feb  5 16:13:12 client1 multipathd[3816730]: 36001405ca5165367d67447ea68108e1d: remove multipath map
 84458 Feb  5 16:13:12 client1 multipathd[3816730]: 8:32: cannot find block device
 84459 Feb  5 16:13:12 client1 multipathd[3816730]: 3600140584e11eb1818c4afab12c17800: remove multipath map
 84460 Feb  5 16:13:12 client1 multipathd[3816730]: 8:96: cannot find block device
 84461 Feb  5 16:13:12 client1 multipathd[3816730]: 36001405b7679bd96b094bccbf971bc90: remove multipath map
 84462 Feb  5 16:13:12 client1 multipathd[3816730]: sda: orphan path, blacklisted
 84463 Feb  5 16:13:12 client1 multipathd[3816730]: sdb: orphan path, blacklisted
 84464 Feb  5 16:13:12 client1 multipathd[3816730]: 36001405b7679bd96b094bccbf971bc90: set ACT_CREATE (map does not exist)
 84465 Feb  5 16:13:12 client1 multipathd[3816730]: 36001405b7679bd96b094bccbf971bc90: load table [0 20971520 multipath 0 1 alua 1 1 service-time 0 1 1 8:128 1]
 84466 Feb  5 16:13:12 client1 multipathd[3816730]: lock .mul_iscsi.lock


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


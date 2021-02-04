Return-Path: <SRS0=5DIA=HG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A65C1C433E0
	for <dm-devel@archiver.kernel.org>; Thu,  4 Feb 2021 11:19:49 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 05A6364DE1
	for <dm-devel@archiver.kernel.org>; Thu,  4 Feb 2021 11:19:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 05A6364DE1
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-433-xeYZlqO1PUiZ8ljaFfMSBg-1; Thu, 04 Feb 2021 06:19:46 -0500
X-MC-Unique: xeYZlqO1PUiZ8ljaFfMSBg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 57910192D787;
	Thu,  4 Feb 2021 11:19:41 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 12C0D57;
	Thu,  4 Feb 2021 11:19:41 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 17AE3996C;
	Thu,  4 Feb 2021 11:19:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 114BEf7i004973 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 4 Feb 2021 06:14:41 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 5C10F2166B2D; Thu,  4 Feb 2021 11:14:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 530742166B30
	for <dm-devel@redhat.com>; Thu,  4 Feb 2021 11:14:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5E940185A78E
	for <dm-devel@redhat.com>; Thu,  4 Feb 2021 11:14:38 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-356-9I_Iy6WkOEmxdosSWgFu1Q-1;
	Thu, 04 Feb 2021 06:14:33 -0500
X-MC-Unique: 9I_Iy6WkOEmxdosSWgFu1Q-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id E8EE1AF1B;
	Thu,  4 Feb 2021 11:14:31 +0000 (UTC)
Message-ID: <340d3b52273623dafd10bccd5062bb35ba1b283e.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: lixiaokeng <lixiaokeng@huawei.com>, Benjamin Marzinski
	<bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Thu, 04 Feb 2021 12:14:31 +0100
In-Reply-To: <9f76457a-5a15-b6ee-8f92-60e23be07e48@huawei.com>
References: <20210202195744.2384-1-mwilck@suse.com>
	<4c3bb639-b359-85a4-ea76-ba83347acd7c@huawei.com>
	<85a30ad88a76e01600aa0879f727da09debf0c42.camel@suse.com>
	<6bafec0c-91e9-37cd-4c68-18f4175be51c@huawei.com>
	<82440fdb64a3722c4e3cba49ec6b94ebbf2db1ca.camel@suse.com>
	<9f76457a-5a15-b6ee-8f92-60e23be07e48@huawei.com>
User-Agent: Evolution 3.38.2
MIME-Version: 1.0
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 114BEf7i004973
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH] libmultipath: check if adopt_path() really
 added current path
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Thu, 2021-02-04 at 15:41 +0800, lixiaokeng wrote:
>=20
>=20
> On 2021/2/3 21:14, Martin Wilck wrote:
> > On Wed, 2021-02-03 at 17:42 +0800, lixiaokeng wrote:
> > >=20
> > >=20
> > > On 2021/2/3 16:14, Martin Wilck wrote:
> > > > Is this also a Tested-by:?=20
> > > > IOW, did it fix your issue?
> > >=20
> > > Yes, it solves the crash.But there is an other issue.
> > >=20
> > > multipath.conf
> > > defaults {
> > > =A0=A0=A0=A0=A0=A0=A0 find_multipaths no
> > > }
> > >=20
> > > [root@localhost coredump]# multipathd add path sdb
> > > fail
> > > [root@localhost coredump]# multipath -ll
> > > [root@localhost coredump]# multipathd add path sdb
> > > ok
> > > [root@localhost coredump]# multipath -ll
> > > 0QEMU_QEMU_HARDDISK_drive-scsi0-0-0-1 dm-3 QEMU,QEMU HARDDISK
> > > size=3D1.0G features=3D'0' hwhandler=3D'0' wp=3Drw
> > > `-+- policy=3D'service-time 0' prio=3D1 status=3Denabled
> > > =A0 `- 2:0:0:1 sdb 8:16 active ready running
> > >=20
> > > I add local path twice. The first fails while the second
> > > succeeds.
> >=20
> > More details please. What exactly were you doing? Was this a
> > regression
> > caused by my patch? Please provide multipathd -v3 logs.
>=20
> I did nothing just "multipathd add path sdb" twice.
> Here I do that again with multipath -v3. The attachment shows all
> messages.

This is a misunderstanding, sorry for being unlear. What I meant was
the logs of *multipathd* running in the background with -v3. IOW, the
journal or syslog or whatever showing what went wrong the first time
around when you tried to add the disk.

But I was able to reproduce the issue, so I can do this myself.

1st time:

994.196771 | sdb: prio args =3D "" (setting: multipath internal)
994.196781 | sdb: const prio =3D 1
994.196831 | QEMU_HARDDISK_QM00007: user_friendly_names =3D no (setting:
multipath internal)
994.196982 | QEMU_HARDDISK_QM00007: alias =3D QEMU_HARDDISK_QM00007
(setting: default to WWID)
994.197053 | adopt_paths: pathinfo failed for sdb
994.197065 | sdb: orphan path, failed to add path

2nd time:

1012.157422 | sdb: path already in pathvec

Here, cli_add_path() calls ev_add_path() right away:

1012.157433 | QEMU_HARDDISK_QM00007: user_friendly_names =3D no (setting:
multipath internal)
1012.157440 | QEMU_HARDDISK_QM00007: alias =3D QEMU_HARDDISK_QM00007
(setting: default to WWID)
1012.157688 | sdb: detect_checker =3D yes (setting: multipath internal)
...
1012.158342 | sdb: ownership set to QEMU_HARDDISK_QM00007

The problem here is, again, that we don't handle blacklisting by
property consistently.

Please apply my recent series "consistent behavior of
filter_property()". It should fix the issue (did so for me).
>=20

> > Also, you're aware that "find_multipaths no" is discouraged?
> > It leads to inconsistent behavior between multipath and multipathd.
> >=20
> There are some different things about local disks between 0.8.5 and
> 0.7.7.
> I just test that.

Sure. I just wanted to make you aware that you are using a possibly
dangerous setting.

Thank you for you hard work and your valuable contributions!

Regards
Martin




--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


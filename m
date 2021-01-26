Return-Path: <SRS0=Cj1z=G5=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 653EFC1B087
	for <dm-devel@archiver.kernel.org>; Tue, 26 Jan 2021 23:17:42 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C356F2067C
	for <dm-devel@archiver.kernel.org>; Tue, 26 Jan 2021 23:17:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C356F2067C
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-512-oeocVB2wP1yVkAuerjgi8Q-1; Tue, 26 Jan 2021 18:17:38 -0500
X-MC-Unique: oeocVB2wP1yVkAuerjgi8Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D089A10054FF;
	Tue, 26 Jan 2021 23:17:33 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E10AE19D80;
	Tue, 26 Jan 2021 23:17:32 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id AC5F84BB7B;
	Tue, 26 Jan 2021 23:17:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10QNBU2j023980 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 26 Jan 2021 18:11:30 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 2F6D02166B2C; Tue, 26 Jan 2021 23:11:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 246B22166B28
	for <dm-devel@redhat.com>; Tue, 26 Jan 2021 23:11:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0A2DC101A563
	for <dm-devel@redhat.com>; Tue, 26 Jan 2021 23:11:28 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-528-MxtVN7XfPj2OSEIyx_IIuQ-1;
	Tue, 26 Jan 2021 18:11:23 -0500
X-MC-Unique: MxtVN7XfPj2OSEIyx_IIuQ-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id D0395AC6E;
	Tue, 26 Jan 2021 23:11:21 +0000 (UTC)
Message-ID: <5440d76a18994a7a214321c30fe8a1e99c0a3988.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: lixiaokeng <lixiaokeng@huawei.com>, Benjamin Marzinski
	<bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>,
	dm-devel mailing list <dm-devel@redhat.com>
Date: Wed, 27 Jan 2021 00:11:20 +0100
In-Reply-To: <ef4f29d8-a20b-2b4d-97ab-a83fb4bca5ac@huawei.com>
References: <063bbeeb-15aa-f7c0-b881-7526c3a2720c@huawei.com>
	<f86753b17cc7e85e7e0f7e711adec349323a7c5a.camel@suse.com>
	<d8ba8118-ce98-249a-cafd-021f0c1831a5@huawei.com>
	<f1961d4104b14c80183b161a53262e1766e0df70.camel@suse.com>
	<c52487a2-5c15-977c-704b-7cad5f6e275e@huawei.com>
	<cd3cae852bffc2d4a9be2e7f4334eb346cfaae8d.camel@suse.com>
	<ef4f29d8-a20b-2b4d-97ab-a83fb4bca5ac@huawei.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 10QNBU2j023980
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Tue, 2021-01-26 at 19:14 +0800, lixiaokeng wrote:
>=20
> > > Hi,
> > > =A0 Unfortunately the verify_path() called before *and* after
> > > domap()
> > > in
> > > coalesce_paths can't solve this problem. I think it is another
> > > way to
> > > lead multipath with wrong path, but now I can't find the way from
> > > log.
> >=20
> > Can you provide multipathd -v3 logs, and kernel logs? Maybe I'll
> > see
> > something.

This is not a -v3 log, right? We can't see much what multipathd is
doing. Anyway, I understand now that verify_paths() won't help. It
looks only for paths that have been removed (i.e. don't exist any more
in sysfs) since the last path detection. But then, when the error
occurs, it seems that sdf has been removed *and re-added*. So, the
check whether the path still exists succeeds. The uevents were also
missed because the uevent handler didn't get the lock.


>=20
> (1)multipath -r: The sdf is found as a path of
> 36001405b7679bd96b094bccbf971bc90
> (iscsi node is 4:0:0:2)
>=20
> (2)iscsi logout: The sdf is removed in iscsi in system time
> [1202538.467014].
>=20
> (3)iscsi login: The sdf appears in iscsi in system time
> [1202538.825745].
> It is a path of 3600140584e11eb1818c4afab12c17800 (iscsi node
> 2:0:0:0)
>=20
> Here I have a doubt. When I stop in domap using gdb and iscsi log
> out/in,
> the sdf will not=A0 be used again becasue the disk refcount is not
> zero. I
> add a print if the disk refcount is zero in put_disk_and_module (for
> example lxk ref put after: name sdi; count 0), but there is not this
> print
> about sdf.

Yes, this is a very good point, and it's indeed strange. multipathd
should have opened a file descriptor to /dev/sdf in pathinfo(), and as
long as that file is open, the use count shouldn't drop to 0, the disk
devices (block device and scsi_disk device) shouldn't be released, and
the major/minor number shouldn't be reused. Unless I'm missing
something essential, that is.

> Jan 25 12:37:48 client1 kernel: [1202538.467014] sd 4:0:0:2: [sdf] Synchr=
onizing SCSI cache
> Jan 25 12:37:48 client1 kernel: [1202538.568195] scsi 4:0:0:2: alua: Deta=
ched
> Jan 25 12:37:48 client1 kernel: [1202538.630507] sd 2:0:0:0: [sdf] 209715=
20 512-byte logical blocks: (10.7 GB/10.0 GiB)

Less than 0.1s between the disappearance of 4:0:0:2 as sdf and reappearance
of 2:0:0:0, without any sign of multipathd having noticed this change,
is indeed quite strange.

So we can only conclude that (if there's no kernel refcounting bug,
which I doubt) either orphan_path()->uninitialize_path() had been
called (closing the fd),  or that opening the sd device had failed in
the first place (in which case the path WWID should have been nulled in
pathinfo(). In both cases it makes little sense that the path should
still be part of a struct multipath.=20

Please increase the log level of the "Couldn't open device node"
message in pathinfo(), and see if respective errors are logged.

Can you verify in the debugger if multipathd still has the fd to the
disk device open?

Perhaps you could trace scsi_disk_release() in the kernel?

Martin



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


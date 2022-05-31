Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A24FC433EF
	for <dm-devel@archiver.kernel.org>; Tue, 31 May 2022 09:58:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-221-LmlMZLnyP1OZr0mdd96__Q-1; Tue, 31 May 2022 05:57:57 -0400
X-MC-Unique: LmlMZLnyP1OZr0mdd96__Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EE1A71857F20;
	Tue, 31 May 2022 09:57:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 671F08287E;
	Tue, 31 May 2022 09:57:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 37FC0194705E;
	Tue, 31 May 2022 09:57:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9D178194705C
 for <dm-devel@listman.corp.redhat.com>; Tue, 31 May 2022 09:57:52 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 782872026D07; Tue, 31 May 2022 09:57:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 73A5B2026D64
 for <dm-devel@redhat.com>; Tue, 31 May 2022 09:57:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5915D80418C
 for <dm-devel@redhat.com>; Tue, 31 May 2022 09:57:52 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-348-eriCmy5-PcGbpGQ_cwgsHg-1; Tue, 31 May 2022 05:57:50 -0400
X-MC-Unique: eriCmy5-PcGbpGQ_cwgsHg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 7319521A93;
 Tue, 31 May 2022 09:57:49 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 37F6D132F9;
 Tue, 31 May 2022 09:57:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id meX3C53mlWLnIAAAMHmgww
 (envelope-from <mwilck@suse.com>); Tue, 31 May 2022 09:57:49 +0000
Message-ID: <b9c89e7f13a87dc2aebda0f88047612b33c0cab7.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Wu Guanghao
 <wuguanghao3@huawei.com>
Date: Tue, 31 May 2022 11:57:48 +0200
In-Reply-To: <20220527193544.GM5254@octiron.msp.redhat.com>
References: <d76b39d2-d6a8-8cb0-a1de-aa684c7371b8@huawei.com>
 <20220527193544.GM5254@octiron.msp.redhat.com>
User-Agent: Evolution 3.44.1
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH]dm_get_map: fix segfault when can't found
 target
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: lixiaokeng@huawei.com, Christophe Varoqui <christophe.varoqui@opensvc.com>,
 dm-devel mailing list <dm-devel@redhat.com>, linfeilong@huawei.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Fri, 2022-05-27 at 14:35 -0500, Benjamin Marzinski wrote:
> On Fri, May 27, 2022 at 10:27:37AM +0800, Wu Guanghao wrote:
> > We got a segfault when we test multipath + iscsi.
> >=20
> > (gdb) bt
> > #0=A0 __strlen_avx2 () at ../sysdeps/x86_64/multiarch/strlen-
> > avx2.S:74
> > #1=A0 0x00007f694306cd23 in __GI___strdup (s=3D0x0) at strdup.c:41
> > #2=A0 0x00007f69433a147c in dm_get_map (name=3D0x55d4bc090320
> > "3600140537cde137ea8c43d8a971462c7",
> > =A0=A0=A0 size=3Dsize@entry=3D0x55d4bc0270d8,
> > outparams=3Doutparams@entry=3D0x7f6941add640) at devmapper.c:688
> > #3=A0 0x00007f69433cbbdf in update_multipath_table
> > (mpp=3Dmpp@entry=3D0x55d4bc026f30,
> > =A0=A0=A0 pathvec=3Dpathvec@entry=3D0x55d4bc063990, flags=3Dflags@entry=
=3D0) at
> > structs_vec.c:426
> > #4=A0 0x00007f69433cbfe5 in update_multipath_strings
> > (mpp=3D0x55d4bc026f30, pathvec=3D0x55d4bc063990)
> > =A0=A0=A0 at structs_vec.c:526
> > #5=A0 0x000055d4bb52e03e in check_path (vecs=3D0x55d4bbfad760,
> > pp=3D0x7f692402d270, ticks=3D<optimized out>)
> > =A0=A0=A0 at main.c:2280
> > #6=A0 0x000055d4bb52f3e2 in checkerloop (ap=3D0x55d4bbfad760) at
> > main.c:2542
> > #7=A0 0x00007f694305b3ba in start_thread (arg=3D<optimized out>) at
> > pthread_create.c:443
> > #8=A0 0x00007f69430ddb40 in clone3 () at
> > ../sysdeps/unix/sysv/linux/x86_64/clone3.S:81
> > (gdb) f 2
> > #2=A0 0x00007f69433a147c in dm_get_map (name=3D0x55d4bc090320
> > "3600140537cde137ea8c43d8a971462c7",
> > =A0=A0=A0 size=3Dsize@entry=3D0x55d4bc0270d8,
> > outparams=3Doutparams@entry=3D0x7f6941add640) at devmapper.c:688
> > 688=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*outp=
arams =3D strdup(params);
> > (gdb) l
> > 683=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*size=
 =3D length;
> > 684=A0=A0=A0=A0=A0
> > 685=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (!outparams)
> > 686=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r =3D=
 DMP_OK;
> > 687=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0else {
> > 688=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*outp=
arams =3D strdup(params);
> > 689=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r =3D=
 *outparams ? DMP_OK : DMP_ERR;
> > 690=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > 691=A0=A0=A0=A0=A0
> > 692=A0=A0=A0=A0=A0out:
> > (gdb) p params
> > $1 =3D 0x0
> >=20
> > If can't found target, we should goto out
> >=20
> > Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>
>=20
> Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

Thanks! Note: We have two other callers of dm_get_next_target that
should add a similar check.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


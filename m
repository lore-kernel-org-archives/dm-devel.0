Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CF2FC433EF
	for <dm-devel@archiver.kernel.org>; Sun, 28 Nov 2021 23:18:33 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-569-gI7TSSGOM36tXVEm3Y3y5g-1; Sun, 28 Nov 2021 18:18:28 -0500
X-MC-Unique: gI7TSSGOM36tXVEm3Y3y5g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 06DA01030C20;
	Sun, 28 Nov 2021 23:18:24 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 380037944B;
	Sun, 28 Nov 2021 23:18:22 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0B1681809C89;
	Sun, 28 Nov 2021 23:18:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ASNIGpA029981 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 28 Nov 2021 18:18:16 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id F2EE240CFD13; Sun, 28 Nov 2021 23:18:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E8C6840CFD0A
	for <dm-devel@redhat.com>; Sun, 28 Nov 2021 23:18:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CE1CC802E5E
	for <dm-devel@redhat.com>; Sun, 28 Nov 2021 23:18:15 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-235-og2hnXkFOJirbAJLov3NxA-1; Sun, 28 Nov 2021 18:18:13 -0500
X-MC-Unique: og2hnXkFOJirbAJLov3NxA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D93F7212BF;
	Sun, 28 Nov 2021 23:18:11 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8ED4E133FE;
	Sun, 28 Nov 2021 23:18:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id GdbUIDMOpGFKGQAAMHmgww
	(envelope-from <mwilck@suse.com>); Sun, 28 Nov 2021 23:18:11 +0000
Message-ID: <17f1efd1ce3372014ca67fd25c992ea169b7afbe.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: lixiaokeng <lixiaokeng@huawei.com>, Christophe Varoqui
	<christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel mailing list <dm-devel@redhat.com>
Date: Mon, 29 Nov 2021 00:18:10 +0100
In-Reply-To: <bfa69895-5b9e-5fe6-e5a0-78be2ee93163@huawei.com>
References: <bfa69895-5b9e-5fe6-e5a0-78be2ee93163@huawei.com>
User-Agent: Evolution 3.42.1
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-loop: dm-devel@redhat.com
Cc: linfeilong <linfeilong@huawei.com>,
	"liuzhiqiang \(I\)" <liuzhiqiang26@huawei.com>
Subject: Re: [dm-devel] [PATCH] libmultipath: clear removed path from mpp
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="=-Fiqy+ZV5pGGzoEa7cARl"

--=-Fiqy+ZV5pGGzoEa7cARl
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2021-11-27 at 18:15 +0800, lixiaokeng wrote:
> multipathd[3525635]: =3D=3D3525635=3D=3DERROR: AddressSanitizer: heap-use=
-
> after-free on address 0xffffa4902fc0 at pc 0xffffac7d5b88 bp
> 0xffffa948dac0 sp 0xffffa948dae0
> multipathd[3525635]: READ of size 8 at 0xffffa4902fc0 thread T7
> multipathd[3525635]:=C2=A0=C2=A0=C2=A0 #0 0xffffac7d5b87 in free_multipat=
h
> (/usr/lib64/libmultipath.so.0+0x4bb87)
> multipathd[3525635]:=C2=A0=C2=A0=C2=A0 #1 0xaaaad6cf7057=C2=A0
> (/usr/sbin/multipathd+0x17057)
> multipathd[3525635]:=C2=A0=C2=A0=C2=A0 #2 0xaaaad6cf78eb=C2=A0
> (/usr/sbin/multipathd+0x178eb)
> multipathd[3525635]:=C2=A0=C2=A0=C2=A0 #3 0xaaaad6cff4df=C2=A0
> (/usr/sbin/multipathd+0x1f4df)
> multipathd[3525635]:=C2=A0=C2=A0=C2=A0 #4 0xaaaad6cfffe7=C2=A0
> (/usr/sbin/multipathd+0x1ffe7)
> multipathd[3525635]:=C2=A0=C2=A0=C2=A0 #5 0xffffac807be3 in uevent_dispat=
ch
> (/usr/lib64/libmultipath.so.0+0x7dbe3)
> multipathd[3525635]:=C2=A0=C2=A0=C2=A0 #6 0xaaaad6cf563f=C2=A0
> (/usr/sbin/multipathd+0x1563f)
> multipathd[3525635]:=C2=A0=C2=A0=C2=A0 #7 0xffffac6877af=C2=A0
> (/usr/lib64/libpthread.so.0+0x87af)
> multipathd[3525635]:=C2=A0=C2=A0=C2=A0 #8 0xffffac44118b=C2=A0
> (/usr/lib64/libc.so.6+0xd518b)
> multipathd[3525635]: 0xffffa4902fc0 is located 1344 bytes inside of
> 1440-byte region [0xffffa4902a80,0xffffa4903020)
> multipathd[3525635]: freed by thread T7 here:
> multipathd[3525635]:=C2=A0=C2=A0=C2=A0 #0 0xffffac97d703 in free
> (/usr/lib64/libasan.so.4+0xd0703)
> multipathd[3525635]:=C2=A0=C2=A0=C2=A0 #1 0xffffac824827 in orphan_paths
> (/usr/lib64/libmultipath.so.0+0x9a827)
> multipathd[3525635]:=C2=A0=C2=A0=C2=A0 #2 0xffffac824a43 in remove_map
> (/usr/lib64/libmultipath.so.0+0x9aa43)
> multipathd[3525635]:=C2=A0=C2=A0=C2=A0 #3 0xaaaad6cf7057=C2=A0
> (/usr/sbin/multipathd+0x17057)
> multipathd[3525635]:=C2=A0=C2=A0=C2=A0 #4 0xaaaad6cf78eb=C2=A0
> (/usr/sbin/multipathd+0x178eb)
> multipathd[3525635]:=C2=A0=C2=A0=C2=A0 #5 0xaaaad6cff4df=C2=A0
> (/usr/sbin/multipathd+0x1f4df)
> multipathd[3525635]:=C2=A0=C2=A0=C2=A0 #6 0xaaaad6cfffe7=C2=A0
> (/usr/sbin/multipathd+0x1ffe7)
> multipathd[3525635]:=C2=A0=C2=A0=C2=A0 #7 0xffffac807be3 in uevent_dispat=
ch
> (/usr/lib64/libmultipath.so.0+0x7dbe3)
> multipathd[3525635]:=C2=A0=C2=A0=C2=A0 #8 0xaaaad6cf563f=C2=A0
> (/usr/sbin/multipathd+0x1563f)
> multipathd[3525635]:=C2=A0=C2=A0=C2=A0 #9 0xffffac6877af=C2=A0
> (/usr/lib64/libpthread.so.0+0x87af)
> multipathd[3525635]:=C2=A0=C2=A0=C2=A0 #10 0xffffac44118b=C2=A0
> (/usr/lib64/libc.so.6+0xd518b)
>=20
> When mpp only has one path and log out the path, there is an asan
> error.
> In remove_mpp, the pp is freed firstly in orphan_path but is
> accessed,
> changed in free_multipath later. Before free_path(pp), the pp should
> be
> cleared from pp->mpp.
>=20
> When pp is set to REMOVED=EF=BC=8C it will be an orphan path. At the same
> time,
> clear it from it's map.
>=20
> Signed-off-by: Lixiaokeng <lixiaokeng@huawei.com>
> ---
> =C2=A0libmultipath/structs_vec.c | 20 +++++++++++++++++---
> =C2=A0multipathd/main.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 |=C2=A0 8 --------
> =C2=A02 files changed, 17 insertions(+), 11 deletions(-)
>=20
> diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
> index 85d97ac1..ab5311cc 100644
> --- a/libmultipath/structs_vec.c
> +++ b/libmultipath/structs_vec.c
> @@ -318,7 +318,9 @@ void orphan_paths(vector pathvec, struct
> multipath *mpp, const char *reason)
>=20
> =C2=A0void set_path_removed(struct path *pp)
> =C2=A0{
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0int i, j;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct multipath *mpp =3D=
 pp->mpp;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct pathgroup * pgp;
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0orphan_path(pp, "removed"=
);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/*
> @@ -329,6 +331,20 @@ void set_path_removed(struct path *pp)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0condlog(0, "%s: internal error: mpp =3D=3D NULL", p=
p-
> >dev);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0return;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
> +
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/*
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * The path is removed, clear =
it from mp->paths and mpp->pgs.
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0i =3D find_slot(mpp->paths, pp=
);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (i !=3D -1)
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0vector_del_slot(mpp->paths, i);
> +
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0vector_foreach_slot(mpp->pg, p=
gp, j) {
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0i =3D find_slot(pgp->paths, (void *)pp);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0if (i !=3D -1)
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0vector_de=
l_slot(pgp->paths, i);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
> +

No, we can't do this. It would invalidate all the work we did for
INIT_REMOVED. It's the very idea of INIT_REMOVED that we do NOT
immediately clear the path from our data structures. The main problem
is that INIT_REMOVED paths may still be part of the map in the kernel.
Thus when we re-read the kernel state, the path will be re-added to
mpp->paths.

We need to rework the free_multipath() logic. It might be sufficient
to simply clear the references to the devices in mpp before calling
orphan_paths(). Can you try the attached patch, please?

Regards
Martin


--=-Fiqy+ZV5pGGzoEa7cARl
Content-Disposition: attachment;
	filename*0=0001-libmultipath-remove_map-make-sure-orphaned-paths-are.pat;
	filename*1=ch
Content-Transfer-Encoding: base64
Content-Type: text/x-patch;
	name="0001-libmultipath-remove_map-make-sure-orphaned-paths-are.patch"; 
	charset="ISO-8859-15"

RnJvbSAwM2ZhNGM0MDI4OTY1OGNiOGI3MGM4ZmE4YzI2NWYyZDA3ZGVlNDJkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNYXJ0aW4gV2lsY2sgPG13aWxja0BzdXNlLmNvbT4KRGF0ZTog
TW9uLCAyOSBOb3YgMjAyMSAwMDoxNjowNyArMDEwMApTdWJqZWN0OiBbUEFUQ0hdIGxpYm11bHRp
cGF0aDogcmVtb3ZlX21hcCgpOiBtYWtlIHN1cmUgb3JwaGFuZWQgcGF0aHMgYXJlbid0CiByZWZl
cmVuY2VkCgouLi4gYnkgdGhlIHBhdGhzIGFuZCBwZyB2ZWN0b3JzIG9mIHRoZSBtYXAgdG8gYmUg
cmVtb3ZlZC4KClNpZ25lZC1vZmYtYnk6IE1hcnRpbiBXaWxjayA8bXdpbGNrQHN1c2UuY29tPgot
LS0KIGxpYm11bHRpcGF0aC9zdHJ1Y3RzX3ZlYy5jIHwgNCArKysrCiAxIGZpbGUgY2hhbmdlZCwg
NCBpbnNlcnRpb25zKCspCgpkaWZmIC0tZ2l0IGEvbGlibXVsdGlwYXRoL3N0cnVjdHNfdmVjLmMg
Yi9saWJtdWx0aXBhdGgvc3RydWN0c192ZWMuYwppbmRleCA0MmMwNmE4Li4xMDVlZTIwIDEwMDY0
NAotLS0gYS9saWJtdWx0aXBhdGgvc3RydWN0c192ZWMuYworKysgYi9saWJtdWx0aXBhdGgvc3Ry
dWN0c192ZWMuYwpAQCAtMzQxLDYgKzM0MSwxMCBAQCByZW1vdmVfbWFwKHN0cnVjdCBtdWx0aXBh
dGggKm1wcCwgdmVjdG9yIHBhdGh2ZWMsIHZlY3RvciBtcHZlYykKIHsKIAlpbnQgaTsKIAorCWZy
ZWVfcGF0aHZlYyhtcHAtPnBhdGhzLCBLRUVQX1BBVEhTKTsKKwlmcmVlX3BndmVjKG1wcC0+cGcs
IEtFRVBfUEFUSFMpOworCW1wcC0+cGF0aHMgPSBtcHAtPnBnID0gTlVMTDsKKwogCS8qCiAJICog
Y2xlYXIgcmVmZXJlbmNlcyB0byB0aGlzIG1hcAogCSAqLwotLSAKMi4zMy4xCgo=
--=-Fiqy+ZV5pGGzoEa7cARl
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel
--=-Fiqy+ZV5pGGzoEa7cARl--


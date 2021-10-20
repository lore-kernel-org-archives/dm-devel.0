Return-Path: <SRS0=0/yZ=PI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F3D2C433FE
	for <dm-devel@archiver.kernel.org>; Wed, 20 Oct 2021 16:04:09 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2A1E661373
	for <dm-devel@archiver.kernel.org>; Wed, 20 Oct 2021 16:04:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2A1E661373
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-474-bUL5mZkpMdW9fq4r01oiUQ-1; Wed, 20 Oct 2021 12:04:04 -0400
X-MC-Unique: bUL5mZkpMdW9fq4r01oiUQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2337D814243;
	Wed, 20 Oct 2021 16:03:58 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7B4CA78B20;
	Wed, 20 Oct 2021 16:03:57 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 704F3181A1D0;
	Wed, 20 Oct 2021 16:03:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19KG3dNn014300 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 20 Oct 2021 12:03:39 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 893F72026D46; Wed, 20 Oct 2021 16:03:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 827572026D64
	for <dm-devel@redhat.com>; Wed, 20 Oct 2021 16:03:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 450BC8038E3
	for <dm-devel@redhat.com>; Wed, 20 Oct 2021 16:03:34 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-1-202r5ehXM6GE7uQsMy5UPA-1; Wed, 20 Oct 2021 12:03:31 -0400
X-MC-Unique: 202r5ehXM6GE7uQsMy5UPA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B89301F770;
	Wed, 20 Oct 2021 16:03:29 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 68DA913B55;
	Wed, 20 Oct 2021 16:03:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id CKQeF9E9cGEuSAAAMHmgww
	(envelope-from <mwilck@suse.com>); Wed, 20 Oct 2021 16:03:29 +0000
Message-ID: <e0092780a8ce82fe9604609b49cc6e49cc737c25.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: chengjike <chengjike.cheng@huawei.com>, dm-devel@redhat.com,
	christophe.varoqui@opensvc.com, xose.vazquez@gmail.com
Date: Wed, 20 Oct 2021 18:03:28 +0200
In-Reply-To: <20211008122449.1328-1-chengjike.cheng@huawei.com>
References: <20211008122449.1328-1-chengjike.cheng@huawei.com>
User-Agent: Evolution 3.42.0
MIME-Version: 1.0
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 19KG3dNn014300
X-loop: dm-devel@redhat.com
Cc: sunao.sun@huawei.com, jiangtao62@huawei.com
Subject: Re: [dm-devel] [PATCH]multipath-tools: fix "multipath -ll" bug for
 Native NVME Multipath devices
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
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Fri, 2021-10-08 at 20:24 +0800, chengjike wrote:
> After "Native NVME Multipath" is configured,
> the content displayed is incorrect when you run "multipath -ll"
> command.
> Each NVME devices have the same path name. For example:
>=20
> [root@localhost home]# multipath -ll
> eui.710032e8fb22a86c24a52c1000000db8 [nvme]:nvme1n1 NVMe,Huawei-
> XSG1,1000001
> size=3D10485760 features=3D'n/a' hwhandler=3D'ANA' wp=3Drw
> > -+- policy=3D'n/a' prio=3D50 status=3Doptimized
> > `- 1:4:1=A0=A0 nvme1c4n1 0:0 n/a=A0=A0 optimized live
> `-+- policy=3D'n/a' prio=3D50 status=3Doptimized
> =A0 `- 1:9:1=A0=A0 nvme1c9n1 0:0 n/a=A0=A0 optimized live
> eui.710032e8fb22a86b24a52c7c00000db7 [nvme]:nvme1n2 NVMe,Huawei-
> XSG1,1000001
> size=3D10485760 features=3D'n/a' hwhandler=3D'ANA' wp=3Drw
> > -+- policy=3D'n/a' prio=3D50 status=3Doptimized
> > `- 1:4:1=A0=A0 nvme1c4n1 0:0 n/a=A0=A0 optimized live
> `-+- policy=3D'n/a' prio=3D50 status=3Doptimized
> =A0 `- 1:9:1=A0=A0 nvme1c9n1 0:0 n/a=A0=A0 optimized live
> [root@localhost home]#
>=20
> The logical paths of "nvme1n1" and "nvme1n2" are both "nvme1c4n1" and
> "nvme1c9n1".
> So when multipath-tools aggregates disks, use "nvme_ns_head-
> >instance" for matching.
> such as ,Use "b" in "nvmeanb" string to match "z" in
> "nvmexcynz"(a,b,x,y,z can be any number),
> and if "b" and "z" are the same, they are related.
>=20
> Signed-off-by: chengjike <chengjike.cheng@huawei.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

Thanks!!


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


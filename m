Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E94AC433EF
	for <dm-devel@archiver.kernel.org>; Fri, 17 Jun 2022 14:34:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-253-2YXA78cJOl6sx4XGVyxnvQ-1; Fri, 17 Jun 2022 10:34:03 -0400
X-MC-Unique: 2YXA78cJOl6sx4XGVyxnvQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6DE0D1C06ED6;
	Fri, 17 Jun 2022 14:34:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3D35240149A6;
	Fri, 17 Jun 2022 14:34:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D863A1947063;
	Fri, 17 Jun 2022 14:33:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EEAC81947064
 for <dm-devel@listman.corp.redhat.com>; Fri, 17 Jun 2022 14:33:58 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 93344DCC486; Fri, 17 Jun 2022 14:33:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8F697DCC485
 for <dm-devel@redhat.com>; Fri, 17 Jun 2022 14:33:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 770942A5955B
 for <dm-devel@redhat.com>; Fri, 17 Jun 2022 14:33:58 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-619-wg2g_jnpMHqUo0HnxD2yCQ-1; Fri, 17 Jun 2022 10:33:56 -0400
X-MC-Unique: wg2g_jnpMHqUo0HnxD2yCQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 6866A1F86A;
 Fri, 17 Jun 2022 14:33:55 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 205C21348E;
 Fri, 17 Jun 2022 14:33:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id FAa4BdOQrGJAMgAAMHmgww
 (envelope-from <mwilck@suse.com>); Fri, 17 Jun 2022 14:33:55 +0000
Message-ID: <1f5d89856bc3d6c6a469b157c3fcfa5e46be5430.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: chengjike <chengjike.cheng@huawei.com>, dm-devel@redhat.com, 
 christophe.varoqui@opensvc.com, xose.vazquez@gmail.com
Date: Fri, 17 Jun 2022 16:33:54 +0200
In-Reply-To: <20211008122449.1328-1-chengjike.cheng@huawei.com>
References: <20211008122449.1328-1-chengjike.cheng@huawei.com>
User-Agent: Evolution 3.44.2
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH]multipath-tools: fix "multipath -ll" bug for
 Native NVME Multipath devices
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
Cc: sunao.sun@huawei.com, jiangtao62@huawei.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
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

Thanks a lot, and sorry for the late reply. This somehow got lost in my
inbox.

Regards,
Martin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


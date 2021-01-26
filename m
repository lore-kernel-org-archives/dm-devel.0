Return-Path: <SRS0=Cj1z=G5=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D586C433E0
	for <dm-devel@archiver.kernel.org>; Tue, 26 Jan 2021 09:32:54 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B252B23104
	for <dm-devel@archiver.kernel.org>; Tue, 26 Jan 2021 09:32:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B252B23104
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-225-4fHoTUzOP-mFaRxJ5ur7ig-1; Tue, 26 Jan 2021 04:32:50 -0500
X-MC-Unique: 4fHoTUzOP-mFaRxJ5ur7ig-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6A042BBEE0;
	Tue, 26 Jan 2021 09:32:45 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 430B619D80;
	Tue, 26 Jan 2021 09:32:45 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E2DCC4BB7B;
	Tue, 26 Jan 2021 09:32:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10Q9Se0j004357 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 26 Jan 2021 04:28:40 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id DBEF42166B28; Tue, 26 Jan 2021 09:28:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D6F372166B29
	for <dm-devel@redhat.com>; Tue, 26 Jan 2021 09:28:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6444C1875049
	for <dm-devel@redhat.com>; Tue, 26 Jan 2021 09:28:37 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-286-y2zjdm3xP_qoj7kPylr5gw-1;
	Tue, 26 Jan 2021 04:28:33 -0500
X-MC-Unique: y2zjdm3xP_qoj7kPylr5gw-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id E74F1AF33;
	Tue, 26 Jan 2021 09:28:30 +0000 (UTC)
Message-ID: <e838410f254c12bfa3643a0cd3c50d31017346d0.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: lixiaokeng <lixiaokeng@huawei.com>, Christophe Varoqui
	<christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel mailing list <dm-devel@redhat.com>
Date: Tue, 26 Jan 2021 10:28:30 +0100
In-Reply-To: <322a434b-9c5d-e145-3de4-e244493b4085@huawei.com>
References: <621a2062-b6eb-d88d-e53a-9c0a6b19cfbb@huawei.com>
	<d592fd0d5eeb2a0a865a395b456e24fc5a359ebf.camel@suse.com>
	<322a434b-9c5d-e145-3de4-e244493b4085@huawei.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 10Q9Se0j004357
X-loop: dm-devel@redhat.com
Cc: linfeilong <linfeilong@huawei.com>, hexiaowen@huawei.com
Subject: Re: [dm-devel] [QUESTION] multipathd crash when stopping
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

On Tue, 2021-01-26 at 17:23 +0800, lixiaokeng wrote:
>=20
> > In general, running multipathd under valgrind might help finding
> > the
> > issue.=20
> >=20
> > But valgrind will slow down multipathd drastically, so timings will
> > change, and it's not granted that the problem will still be
> > reproducable. Alternatively, you can work with -fsanitize=3Daddress,
> > but
> > in this specific case you'd need to compile libudev with this
> > option,
> > too.
> >=20
> > Martin
> >=20
>=20
> =A0=A0 Thanks very much. Your suggestions is very helpful.
> =A0=A0 The problem reproduced and the bug seems that shown in
> https://bugzilla.redhat.com/show_bug.cgi?id=3D1293594.

Really? I don't see a connection to your case there. It's about
glusterfs and libgcc...

Martin



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


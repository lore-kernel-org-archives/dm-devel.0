Return-Path: <SRS0=nVuD=HH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE0ABC433DB
	for <dm-devel@archiver.kernel.org>; Fri,  5 Feb 2021 11:09:12 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id EECA164FA0
	for <dm-devel@archiver.kernel.org>; Fri,  5 Feb 2021 11:09:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EECA164FA0
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-333-k9HEs5h1McOn17gXAXYWCQ-1; Fri, 05 Feb 2021 06:09:06 -0500
X-MC-Unique: k9HEs5h1McOn17gXAXYWCQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 69705107ACC7;
	Fri,  5 Feb 2021 11:09:00 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 778A819C47;
	Fri,  5 Feb 2021 11:08:59 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 582E458074;
	Fri,  5 Feb 2021 11:08:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 115B8oJB023261 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 5 Feb 2021 06:08:50 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A7A8D2166B2F; Fri,  5 Feb 2021 11:08:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A267F2166B2D
	for <dm-devel@redhat.com>; Fri,  5 Feb 2021 11:08:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4BB0B800B2A
	for <dm-devel@redhat.com>; Fri,  5 Feb 2021 11:08:48 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-301-ceM1R9fpPdeJUlHKv9ilmg-1;
	Fri, 05 Feb 2021 06:08:44 -0500
X-MC-Unique: ceM1R9fpPdeJUlHKv9ilmg-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 9DB65AD29;
	Fri,  5 Feb 2021 11:08:42 +0000 (UTC)
Message-ID: <cb16789171d381a97bbef78c968b9fdb0b29955e.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: lixiaokeng <lixiaokeng@huawei.com>, Benjamin Marzinski
	<bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Fri, 05 Feb 2021 12:08:41 +0100
In-Reply-To: <57ec651871345e3aae745ba3a75c5f1e59bc25ef.camel@suse.com>
References: <20210128210852.23207-1-mwilck@suse.com>
	<c1dddccecfe0e12a2fe2dca66faad740a30acd53.camel@suse.com>
	<99488b1b-2339-338d-e951-0b8f3e78449b@huawei.com>
	<dcc6fb2a344ce75972242e2c78e2e485b58140da.camel@suse.com>
	<45fe03c8-1cc0-4318-ae84-698959667a6b@huawei.com>
	<57ec651871345e3aae745ba3a75c5f1e59bc25ef.camel@suse.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 115B8oJB023261
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH] multipathd: avoid crash in uevent_cleanup()
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

On Thu, 2021-02-04 at 16:06 +0100, Martin Wilck wrote:
> On Thu, 2021-02-04 at 09:40 +0800, lixiaokeng wrote:
> >=20
> >=20
> > On 2021/2/3 21:57, Martin Wilck wrote:
> > > > If exit() before all pthread_cancel in child of 0.7.7, there is
> > > > no
> > > > any crash.
> > > What do you mean with "exit() before all pthread_cancel"? If this
> > > happens on pthread_cancel(), and you don't call that function,
> > > this
> > > would actually be expected.
> >=20
> > When running_state is DAEMON_SHUTDOWN, break while then _exit(0).
> > But
> > is is not a great method.
>=20
> I wonder if it would be possible to figure out the LWP numbers
> (process
> IDs) of the different threads before the crash occurs, and compare
> this
> to the gdb output
>=20
> (gdb) info threads
> =A0 Id=A0=A0 Target Id=A0=A0=A0=A0=A0=A0=A0=A0 Frame
> * 1=A0=A0=A0 LWP 1997690=A0=A0=A0=A0=A0=A0 0x00007f59a0109647 in ?? ()
> =A0 2=A0=A0=A0 LWP 1996840=A0=A0=A0=A0=A0=A0 0x00007f59a0531de7 in ?? ()
> =A0 3=A0=A0=A0 LWP 1997692=A0=A0=A0=A0=A0=A0 0x00007f59a0109647 in ?? ()
> =A0 4=A0=A0=A0 LWP 1996857=A0=A0=A0=A0=A0=A0 0x00007f59a020d169 in ?? ()
>=20
> ... to identify which thread crashed, and if it's always the same
> one.

>From the LWP numbers, thread 2 and 4 are probably TUR checkers
(temporary threads). thread 1 can't be easily identified. Could you=20
provide the stack of thread 3? From that, we might be able to infer
which thread crashed, because multipathd always starts its threads in
the same sequence.

Martin



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


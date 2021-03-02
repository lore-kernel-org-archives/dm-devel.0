Return-Path: <SRS0=Fgdj=IA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5CF3C433DB
	for <dm-devel@archiver.kernel.org>; Tue,  2 Mar 2021 09:56:56 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0EF7D64F0D
	for <dm-devel@archiver.kernel.org>; Tue,  2 Mar 2021 09:56:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0EF7D64F0D
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-464-RX-x9uwNPKKmx7DHGkZE1A-1; Tue, 02 Mar 2021 04:56:53 -0500
X-MC-Unique: RX-x9uwNPKKmx7DHGkZE1A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2068B6D4E8;
	Tue,  2 Mar 2021 09:56:47 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5BD2D6F978;
	Tue,  2 Mar 2021 09:56:45 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 57CDF18095CB;
	Tue,  2 Mar 2021 09:56:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1229ub01014594 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 2 Mar 2021 04:56:37 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 9A2FF2167D67; Tue,  2 Mar 2021 09:56:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 92AAA2167D69
	for <dm-devel@redhat.com>; Tue,  2 Mar 2021 09:56:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 47A74805F2D
	for <dm-devel@redhat.com>; Tue,  2 Mar 2021 09:56:35 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-304-aCiWGcuqNumLb2ZseevZTw-1;
	Tue, 02 Mar 2021 04:56:33 -0500
X-MC-Unique: aCiWGcuqNumLb2ZseevZTw-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id CCB64AAC5;
	Tue,  2 Mar 2021 09:56:31 +0000 (UTC)
Message-ID: <79f18cdb19b41be24d082d5528ab2325e6552395.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: lixiaokeng <lixiaokeng@huawei.com>, Benjamin Marzinski
	<bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Tue, 02 Mar 2021 10:56:31 +0100
In-Reply-To: <655de0b3-9625-bf3c-85f8-d19832bd84d8@huawei.com>
References: <20210128210852.23207-1-mwilck@suse.com>
	<c1dddccecfe0e12a2fe2dca66faad740a30acd53.camel@suse.com>
	<99488b1b-2339-338d-e951-0b8f3e78449b@huawei.com>
	<dcc6fb2a344ce75972242e2c78e2e485b58140da.camel@suse.com>
	<655de0b3-9625-bf3c-85f8-d19832bd84d8@huawei.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1229ub01014594
X-loop: dm-devel@redhat.com
Cc: linfeilong <linfeilong@huawei.com>, dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH] multipathd: avoid crash in uevent_cleanup()
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

Hi Lixiaokeng,

thanks for your continued efforts!

On Mon, 2021-03-01 at 22:53 +0800, lixiaokeng wrote:

>=20
> Hi Martin:
> =A0=A0 Here I add condlog(2, "start funcname"),
> pthread_cleanup_push(func_print, NULL)
> in every pthread_create func. When these two core happened, "exit
> tur_thread"
> are less than "start tur_thread". So the trouble may be in
> tur_thread.

Note that unlike all other threads, TUR threads are _detached_ threads.
multipathd tries to cancel them, but it has no way to verify that they
actually stopped. It may be just a normal observation that you can't
see the messages when a TUR thread terminates, in particular if the
program is exiting and might have already closed the stderr file
descriptor.


If you look at the crashed processes with gdb, the thread IDs should
give you some clue which stack belongs to which thread. The TUR threads
will have higher thread IDs than the others because they are started
later.

> I will use
> =A0=A0=A0=A0=A0=A0=A0=A0int oldstate;
> =A0=A0=A0=A0=A0=A0=A0=A0pthread_setcancelstate(PTHREAD_CANCEL_DISABLE, &o=
ldstate);
> =A0=A0=A0=A0=A0=A0=A0=A0...
> =A0=A0=A0=A0=A0=A0=A0=A0pthread_setcancelstate(oldstate, NULL);
> =A0=A0=A0=A0=A0=A0=A0=A0pthread_testcancel();
> to test it.

Where exactly do you want to put that code?

IIUC you don't compile multipathd with -fexceptions, do you? You
haven't answered my previous question why you do that for systemd.

Regards
Martin



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


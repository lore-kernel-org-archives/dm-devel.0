Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83126C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 23 Nov 2021 23:07:40 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-212-r5DTpfAAN5Sw0wDh7ZdVMg-1; Tue, 23 Nov 2021 18:07:35 -0500
X-MC-Unique: r5DTpfAAN5Sw0wDh7ZdVMg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 732D6CC622;
	Tue, 23 Nov 2021 23:07:31 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5961510246E3;
	Tue, 23 Nov 2021 23:07:31 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 30CD24A704;
	Tue, 23 Nov 2021 23:07:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ANN7TEC026793 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 23 Nov 2021 18:07:29 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 819954047279; Tue, 23 Nov 2021 23:07:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7DDFD4047272
	for <dm-devel@redhat.com>; Tue, 23 Nov 2021 23:07:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6628F8001EA
	for <dm-devel@redhat.com>; Tue, 23 Nov 2021 23:07:29 +0000 (UTC)
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-556-12uzTUD0OTqqPaFc5wFiig-1; Tue, 23 Nov 2021 18:07:27 -0500
X-MC-Unique: 12uzTUD0OTqqPaFc5wFiig-1
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx104
	[212.227.17.174]) with ESMTPSA (Nemesis) id 1MhD2Y-1mCjZA2yqQ-00eOwX;
	Wed, 24 Nov 2021 00:07:23 +0100
Message-ID: <133792e9-b89b-bc82-04fe-41202c3453a5@gmx.com>
Date: Wed, 24 Nov 2021 07:07:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
	Thunderbird/91.3.1
To: "hch@infradead.org" <hch@infradead.org>,
	Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
References: <5d8351f1-1b09-bff0-02f2-a417c1669607@gmx.com>
	<YZybvlheyLGAadFF@infradead.org>
	<79d38fc2-cd2f-2980-2c4e-408078ce6079@gmx.com>
	<YZyiuFxAeKE/WMrR@infradead.org>
	<cca20bcb-1674-f99d-d504-b7fc928e227a@gmx.com>
	<PH0PR04MB74169757F9CF740289B790C49B609@PH0PR04MB7416.namprd04.prod.outlook.com>
	<YZz6jAVXun8yC/6k@infradead.org>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
In-Reply-To: <YZz6jAVXun8yC/6k@infradead.org>
X-Provags-ID: V03:K1:qASjRyYRjJnLkrnZlSVGlZAZgsTMuJmguDInPrNNx+V3HgKz2ZX
	JgTDvELnCmstXDimn/HR4QUbvaruhP53LS61RyZb1dGMlCVEiHplGwdca7UsjCw3xv9Z/QH
	y7U/eA+HElDgXJ2TxGJzoioVeGNjOa2BN89ufziw6WSp1ohfvJTta7fy/XxIrwqwv8hoyMI
	5RvfLURk3X0mZv+Cm544A==
X-UI-Out-Filterresults: notjunk:1;V03:K0:3eFqAMexTz4=:m1BNluKfSjwvib3xt17B7Z
	jM/IPlEZdsfA8QOqYFXaNVeAwzvc4BDQBddJt6bRMILr0A3W2toL2M7m5aHN7h7nh2Nu7Dr6g
	rDezAhQAL7Ggd7h66IScupMbbpFBdV/+i7wKv5nb+NbsMOAfSeH5gOP8gu1R+RPLfQQQa7axM
	fz6/qcnmsYcnj/QUsdcmgmlIQPxE0FGX2dllBTtWhYLfM1mqhEPlE+yGANuJ4HJ+piv/O7bHz
	VIGpLhAMjzbitwYfbf1v6Ym19/jB6h7NPBynGe8Pr+tBshlhHG8ALgCCT133Ne7N5p+TOq99F
	Evjiruoy2blCDoCfUNx4q12Khy3bFSiqK8OI2vEqlUAa//JnHAzSRioq02MblIA4rrycizDll
	550kFYesOZ4MSslJuvd4iuOI69Vf+uImi/ZZDFppuTzotBwre75iVT7wWTsa+3pMUZGXmOBEh
	2y5vJo5I193b7Ojvbvfpk8v4eNPpf+cmr24k+6iQrgz4qYFMgAFuvK+YhmvevPU23yuiqyBle
	1YqGsxC5pjNq+PIDbc+YHwiE2tTumno8cUj0PAWuqwnZFDsTCosDN8EJ1rD55oWMauSskEg6h
	++K4Hz/0pdkrEjuRSemfldT877XDqVZHma1sdfz/6J58p6s/Dld0eHAbgQPKuL0DZiUZDuC4X
	7j5yLGvODBRLWhWdvujli/qdFxO/fO5QE1XvNQPBVpsI4IL9+GgneYp//tUdZJzP9kDcl06Px
	4gehT7Ntz9msNwTOnbxwxVdqUTWRLtbvL4j+nzqWmourG5Rtcab6p9ISq19zWAqKdqE6bAtqD
	6tZvkgDqscfJ0OnIBoQciYJBh2Og8zGRhnvdjwKisPnmlrrzPXL8xlyXs4BCpsYTTo6GPDz1h
	cmJrbizN0m9HyQvBUpvemKKVmjyKCMTDvOVOSWvbD2/WsSXfsN5CW+4g3wMyGWDDVsBuzUCDZ
	eY/glM/WDnhVR6E0SMhuBd4wpj+WVVIyj5mV1YMSZvntlPm6KEfGgB9cw1swvBq1YPjdWCYhP
	wXivyJjXQ5evZV3iX4tmDwZnFcyJbXnCkwZMAwTEbI7o0i8D5ddjzGGhCfIxo8/UOZv9Sc7Bx
	b3iZRCOl0nqISA=
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1ANN7TEC026793
X-loop: dm-devel@redhat.com
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [dm-devel] Any bio_clone_slow() implementation which doesn't
 share bi_io_vec?
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"



On 2021/11/23 22:28, hch@infradead.org wrote:
> On Tue, Nov 23, 2021 at 11:39:11AM +0000, Johannes Thumshirn wrote:
>> I think we have to differentiate two cases here:
>> A "regular" REQ_OP_ZONE_APPEND bio and a RAID stripe REQ_OP_ZONE_APPEND
>> bio. The 1st one (i.e. the regular REQ_OP_ZONE_APPEND bio) can't be split
>> because we cannot guarantee the order the device writes the data to disk.

That's correct.

But if we want to move all bio split into chunk layer, we want a initial
bio without any limitation, and then using that bio to create real
REQ_OP_ZONE_APPEND bios with proper size limitations.

>> For the RAID stripe bio we can split it into the two (or more) parts that
>> will end up on _different_ devices. All we need to do is a) ensure it
>> doesn't cross the device's zone append limit and b) clamp all
>> bi_iter.bi_sector down to the start of the target zone, a.k.a sticking to
>> the rules of REQ_OP_ZONE_APPEND.
>
> Exactly.  A stacking driver must never split a REQ_OP_ZONE_APPEND bio.
> But the file system itself can of course split it as long as each split
> off bio has it's own bi_end_io handler to record where it has been
> written to.
>

This makes me wonder, can we really forget the zone thing for the
initial bio so we just create a plain bio without any special
limitation, and let every split condition be handled in the lower layer?

Including raid stripe boundary, zone limitations etc.

(yeah, it's still not pure stacking driver, but it's more
stacking-driver like).

In that case, the missing piece seems to be a way to convert a splitted
plain bio into a REQ_OP_ZONE_APPEND bio.

Can this be done without slow bvec copying?

Thanks,
Qu


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


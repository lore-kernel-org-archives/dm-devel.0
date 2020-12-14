Return-Path: <SRS0=VSmt=FT=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B655DC4361B
	for <dm-devel@archiver.kernel.org>; Tue, 15 Dec 2020 10:00:20 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C4774221FF
	for <dm-devel@archiver.kernel.org>; Tue, 15 Dec 2020 10:00:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C4774221FF
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codemonkey.org.uk
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-409-WY7YbK9XOYyfTNbiARcTuQ-1; Tue, 15 Dec 2020 05:00:16 -0500
X-MC-Unique: WY7YbK9XOYyfTNbiARcTuQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3F2AD8030A2;
	Tue, 15 Dec 2020 10:00:11 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1EF7076E3C;
	Tue, 15 Dec 2020 10:00:11 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E4E411809CA0;
	Tue, 15 Dec 2020 10:00:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BEIAXIU012196 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 14 Dec 2020 13:10:33 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id E33701132E; Mon, 14 Dec 2020 18:10:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DDEBA2EFB1
	for <dm-devel@redhat.com>; Mon, 14 Dec 2020 18:10:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AB418101A53F
	for <dm-devel@redhat.com>; Mon, 14 Dec 2020 18:10:30 +0000 (UTC)
Received: from scorn.kernelslacker.org (scorn.kernelslacker.org
	[45.56.101.199]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-70-1kk-jDJKMR6OgFHHaMktWA-1; Mon, 14 Dec 2020 13:10:27 -0500
X-MC-Unique: 1kk-jDJKMR6OgFHHaMktWA-1
Received: from [2601:196:4600:6634:ae9e:17ff:feb7:72ca]
	(helo=wopr.kernelslacker.org)
	by scorn.kernelslacker.org with esmtp (Exim 4.92)
	(envelope-from <davej@codemonkey.org.uk>)
	id 1korfY-0004o6-Dt; Mon, 14 Dec 2020 12:29:56 -0500
Received: by wopr.kernelslacker.org (Postfix, from userid 1026)
	id 08F3C56016E; Mon, 14 Dec 2020 12:29:56 -0500 (EST)
Date: Mon, 14 Dec 2020 12:29:55 -0500
From: Dave Jones <davej@codemonkey.org.uk>
To: Jens Axboe <axboe@kernel.dk>
Message-ID: <20201214172955.GA9066@codemonkey.org.uk>
Mail-Followup-To: Dave Jones <davej@codemonkey.org.uk>,
	Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>,
	Greg KH <gregkh@linuxfoundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-block@vger.kernel.org, dm-devel@redhat.com
References: <CAHk-=whCKhxNyKn1Arut8xUDKTwp3fWcCj_jbL5dbzkUmo45gQ@mail.gmail.com>
	<20201214053147.GA24093@codemonkey.org.uk>
	<X9b9ujh5T6U5+aBY@kroah.com> <20201214160247.GA2090@redhat.com>
	<20201214162631.GA2290@redhat.com>
	<6522caad-bfe8-2554-2ba9-dff5856233d1@kernel.dk>
MIME-Version: 1.0
In-Reply-To: <6522caad-bfe8-2554-2ba9-dff5856233d1@kernel.dk>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Tue, 15 Dec 2020 04:59:49 -0500
Cc: Mike Snitzer <snitzer@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [dm-devel] Linux 5.10
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Dec 14, 2020 at 10:21:59AM -0700, Jens Axboe wrote:
 
 > >>>> [   87.290698] attempt to access beyond end of device
 > >>>>                md0: rw=4096, want=13996467328, limit=6261202944
 > >>>> [   87.293371] attempt to access beyond end of device
 > >>>>                md0: rw=4096, want=13998564480, limit=6261202944
 > >>>> [   87.296045] BTRFS warning (device md0): couldn't read tree root
 > >>>> [   87.300056] BTRFS error (device md0): open_ctree failed
 > >>>>
 > >>>> Reverting it goes back to the -rc7 behaviour where it mounts fine.
 > >>>
 > >>> If the developer/maintainer(s) agree, I can revert this and push out a
 > >>> 5.10.1, just let me know.
 > >>
 > >> Yes, these should be reverted from 5.10 via 5.10.1:
 > >>
 > >> e0910c8e4f87 dm raid: fix discard limits for raid1 and raid10
 > >> f075cfb1dc59 md: change mddev 'chunk_sectors' from int to unsigned
 > > 
 > > Sorry, f075cfb1dc59 was my local commit id, the corresponding upstream
 > > commit as staged by Jens is:
 > > 
 > > 6ffeb1c3f82 md: change mddev 'chunk_sectors' from int to unsigned
 > > 
 > > So please revert:
 > > 6ffeb1c3f822 md: change mddev 'chunk_sectors' from int to unsigned
 > > and then revert:
 > > e0910c8e4f87 dm raid: fix discard limits for raid1 and raid10
 > 
 > Working with Song on understanding the failure case here. raid6 was
 > tested prior to this being shipped. We'll be back with more soon...

FYI, mixup in my original mail, it was raid5  (I forgot I converted it from
raid6->raid5 a few months back).  But I wouldn't be surprised if they
were both equally affected given what that header touched.

	Dave

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


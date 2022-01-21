Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2AE0C433F5
	for <dm-devel@archiver.kernel.org>; Fri, 21 Jan 2022 16:51:21 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-671-3MiYc4JoNFqxYZfC6yscPQ-1; Fri, 21 Jan 2022 11:51:17 -0500
X-MC-Unique: 3MiYc4JoNFqxYZfC6yscPQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 95E188519E0;
	Fri, 21 Jan 2022 16:51:11 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5106A7E8EB;
	Fri, 21 Jan 2022 16:51:10 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BB8491809CB8;
	Fri, 21 Jan 2022 16:51:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20LGkZG8031519 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 21 Jan 2022 11:46:35 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 428887773; Fri, 21 Jan 2022 16:46:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3CAE176F0
	for <dm-devel@redhat.com>; Fri, 21 Jan 2022 16:46:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 874B52A84B72
	for <dm-devel@redhat.com>; Fri, 21 Jan 2022 16:46:28 +0000 (UTC)
Received: from c.mx.filmlight.ltd.uk (c.mx.filmlight.ltd.uk [54.76.112.217])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-582-1XAvD4ueNFOs6glkhuOr7Q-1; Fri, 21 Jan 2022 11:46:26 -0500
X-MC-Unique: 1XAvD4ueNFOs6glkhuOr7Q-1
Received: from localhost (localhost [127.0.0.1])
	by omni.filmlight.ltd.uk (Postfix) with ESMTP id CF61F40000DE
	for <dm-devel@redhat.com>; Fri, 21 Jan 2022 16:38:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 omni.filmlight.ltd.uk CF61F40000DE
Received: from smtpclient.apple
	(cpc122860-stev8-2-0-cust234.9-2.cable.virginm.net [81.111.212.235])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(Client did not present a certificate) (Authenticated sender: roger)
	by omni.filmlight.ltd.uk (Postfix) with ESMTPSA id AA3098010F0;
	Fri, 21 Jan 2022 16:38:03 +0000 (GMT)
From: Roger Willcocks <roger@filmlight.ltd.uk>
Mime-Version: 1.0 (Mac OS X Mail 15.0 \(3693.20.0.1.32\))
Message-Id: <747C2684-B570-473E-9146-E8AB53102236@filmlight.ltd.uk>
Date: Fri, 21 Jan 2022 16:38:03 +0000
To: dm-devel@redhat.com
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
Cc: Roger Willcocks <roger@filmlight.ltd.uk>
Subject: [dm-devel] Raid0 performance regression
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi folks,

we noticed a thirty percent drop in performance on one of our raid
arrays when switching from CentOS 6.5 to 8.4; it uses raid0-like
striping to balance (by time) access to a pair of hardware raid-6
arrays. The underlying issue is also present in the native raid0
driver so herewith the gory details; I'd appreciate your thoughts.

--

blkdev_direct_IO() calls submit_bio() which calls an outermost
generic_make_request() (aka submit_bio_noacct()).

md_make_request() calls blk_queue_split() which cuts an incoming
request into two parts with the first no larger than get_max_io_size()
bytes (which in the case of raid0, is the chunk size):

  R -> AB
  
blk_queue_split() gives the second part 'B' to generic_make_request()
to worry about later and returns the first part 'A'.

md_make_request() then passes 'A' to a more specific request handler,
In this case raid0_make_request().

raid0_make_request() cuts its incoming request into two parts at the
next chunk boundary:

A -> ab

it then fixes up the device (chooses a physical device) for 'a', and
gives both parts, separately, to generic make request()

This is where things go awry, because 'b' is still targetted to the
original device (same as 'B'), but 'B' was queued before 'b'. So we
end up with:

  R -> Bab

The outermost generic_make_request() then cuts 'B' at
get_max_io_size(), and the process repeats. Ascii art follows:


    /---------------------------------------------------/   incoming rq

    /--------/--------/--------/--------/--------/------/   max_io_size
      
|--------|--------|--------|--------|--------|--------|--------| chunks

|...=====|---=====|---=====|---=====|---=====|---=====|--......| rq out
      a    b  c     d  e     f  g     h  i     j  k     l

Actual submission order for two-disk raid0: 'aeilhd' and 'cgkjfb'

--

There are several potential fixes -

simplest is to set raid0 blk_queue_max_hw_sectors() to UINT_MAX
instead of chunk_size, so that raid0_make_request() receives the
entire transfer length and cuts it up at chunk boundaries;

neatest is for raid0_make_request() to recognise that 'b' doesn't
cross a chunk boundary so it can be sent directly to the physical
device;

and correct is for blk_queue_split to requeue 'A' before 'B'.

--

There's also a second issue - with large raid0 chunk size (256K), the
segments submitted to the physical device are at least 128K and
trigger the early unplug code in blk_mq_make_request(), so the
requests are never merged. There are legitimate reasons for a large
chunk size so this seems unhelpful.

--

As I said, I'd appreciate your thoughts.

--

Roger

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


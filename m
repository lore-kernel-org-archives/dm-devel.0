Return-Path: <SRS0=OloW=ME=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.5 required=3.0 tests=BAYES_00,DKIM_ADSP_ALL,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41A62C07E99
	for <dm-devel@archiver.kernel.org>; Mon, 12 Jul 2021 06:49:21 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A57766100B
	for <dm-devel@archiver.kernel.org>; Mon, 12 Jul 2021 06:49:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A57766100B
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-494-VDIBc4dRMaCgIEQKLkvsEg-1; Mon, 12 Jul 2021 02:49:17 -0400
X-MC-Unique: VDIBc4dRMaCgIEQKLkvsEg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 97C7A1084F6D;
	Mon, 12 Jul 2021 06:49:12 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 950285D9D5;
	Mon, 12 Jul 2021 06:49:11 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B458E4EA2A;
	Mon, 12 Jul 2021 06:49:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 169KkXo7032188 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 9 Jul 2021 16:46:33 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 5190D209D0E8; Fri,  9 Jul 2021 20:46:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4D0E6209A508
	for <dm-devel@redhat.com>; Fri,  9 Jul 2021 20:46:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BA81B18A01A5
	for <dm-devel@redhat.com>; Fri,  9 Jul 2021 20:46:29 +0000 (UTC)
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com
	[207.171.190.10]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-557-6KIULkR-ONycwf5DK1gSXA-1; Fri, 09 Jul 2021 16:46:27 -0400
X-MC-Unique: 6KIULkR-ONycwf5DK1gSXA-1
X-IronPort-AV: E=Sophos;i="5.84,227,1620691200"; d="scan'208";a="135471522"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO
	email-inbound-relay-2c-76e0922c.us-west-2.amazon.com)
	([10.25.36.210]) by smtp-border-fw-33001.sea14.amazon.com with ESMTP;
	09 Jul 2021 20:45:24 +0000
Received: from EX13MTAUWA001.ant.amazon.com
	(pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
	by email-inbound-relay-2c-76e0922c.us-west-2.amazon.com (Postfix) with
	ESMTPS id 8305AE255D; Fri,  9 Jul 2021 20:45:22 +0000 (UTC)
Received: from EX13D01UWA002.ant.amazon.com (10.43.160.74) by
	EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server
	(TLS) id 15.0.1497.18; Fri, 9 Jul 2021 20:45:22 +0000
Received: from localhost (10.43.160.41) by EX13d01UWA002.ant.amazon.com
	(10.43.160.74) with Microsoft SMTP Server (TLS) id 15.0.1497.18;
	Fri, 9 Jul 2021 20:45:21 +0000
Date: Fri, 9 Jul 2021 13:45:21 -0700
From: Samuel Mendoza-Jonas <samjonas@amazon.com>
To: Changheun Lee <nanich.lee@samsung.com>
Message-ID: <20210709204521.y3mg7wpejqctpkmi@u87e72aa3c6c25c.ant.amazon.com>
References: <alpine.LRH.2.02.2105140544010.22439@file01.intranet.prod.int.rdu2.redhat.com>
	<CGME20210514104426epcas1p3ee2f22f8e18c961118795c356e6a14ae@epcas1p3.samsung.com>
	<20210514102614.3804-1-nanich.lee@samsung.com>
MIME-Version: 1.0
In-Reply-To: <20210514102614.3804-1-nanich.lee@samsung.com>
User-Agent: NeoMutt/20171215
X-Originating-IP: [10.43.160.41]
X-ClientProxiedBy: EX13D43UWC004.ant.amazon.com (10.43.162.42) To
	EX13d01UWA002.ant.amazon.com (10.43.160.74)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 12 Jul 2021 02:49:05 -0400
Cc: axboe@kernel.dk, ming.lei@redhat.com, tytso@mit.edu, bvanassche@acm.org,
	bgoncalv@redhat.com, dm-crypt@saout.de,
	linux-kernel@vger.kernel.org, alex_y_xu@yahoo.ca, hch@lst.de,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	linux-nvme@lists.infradead.org, yi.zhang@redhat.com,
	jaegeuk@kernel.org, linux-ext4@vger.kernel.org, gmazyland@gmail.com
Subject: Re: [dm-devel] regression: data corruption with ext4 on LUKS on
 nvme with torvalds master
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, May 14, 2021 at 07:26:14PM +0900, Changheun Lee wrote:
> > On 5/13/21 7:15 AM, Theodore Ts'o wrote:
> > > On Thu, May 13, 2021 at 06:42:22PM +0900, Changheun Lee wrote:
> > >>
> > >> Problem might be casued by exhausting of memory. And memory exhausting
> > >> would be caused by setting of small bio_max_size. Actually it was not
> > >> reproduced in my VM environment at first. But, I reproduced same problem
> > >> when bio_max_size is set with 8KB forced. Too many bio allocation would
> > >> be occurred by setting of 8KB bio_max_size.
> > > 
> > > Hmm... I'm not sure how to align your diagnosis with the symptoms in
> > > the bug report.  If we were limited by memory, that should slow down
> > > the I/O, but we should still be making forward progress, no?  And a
> > > forced reboot should not result in data corruption, unless maybe there
> > 
> > If you use data=writeback, data writes and journal writes are not 
> > synchronized. So, it may be possible that a journal write made it through, 
> > a data write didn't - the end result would be a file containing random 
> > contents that was on the disk.
> > 
> > Changheun - do you use data=writeback? Did the corruption happen only in 
> > newly created files? Or did it corrupt existing files?
> 
> Actually I didn't reproduced data corruption. I only reproduced hang during
> making ext4 filesystem. Alex, could you check it?
> 
> > 
> > > was a missing check for a failed memory allocation, causing data to be
> > > written to the wrong location, a missing error check leading to the
> > > block or file system layer not noticing that a write had failed
> > > (although again, memory exhaustion should not lead to failed writes;
> > > it might slow us down, sure, but if writes are being failed, something
> > > is Badly Going Wrong --- things like writes to the swap device or
> > > writes by the page cleaner must succeed, or else Things Would Go Bad
> > > In A Hurry).
> > 
> > Mikulas

I've recently been debugging an issue that isn't this exact issue
(it occurs in 5.10), but looks somewhat similar.
On a host that
- Is running a kernel 5.4 >= x >= 5.10.47 at least
- Using an EXT4 + LUKS partition
- Running Elasticsearch stress tests

We see that the index files used by the Elasticsearch process become
corrupt after some time, and in each case I've seen so far the content
of the file looks like the EXT4 extent header. 
	#define EXT4_EXT_MAGIC          cpu_to_le16(0xf30a)

For example:
$ hexdump -C /hdd1/nodes/0/indices/c6eSGDlCRjaWeIBwdeo9DQ/0/index/_23c.si
00000000  0a f3 04 00 54 01 00 00  00 00 00 00 00 00 00 00  |....T...........|
00000010  00 38 00 00 00 60 46 05  00 38 00 00 00 88 00 00  |.8...`F..8......|
00000020  00 98 46 05 00 40 00 00  00 88 00 00 00 a0 46 05  |..F..@........F.|
00000030  00 48 00 00 00 88 00 00  00 a8 46 05 00 48 00 00  |.H........F..H..|
00000040  00 88 00 00 00 a8 46 05  00 48 00 00 00 88 00 00  |......F..H......|
00000050  00 a8 46 05 00 48 00 00  00 88 00 00 00 a8 46 05  |..F..H........F.|
00000060  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
000001a0  00 00                                             |..|
000001a2


I'm working on tracing exactly when this happens, but I'd be interested
to hear if that sounds familar or might have a similar underlying cause
beyond the commit that was reverted above.

Cheers,
Sam Mendoza-Jonas

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


Return-Path: <SRS0=TigA=PD=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9522AC433F5
	for <dm-devel@archiver.kernel.org>; Fri, 15 Oct 2021 06:24:14 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BF29560EE9
	for <dm-devel@archiver.kernel.org>; Fri, 15 Oct 2021 06:24:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org BF29560EE9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=tuxera.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-127-cq5P6PuNMZmJAJqFYtP9Qw-1; Fri, 15 Oct 2021 02:24:08 -0400
X-MC-Unique: cq5P6PuNMZmJAJqFYtP9Qw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 544B31808310;
	Fri, 15 Oct 2021 06:24:03 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7E6822B060;
	Fri, 15 Oct 2021 06:24:01 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2F4BB1809C81;
	Fri, 15 Oct 2021 06:23:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19E9rBri028551 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 14 Oct 2021 05:53:14 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 8D2F140CFD11; Thu, 14 Oct 2021 09:53:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8666C40CFD0E
	for <dm-devel@redhat.com>; Thu, 14 Oct 2021 09:53:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6D7E0185A7A4
	for <dm-devel@redhat.com>; Thu, 14 Oct 2021 09:53:11 +0000 (UTC)
Received: from mgw-01.mpynet.fi (mgw-01.mpynet.fi [82.197.21.90]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-581-uqliBTx3MU6CSceZqdd_qg-1; Thu, 14 Oct 2021 05:53:07 -0400
X-MC-Unique: uqliBTx3MU6CSceZqdd_qg-1
Received: from pps.filterd (mgw-01.mpynet.fi [127.0.0.1])
	by mgw-01.mpynet.fi (8.16.0.43/8.16.0.43) with SMTP id 19E9Pj42091529; 
	Thu, 14 Oct 2021 12:32:59 +0300
Received: from ex13.tuxera.com (ex13.tuxera.com [178.16.184.72])
	by mgw-01.mpynet.fi with ESMTP id 3bphjf80v4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
	Thu, 14 Oct 2021 12:32:59 +0300
Received: from tuxera-exch.ad.tuxera.com (10.20.48.11) by
	tuxera-exch.ad.tuxera.com (10.20.48.11) with Microsoft SMTP Server
	(TLS) id 15.0.1497.23; Thu, 14 Oct 2021 12:32:59 +0300
Received: from tuxera-exch.ad.tuxera.com ([fe80::552a:f9f0:68c3:d789]) by
	tuxera-exch.ad.tuxera.com ([fe80::552a:f9f0:68c3:d789%12]) with mapi id
	15.00.1497.023; Thu, 14 Oct 2021 12:32:59 +0300
From: Anton Altaparmakov <anton@tuxera.com>
To: Christoph Hellwig <hch@lst.de>
Thread-Topic: don't use ->bd_inode to access the block device size
Thread-Index: AQHXv/D8RnQWsWSgAkyxOdAYku+41KvR10wAgAAzeIA=
Date: Thu, 14 Oct 2021 09:32:58 +0000
Message-ID: <3AB8052D-DD45-478B-85F2-BFBEC1C7E9DF@tuxera.com>
References: <20211013051042.1065752-1-hch@lst.de>
	<20211014062844.GA25448@lst.de>
In-Reply-To: <20211014062844.GA25448@lst.de>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [109.154.241.177]
MIME-Version: 1.0
X-Proofpoint-ORIG-GUID: itBrsNbhZ2FR6MA_DlXhPV1L0UjW3zcs
X-Proofpoint-GUID: itBrsNbhZ2FR6MA_DlXhPV1L0UjW3zcs
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425, 18.0.790
	definitions=2021-10-14_02:2021-10-14,
	2021-10-14 signatures=0
X-Proofpoint-Spam-Details: rule=mpy_notspam policy=mpy score=0 spamscore=0
	mlxlogscore=453 bulkscore=0
	malwarescore=0 phishscore=0 mlxscore=0 adultscore=0 suspectscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2109230001 definitions=main-2110140057
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 19E9rBri028551
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 15 Oct 2021 02:19:28 -0400
Cc: Dave Kleikamp <shaggy@kernel.org>, "jfs-discussion@lists.sourceforge.net"
	<jfs-discussion@lists.sourceforge.net>, Mike Snitzer <snitzer@redhat.com>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Song Liu <song@kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>,
	"target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
	"linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
	"reiserfs-devel@vger.kernel.org" <reiserfs-devel@vger.kernel.org>,
	"drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>,
	"linux-nilfs@vger.kernel.org" <linux-nilfs@vger.kernel.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
	David Sterba <dsterba@suse.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Jens Axboe <axboe@kernel.dk>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>, "linux-ntfs-dev@lists.sourceforge.net"
	<linux-ntfs-dev@lists.sourceforge.net>, Jan Kara <jack@suse.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	Phillip Lougher <phillip@squashfs.org.uk>,
	"ntfs3@lists.linux.dev" <ntfs3@lists.linux.dev>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [dm-devel] don't use ->bd_inode to access the block device size
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
Content-Language: en-US
Content-ID: <F1129580E148624C920474BEC9F515C5@ex13.tuxera.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Christoph,

> On 14 Oct 2021, at 07:28, Christoph Hellwig <hch@lst.de> wrote:
> 
> On Wed, Oct 13, 2021 at 07:10:13AM +0200, Christoph Hellwig wrote:
>> I wondered about adding a helper for looking at the size in byte units
>> to avoid the SECTOR_SHIFT shifts in various places.  But given that
>> I could not come up with a good name and block devices fundamentally
>> work in sector size granularity I decided against that.
> 
> So it seems like the biggest review feedback is that we should have
> such a helper.  I think the bdev_size name is the worst as size does
> not imply a particular unit.  bdev_nr_bytes is a little better but I'm
> not too happy.  Any other suggestions or strong opinions?

bdev_byte_size() would seem to address your concerns?

bdev_nr_bytes() would work though - it is analogous to bdev_nr_sectors() after all.

No strong opinion here but I do agree with you that bdev_size() is a bad choice for sure.  It is bound to cause bugs down the line when people forget what unit it is in.

Best regards,

	Anton
-- 
Anton Altaparmakov <anton at tuxera.com> (replace at with @)
Lead in File System Development, Tuxera Inc., http://www.tuxera.com/
Linux NTFS maintainer


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


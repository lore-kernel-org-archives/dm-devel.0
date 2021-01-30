Return-Path: <SRS0=6nCw=HB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14CC7C433DB
	for <dm-devel@archiver.kernel.org>; Sat, 30 Jan 2021 03:57:27 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 49E1764DDE
	for <dm-devel@archiver.kernel.org>; Sat, 30 Jan 2021 03:57:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 49E1764DDE
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-47-Ekk9-alMP5C65M8luqoFhQ-1; Fri, 29 Jan 2021 22:57:22 -0500
X-MC-Unique: Ekk9-alMP5C65M8luqoFhQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E851D10054FF;
	Sat, 30 Jan 2021 03:57:16 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 856FB60BE2;
	Sat, 30 Jan 2021 03:57:15 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3D2C9180954D;
	Sat, 30 Jan 2021 03:57:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10U3v81e000331 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 29 Jan 2021 22:57:09 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id F2B302166B2A; Sat, 30 Jan 2021 03:57:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id ED4442166B27
	for <dm-devel@redhat.com>; Sat, 30 Jan 2021 03:57:05 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EC9A9858EEC
	for <dm-devel@redhat.com>; Sat, 30 Jan 2021 03:57:04 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-82-kTHxLneWOJOajImOOnaKMQ-1; Fri, 29 Jan 2021 22:57:02 -0500
X-MC-Unique: kTHxLneWOJOajImOOnaKMQ-1
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat
	Linux)) id 1l5hNO-00Afhm-T1; Sat, 30 Jan 2021 03:56:47 +0000
Date: Sat, 30 Jan 2021 03:56:46 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20210130035646.GH308988@casper.infradead.org>
References: <20210126145247.1964410-1-hch@lst.de>
	<20210126145247.1964410-5-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20210126145247.1964410-5-hch@lst.de>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 10U3v81e000331
X-loop: dm-devel@redhat.com
Cc: Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>,
	dm-devel@redhat.com, Naohiro Aota <naohiro.aota@wdc.com>,
	linux-nilfs@vger.kernel.org, Chao Yu <chao@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>,
	linux-raid@vger.kernel.org, linux-bcache@vger.kernel.org,
	David Sterba <dsterba@suse.com>, drbd-dev@tron.linbit.com,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	Damien Le Moal <damien.lemoal@wdc.com>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	Philipp Reisner <philipp.reisner@linbit.com>,
	linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	linux-nfs@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 04/17] block: split bio_kmalloc from
	bio_alloc_bioset
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Jan 26, 2021 at 03:52:34PM +0100, Christoph Hellwig wrote:
> bio_kmalloc shares almost no logic with the bio_set based fast path
> in bio_alloc_bioset.  Split it into an entirely separate implementation.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/bio.c         | 167 ++++++++++++++++++++++----------------------
>  include/linux/bio.h |   6 +-
>  2 files changed, 86 insertions(+), 87 deletions(-)

This patch causes current linux-next to OOM for me when running xfstests
after about ten minutes.  Haven't looked into why yet, this is just the
results of a git bisect.

The qemu command line is:

qemu-system-x86_64 -nodefaults -nographic -cpu host -machine accel=kvm,nvdimm -m 2G,slots=8,maxmem=1T -smp 6 -kernel /home/willy/kernel/folio/.build_test_kernel-x86_64/kpgk/vmlinuz -append console=hvc0 root=/dev/sda rw log_buf_len=8M ktest.dir=/home/willy/kernel/ktest ktest.env=/tmp/build-test-kernel-nJO6QgxOmo/env quiet systemd.show_status=0 systemd.log-target=journal crashkernel=128M no_console_suspend -device virtio-serial -chardev stdio,id=console -device virtconsole,chardev=console -serial unix:/tmp/build-test-kernel-nJO6QgxOmo/vm-kgdb,server,nowait -monitor unix:/tmp/build-test-kernel-nJO6QgxOmo/vm-mon,server,nowait -gdb unix:/tmp/build-test-kernel-nJO6QgxOmo/vm-gdb,server,nowait -device virtio-rng-pci -virtfs local,path=/,mount_tag=host,security_model=none -device virtio-scsi-pci,id=hba -nic user,model=virtio,hostfwd=tcp:127.0.0.1:24674-:22 -drive if=none,format=raw,id=disk0,file=/var/lib/ktest/root.amd64,snapshot=on -device scsi-hd,bus=hba.0,drive=disk0 -drive if=none,format=
 raw,id=disk1,file=/tmp/build-test-kernel-nJO6QgxOmo/dev-1,cache=unsafe -device scsi-hd,bus=hba.0,drive=disk1 -drive if=none,format=raw,id=disk2,file=/tmp/build-test-kernel-nJO6QgxOmo/dev-2,cache=unsafe -device scsi-hd,bus=hba.0,drive=disk2 -drive if=none,format=raw,id=disk3,file=/tmp/build-test-kernel-nJO6QgxOmo/dev-3,cache=unsafe -device scsi-hd,bus=hba.0,drive=disk3


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [ Regressions ] linux next 20201008: blk_update_request: I/O
 error, dev sda, sector 0 op 0x1:(WRITE) flags 0x800 phys_seg 0 prio class
 0
Date: Thu, 08 Oct 2020 16:40:18 -0400
Message-ID: <yq1zh4w1mrq.fsf@ca-mkp.ca.oracle.com>
References: <CA+G9fYtwisRJtN4ht=ApeWc1jWssDok-7y2wee6Z0kzMP-atKg@mail.gmail.com>
        <CA+G9fYseTYRWoHUNZ=j4mjFs9dDJ-KOD8hDy+RnyDPx75HcVWw@mail.gmail.com>
        <24c8ee4d-d5f7-e49f-cd0c-7cf50a5fd885@kernel.dk>
        <20201008203058.GA27821@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20201008203058.GA27821@lst.de> (Christoph Hellwig's message of
        "Thu, 8 Oct 2020 22:30:58 +0200")
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Naresh Kamboju <naresh.kamboju@linaro.org>, dm-devel@redhat.com, open list <linux-kernel@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, drbd-dev@tron.linbit.com, "open list:LIBATA SUBSYSTEM (Serial and Parallel ATA drivers)" <linux-ide@vger.kernel.org>, linux-raid@vger.kernel.org, linux-mmc <linux-mmc@vger.kernel.org>, Linux-Next Mailing List <linux-next@vger.kernel.org>, lkft-triage@lists.linaro.org, Song Liu <song@kernel.org>, Ulf Hansson <ulf.hansson@linaro.org>, Stephen Rothwell <sfr@canb.auug.org.au>, martin.petersen@oracle.com, Hannes Reinecke <hare@suse.de>
List-Id: dm-devel.ids


Christoph,

> On Thu, Oct 08, 2020 at 02:17:41PM -0600, Jens Axboe wrote:
>> Just for everyones edification, that would be these 9 patches from the
>> SCSI tree:
>
> I sent the fixes out a bit ago and Cced the reporters..

I do not have any libata-connected devices in the SCSI test setup so
things worked fine for me yesterday. I have a retired Nehalem server in
the rack which has a couple of ATA 500GB disk drives in it. I'll try to
see if I can add that to my test pool. Just for good measure.

In any case the fixes are now in my for-next branch:

b6ba9b0e201a scsi: core: Set sc_data_direction to DMA_NONE for no-transfer commands
9120ac54cce6 scsi: sr: Initialize ->cmd_len

-- 
Martin K. Petersen	Oracle Linux Engineering

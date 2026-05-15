Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C96334CA266
	for <dm-devel@lists.linux.dev>; Fri, 15 May 2026 16:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778863994; cv=pass; b=ejqsaTnwJiq+trOJlaN3ZRNzHUC2K2bfiiTXVEMotRhUNZpRV5oRF6d+u7JLE66H+MOPAFIefSdDphXs3qmL0Wrawq8mFtGH1fx+EjU+5uxfu2T/Sl/FSSiStQP6rk0WRUry9QGSsy2d41WTrz28+JmG0tWTsGxdrwfEtPKj3v4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778863994; c=relaxed/simple;
	bh=oour2uG5iRfmu2ayrytJIqDx9R0+oLFFwOaMHB+gtAU=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=MFDkYSA3Fz7yNvJhWhSAJh0VV5vQr3K0+W0gB+Z6qWciZT0OaZMEvPG+OCaUkCB1CKjdLxHNvJIYz9hJr0WnRZ/Wp/zpBCjIMfrmV4dgdoxDMMSN9tjJ+smNxXGF5uH9W7thMnOaTXuxK4gjoEHKeDWmY0OxmDjiN5oWfa8mt3k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EPb1XMpv; arc=pass smtp.client-ip=209.85.208.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EPb1XMpv"
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-393b0fa758fso87201fa.3
        for <dm-devel@lists.linux.dev>; Fri, 15 May 2026 09:53:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778863991; cv=none;
        d=google.com; s=arc-20240605;
        b=TSQ7gG8M7boGubC3mXOJ5si2qZmk3wZ65uYbLOlc3FY60olwk9Q3epqxWw3IkshfRA
         Kc1lsS1UpPrnk3XQ/1ISGFQ124NDxrdD5jaFCStO8fKMi/N6Dz3ybG9J8MED9q9rO/zD
         542ARJdQEtx+atzLG3rUH1ubmG4NCOYb4sb4AzwcTOAmLdC4tN7eLr6H1tJTsPeCy30O
         yca9Ee0+1wTH7UduewzAsagxVo4V9tIwJCdgqOYMiDn9mUezU0XYf9imn0BgJhfJq3Jf
         ldWjt5ia2AKpxx2HacnxtZMlWlXPK/pmY+d6A19gLL3QMIs8gTYYM5WaqqVLOkKADQT6
         itNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=QyIEXMzo0LLWlJtxbIVaApvLffeGdlkhSdDar+auJNA=;
        fh=LKr8JtfwIXNmiUaFVVXeNlTVxBw8Mot146BmqiWdDrw=;
        b=gm3yDGB0Ss9WBEbAchdKMjjKLYvt3gO+UFnZhXubGDwWDbdudnYOnsc9dgG3QjGjBz
         y3AMi4rjKfNN7lJqTocjCcBStHEGq7e/IAZReIyuzfh5YIcgjFVm/1iMEQ1jmFjjuq48
         KGgDKr/8K/ddvZs6OYALI3MZjc3+/G0Pp7QTdXPaB4Y8/3MgPyYVc3LhRwqaaZkd4Ux0
         Ml/X+mkCojLlOBvSx48zblJkQ9yBM1auvLblolw4Nc8VGOHBOIEjXqKBaEa9rfMZWb0b
         kiZ0+OBnaZApbMvqxolpKU//dg2EDOl/M/iiwhW2Z+K7w0yaUZ63BABXwB+8rrER+aai
         /FOg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778863991; x=1779468791; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=QyIEXMzo0LLWlJtxbIVaApvLffeGdlkhSdDar+auJNA=;
        b=EPb1XMpvDwMMReBdXckAp/4bbVzNrkWASYtSzpxRiPTFXks6S3G5KoCYsjxCjuOCgU
         +GekDLeaqkqVl08md07mv5146ZoeyrA9pE+ygrPezGjCs5xTj0WbsxgOPw+dXKTZ71to
         7wp5IOdXDlFjCx1v111xoURyurt1CZe5UzGY/E3BPK0n8oedWF/qgYsVgUd+fiU5y4aa
         Pc9p4nllrqvCryEonPqSd0DSTjieQ9i0SgHDsrcc3BjT7fz9cwss6l9C+vYBhg7BymjT
         9abHNlJbt1+Wnn6eAAkBIdTU5Sy9IqsGcTBu9WfpL+H0NlqW2Q3GewhvKtahFljCEuWQ
         Zg1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778863991; x=1779468791;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QyIEXMzo0LLWlJtxbIVaApvLffeGdlkhSdDar+auJNA=;
        b=Rv0G0F4mJGzVkGw7J89EovN16Vu7R1Z2od1zqeBYTNdix5+On651WMDN3/iPZvGp21
         GRaRMYUxWZB2MvqQ5Qp1v9QkLN1asLP++/rkaSixsxw9y90FQhczk+aS41K1ZSWz3MDM
         el3JdzAel+HN6Ae+45D1ta2X/NjN1MfhaDEHfVLPWucbtZQuq4eEQCUaxCU9cXHUMI49
         vtviUe1YBm8JIUL2EFhLQ6/Mh6xVd2Bqzh9vrlfCh+4qcu3eoFPSCqGRI4vl2+qDJIYj
         SDWfb0YVcFeb2PsDdcw7dsoKlgocxMwW8mUTdTgZ18F39MwIByOrlBrLL3/CA0iRiiC5
         ME6g==
X-Forwarded-Encrypted: i=1; AFNElJ/pfrmFwUgp+V16n05sgfWR47A7l/FLM7V/BOQOnMCH3tkBKYLxHNMzLsOLFWQWrtT8MtOGvKPZdg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw9hRF83qFYAyg01TikhnIt0Qqf8XKK2S9ObxFE2CRPu8pdKzuf
	DfN4PqZf3/hR3RUxD+sLPzP8hGV2EvkZZc98KcOMdCOPXiJWh6Jk8EKZcQkGtJyhDk941oaUYpv
	x1vdSgr9vpVc5f8pvCRt+noN7WRU3+q8=
X-Gm-Gg: Acq92OEVAZ67ogZeKSnzK144C43HDSW3nzapLZbfWE2fRJUXV5aZB2st9uZzxganCPx
	CEXGvlflAMeZ10nRZunDri/bjex/dHonChlIysPz5/8bCj+ZF7Hyfyv+9GSLyg+9WnbYsqGAtLI
	5t3lpglgLrpJOwOloTTkJjbmIYfYIzq2UzPg5UOuufMMegS/QYpQYx94znpd6MwB2/+4Nx0h0Wx
	caolpGGqXNwqp0GuFDV4fGnPM3lYFcRukUjdTXqz3mHhtmmT9RoiWbp0njPN8hmJQCkYZGoLVts
	BDpbJcw=
X-Received: by 2002:a05:6512:108a:b0:5a4:19de:eb77 with SMTP id
 2adb3069b0e04-5aa0e74c40emr560236e87.3.1778863990648; Fri, 15 May 2026
 09:53:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: Vjaceslavs Klimovs <vklimovs@gmail.com>
Date: Fri, 15 May 2026 09:52:59 -0700
X-Gm-Features: AVHnY4K5KLdo5SUY6rORreRp5hLSJu5MynIgl0mmY702h5swQNzKJAuKAe4ZMPI
Message-ID: <CAC_j7i1R7oy+nRhxEjCTba=DUgn02w9X+p94DCu0aHv5+5tKnQ@mail.gmail.com>
Subject: [REGRESSION] block: virtio-blk + LVM raid1 spurious sector-0 read
 failures on libaio/threads submit since 5ff3f74e145a ("block: simplify direct
 io validity check")
To: Jens Axboe <axboe@kernel.dk>
Cc: Keith Busch <kbusch@kernel.org>, Hannes Reinecke <hare@suse.de>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, 
	linux-raid@vger.kernel.org, dm-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org, regressions@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Summary
-------
On v6.18, starting a libvirt/QEMU guest with virtio-blk backed by an
LVM "--type raid1" LV (drivers/md/dm-raid.c stacked on
drivers/md/raid1.c) makes md/raid1 register read failures at LV
sector 0 within seconds of "virsh start" and mark rimage_0 Faulty
once max_corrected_read_errors (default 20) is exceeded. Reads
succeed via the redirect path so guests boot, but every guest disk
ends up degraded on every VM start. Same workload on legacy
"--type mirror" (drivers/md/dm-raid1.c) crashes the host: a
zero-length READ reaches the NVMe controller, is rejected with
"Invalid Field in Command", and the dm-mirror recovery path oopses.

Symptom on dm-raid raid1 (post --type raid1)
--------------------------------------------
Per LV, at virsh start, in host dmesg:

  kernel: raid1_end_read_request: 95 callbacks suppressed
  kernel: raid1_read_request: 95 callbacks suppressed
  kernel: md/raid1:mdX: dm-58: rescheduling sector 0
  kernel: md/raid1:mdX: redirecting sector 0 to other mirror: dm-58
  kernel: md/raid1:mdX: dm-58: rescheduling sector 0
  kernel: md/raid1:mdX: redirecting sector 0 to other mirror: dm-58
  [... 10 rescheduling/redirecting pairs ...]
  kernel: md/raid1:mdX: dm-58: Raid device exceeded read_error
threshold [cur 21:max 20]
  kernel: md/raid1:mdX: dm-58: Failing raid device
  kernel: md/raid1:mdX: Disk failure on dm-58, disabling device.
  kernel: md/raid1:mdX: Operation continuing on 1 devices.

  dmeventd: WARNING: Device #0 of raid1 array, vg0-iris_boot, has failed.
  dmeventd: WARNING: Waiting for resynchronization to finish before
initiating repair on RAID device vg0-iris_boot.
  dmeventd: Use 'lvconvert --repair vg0/iris_boot' to replace failed device.

Subsequent "lvs -a":

  WARNING: RaidLV vg0/iris_boot needs to be refreshed!
  See character 'r' at position 9 in the RaidLV's attributes and its SubLV(s).

dmesg | grep nvme is EMPTY on this path. The NVMe driver is not
involved in producing the error; the failure originates between the
virtio-blk bio submission and raid1_end_read_request().

Symptom on legacy dm-mirror (pre-conversion --type mirror)
----------------------------------------------------------
Same workload on drivers/md/dm-raid1.c reaches the NVMe controller
as a zero-length READ and panics the host through dm-mirror's
recovery path:

  kernel: operation not supported error, dev nvme1n1, sector 935446535
op 0x0:(READ) flags 0x0 phys_seg 0 prio class 2
  kernel: nvme1n1: I/O Cmd(0x2) @ LBA 935446535, 0 blocks, I/O Error
(sct 0x0 / sc 0x2)
  [... 10+ identical bursts at same timestamp ...]
  dmeventd: Primary mirror device 252:58 read failed.
  dmeventd: vg0-iris_boot is now in-sync.
  [kernel oops in dm_mirror recovery path, full trace lost to console flash]

The "phys_seg 0", "0 blocks", "sct 0x0/sc 0x2" trio (NVMe Generic,
Invalid Field in Command, NVMe spec 4.1.1.2) is unambiguous: a bio
with bi_iter.bi_size == 0 and bi_vcnt == 0 left the block layer and
hit the controller. dm-raid raid1 hides this by retrying on the
surviving leg, but the upstream-of-md trigger is identical.

Bisect
------
git bisect, v6.12..v6.18, 16 deterministic GOOD/BAD steps, no skips,
~104 minutes:

  5ff3f74e145adc79b49668adb8de276446acf6be is the first bad commit
  block: simplify direct io validity check

  --- a/block/fops.c
  +++ b/block/fops.c
  @@ -38,8 +38,8 @@ static blk_opf_t dio_bio_write_op(struct kiocb *iocb)
   static bool blkdev_dio_invalid(struct block_device *bdev, struct kiocb *iocb,
                                  struct iov_iter *iter)
   {
  -        return iocb->ki_pos & (bdev_logical_block_size(bdev) - 1) ||
  -                !bdev_iter_is_aligned(bdev, iter);
  +        return (iocb->ki_pos | iov_iter_count(iter)) &
  +                        (bdev_logical_block_size(bdev) - 1);
   }

The dropped bdev_iter_is_aligned() used to walk the iov_iter and
reject per-segment misaligned/degenerate vectors at the blkdev fops
entry point. The replacement only validates ki_pos and total length
against the logical block size. Cases that now pass that no longer
get rejected:

  - iter with iov_iter_count(iter) == 0  (degenerate; total length is
    "sector-aligned" since 0 % 512 == 0)
  - iter where total length is sector-aligned but a segment isn't

The commit message justifies the removal with "The block layer
checks all the segments for validity later". This is true for the
io_uring submit path (which enters __blkdev_direct_IO directly and
does its own validation) but not for the libaio aio_read/write_iter
or the worker-pool sync read/write_iter paths that enter via
blkdev_{read,write}_iter() -> blkdev_dio_invalid(). For those paths,
the segment check has no replacement.

Reproducing
----------------------------------------------------------

The trigger requires QEMU virtio-blk's specific submission shape AND
a non-io_uring submit. Userspace libaio alone, userspace
preadv-in-a-thread alone, and QEMU's raw-driver open probes (which
qemu-img info exercises identically) are all insufficient. The
combination that hits the bug is "guest-driven I/O through
virtio-blk-pci with cache.direct=on and aio in {native, threads}".

#regzbot introduced: 5ff3f74e145adc79b49668adb8de276446acf6be

Thanks,
Vjaceslavs Klimovs

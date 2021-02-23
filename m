Return-Path: <SRS0=Sgdu=HZ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BD74C433E0
	for <dm-devel@archiver.kernel.org>; Tue, 23 Feb 2021 16:52:49 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C1FEA64E60
	for <dm-devel@archiver.kernel.org>; Tue, 23 Feb 2021 16:52:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C1FEA64E60
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-385-0St4FGDJPRKT_hJD-7P7qA-1; Tue, 23 Feb 2021 11:52:44 -0500
X-MC-Unique: 0St4FGDJPRKT_hJD-7P7qA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7BA3A107ACE6;
	Tue, 23 Feb 2021 16:52:39 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D5F2560936;
	Tue, 23 Feb 2021 16:52:38 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0312F4EA32;
	Tue, 23 Feb 2021 16:52:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11NGpr89001999 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 23 Feb 2021 11:51:53 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 22ADFF49A1; Tue, 23 Feb 2021 16:51:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1C5F9F783C
	for <dm-devel@redhat.com>; Tue, 23 Feb 2021 16:51:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 41937967F60
	for <dm-devel@redhat.com>; Tue, 23 Feb 2021 16:51:46 +0000 (UTC)
Received: from mail-ua1-f53.google.com (mail-ua1-f53.google.com
	[209.85.222.53]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-420-dqb2C2lzM7awaa5CMMWkBg-1; Tue, 23 Feb 2021 11:51:13 -0500
X-MC-Unique: dqb2C2lzM7awaa5CMMWkBg-1
Received: by mail-ua1-f53.google.com with SMTP id m15so502089uah.7
	for <dm-devel@redhat.com>; Tue, 23 Feb 2021 08:51:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=BQZTt3RWxAHT7X2G1dusHZyy5pbdHfsZvlDfjbah2TI=;
	b=AGX9HS/VuHTQtBu95EmVgQp+VWGOET4rtUzIQcHI/J8YSFtpt6VelKPFakOs8Ec5UI
	KgZAgZz/u57jc9MgRsC0NBTi1pQ4alpX0gmdHo4GJ22oVy0UydLfFof3Cj+lW8+Ftv6H
	hW1wRfa5DDUJsDH17nfILEvTbSxJF3iEaXQmmFENR70RqV/NZmynt0rMSKskOIMEIhlj
	jM4hPj5PghVh/0lS6vGdOL7Rm9h3qd1m5XTDgBgTAHI74dxuil8CqAJcPzUVi3CRkPF1
	ZX6pHogL1aNhbQhc5h3hYs99W4tcefq7yy5hYRTV2h22cVBQpM+VGrim2t1Ayc68NC/5
	nvIw==
X-Gm-Message-State: AOAM530mZd+a6f8GFWoMQ3TkHY/dfQL7NVNk7tQ1sjE4WuWjNiD42TJj
	GT+zLeGlXKnS/YsM48qveVowEJZTDAd6JKt8O3Kx7A==
X-Google-Smtp-Source: ABdhPJxVk8cwstVcOoaD5HxjxaW2MeUnluqwlS4V0ukeCBAuOoobWux3ADbtBhV+VkdBOCQaA7DSLcoDYYkTTh1Ag74=
X-Received: by 2002:ab0:6ecf:: with SMTP id c15mr18403228uav.52.1614099073078; 
	Tue, 23 Feb 2021 08:51:13 -0800 (PST)
MIME-Version: 1.0
References: <20210222211528.848441-1-gmazyland@gmail.com>
In-Reply-To: <20210222211528.848441-1-gmazyland@gmail.com>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Tue, 23 Feb 2021 08:51:01 -0800
Message-ID: <CABCJKufZjA4G4-ncU_+8aS_SS9wU5frFyCThxVg2i-rBTu-KkQ@mail.gmail.com>
To: Milan Broz <gmazyland@gmail.com>
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
Cc: device-mapper development <dm-devel@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [dm-devel] [PATCH] dm-verity: Fix FEC for RS roots non-aligned
	to block size
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Milan,

On Mon, Feb 22, 2021 at 1:15 PM Milan Broz <gmazyland@gmail.com> wrote:
>
> Optional Forward Error Correction (FEC) code in dm-verity uses
> Reed-Solomon code and should support roots from 2 to 24.
>
> The error correction parity bytes (of roots lengths per RS block) are stored
> on a separate device in sequence without any padding.
>
> Currently, to access FEC device, the dm-verity-fec code uses dm-bufio client
> with block size set to verity data block (usually 4096 or 512 bytes).
>
> Because this block size is not divisible by some (most!) of the roots
> supported lengths, data repair cannot work for partially stored
> parity bytes.

Ah, good catch!

> This patch changes FEC device dm-bufio block size to "roots << SECTOR_SHIFT"
> where we can be sure that the full parity data is always available.
> (There cannot be partial FEC blocks because parity must cover whole sectors.)
>
> Because the optional FEC starting offset could be unaligned to this
> new block size, we have to use dm_bufio_set_sector_offset() to configure it.
>
> The problem is easily reproducible using veritysetup,
> here for example for roots=13:
>
>   # create verity device with RS FEC
>   dd if=/dev/urandom of=data.img bs=4096 count=8 status=none
>   veritysetup format data.img hash.img --fec-device=fec.img --fec-roots=13 | awk '/^Root hash/{ print $3 }' >roothash
>
>   # create an erasure that should be always repairable with this roots setting
>   dd if=/dev/zero of=data.img conv=notrunc bs=1 count=8 seek=4088 status=none
>
>   # try to read it through dm-verity
>   veritysetup open data.img test hash.img --fec-device=fec.img --fec-roots=13 $(cat roothash)
>   dd if=/dev/mapper/test of=/dev/null bs=4096 status=noxfer
>   # wait for possible recursive recovery in kernel
>   udevadm settle
>   veritysetup close test
>
> Without it, FEC code usually ends on unrecoverable failure in RS decoder:
>   device-mapper: verity-fec: 7:1: FEC 0: failed to correct: -74
>   ...
>
> With the patch, errors are properly repaired.
>   device-mapper: verity-fec: 7:1: FEC 0: corrected 8 errors
>   ...
>
> This problem is present in all kernels since the FEC code introduction (kernel 4.5).
>
> AFAIK the problem is not visible in Android  ecosystem because it always
> use default RS roots=2.

That's correct, Android always uses the default value to minimize
space overhead, which is why we never ran into this.

>
> Signed-off-by: Milan Broz <gmazyland@gmail.com>
> ---
>  drivers/md/dm-verity-fec.c | 23 +++++++++++++----------
>  1 file changed, 13 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
> index fb41b4f23c48..be170581eb69 100644
> --- a/drivers/md/dm-verity-fec.c
> +++ b/drivers/md/dm-verity-fec.c
> @@ -61,18 +61,18 @@ static int fec_decode_rs8(struct dm_verity *v, struct dm_verity_fec_io *fio,
>  static u8 *fec_read_parity(struct dm_verity *v, u64 rsb, int index,
>                            unsigned *offset, struct dm_buffer **buf)
>  {
> -       u64 position, block;
> +       u64 position, block, rem;
>         u8 *res;
>
>         position = (index + rsb) * v->fec->roots;
> -       block = position >> v->data_dev_block_bits;
> -       *offset = (unsigned)(position - (block << v->data_dev_block_bits));
> +       block = div64_u64_rem(position, v->fec->roots << SECTOR_SHIFT, &rem);
> +       *offset = (unsigned)rem;
>
> -       res = dm_bufio_read(v->fec->bufio, v->fec->start + block, buf);
> +       res = dm_bufio_read(v->fec->bufio, block, buf);
>         if (IS_ERR(res)) {
>                 DMERR("%s: FEC %llu: parity read failed (block %llu): %ld",
>                       v->data_dev->name, (unsigned long long)rsb,
> -                     (unsigned long long)(v->fec->start + block),
> +                     (unsigned long long)(block),

Nit: parentheses not needed around block.

>                       PTR_ERR(res));
>                 *buf = NULL;
>         }
> @@ -155,7 +155,7 @@ static int fec_decode_bufs(struct dm_verity *v, struct dm_verity_fec_io *fio,
>
>                 /* read the next block when we run out of parity bytes */
>                 offset += v->fec->roots;
> -               if (offset >= 1 << v->data_dev_block_bits) {
> +               if (offset >= (v->fec->roots << SECTOR_SHIFT)) {

Same here, but I suppose it might help with readability.

>                         dm_bufio_release(buf);
>
>                         par = fec_read_parity(v, rsb, block_offset, &offset, &buf);
> @@ -674,7 +674,7 @@ int verity_fec_ctr(struct dm_verity *v)
>  {
>         struct dm_verity_fec *f = v->fec;
>         struct dm_target *ti = v->ti;
> -       u64 hash_blocks;
> +       u64 hash_blocks, start_blocks, fec_blocks;
>         int ret;
>
>         if (!verity_fec_is_enabled(v)) {
> @@ -744,15 +744,18 @@ int verity_fec_ctr(struct dm_verity *v)
>         }
>
>         f->bufio = dm_bufio_client_create(f->dev->bdev,
> -                                         1 << v->data_dev_block_bits,
> +                                         f->roots << SECTOR_SHIFT,
>                                           1, 0, NULL, NULL);
>         if (IS_ERR(f->bufio)) {
>                 ti->error = "Cannot initialize FEC bufio client";
>                 return PTR_ERR(f->bufio);
>         }
>
> -       if (dm_bufio_get_device_size(f->bufio) <
> -           ((f->start + f->rounds * f->roots) >> v->data_dev_block_bits)) {
> +       dm_bufio_set_sector_offset(f->bufio, f->start << v->data_dev_block_bits >> SECTOR_SHIFT);
> +
> +       start_blocks = div64_u64(f->start << v->data_dev_block_bits, v->fec->roots << SECTOR_SHIFT);
> +       fec_blocks   = div64_u64(f->rounds * f->roots, v->fec->roots << SECTOR_SHIFT);
> +       if (dm_bufio_get_device_size(f->bufio) < (start_blocks + fec_blocks)) {
>                 ti->error = "FEC device is too small";
>                 return -E2BIG;
>         }

I haven't tested the code, but it looks correct to me. Thanks for fixing this!

Reviewed-by: Sami Tolvanen <samitolvanen@google.com>

Sami

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


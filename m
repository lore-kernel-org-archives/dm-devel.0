Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 964603D0905
	for <dm-devel@lists.linux.dev>; Tue,  4 Aug 2026 15:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785856717; cv=none; b=OAy+81DNOC2GoDzxKd2bm000cATEpRuAmVX+ZjfS4bglei+nglTNk3DnuewXGGoWBscSiAfAhcRmiEwoCEa+ReTz4QiezQ0tMUQ2nNfZ9IYtxBBjvSoFFCk5vmMZfLfBdnmSrPqOGGEjPiKgRY9Mitv9dRymGy4FOYvrJjxn3WY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785856717; c=relaxed/simple;
	bh=4UrpMWkmQVjVeMfanMeYsEb1NJP6/UIHBXDp7z9dGaw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=A9f2eQyqFqVaMvn2Kcv9RFfmHep1FIyp/NVRwYIKVKx/TgoDBylH4K+XRAp5i0JyaxPS44B4e5el4YBg1zewlCbowmrUtInDmZ9z/AE9BT8TVpHdyf5K8cNuJxRs7PnXqunneOtOgOsEyQWQCXCu+C46q6yJ7BQYQtOjESC4mzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BMeKznRc; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BMeKznRc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785856714;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Zj7ba29dQJND2oSpVrWPCFdiWCJWCvNj5vKIOwOJW/4=;
	b=BMeKznRcYIYSB/Y0E32WWUXi1v99oT58lDfhegw3o4w/HG3NgoBEQlB5LaPjReLAuIPlLR
	7N93taLugD+zQkp4B2HattzUe0NoqSKv/XK2NMXub4D7uyz1ATvmHTT+SMSG50SufqoH7S
	QXuNc6vzCIYnwNitN0gTJhkq9oSUXsM=
Received: from mail-yx1-f72.google.com (mail-yx1-f72.google.com
 [74.125.224.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-480-q681EXGYNS2TnHOo-XPYmg-1; Tue, 04 Aug 2026 11:18:33 -0400
X-MC-Unique: q681EXGYNS2TnHOo-XPYmg-1
X-Mimecast-MFC-AGG-ID: q681EXGYNS2TnHOo-XPYmg_1785856712
Received: by mail-yx1-f72.google.com with SMTP id 956f58d0204a3-66931a828c0so6992742d50.0
        for <dm-devel@lists.linux.dev>; Tue, 04 Aug 2026 08:18:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785856712; x=1786461512;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Zj7ba29dQJND2oSpVrWPCFdiWCJWCvNj5vKIOwOJW/4=;
        b=DT8i1XxIJJsddWXuIt3ETkX+K/gGJegzb+xfpQSOJCDOxGNXiSUvrjkjIcw6CG271w
         pLAWP1q3VwWLhTLsIzznfNSz8TaHsZwVANA8JUPqeAXCD8qkQLV/0YvSP5cD4o0uDChr
         Dt+CLrkxr3+owGc38WHs7ymOQ1vs03vZMBHpzFYpes/wxmLj43j4lKMbIY0obDsqX21k
         252U3X52+aOctlqRYw1fw9Dwn4y97R75AAd5jZ5Ve0ixR1w7eydorWnlBGGnzberzXCA
         1qn5DyUkwBVuuZt99ij0IqFm3UyDLNify1mGX/eaR1UHiiduVmtY+LHerjFfcYh8ooyb
         0oXA==
X-Forwarded-Encrypted: i=1; AHgh+RrsbkA+CA5VvTf8mHZFef+bAPCNgXb8kjNv5bS5ij7NbI09qQx2FflHtAfDHw75u4CK4ZHiKk//qw==@lists.linux.dev
X-Gm-Message-State: AOJu0YzIQLFQMqEmAAvUw33BiJDnS8dLSsdlSTiLboevH3KJ92sTcXc+
	XDvGcA/tHlJiH4RpvznjJ4TBRaoK1R9QqOOOJ0YDm0iPeRfRiqfLrhVVBh9HspPXJMXgrdmNWV0
	Y9To1ukB8eW38uydmyXO/NJFGFT+484aHJU58X1TTgnH5M3qZsevrYEJESE/+8fHNQKSuutIYSE
	m6WplzPSzVCwtivL8xG6Hz2xZEBZp03D2jaUs=
X-Gm-Gg: AR+sD12gK2j0L9AwU5orUT/uSLakinkKD4BqJbicC06JNWSSqHu38X093nxfisp1sAa
	yR+8al5fx5BY7tNkr7RATGZQ8gSL7eoZwQ23cdzMom20jsXBYePE61OVfJoadGohoWcO324YLBF
	Cyh4xurAC5Q6o/Z4RccbrCqjw5iTow0tf/PhRtK2QvnhNXhDENoLV80TG/BIb6mWc7EYhyXR0//
	meja6GM7wHVh1EiDVutQ9XUFFJu6RDkJhr8tbsecMn9+YM=
X-Received: by 2002:a53:a9cd:0:b0:667:b16d:ed57 with SMTP id 956f58d0204a3-6694f160addmr10594773d50.27.1785856712344;
        Tue, 04 Aug 2026 08:18:32 -0700 (PDT)
X-Received: by 2002:a53:a9cd:0:b0:667:b16d:ed57 with SMTP id
 956f58d0204a3-6694f160addmr10594752d50.27.1785856711919; Tue, 04 Aug 2026
 08:18:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260803140905.383600.be823861719c.dm-dust-badblock-coordinate-mismatch@trailofbits.com>
In-Reply-To: <20260803140905.383600.be823861719c.dm-dust-badblock-coordinate-mismatch@trailofbits.com>
From: Bryan Gurney <bgurney@redhat.com>
Date: Tue, 4 Aug 2026 11:18:18 -0400
X-Gm-Features: AUfX_mwhVK8R3fTMTMbhqxYZzyeMuiKybY07nROX_VyTptiCOHRzTpEi2fv6ikM
Message-ID: <CAHhmqcQigDdvfazttm_tFiXMy-3hUQQnQS0meJrzhkDC_ie0Xg@mail.gmail.com>
Subject: Re: [PATCH v2] dm dust: make badblock messages target-relative
To: Samuel Moelius <sam.moelius@trailofbits.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
	Mikulas Patocka <mpatocka@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>, 
	"open list:DEVICE-MAPPER (LVM)" <dm-devel@lists.linux.dev>, open list <linux-kernel@vger.kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: GBCVTHReBrvP4xtHiWKvWFber3wITy3DSVjxQM1bPyE_1785856712
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 3, 2026 at 10:30=E2=80=AFAM Samuel Moelius
<sam.moelius@trailofbits.com> wrote:
>
> dm-dust currently treats addbadblock, removebadblock and queryblock
> arguments as block numbers on the underlying device. That is surprising
> for a device-mapper target: a dm-dust table with a non-zero backing
> offset can add bad blocks that are outside the mapped target, and a
> badblock added for logical block 0 is missed because the I/O path checks
> the remapped backing-device block instead.
>
> Interpret badblock message arguments as blocks relative to the start of
> the dm-dust target instead. Bound the arguments by the target length and
> perform badblock lookup using target-relative sectors before remapping
> the bio to the underlying device.
>
> This intentionally changes the non-zero backing-offset behavior to make
> the badblock control interface match the mapped dm-dust device, rather
> than the underlying device.
>
> Assisted-by: Codex:gpt-5.5-cyber-preview
> Signed-off-by: Samuel Moelius <sam.moelius@trailofbits.com>
> ---
> Changes in v2:
>   - Revise commit message
>   - Remove call to sector_div() in __dust_map_write()
>

Hi,

I'm Bryan Gurney, the original submitter of dm-dust.  It's a test
target, so its main value is in being able to instigate a certain kind
of failure.  It's been a while since I've worked on this, but I made a
modification to the blktests test that I created for it, to test this
patch:

--- tests/dm/002
+++ tests/dm/002
@@ -17,9 +17,9 @@ test_device() {
     local sz bsz
     echo "Running ${TEST_NAME}"

-    sz=3D$(blockdev --getsz "$TEST_DEV")
+    # sz=3D$(blockdev --getsz "$TEST_DEV")
     bsz=3D$(blockdev --getbsz "$TEST_DEV")
-    dmsetup create dust1 --table "0 $sz dust $TEST_DEV 0 $bsz"
+    dmsetup create dust1 --table "0 1048576 dust $TEST_DEV 1024 $bsz"
     dmsetup message dust1 0 addbadblock 60
     dmsetup message dust1 0 addbadblock 67
     dmsetup message dust1 0 addbadblock 72

...and I built it off of v7.2.0-rc6; in the non-zero offset test, the
3 badblocks fail to clear after the "dd if=3D/dev/zero
of=3D/dev/mapper/dust1" command, but with your patch (both v1 and v2),
both the zero-offset and non-zero offset tests successfully pass.

So with that, I will add:

Tested-by: Bryan Gurney <bgurney@redhat.com>

...in the sense that it does what the original designer of the test
target feels should be the correct behavior.

I admit that I should have done more testing with non-zero offsets.  I
saw Ben Marzinski's review comment about dm-dust being able to "mark
bad blocks that aren't aligned with the dm-dust target"; that's an
oversight, and this patch fixes it.  (Or at least, as best as I can
test; Ben, Mikulas and Mike are more experienced with the
device-mapper code.)

To try and answer Ben's question about the expectations of existing
dm-dust users: from how I tried to design the target, a "bad block"
should be relative to the created device; e.g., "/dev/mapper/dust1".


Thanks,

Bryan Gurney
Senior Software Engineer - Enterprise Storage
Red Hat

>  drivers/md/dm-dust.c | 16 +++++++---------
>  1 file changed, 7 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/md/dm-dust.c b/drivers/md/dm-dust.c
> index c7e3077fb1f5..954f4ec5a51c 100644
> --- a/drivers/md/dm-dust.c
> +++ b/drivers/md/dm-dust.c
> @@ -196,7 +196,6 @@ static int __dust_map_write(struct dust_device *dd, s=
ector_t thisblock)
>                 dd->badblock_count--;
>                 kfree(bblk);
>                 if (!dd->quiet_mode) {
> -                       sector_div(thisblock, dd->sect_per_block);
>                         DMINFO("block %llu removed from badblocklist by w=
rite",
>                                (unsigned long long)thisblock);
>                 }
> @@ -224,15 +223,16 @@ static int dust_map_write(struct dust_device *dd, s=
ector_t thisblock,
>  static int dust_map(struct dm_target *ti, struct bio *bio)
>  {
>         struct dust_device *dd =3D ti->private;
> +       sector_t dust_sector =3D dm_target_offset(ti, bio->bi_iter.bi_sec=
tor);
>         int r;
>
>         bio_set_dev(bio, dd->dev->bdev);
> -       bio->bi_iter.bi_sector =3D dd->start + dm_target_offset(ti, bio->=
bi_iter.bi_sector);
> +       bio->bi_iter.bi_sector =3D dd->start + dust_sector;
>
>         if (bio_data_dir(bio) =3D=3D READ)
> -               r =3D dust_map_read(dd, bio->bi_iter.bi_sector, dd->fail_=
read_on_bb);
> +               r =3D dust_map_read(dd, dust_sector, dd->fail_read_on_bb)=
;
>         else
> -               r =3D dust_map_write(dd, bio->bi_iter.bi_sector, dd->fail=
_read_on_bb);
> +               r =3D dust_map_write(dd, dust_sector, dd->fail_read_on_bb=
);
>
>         return r;
>  }
> @@ -415,7 +415,7 @@ static int dust_message(struct dm_target *ti, unsigne=
d int argc, char **argv,
>                         char *result, unsigned int maxlen)
>  {
>         struct dust_device *dd =3D ti->private;
> -       sector_t size =3D bdev_nr_sectors(dd->dev->bdev);
> +       sector_t size =3D dm_sector_div_up(ti->len, dd->sect_per_block);
>         bool invalid_msg =3D false;
>         int r =3D -EINVAL;
>         unsigned long long tmp, block;
> @@ -462,8 +462,7 @@ static int dust_message(struct dm_target *ti, unsigne=
d int argc, char **argv,
>                         return r;
>
>                 block =3D tmp;
> -               sector_div(size, dd->sect_per_block);
> -               if (block > size) {
> +               if (block >=3D size) {
>                         DMERR("selected block value out of range");
>                         return r;
>                 }
> @@ -490,8 +489,7 @@ static int dust_message(struct dm_target *ti, unsigne=
d int argc, char **argv,
>                         return r;
>                 }
>                 wr_fail_cnt =3D tmp_ui;
> -               sector_div(size, dd->sect_per_block);
> -               if (block > size) {
> +               if (block >=3D size) {
>                         DMERR("selected block value out of range");
>                         return r;
>                 }
> --
> 2.43.0
>
>


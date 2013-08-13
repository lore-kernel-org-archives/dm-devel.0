From: Chaitra Bhat <Chaitra.Bhat@VERIFONE.com>
Subject: Re: dm-verity: Verification fails but do not see
 Input/Output Error on read
Date: Tue, 13 Aug 2013 13:49:16 +0000
Message-ID: <20847BF06520E04D933186677BF7B724D231DC@VF2WDEXMB1.verifone.com>
References: <20847BF06520E04D933186677BF7B724D1F523@VF2WDEXMB1.verifone.com>,
	<20130808121858.GB31819@agk-dp.fab.redhat.com>
	<20847BF06520E04D933186677BF7B724D1F55D@VF2WDEXMB1.verifone.com>,
	<alpine.LRH.2.02.1308080849500.15699@file01.intranet.prod.int.rdu2.redhat.com>
	<20847BF06520E04D933186677BF7B724D1F58F@VF2WDEXMB1.verifone.com>,
	<alpine.LRH.2.02.1308081256540.20081@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1308081256540.20081@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>, device-mapper development <dm-devel@redhat.com>
Cc: Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Hi Mikulas,

I figured out what was happening - but I would need your help to explain these behaviours please :)

Case I - Format the hash device, verify and create the dm-verity target. Then modify data in the underlying data-device using dd. Read back the data from the modified location from the verity-device.

Result: Verify fails but 'NO' I/O error reported when reading back from the location using dd.

Case II - Format the hash device, verify and create the dm-verity target device. Remove the verity target, then modify the data in the data-device using dd. Load the verity target and read-back the data from the verity-device from the modified location.

Result: Verify fails and also get I/O error on reading that location using dd.

My understanding was that the verity-device could be created and mounted and then if the underlying data was corrupted somehow, then a read of invalid data from that corrupted location will return -EIO.

Chaitra

PS: I was following the examples in the verity-compat-test script.
________________________________________
From: Mikulas Patocka [mpatocka@redhat.com]
Sent: 08 August 2013 18:00
To: device-mapper development; Chaitra Bhat
Cc: Alasdair G Kergon
Subject: Re: [dm-devel] dm-verity: Verification fails but do not see Input/Output Error on read

On Thu, 8 Aug 2013, Chaitra Bhat wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA512
>
> Hi Mikulas,
>
> I get 'Invalid argument' with 'iflag=direct' option when I try to read
> from a verity device using dd.

If you use iflag=direct, block size and offset must be aligned on physical
block size boundary (usually 4k). If they are not aligned, you get invalid
argument error.

> Before I read from the device, I also did 'echo 3 >
> /proc/sys/vm/drop_caches' to make sure caches are dropped.

If the filesystem is mounted, it doesn't drop some buffers (those that are
used by the filesystem). Unmount the filesystem first.

> But as I said before, some locations always fail with I/O error when
> read and others don't.

If you still get misbehavior, even if you bypass the cache with
iflag=direct or with filesystem unmount, create a script that reproduces
it and send it to us.

> Regards,
> Chaitra

Mikulas

________________________________
This electronic message, including attachments, is intended only for the use of the individual or company named above or to which it is addressed. The information contained in this message shall be considered confidential and proprietary, and may include confidential work product. If you are not the intended recipient, please be aware that any unauthorized use, dissemination, distribution or copying of this message is strictly prohibited. If you have received this email in error, please notify the sender by replying to this message and deleting this email immediately.

-----BEGIN PGP SIGNATURE-----
Version: PGP Universal 3.2.0 (Build 2599)
Charset: us-ascii

wsFVAwUBUgo6DvoDVUR++NlrAQqymBAA3XlrZBofe+VuyvzgLgpyXGJ3VPG4geQm
VbgtmPbEK4aF4SD4cRnKWgopQ7cVttPnWbf4vSOBLBcbMtq9LvyeYjVLlzvBPonR
qOjA2EQ4E2cIul4I4QcUt6gPb/3eRYZd1ighaOgS7+u+kB+BdevaHMpGYSXHX+dz
2uNC8yTv+f68I8Uyet2v7YXXbENjJ+lmNV7CDxupIbHHp0oSw/Ko84mxOSf0rxAW
uUGKVBDaVH3wka6bMcSjUzSSuyAeLDD5lkC9Z8s9piRN+WkQBWwk3ag0cdftK9Ur
lI72I9rzhh+RkLk+sGVXt1+M+elvy3fKy8Rbvlzk3fa7cEIFimUdNET7wEWn9/jg
bzUp6XFLq/mTi4XkwPBVKgTgbeX1uiD593SnGpTeoMZ3suaGBX605LIH2QfTvjEX
lDMEtnzzJH2OQn7ziIQSwROu7rNoTse6eaGjXG27AxMQp+jX3KefGoZEey10nmYW
s4BpQo5MJXElT9SlXR869MFrB0urzok+9loXIl03+0Z0S3IR2JATOp3WnDVCckrz
cgCLhfUgoZTSlT9x5haRFD5bSSB5YHujMWLyJxL1SiRiK6yQJ/eNBc5kDHAt2vhK
Ag0/GXXXXnAJxchEmpjzr1w9I2lhofO3DbI6kssOeQwve/UhtTO5mI1l5C/42VaV
8taSIt9IcAE=
=Z+BV
-----END PGP SIGNATURE-----

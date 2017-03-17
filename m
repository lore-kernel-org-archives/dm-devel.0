From: Milan Broz <mbroz@redhat.com>
Subject: Re: [BUG] Oops caused by FEC in 4.10.0
Date: Fri, 17 Mar 2017 12:45:00 +0100
Message-ID: <accf7e0f-1964-6e19-9453-a1c27e3666d4@redhat.com>
References: <CAMKhuNG_AKfY_EB9C_Y-8q7sR+9u+Mn9w-hb1YvZQBCNLC_-ww@mail.gmail.com>
	<20170315221223.GA116381@samitolvanen.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170315221223.GA116381@samitolvanen.mtv.corp.google.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Sami Tolvanen <samitolvanen@google.com>
Cc: michal virgovic <michalvirgovic1@gmail.com>, dm-devel@redhat.com, agk@redhat.com, snitzer@redhat.com
List-Id: dm-devel.ids

On 03/15/2017 11:12 PM, Sami Tolvanen wrote:
> On Wed, Mar 15, 2017 at 09:22:02PM +0100, michal virgovic wrote:
>> This oops keeps appearing.
> 
> This can happen if dm-verity is set up with an invalid root hash, for
> example. Please test the attached patch, which limits recursion and should
> allow it to fail more gracefully.

I tried it and it still does take at least two minutes and tons of logs until even
udev scan finishes on a device with incorrect FEC attributes.

And once it is finished, dm-verity crashes on dm-device removal...

Could we please have all crucial fixes upstream? It seems that
FEC is really not usable for now.

Milan


This is what I run (32bit VM, Linus' git + your fix), dmesg below.

DEV_NAME=tst12414
DEV_DATA=/dev/sdb
DEV_HASH=/dev/sdc
DEV_FEC=/dev/sdd

dmsetup -r create $DEV_NAME --table "0 8 verity 1 $DEV_DATA $DEV_HASH 4096 4096 1 1 sha256 0000000000000000000000000000000000000000000000000000000000000000 0000000000000000000000000000000000000000000000000000000000000000 8 use_fec_from_device $DEV_FEC fec_roots 16 fec_blocks 1 fec_start 1"
udevadm settle
dd if=/dev/mapper/$DEV_NAME of=/dev/null bs=4k count=1 iflag=direct
dmsetup remove $DEV_NAME

...

Mar 17 12:34:59 : device-mapper: verity-fec: 8:16: FEC 0: corrected 14 errors
Mar 17 12:34:59 : device-mapper: verity-fec: 8:16: FEC 0: failed to correct (0 erasures)
Mar 17 12:34:59 : device-mapper: verity-fec: 8:16: FEC 0: corrected 14 errors
Mar 17 12:34:59 : device-mapper: verity-fec: 8:16: FEC 0: failed to correct (1 erasures)
Mar 17 12:34:59 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:34:59 : device-mapper: verity-fec: 8:16: FEC 0: corrected 14 errors
Mar 17 12:34:59 : device-mapper: verity-fec: 8:16: FEC 0: failed to correct (0 erasures)
Mar 17 12:34:59 : device-mapper: verity-fec: 8:16: FEC 0: corrected 14 errors
Mar 17 12:34:59 : device-mapper: verity-fec: 8:16: FEC 0: failed to correct (1 erasures)
Mar 17 12:34:59 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:34:59 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:34:59 : device-mapper: verity-fec: 8:16: FEC 0: corrected 14 errors
Mar 17 12:34:59 : device-mapper: verity-fec: 8:16: FEC 0: failed to correct (0 erasures)
Mar 17 12:34:59 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:34:59 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:34:59 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:34:59 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:34:59 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:34:59 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:34:59 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:34:59 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:34:59 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:34:59 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:34:59 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:34:59 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:34:59 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:34:59 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:34:59 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:34:59 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:34:59 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:34:59 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:34:59 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:34:59 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:34:59 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:34:59 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:00 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:00 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:00 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:00 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:00 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:00 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:00 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:00 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:00 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:00 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:00 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:00 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:00 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:00 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:00 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:00 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:00 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:01 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:01 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:01 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:01 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:01 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:01 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:01 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:01 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:01 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:01 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:01 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:01 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:01 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:01 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:01 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:01 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:02 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:02 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:02 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:02 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:02 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:02 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:02 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:02 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:02 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:02 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:02 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:02 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:02 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:02 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:02 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:02 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:02 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:03 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:03 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:03 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:03 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:03 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:03 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:03 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:03 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:03 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:03 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:03 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:03 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:03 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:03 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:03 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:03 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:04 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:04 : fec_decode_bufs: 320 callbacks suppressed
Mar 17 12:35:04 : device-mapper: verity-fec: 8:16: FEC 0: corrected 14 errors
Mar 17 12:35:04 : device-mapper: verity-fec: 8:16: FEC 0: failed to correct (1 erasures)
Mar 17 12:35:04 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:04 : device-mapper: verity-fec: 8:16: FEC 0: corrected 14 errors
Mar 17 12:35:04 : device-mapper: verity-fec: 8:16: FEC 0: failed to correct (0 erasures)
Mar 17 12:35:04 : device-mapper: verity-fec: 8:16: FEC 0: corrected 14 errors
Mar 17 12:35:04 : device-mapper: verity-fec: 8:16: FEC 0: failed to correct (1 erasures)
Mar 17 12:35:04 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:04 : device-mapper: verity-fec: 8:16: FEC 0: corrected 14 errors
Mar 17 12:35:04 : device-mapper: verity-fec: 8:16: FEC 0: failed to correct (0 erasures)
Mar 17 12:35:04 : device-mapper: verity-fec: 8:16: FEC 0: corrected 14 errors
Mar 17 12:35:04 : device-mapper: verity-fec: 8:16: FEC 0: failed to correct (1 erasures)
Mar 17 12:35:04 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:04 : buffer_io_error: 66 callbacks suppressed
Mar 17 12:35:04 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:04 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:04 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:04 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:04 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:04 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:04 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:04 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:04 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:04 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:04 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:04 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:04 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:04 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:04 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:04 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:04 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:04 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:04 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:04 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:04 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:04 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:05 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:05 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:05 : device-mapper: verity: 8:16: data block 0 is corrupted
Mar 17 12:35:05 : device-mapper: verity: 8:16: reached maximum errors
Mar 17 12:35:09 : fec_decode_bufs: 328 callbacks suppressed
Mar 17 12:35:09 : device-mapper: verity-fec: 8:16: FEC 0: corrected 14 errors
Mar 17 12:35:09 : device-mapper: verity-fec: 8:16: FEC 0: failed to correct (0 erasures)
Mar 17 12:35:09 : device-mapper: verity-fec: 8:16: FEC 0: corrected 14 errors
Mar 17 12:35:09 : device-mapper: verity-fec: 8:16: FEC 0: failed to correct (1 erasures)
Mar 17 12:35:09 : device-mapper: verity-fec: 8:16: FEC 0: corrected 14 errors
Mar 17 12:35:09 : device-mapper: verity-fec: 8:16: FEC 0: failed to correct (0 erasures)
Mar 17 12:35:09 : device-mapper: verity-fec: 8:16: FEC 0: corrected 14 errors
Mar 17 12:35:09 : device-mapper: verity-fec: 8:16: FEC 0: failed to correct (1 erasures)
Mar 17 12:35:09 : device-mapper: verity-fec: 8:16: FEC 0: corrected 14 errors
Mar 17 12:35:09 : device-mapper: verity-fec: 8:16: FEC 0: failed to correct (0 erasures)
Mar 17 12:35:09 : buffer_io_error: 67 callbacks suppressed
Mar 17 12:35:09 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:09 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:09 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:09 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:09 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:09 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:09 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:09 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:09 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:09 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:14 : fec_decode_bufs: 332 callbacks suppressed
Mar 17 12:35:14 : device-mapper: verity-fec: 8:16: FEC 0: corrected 14 errors
Mar 17 12:35:14 : device-mapper: verity-fec: 8:16: FEC 0: failed to correct (1 erasures)
Mar 17 12:35:14 : device-mapper: verity-fec: 8:16: FEC 0: corrected 14 errors
Mar 17 12:35:14 : device-mapper: verity-fec: 8:16: FEC 0: failed to correct (0 erasures)
Mar 17 12:35:14 : device-mapper: verity-fec: 8:16: FEC 0: corrected 14 errors
Mar 17 12:35:14 : device-mapper: verity-fec: 8:16: FEC 0: failed to correct (1 erasures)
Mar 17 12:35:14 : device-mapper: verity-fec: 8:16: FEC 0: corrected 14 errors
Mar 17 12:35:14 : device-mapper: verity-fec: 8:16: FEC 0: failed to correct (0 erasures)
Mar 17 12:35:14 : device-mapper: verity-fec: 8:16: FEC 0: corrected 14 errors
Mar 17 12:35:14 : device-mapper: verity-fec: 8:16: FEC 0: failed to correct (1 erasures)
Mar 17 12:35:14 : buffer_io_error: 68 callbacks suppressed
Mar 17 12:35:14 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:14 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:14 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:14 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:14 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:14 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:14 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:14 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:14 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:14 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:19 : fec_decode_bufs: 332 callbacks suppressed
Mar 17 12:35:19 : device-mapper: verity-fec: 8:16: FEC 0: corrected 14 errors
Mar 17 12:35:19 : device-mapper: verity-fec: 8:16: FEC 0: failed to correct (0 erasures)
Mar 17 12:35:19 : device-mapper: verity-fec: 8:16: FEC 0: corrected 14 errors
Mar 17 12:35:19 : device-mapper: verity-fec: 8:16: FEC 0: failed to correct (1 erasures)
Mar 17 12:35:19 : device-mapper: verity-fec: 8:16: FEC 0: corrected 14 errors
Mar 17 12:35:19 : device-mapper: verity-fec: 8:16: FEC 0: failed to correct (0 erasures)
Mar 17 12:35:19 : device-mapper: verity-fec: 8:16: FEC 0: corrected 14 errors
Mar 17 12:35:19 : device-mapper: verity-fec: 8:16: FEC 0: failed to correct (1 erasures)
Mar 17 12:35:19 : buffer_io_error: 67 callbacks suppressed
Mar 17 12:35:19 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:19 : device-mapper: verity-fec: 8:16: FEC 0: corrected 14 errors
Mar 17 12:35:19 : device-mapper: verity-fec: 8:16: FEC 0: failed to correct (0 erasures)
Mar 17 12:35:19 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:19 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:19 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:19 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:19 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:19 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:19 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:19 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:19 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:24 : fec_decode_bufs: 320 callbacks suppressed
Mar 17 12:35:24 : device-mapper: verity-fec: 8:16: FEC 0: corrected 14 errors
Mar 17 12:35:24 : device-mapper: verity-fec: 8:16: FEC 0: failed to correct (1 erasures)
Mar 17 12:35:24 : device-mapper: verity-fec: 8:16: FEC 0: corrected 14 errors
Mar 17 12:35:24 : device-mapper: verity-fec: 8:16: FEC 0: failed to correct (0 erasures)
Mar 17 12:35:24 : device-mapper: verity-fec: 8:16: FEC 0: corrected 14 errors
Mar 17 12:35:24 : device-mapper: verity-fec: 8:16: FEC 0: failed to correct (1 erasures)
Mar 17 12:35:24 : device-mapper: verity-fec: 8:16: FEC 0: corrected 14 errors
Mar 17 12:35:24 : device-mapper: verity-fec: 8:16: FEC 0: failed to correct (0 erasures)
Mar 17 12:35:24 : device-mapper: verity-fec: 8:16: FEC 0: corrected 14 errors
Mar 17 12:35:24 : device-mapper: verity-fec: 8:16: FEC 0: failed to correct (1 erasures)
Mar 17 12:35:24 : buffer_io_error: 65 callbacks suppressed
Mar 17 12:35:24 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:24 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:24 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:24 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:24 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:24 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:24 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:24 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:24 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:24 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:29 : fec_decode_bufs: 324 callbacks suppressed
Mar 17 12:35:29 : device-mapper: verity-fec: 8:16: FEC 0: corrected 14 errors
Mar 17 12:35:29 : device-mapper: verity-fec: 8:16: FEC 0: failed to correct (0 erasures)
Mar 17 12:35:29 : device-mapper: verity-fec: 8:16: FEC 0: corrected 14 errors
Mar 17 12:35:29 : device-mapper: verity-fec: 8:16: FEC 0: failed to correct (1 erasures)
Mar 17 12:35:29 : device-mapper: verity-fec: 8:16: FEC 0: corrected 14 errors
Mar 17 12:35:29 : device-mapper: verity-fec: 8:16: FEC 0: failed to correct (0 erasures)
Mar 17 12:35:29 : device-mapper: verity-fec: 8:16: FEC 0: corrected 14 errors
Mar 17 12:35:29 : device-mapper: verity-fec: 8:16: FEC 0: failed to correct (1 erasures)
Mar 17 12:35:29 : device-mapper: verity-fec: 8:16: FEC 0: corrected 14 errors
Mar 17 12:35:29 : device-mapper: verity-fec: 8:16: FEC 0: failed to correct (0 erasures)
Mar 17 12:35:29 : buffer_io_error: 68 callbacks suppressed
Mar 17 12:35:29 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:29 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:29 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:29 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:29 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:29 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:29 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:29 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:29 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:30 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:34 : fec_decode_bufs: 330 callbacks suppressed
Mar 17 12:35:34 : device-mapper: verity-fec: 8:16: FEC 0: corrected 14 errors
Mar 17 12:35:34 : device-mapper: verity-fec: 8:16: FEC 0: failed to correct (0 erasures)
Mar 17 12:35:34 : device-mapper: verity-fec: 8:16: FEC 0: corrected 14 errors
Mar 17 12:35:34 : device-mapper: verity-fec: 8:16: FEC 0: failed to correct (1 erasures)
Mar 17 12:35:34 : device-mapper: verity-fec: 8:16: FEC 0: corrected 14 errors
Mar 17 12:35:34 : device-mapper: verity-fec: 8:16: FEC 0: failed to correct (0 erasures)
Mar 17 12:35:34 : device-mapper: verity-fec: 8:16: FEC 0: corrected 14 errors
Mar 17 12:35:34 : device-mapper: verity-fec: 8:16: FEC 0: failed to correct (1 erasures)
Mar 17 12:35:34 : device-mapper: verity-fec: 8:16: FEC 0: corrected 14 errors
Mar 17 12:35:34 : device-mapper: verity-fec: 8:16: FEC 0: failed to correct (0 erasures)
Mar 17 12:35:34 : buffer_io_error: 68 callbacks suppressed
Mar 17 12:35:34 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:34 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:34 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:34 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:34 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:34 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:34 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:34 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:35 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:35 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:39 : fec_decode_bufs: 330 callbacks suppressed
Mar 17 12:35:39 : device-mapper: verity-fec: 8:16: FEC 0: corrected 14 errors
Mar 17 12:35:39 : device-mapper: verity-fec: 8:16: FEC 0: failed to correct (0 erasures)
Mar 17 12:35:39 : device-mapper: verity-fec: 8:16: FEC 0: corrected 14 errors
Mar 17 12:35:39 : device-mapper: verity-fec: 8:16: FEC 0: failed to correct (1 erasures)
Mar 17 12:35:39 : device-mapper: verity-fec: 8:16: FEC 0: corrected 14 errors
Mar 17 12:35:39 : device-mapper: verity-fec: 8:16: FEC 0: failed to correct (0 erasures)
Mar 17 12:35:39 : device-mapper: verity-fec: 8:16: FEC 0: corrected 14 errors
Mar 17 12:35:39 : device-mapper: verity-fec: 8:16: FEC 0: failed to correct (1 erasures)
Mar 17 12:35:39 : device-mapper: verity-fec: 8:16: FEC 0: corrected 14 errors
Mar 17 12:35:39 : device-mapper: verity-fec: 8:16: FEC 0: failed to correct (0 erasures)
Mar 17 12:35:39 : buffer_io_error: 67 callbacks suppressed
Mar 17 12:35:39 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:39 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:39 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:39 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:39 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:39 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:39 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:40 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:40 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:40 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:44 : fec_decode_bufs: 330 callbacks suppressed
Mar 17 12:35:44 : device-mapper: verity-fec: 8:16: FEC 0: corrected 14 errors
Mar 17 12:35:44 : device-mapper: verity-fec: 8:16: FEC 0: failed to correct (0 erasures)
Mar 17 12:35:44 : device-mapper: verity-fec: 8:16: FEC 0: corrected 14 errors
Mar 17 12:35:44 : device-mapper: verity-fec: 8:16: FEC 0: failed to correct (1 erasures)
Mar 17 12:35:44 : device-mapper: verity-fec: 8:16: FEC 0: corrected 14 errors
Mar 17 12:35:44 : device-mapper: verity-fec: 8:16: FEC 0: failed to correct (0 erasures)
Mar 17 12:35:44 : device-mapper: verity-fec: 8:16: FEC 0: corrected 14 errors
Mar 17 12:35:44 : device-mapper: verity-fec: 8:16: FEC 0: failed to correct (1 erasures)
Mar 17 12:35:44 : device-mapper: verity-fec: 8:16: FEC 0: corrected 14 errors
Mar 17 12:35:44 : device-mapper: verity-fec: 8:16: FEC 0: failed to correct (0 erasures)
Mar 17 12:35:44 : buffer_io_error: 65 callbacks suppressed
Mar 17 12:35:44 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:44 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:44 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:44 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:44 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:44 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:44 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:44 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:45 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:45 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:49 : fec_decode_bufs: 320 callbacks suppressed
Mar 17 12:35:49 : device-mapper: verity-fec: 8:16: FEC 0: corrected 14 errors
Mar 17 12:35:49 : device-mapper: verity-fec: 8:16: FEC 0: failed to correct (1 erasures)
Mar 17 12:35:49 : device-mapper: verity-fec: 8:16: FEC 0: corrected 14 errors
Mar 17 12:35:49 : device-mapper: verity-fec: 8:16: FEC 0: failed to correct (0 erasures)
Mar 17 12:35:49 : device-mapper: verity-fec: 8:16: FEC 0: corrected 14 errors
Mar 17 12:35:49 : device-mapper: verity-fec: 8:16: FEC 0: failed to correct (1 erasures)
Mar 17 12:35:49 : device-mapper: verity-fec: 8:16: FEC 0: corrected 14 errors
Mar 17 12:35:49 : device-mapper: verity-fec: 8:16: FEC 0: failed to correct (0 erasures)
Mar 17 12:35:49 : device-mapper: verity-fec: 8:16: FEC 0: corrected 14 errors
Mar 17 12:35:49 : device-mapper: verity-fec: 8:16: FEC 0: failed to correct (1 erasures)
Mar 17 12:35:49 : buffer_io_error: 67 callbacks suppressed
Mar 17 12:35:49 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:49 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:49 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:49 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:49 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:49 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:49 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:50 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:50 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:50 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:54 : fec_decode_bufs: 326 callbacks suppressed
Mar 17 12:35:54 : device-mapper: verity-fec: 8:16: FEC 0: corrected 14 errors
Mar 17 12:35:54 : device-mapper: verity-fec: 8:16: FEC 0: failed to correct (1 erasures)
Mar 17 12:35:54 : device-mapper: verity-fec: 8:16: FEC 0: corrected 14 errors
Mar 17 12:35:54 : device-mapper: verity-fec: 8:16: FEC 0: failed to correct (0 erasures)
Mar 17 12:35:54 : device-mapper: verity-fec: 8:16: FEC 0: corrected 14 errors
Mar 17 12:35:54 : device-mapper: verity-fec: 8:16: FEC 0: failed to correct (1 erasures)
Mar 17 12:35:54 : device-mapper: verity-fec: 8:16: FEC 0: corrected 14 errors
Mar 17 12:35:54 : device-mapper: verity-fec: 8:16: FEC 0: failed to correct (0 erasures)
Mar 17 12:35:54 : device-mapper: verity-fec: 8:16: FEC 0: corrected 14 errors
Mar 17 12:35:54 : device-mapper: verity-fec: 8:16: FEC 0: failed to correct (1 erasures)
Mar 17 12:35:54 : buffer_io_error: 66 callbacks suppressed
Mar 17 12:35:54 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:54 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:54 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:54 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:54 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:54 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:55 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:55 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:55 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:55 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:59 : fec_decode_bufs: 328 callbacks suppressed
Mar 17 12:35:59 : device-mapper: verity-fec: 8:16: FEC 0: corrected 14 errors
Mar 17 12:35:59 : device-mapper: verity-fec: 8:16: FEC 0: failed to correct (0 erasures)
Mar 17 12:35:59 : device-mapper: verity-fec: 8:16: FEC 0: corrected 14 errors
Mar 17 12:35:59 : device-mapper: verity-fec: 8:16: FEC 0: failed to correct (1 erasures)
Mar 17 12:35:59 : device-mapper: verity-fec: 8:16: FEC 0: corrected 14 errors
Mar 17 12:35:59 : device-mapper: verity-fec: 8:16: FEC 0: failed to correct (0 erasures)
Mar 17 12:35:59 : device-mapper: verity-fec: 8:16: FEC 0: corrected 14 errors
Mar 17 12:35:59 : device-mapper: verity-fec: 8:16: FEC 0: failed to correct (1 erasures)
Mar 17 12:35:59 : device-mapper: verity-fec: 8:16: FEC 0: corrected 14 errors
Mar 17 12:35:59 : device-mapper: verity-fec: 8:16: FEC 0: failed to correct (0 erasures)
Mar 17 12:35:59 : buffer_io_error: 66 callbacks suppressed
Mar 17 12:35:59 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:59 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:59 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:59 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:59 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:59 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:35:59 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:36:00 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:36:00 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:36:00 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:36:04 : fec_decode_bufs: 326 callbacks suppressed
Mar 17 12:36:04 : device-mapper: verity-fec: 8:16: FEC 0: corrected 14 errors
Mar 17 12:36:04 : device-mapper: verity-fec: 8:16: FEC 0: failed to correct (0 erasures)
Mar 17 12:36:04 : device-mapper: verity-fec: 8:16: FEC 0: corrected 14 errors
Mar 17 12:36:04 : device-mapper: verity-fec: 8:16: FEC 0: failed to correct (1 erasures)
Mar 17 12:36:04 : device-mapper: verity-fec: 8:16: FEC 0: corrected 14 errors
Mar 17 12:36:04 : device-mapper: verity-fec: 8:16: FEC 0: failed to correct (0 erasures)
Mar 17 12:36:04 : device-mapper: verity-fec: 8:16: FEC 0: corrected 14 errors
Mar 17 12:36:04 : device-mapper: verity-fec: 8:16: FEC 0: failed to correct (1 erasures)
Mar 17 12:36:04 : device-mapper: verity-fec: 8:16: FEC 0: corrected 14 errors
Mar 17 12:36:04 : device-mapper: verity-fec: 8:16: FEC 0: failed to correct (0 erasures)
Mar 17 12:36:04 : buffer_io_error: 69 callbacks suppressed
Mar 17 12:36:04 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:36:04 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:36:04 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:36:04 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:36:04 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:36:05 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:36:05 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:36:05 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:36:05 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:36:05 : Buffer I/O error on dev dm-0, logical block 0, async page read
Mar 17 12:36:05 : ------------[ cut here ]------------
Mar 17 12:36:05 : WARNING: CPU: 0 PID: 1895 at drivers/md/dm-bufio.c:1505 dm_bufio_client_destroy+0x204/0x210 [dm_bufio]
Mar 17 12:36:05 : Modules linked in: dm_verity reed_solomon dm_bufio loop rpcsec_gss_krb5 dm_mod crc32_pclmul crc32c_intel pcbc aesni_intel aes_i586 crypto_simd cryptd ata_piix
Mar 17 12:36:05 : CPU: 0 PID: 1895 Comm: dmsetup Tainted: G        W       4.11.0-rc2+ #163
Mar 17 12:36:05 : Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 07/02/2015
Mar 17 12:36:05 : Call Trace:
Mar 17 12:36:05 :  dump_stack+0x60/0x94
Mar 17 12:36:05 :  __warn+0xc1/0xe0
Mar 17 12:36:05 :  warn_slowpath_null+0x11/0x20
Mar 17 12:36:05 :  dm_bufio_client_destroy+0x204/0x210 [dm_bufio]
Mar 17 12:36:05 :  verity_fec_dtr+0x4f/0x80 [dm_verity]
Mar 17 12:36:05 :  verity_dtr+0x73/0x80 [dm_verity]
Mar 17 12:36:05 :  dm_table_destroy+0x51/0xf0 [dm_mod]
Mar 17 12:36:05 :  __dm_destroy+0x132/0x220 [dm_mod]
Mar 17 12:36:05 :  dm_destroy+0xd/0x10 [dm_mod]
Mar 17 12:36:05 :  dev_remove+0xf9/0x150 [dm_mod]
Mar 17 12:36:05 :  ? dev_suspend+0x220/0x220 [dm_mod]
Mar 17 12:36:05 :  ctl_ioctl+0x1f3/0x4c0 [dm_mod]
Mar 17 12:36:05 :  ? dev_suspend+0x220/0x220 [dm_mod]
Mar 17 12:36:05 :  ? ctl_ioctl+0x4c0/0x4c0 [dm_mod]
Mar 17 12:36:05 :  dm_ctl_ioctl+0xc/0x10 [dm_mod]
Mar 17 12:36:05 :  do_vfs_ioctl+0x7d/0x770
Mar 17 12:36:05 :  ? mntput_no_expire+0x6e/0x380
Mar 17 12:36:05 :  ? SyS_semctl+0x230/0x4b0
Mar 17 12:36:05 :  SyS_ioctl+0x28/0x50
Mar 17 12:36:05 :  do_int80_syscall_32+0x3e/0x110
Mar 17 12:36:05 :  ? quirk_via_cx700_pci_parking_caching+0xb4/0x100
Mar 17 12:36:05 :  entry_INT80_32+0x2f/0x2f
Mar 17 12:36:05 : EIP: 0xb770c9f2
Mar 17 12:36:05 : EFLAGS: 00000286 CPU: 0
Mar 17 12:36:05 : EAX: ffffffda EBX: 00000003 ECX: c138fd04 EDX: 800cc910
Mar 17 12:36:05 : ESI: 00000000 EDI: b7701500 EBP: b76f5c0f ESP: bfcb9a34
Mar 17 12:36:05 :  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b
Mar 17 12:36:05 :  ? quirk_via_cx700_pci_parking_caching+0xb4/0x100
Mar 17 12:36:05 : ---[ end trace f97eb78ad904f683 ]---
Mar 17 12:36:05 : device-mapper: bufio: leaked buffer 10, hold count 2224, list 0
Mar 17 12:36:05 : ------------[ cut here ]------------
Mar 17 12:36:05 : kernel BUG at drivers/md/dm-bufio.c:1521!
Mar 17 12:36:05 : invalid opcode: 0000 [#1] PREEMPT SMP
Mar 17 12:36:05 : Modules linked in: dm_verity reed_solomon dm_bufio loop rpcsec_gss_krb5 dm_mod crc32_pclmul crc32c_intel pcbc aesni_intel aes_i586 crypto_simd cryptd ata_piix
Mar 17 12:36:05 : CPU: 0 PID: 1895 Comm: dmsetup Tainted: G        W       4.11.0-rc2+ #163
Mar 17 12:36:05 : Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 07/02/2015
Mar 17 12:36:05 : task: f5e201c0 task.stack: f3a34000
Mar 17 12:36:05 : EIP: dm_bufio_client_destroy+0x170/0x210 [dm_bufio]
Mar 17 12:36:05 : EFLAGS: 00010297 CPU: 0
Mar 17 12:36:05 : EAX: f5ed0c0c EBX: f5ec0e00 ECX: f5ec0e5c EDX: 00000001
Mar 17 12:36:05 : ESI: f5ec0e64 EDI: 00000002 EBP: f3a35d28 ESP: f3a35d14
Mar 17 12:36:05 :  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Mar 17 12:36:05 : CR0: 80050033 CR2: b74ff4d0 CR3: 346c3000 CR4: 001406d0
Mar 17 12:36:05 : Call Trace:
Mar 17 12:36:05 :  verity_fec_dtr+0x4f/0x80 [dm_verity]
Mar 17 12:36:05 :  verity_dtr+0x73/0x80 [dm_verity]
Mar 17 12:36:05 :  dm_table_destroy+0x51/0xf0 [dm_mod]
Mar 17 12:36:05 :  __dm_destroy+0x132/0x220 [dm_mod]
Mar 17 12:36:05 :  dm_destroy+0xd/0x10 [dm_mod]
Mar 17 12:36:05 :  dev_remove+0xf9/0x150 [dm_mod]
Mar 17 12:36:05 :  ? dev_suspend+0x220/0x220 [dm_mod]
Mar 17 12:36:05 :  ctl_ioctl+0x1f3/0x4c0 [dm_mod]
Mar 17 12:36:05 :  ? dev_suspend+0x220/0x220 [dm_mod]
Mar 17 12:36:05 :  ? ctl_ioctl+0x4c0/0x4c0 [dm_mod]
Mar 17 12:36:05 :  dm_ctl_ioctl+0xc/0x10 [dm_mod]
Mar 17 12:36:05 :  do_vfs_ioctl+0x7d/0x770
Mar 17 12:36:05 :  ? mntput_no_expire+0x6e/0x380
Mar 17 12:36:05 :  ? SyS_semctl+0x230/0x4b0
Mar 17 12:36:05 :  SyS_ioctl+0x28/0x50
Mar 17 12:36:05 :  do_int80_syscall_32+0x3e/0x110
Mar 17 12:36:05 :  ? quirk_via_cx700_pci_parking_caching+0xb4/0x100
Mar 17 12:36:05 :  entry_INT80_32+0x2f/0x2f
Mar 17 12:36:05 : EIP: 0xb770c9f2
Mar 17 12:36:05 : EFLAGS: 00000286 CPU: 0
Mar 17 12:36:05 : EAX: ffffffda EBX: 00000003 ECX: c138fd04 EDX: 800cc910
Mar 17 12:36:05 : ESI: 00000000 EDI: b7701500 EBP: b76f5c0f ESP: bfcb9a34
Mar 17 12:36:05 :  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b
Mar 17 12:36:05 :  ? quirk_via_cx700_pci_parking_caching+0xb4/0x100
Mar 17 12:36:05 : Code: 0f 85 84 00 00 00 8b 43 68 85 c0 75 5e 8b 83 84 00 00 00 e8 43 18 02 00 89 d8 e8 bc 7e 0e c9 8d 65 f4 5b 5e 5f 5d c3 8d 74 26 00 <0f> 0b 0f 0b 0f 0b 0f 0b 84 c0 74 76 83 e9 0c 57 ff 71 28 89 4d
Mar 17 12:36:05 : EIP: dm_bufio_client_destroy+0x170/0x210 [dm_bufio] SS:ESP: 0068:f3a35d14
Mar 17 12:36:05 : ---[ end trace f97eb78ad904f684 ]---

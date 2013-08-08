From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: dm-verity: Verification fails but do not see
 Input/Output Error on read
Date: Thu, 8 Aug 2013 13:00:56 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1308081256540.20081@file01.intranet.prod.int.rdu2.redhat.com>
References: <20847BF06520E04D933186677BF7B724D1F523@VF2WDEXMB1.verifone.com>,
	<20130808121858.GB31819@agk-dp.fab.redhat.com>
	<20847BF06520E04D933186677BF7B724D1F55D@VF2WDEXMB1.verifone.com>,
	<alpine.LRH.2.02.1308080849500.15699@file01.intranet.prod.int.rdu2.redhat.com>
	<20847BF06520E04D933186677BF7B724D1F58F@VF2WDEXMB1.verifone.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20847BF06520E04D933186677BF7B724D1F58F@VF2WDEXMB1.verifone.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Chaitra Bhat <Chaitra.Bhat@verifone.com>
Cc: Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

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

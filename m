From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [lvm-devel] dm thin: optimize away writing all
 zeroes to unprovisioned blocks
Date: Sat, 06 Dec 2014 18:41:33 -0700
Message-ID: <5483B04D.5030606@kernel.dk>
References: <alpine.DEB.2.00.1409301121470.26721@ware.dreamhost.com>
	<alpine.DEB.2.02.1412032237010.12556@ware.dreamhost.com>
	<alpine.DEB.2.02.1412032318290.29609@ware.dreamhost.com>
	<20141204153358.GA19315@redhat.com> <5481EB1C.4000202@kernel.dk>
	<20141205183342.GA27397@redhat.com>
	<alpine.DEB.2.02.1412061437430.19773@ware.dreamhost.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.DEB.2.02.1412061437430.19773@ware.dreamhost.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Eric Wheeler <lvm-dev@lists.ewheeler.net>, LVM2 development <lvm-devel@redhat.com>
Cc: dm-devel@redhat.com, ejt@redhat.com
List-Id: dm-devel.ids

On 12/06/2014 03:40 PM, Eric Wheeler wrote:
> On Fri, 5 Dec 2014, Mike Snitzer wrote:
>>> I do wonder what the performance impact is on this for dm. Have you
>>> tried a (worst case) test of writing blocks that are zero filled, but
>>> with the last byte not being a zero?
>
> The additional overhead of worst-case should be (nearly) equal to the
> simplest test case of dd if=/dev/zero of=/dev/thinp/vol.  In my testing
> that was 1.4GB/s within KVM on an Intel Xeon(R) CPU E3-1230 V2 @ 3.30GHz.

That seems way too slow for checking if it's zero or not... Memory 
bandwidth should be way higher than that. The line above, was that what 
you ran? How does it look with bs=4k or higher?

> I could see where really fast storage that can obtain 1.4gb/s might
> notice a performance regression---but for most use cases that is quite
> fast.

Depends on your view point, I think it's pretty slow. Plenty of devices 
out there that are faster than that. Quick example, the laptop I am 
typing this email from:

   read : io=12233MB, bw=1432.7MB/s, iops=22922, runt=  8539msec

Writes are around 1GB/sec, enough that I bet the slowdown in checking 
for zeroes will be noticeable. In the pci-e flash space, more than 
double your current /dev/zero benchmark is common for current devices.

-- 
Jens Axboe

From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: HPA unlock during partition scan of RAID components
Date: Thu, 03 Nov 2011 15:00:07 -0400
Message-ID: <4EB2E4B7.7000103@cfl.rr.com>
References: <74AAB12B538EC94087A0D16AFDFC24F4045674@IRSMSX102.ger.corp.intel.com>
	<20111103153835.GF4417@google.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20111103153835.GF4417@google.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, "Hawrylewicz Czarnowski,
	Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
List-Id: dm-devel.ids

On 11/3/2011 11:54 AM, Tejun Heo wrote:
> This has come up a couple times and I think the proper solution is to
> always unlock HPA and expose both sizes - locked and unlocked and let
> dm, md or whatever do whatever is approriate.  Block or driver layer
> doesn't have any way to determine which one is the right bet - it
> simply doesn't have enough information.  I tried to bounce this idea
> off people who whould actually be using this (dm/md) but haven't heard
> back yet.

Simply making the smaller size available does not solve the problem of 
making the part of the drive that is supposed to remain hidden 
accessible to user space, and it remains unlocked across a reboot, which 
usually makes the bios fail to recognize such drives.

The only reason I am aware of for unlocking the hpa is to avoid problems 
caused by upgrading an old system that was installed using the unlock 
behavior and thus, incorrectly extended its partition into the protected 
area.  It seems the appropriate fix for that it for distribution upgrade 
scripts to test for this and configure the boot loader to pass the 
unlock flag ( or maybe fix the problem by shrinking the partition ), 
rather than have the kernel continue to try unlocking things by default.

From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: HPA unlock during partition scan of RAID components
Date: Fri, 04 Nov 2011 11:42:20 -0400
Message-ID: <4EB407DC.8070307@cfl.rr.com>
References: <74AAB12B538EC94087A0D16AFDFC24F4045674@IRSMSX102.ger.corp.intel.com>
	<20111103153835.GF4417@google.com> <4EB2E4B7.7000103@cfl.rr.com>
	<CAOS58YNMOYDjuok5DDVF+CcgmP5Z4pdscv6boUC9gUqd7DiUpw@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAOS58YNMOYDjuok5DDVF+CcgmP5Z4pdscv6boUC9gUqd7DiUpw@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Tejun Heo <tj@kernel.org>
Cc: device-mapper development <dm-devel@redhat.com>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, "Hawrylewicz Czarnowski,
	Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
List-Id: dm-devel.ids

On 11/4/2011 10:48 AM, Tejun Heo wrote:
> I frankly don't care about BIOSen locking up afterwards and I don't
> think they are more common than the issues from not unlocking (e.g.
> moving harddrive to another machine, hot-plugging - partition -
> reboot).  There will be a kernel param to disable unlocking behavior

Could you clarify what issues you refer to?  Moving a drive to another 
machine?

> and that would be it.  On top of that if bios is that screwed it's
> probably a good idea to not use bios raid which is a silly thing to
> begin with.  Currently the problem is that the kernel doesn't unlock
> by default and the heuristics can't be turned off, so we have unhappy
> customers on both sides.  Anyways, if md/dm people are on board, I'm
> gonna push for that but otherwise there isn't much point.

It isn't only a problem for bios raid, it also affects mdadm raid. 
Being able to defeat the heuristic would help, but I still don't see why 
the heuristic should be implemented in the kernel instead of user space?

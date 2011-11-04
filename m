From: Tejun Heo <tj@kernel.org>
Subject: Re: HPA unlock during partition scan of RAID components
Date: Fri, 4 Nov 2011 07:48:50 -0700
Message-ID: <CAOS58YNMOYDjuok5DDVF+CcgmP5Z4pdscv6boUC9gUqd7DiUpw@mail.gmail.com>
References: <74AAB12B538EC94087A0D16AFDFC24F4045674@IRSMSX102.ger.corp.intel.com>
	<20111103153835.GF4417@google.com> <4EB2E4B7.7000103@cfl.rr.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4EB2E4B7.7000103@cfl.rr.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Phillip Susi <psusi@cfl.rr.com>
Cc: device-mapper development <dm-devel@redhat.com>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, "Hawrylewicz Czarnowski,
	Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
List-Id: dm-devel.ids

Hello,

On Thu, Nov 3, 2011 at 12:00 PM, Phillip Susi <psusi@cfl.rr.com> wrote:
> Simply making the smaller size available does not solve the problem of
> making the part of the drive that is supposed to remain hidden accessible=
 to
> user space, and it remains unlocked across a reboot, which usually makes =
the
> bios fail to recognize such drives.
>
> The only reason I am aware of for unlocking the hpa is to avoid problems
> caused by upgrading an old system that was installed using the unlock
> behavior and thus, incorrectly extended its partition into the protected
> area. =A0It seems the appropriate fix for that it for distribution upgrade
> scripts to test for this and configure the boot loader to pass the unlock
> flag ( or maybe fix the problem by shrinking the partition ), rather than
> have the kernel continue to try unlocking things by default.

I frankly don't care about BIOSen locking up afterwards and I don't
think they are more common than the issues from not unlocking (e.g.
moving harddrive to another machine, hot-plugging - partition -
reboot).  There will be a kernel param to disable unlocking behavior
and that would be it.  On top of that if bios is that screwed it's
probably a good idea to not use bios raid which is a silly thing to
begin with.  Currently the problem is that the kernel doesn't unlock
by default and the heuristics can't be turned off, so we have unhappy
customers on both sides.  Anyways, if md/dm people are on board, I'm
gonna push for that but otherwise there isn't much point.

Thanks.

-- =

tejun

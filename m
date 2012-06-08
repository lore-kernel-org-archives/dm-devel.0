From: Hannes Reinecke <hare@suse.de>
Subject: Re: different LUN numbers under the same dm device
Date: Fri, 08 Jun 2012 08:29:21 +0200
Message-ID: <4FD19BC1.5020702@suse.de>
References: <8DCD6D08-35CE-48CC-AC54-7436265C32CB@purestorage.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <8DCD6D08-35CE-48CC-AC54-7436265C32CB@purestorage.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Brian Bunker <brian@purestorage.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On 06/06/2012 09:27 PM, Brian Bunker wrote:
> Our company produces a multiple port Fibre Channel storage array. We are =
continually plagued
> by this problem. We get a dm device which combines paths for
different LUN's. We would like
> to understand why this is happening. Wouldn't this problem almost
certainly lead to a data
> corruption?
> =

Most likely; given that the two LUNs indeed refer to different disks.

> Thanks,
> Brian
> =

> 3624a93700a14254d729923840001000b dm-11 PURE,FlashArray
> size=3D500G features=3D'0' hwhandler=3D'0' wp=3Drw
> `-+- policy=3D'round-robin 0' prio=3D1 status=3Dactive
>   |- 1:0:0:12 sde  8:64   failed faulty running
>   |- 0:0:0:12 sdd  8:48   failed faulty running
>   |- 0:0:0:10 sdar 66:176 active ready  running
>   `- 1:0:0:10 sdba 67:64  active ready  running
> =

> Of the 4 paths to dm-11, we can see two paths are for LUN 10 and the othe=
r two are for LUN 12.
> We have 24 other dm devices which have only the expected 2 paths.
> =

Check the output of 'sg_vpd -p di /dev/sd(e|d|ar|ba)'.

'sde' and 'sdd' should be identical (well, the bits for 'Addressed
logical unit' should be), as should 'sdar' and 'sdab'.
'sde' and 'sdar', on the other hand, should _not_.

Given the above, however, I strongly suspect they are.
Looks like your LUN WWID generation code is buggered.

But I guess you can always blame Nic Bellinger :-)

Greetings to Joern Engel.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)

From: "Molle Bestefich" <molle.bestefich@gmail.com>
Subject: Re: Hard drives shutting themselves off in RAID mode
Date: Wed, 14 Jun 2006 13:19:19 +0200
Message-ID: <62b0912f0606140419s60c30535pbcc97c30ef99c50d@mail.gmail.com>
References: <20060613235316.7f982af7@localhost>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20060613235316.7f982af7@localhost>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Tom Wirschell wrote:
> I want to create a RAID5 array of these drives. Unfortunately after a
> varying amount of time of moderate use (though never more than 24 hours)
> one of the drives not connected to the 6300ESB just out of the blue
> shuts itself down, eventually followed by another at which point the
> array is dead.
>
> When the drive shuts down I can hear the familiar click from the drive
> cutting its power, and after a bit the following gets logged:

Usually a 'click' just means that the drive is recalibrating because
it has failed to read a sector/track.
You are sure that it's shutting down?

> ata9: commant timeout

Ugly.
Does the drive's SMART log say anything interesting?

> when using the Promise controllers. The machine locks hard at this
> point. With the SuperMicro card the machine remains usable, but the
> drives are never to be heared from again.

Bug?
Report it to the Promise maintainer?

> The following is logged:
>
> ata14: no device found (phy stat 00000000)
> sd 13:0:0:0: SCSI error: return code = 0x40000
> end_request: I/O errorm dev sdi, sector 390716676
> raid5: Disk failure on sdi2, disabling device.
>
> Pretty much every time it's a different disk,
> and I'm unable to revive that disk without a reboot.

Have you tried poking the IDE driver to reset the bus, might get it
running again?

Not a very pretty solution, especially since you might still suffer
two drives going down at once from time to time.  Maybe you can patch
MD to pause the array and poke the IDE driver whenever a disk is lost?
 Then you would at least only have intermittent failures / timeouts on
a rare basis rather than a non-redundant array when something happens.

> I brought this issue to the attention of some WD support people who're
> basically telling me that the RAID software is impatient.

If the disk never comes up, being patient surely won't help.
Wait for an hour and see if the drive comes up, ask the WD folks
exactly how patient they want you to be? :-)

> When I mount the drives as separate partitions I can play with them to
> my heart's content. As a test I filled up 5 drives, copied the data to
> the other 5 drives (I'm using the 11th drive, a PATA one, for Linux
> itself ATM) and vice versa. As I'm writing this I'm running Bonnie++ in
> parallel on these partitions and so far everything's solid as a rock.

Bizarre!...

An idea that will take some amount of work, don't know if it's feasible:
Patch the IDE driver to log everything it does in a ring buffer in memory.
When a drive is lost, dump the buffer contents to disk so you can see
what happened, perhaps even try and reproduce it.
Perhaps the WD folks could even take a look at it..

> To the best of my ability I've ruled out hardware faults. The only
> thing I can think of now is that the RAID5 module, for whatever reason,
> is _telling_ the drive to shutdown, but I can't imagine that happening
> without some serious logging going on.

bonnie++ does random seeks, right?

> Hopefully someone on this list can help me get this problem sorted?

Sorry :-)...

From: Brian Bunker <brian@purestorage.com>
Subject: Re: path coalescing once more
Date: Thu, 15 May 2014 09:59:18 -0700
Message-ID: <4E2D4DFE-F486-4515-898E-693BBC6A8589@purestorage.com>
References: <ED745309-08E8-4C83-86BD-F9D7246CA8F6@purestorage.com>
	<1400172493.19394.7.camel@ict-vth-stewarts01.ict.englab.netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1400172493.19394.7.camel@ict-vth-stewarts01.ict.englab.netapp.com>
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
List-Id: dm-devel.ids

Thanks Sean. Did you see my latest post where I printed the pp->serial afte=
r the problem happens. It looks like the pp->wwid and the pp->serial are po=
inting to the same thing. I am looking into how pp->wwid gets formed for a =
path, but the correct serial for that path is there. Since the dm is looked=
 up by the wwid and not the serial though, it gets into this problem. =


Thanks,
Brian

On May 15, 2014, at 9:48 AM, Stewart, Sean <Sean.Stewart@netapp.com> wrote:

> Hi Brian,
> =

> On Tue, 2014-05-13 at 16:55 -0700, Brian Bunker wrote:
>> We continue to run into problems with the device-mapper presumably
>> putting LUNs which do not belong with the dm under its control. Here
>> is the latest (I am picking out just dm-2 but there are others in this
>> same state):
> =

>> =

>> I see the following kernel messages in the syslog when the device sdaj
>> arrives to when it is put in the wrong place:
>> May 13 11:28:27 rb9init4 kernel: scsi 1:0:0:1: Direct-Access     PURE   =
  FlashArray       400B PQ: 0 ANSI: 6
>> May 13 11:28:27 rb9init4 kernel: sd 1:0:0:1: [sdaj] 1048576000 512-byte =
logical blocks: (536 GB/500 GiB)
>> May 13 11:28:27 rb9init4 kernel: sd 1:0:0:1: Attached scsi generic sg1 t=
ype 0
>> May 13 11:28:27 rb9init4 kernel: sd 1:0:0:1: [sdaj] Write Protect is off
>> May 13 11:28:27 rb9init4 kernel: sd 1:0:0:1: [sdaj] Write cache: disable=
d, read cache: enabled, doesn't support DPO or FUA
>> May 13 11:28:27 rb9init4 kernel: sdaj:
>> May 13 11:28:27 rb9init4 kernel: unknown partition table
>> May 13 11:28:27 rb9init4 kernel: sd 1:0:0:1: [sdaj] Attached SCSI disk
>> May 13 11:28:28 rb9init4 multipathd: sdaj: add path (uevent)
>> May 13 11:28:28 rb9init4 multipathd: sdaj path added to devmap 3624a9370=
c90d0d631ef8783e00010004
>> =

> I ran through the code a little bit the other day, and I don't see how
> it could be making a mistake here.  It runs scsi_id, the result is
> placed in a 128 character buffer, then it is strncmp'd with the wwid of
> the mpath devices.
>> =

>> I don=92t understand where it gets 3624a9370c90d0d631ef8783e00010004.
>> When I run the =91multipath -v6 -d=92 so that it prints out what it wants
>> to do but doesn=92t do it, I see:
> =

>> May 13 16:45:15 | sdaj: getuid =3D /lib/udev/scsi_id --whitelisted
>> --device=3D/dev/%n (config file default)
>> May 13 16:45:15 | sdaj: uid =3D 3624a9370c90d0d631ef8783e00010002
>> (callout)
>> May 13 16:45:15 | sdaj: state =3D running
>> May 13 16:45:15 | sdaj: detect_prio =3D 1 (config file default)
>> May 13 16:45:15 | sdaj: prio =3D const (config file default)
>> May 13 16:45:15 | sdaj: const prio =3D 1
>> =

> Running this command later will make it do the same thing, run scsi_id
> which runs an inquiry that gets the wwid..  I would think the only
> reason these should be different is that the inquiries returned
> different values when multipathd did it at 11:28, and when you did it
> through multipath at 16:45.  =

> =

> In order to see that, we'd probably need to set verbosity 3 in the
> defaults section of multipath.conf, restart the daemon, and do it
> again..  Does anyone else have any thoughts on this?
>> =

>> So it seems to know thats its serial ends in =9302=94 and not =9304=94 l=
ike
>> where it put the device. I don=92t understand how to debug this further,
>> so any help would be appreciated.
> =

> =

> Thanks,
> Sean Stewart
> =

> =

> =

> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

Brian Bunker
brian@purestorage.com

From: Brian Bunker <brian@purestorage.com>
Subject: Re: an interesting note on LUN coalescing
Date: Thu, 15 May 2014 10:23:06 -0700
Message-ID: <CDE8FB77-CD2E-4FF6-8485-C08FA3A7AE74@purestorage.com>
References: <9E356404-6E9E-4271-A8DC-8A95DD66AC81@purestorage.com>
	<1400173675.19394.13.camel@ict-vth-stewarts01.ict.englab.netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1400173675.19394.13.camel@ict-vth-stewarts01.ict.englab.netapp.com>
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

I will get both the page 0x83 and page 0x80 data of the path when the probl=
em happens. In our case the page 0x83 and page 0x80 data are the same alway=
s. The page 0x83 data has the additional encoding and OUI information but t=
he bytes after that 3624a9370 are exactly the same. I am wondering about ho=
w the path gets its wwid when it comes back. =


In our case we have a controller coming back online after doing something. =
All the LUNs are re-discovered by the initiator and an sd device gets creat=
ed for each LUN path which came back. The serial of the sd device at that t=
ime I believe is known to the initiator. The multipathd gets that sd device=
 and comes up with a wwid. I would expect that wwid would be just the seria=
l number plus some bytes in the beginning but that is not what we see in th=
e fail case. The path wwid and path serial are pointing to different volume=
s on the array. I expect that the sd device will show the same data for pag=
e 0x83 and page 0x80 pointing to the same volume on the array but I will ve=
rify that with more logging.

You can see from my previous posts on this issue. (They go back for some ti=
me). That the page 0x83 and page 0x80 from sg3_utils show that they point t=
o same LUN but different from the dm device that they are coalesced under.

Thanks,
Brian
On May 15, 2014, at 10:07 AM, Stewart, Sean <Sean.Stewart@netapp.com> wrote:

> Hi Brian,
> =

> I responded to your other email before I saw this one, but I wanted to
> see if I could help, here, too. =

> =

> On Thu, 2014-05-15 at 09:35 -0700, Brian Bunker wrote:
>> I have added a line to multipathd/main.c to see if I could get some more=
 information when the dm device gets the wrong LUN=92s underneath. So I hav=
e a dm device:
>> =

>> 3624a9370c90d0d631ef8783e00010004 dm-2 PURE,FlashArray
>> size=3D500G features=3D'0' hwhandler=3D'0' wp=3Drw
>> `-+- policy=3D'round-robin 0' prio=3D0 status=3Dactive
>>  |- 3:0:0:3 sdav 66:240 active undef running
>>  |- 0:0:0:3 sdbc 67:96  active undef running
>>  |- 6:0:0:3 sdbt 68:112 active undef running
>>  |- 5:0:0:3 sdbu 68:128 active undef running
>>  |- 7:0:0:1 sdal 66:80  active undef running
>>  |- 2:0:0:1 sdb  8:16   active undef running
>>  `- 4:0:0:1 sdk  8:160  active undef running
>> =

>> I can see that when sdk is added to the dm, it is added to a dm ending i=
n 004, but the serial number of sdk clearly ends in 002:
>> =

>> May 15 05:09:55 rb9init4 multipathd: sdk: add path (uevent)
>> May 15 05:09:55 rb9init4 multipathd: 3624a9370c90d0d631ef8783e00010004: =
load table [0 1048576000 multipath 0 0 1 1 round-robin 0 7 1 66:240 1 67:96=
 1 68:112 1 68:128 1 66:80 1 8:16 1 8:160 1]
>> May 15 05:09:55 rb9init4 multipathd: sdk path added to devmap 3624a9370c=
90d0d631ef8783e00010004
>> May 15 05:09:55 rb9init4 multipathd: sdk [8:160]: path has a serial C90D=
0D631EF8783E00010002
>> =

>> I am printing out pp->serial to get the serial number of sdk. =

> =

> pp->serial actually plays no part in determining the multipath device.
> It is queried from VPD page 0x80, via the function get_serial, whereas
> the wwid is obtained from VPD page 0x83, through the function get_uid().
> The pp->wwid attribute ultimately is what it compares to determine the
> multipath device.
> =

> Perhaps when you do this, we should check what the device reports as the
> wwid in inquiry page 0x83?  If you have sg3_utils on your system, you
> can do that through sg_vpd -p 0x83 <device>.  I'd be interested in
> knowing if the page 0x83 and the serial in 0x80 are disagreeing at the
> time it's being queried by multipathd..
> =

> =

> Thanks,
> Sean Stewart
> =

> =

> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

Brian Bunker
brian@purestorage.com

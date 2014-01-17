From: Brian Bunker <brian@purestorage.com>
Subject: Re: About WWID
Date: Fri, 17 Jan 2014 10:07:44 -0800
Message-ID: <3922A2F5-A049-4D48-96BB-50B2D55E33D7@purestorage.com>
References: <CAO5znavrjYwyY2=bmZ0F++ePJP3+geDhUd4DVvLL8aW25xgtGg@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAO5znavrjYwyY2=bmZ0F++ePJP3+geDhUd4DVvLL8aW25xgtGg@mail.gmail.com>
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

Nicolas,

The details of this are spelled out in the SPC-4 SCSI document available fr=
om t10.org. The =913=92 in the value you are asking about tells what format=
 that the value in question is using. =913=92 being =91NAA=92. The =916=92 =
too is also again a format designation as well. The rest of the number cont=
ains a company id and then the part that is unique to a particular volume o=
n your array:

So it is:

=913=92 - NAA
=916=92 - NAA
=91000144=92 - =91EMC corporation=92
=910000000102058055965f660d8=92 - Some unique id (some part will likely be =
a serial number you can see on the array side)

Multipathing software uses this number to determine if a device is a new de=
vice or a path to an existing one. The answer to your question is that a ww=
id is not defined in the SPC-4 spec so what is right is not really relevant=
, it is more just how they choose to display uniqueness. multipath is displ=
aying the entire designator while EMC is stripping the =913=92 from the fro=
nt. Either way it is in the VPD page 0x83 of an inquiry to your device. You=
 can do =91sg_inq -p 0x83 device=92 where device is /dev/*** to see what I =
mean.

Thanks,
Brian

On Jan 17, 2014, at 4:19 AM, Nicolas Michel <be.nicolas.michel@gmail.com> w=
rote:

> Hello guys,
> =

> I noticed a difference with the WWID of a multipath device as reported
> by the device mapper native multipath, and by the EMC propriatary tool
> powermt. In the latter case it misses a leading 3 (which seems to be
> an invariant prefix with the device mapper).
> =

> Exemple :
> =

> Reported by multipath -ll : 360001440000000102058055965f660d8
> Reported by powermt :       60001440000000102058055965F660D8
> =

> My questions are : what means the leading 3 given by the device-mapper
> and which one is the right WWID?
> =

> Thank you a lot ;)
> =

> -- =

> Nicolas MICHEL
> =

> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

Brian Bunker
brian@purestorage.com

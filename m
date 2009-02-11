From: "Romanowski, John (OFT)" <John.Romanowski@oft.state.ny.us>
Subject: RE: Bug? Determining the holders of partitions shadowed
	by dm-multipath.
Date: Tue, 10 Feb 2009 20:14:11 -0500
Message-ID: <16F7C86087BE0247B20562A9E6B07DC75BC1284D@excnysm95bagp.nysemail.nyenet>
References: <20090210004951.GA4341@mail.oracle.com>
	<16F7C86087BE0247B20562A9E6B07DC75BB5DAA6@excnysm95bagp.nysemail.nyenet>
	<20090210213239.GA30270@mail.oracle.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090210213239.GA30270@mail.oracle.com>
Content-Language: en-US
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

good point. sorry.
The partition's parent's device number will be in the dmsetup deps list.
/dev/sda2 is a partition; dmsetup deps will list its parent's, /dev/sda, =
major:minor as a dependency of the mpath device .

kludgy.

> -----Original Message-----
> From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
> On Behalf Of Joel Becker
> Sent: Tuesday, February 10, 2009 4:33 PM
> To: device-mapper development
> Subject: Re: [dm-devel] Bug? Determining the holders of partitions
> shadowed by dm-multipath.
>
> On Tue, Feb 10, 2009 at 09:49:58AM -0500, Romanowski, John (OFT) wrote:
> > my sles10sp2 at 2.6.16.60-0.29-default doesn't have the
> /sys/block/.../holders but
> > I've used major:minor device numbers from commands
> > dmsetup ls
> > and
> > dmsetup deps
> > to resolve such device relationships.
> >
> > A 'dmsetup ls' device number that isn't listed in 'dmsetup deps'
> device numbers is a top-level device. Example below: mproot-part1 (dev
> 253:3, a partition of mp device 253:2) isn't listed as a dependency of
> any device. Likewise each listed LVM volume isn't listed as a
> dependency of any device; example- rootvg-tmp 253:10
>
>       Sure, but a /dev/sda2 won't show up in dmsetup output anywhere.
> That's kind of my point.
>
> Joel
>
> --
>
> Life's Little Instruction Book #198
>
>       "Feed a stranger's expired parking meter."
>
> Joel Becker
> Principal Software Developer
> Oracle
> E-mail: joel.becker@oracle.com
> Phone: (650) 506-8127
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel


This e-mail, including any attachments, may be confidential, privileged o=
r otherwise legally protected. It is intended only for the addressee. If =
you received this e-mail in error or from someone who was not authorized =
to send it to you, do not disseminate, copy or otherwise use this e-mail =
or its attachments.  Please notify the sender immediately by reply e-mail=
 and delete the e-mail from your system.

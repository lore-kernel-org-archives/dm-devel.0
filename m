From: joe@eiler.net
Subject: Re: Data corruption on large, multi-device filesystem
Date: Tue, 25 Jan 2005 09:37:28 -0800
Message-ID: <1106674648.41f683d80ea75@www.eiler.net>
References: <20050118091059.GC27553@pcnocjb.dlan.cinetic.de>
	<1106172883.41eedbd386498@www.eiler.net>
	<41EFBAF4.5030403@svs.gsfc.nasa.gov>
	<20050120175900.GE14093@agk.surrey.redhat.com>
	<20050121150913.GA16975@pcnocjb.dlan.cinetic.de>
Reply-To: LVM general discussion and development <linux-lvm@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-lvm-bounces@redhat.com>
In-Reply-To: <20050121150913.GA16975@pcnocjb.dlan.cinetic.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/linux-lvm>,
	<mailto:linux-lvm-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/linux-lvm>
List-Post: <mailto:linux-lvm@redhat.com>
List-Help: <mailto:linux-lvm-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/linux-lvm>,
	<mailto:linux-lvm-request@redhat.com?subject=subscribe>
Sender: linux-lvm-bounces@redhat.com
Errors-To: linux-lvm-bounces@redhat.com
To: Jens Beyer <jbe@webde-ag.de>
Cc: dm-devel@redhat.com, LVM general discussion and development <linux-lvm@redhat.com>
List-Id: dm-devel.ids

I just thought I would give a quick update on what I have been doing in c=
ase
anyone can give me more/better direction.

I incorporated the (sector_t) cast and I also changed stripe_width to sec=
tor_t
since my individual devices are bigger than 2TB.

I took lvm out of the equation by using dmsetup and striping together my
devices.  Then I created and mounted and XFS filesystem directly on /dev/=
dm-0
This still caused corruption.

I have compiled hashdd with largefile support and am now letting it run d=
irectly
on /dev/dm-0.  The write finished last night and I am running the read pa=
ss now
(man it takes a long time to to write and verify 4+TB)

I have also been putting some debug statements in stripe_map() but this h=
asn't
shown me anything useful yet.

Joe

Quoting Jens Beyer <jbe@webde-ag.de>:

>
> Hi,
>
> On Thu, Jan 20, 2005 at 05:59:00PM +0000, Alasdair G Kergon wrote:
> > On Thu, Jan 20, 2005 at 09:06:44AM -0500, Randall A. Jones wrote:
> > > To verify, this corruption you are seeing only happens when you hav=
e a
> > > LV larger than 2TB
> > > and when you use striping specifically with lvcreate -i.
> > > Has anyone experienced data corruption with >2TB LV and no striping=
?
> >
> > Does this patch help?
> >
>
> No, it doesn't. I just checked multiple times in different setups.
> To address the 'chunksize' Problem mentioned i used lvcreate -i 3 -I 25=
6 .
>
> Jens
>
>
> >
> > Missing cast causing data corruption on devices with stripes > ~1TB.
> > --- diff/drivers/md/dm-stripe.c	2005-01-20 17:32:37.000000000 +0000
> > +++ source/drivers/md/dm-stripe.c	2005-01-20 17:32:26.000000000 +0000
> > @@ -179,7 +179,7 @@
> >
> >  	bio->bi_bdev =3D sc->stripe[stripe].dev->bdev;
> >  	bio->bi_sector =3D sc->stripe[stripe].physical_start +
> > -	    (chunk << sc->chunk_shift) + (offset & sc->chunk_mask);
> > +	    ((sector_t) chunk << sc->chunk_shift) + (offset & sc->chunk_mas=
k);
> >  	return 1;
> >  }
> >
> >
>
>
> --
> Nur tote Fische schwimmen mit dem Strom
>
> _______________________________________________
> linux-lvm mailing list
> linux-lvm@redhat.com
> https://www.redhat.com/mailman/listinfo/linux-lvm
> read the LVM HOW-TO at http://tldp.org/HOWTO/LVM-HOWTO/
>



_______________________________________________
linux-lvm mailing list
linux-lvm@redhat.com
https://www.redhat.com/mailman/listinfo/linux-lvm
read the LVM HOW-TO at http://tldp.org/HOWTO/LVM-HOWTO/

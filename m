From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: Configuring multipath for root device
Date: Tue, 15 Jan 2008 18:32:53 -0800
Message-ID: <1200450773.7183.42.camel@linuxchandra>
References: <110b17190712191302o60d521eaj693410c26d07c1ad@mail.gmail.com>
	<1198099093.26366.32.camel@linuxchandra>
	<110b17190801071219k11749b81n45a7d1d5d35b9413@mail.gmail.com>
	<4783239C.7020206@suse.de>
	<110b17190801151825ofd63e20yd9d4f01be7b67407@mail.gmail.com>
Reply-To: sekharan@us.ibm.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <110b17190801151825ofd63e20yd9d4f01be7b67407@mail.gmail.com>
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

On Tue, 2008-01-15 at 18:25 -0800, Pradipmaya Maharana wrote:
> Hi All,
>=20
> Thanks for all your comments, it worked for installaions on partitions.

Cool.
>=20
> Now the question is:
> Is it supposed to work the same way if the SLES is installed on LVM?

Supposed to :)

> On SLES, under fstab, I do not see any device, except for the boot
> device; other entries does not have /dev/deisk mention. In such

I am not clear about what you are mentioning here. Can you annotate with
a cut-n-paste of /etc/fstab ?

> scenario, how am I supposed to make the /root device multipath-aware?
>=20
> I tried the same with RHEL, but with RHEL installed (with linux mpath)
> on LVM, it seems to be working fine. Is there anything I am missing on
> SLES?
>=20
> Thanks and Regards,
> Pradipmaya.
>=20
>=20
>=20
> On Jan 7, 2008 11:17 PM, Hannes Reinecke <hare@suse.de> wrote:
> > Pradipmaya Maharana wrote:
> > > RHEL Steps worked perfectly for me but i have a question for SLES i=
nstallation.
> > >
> > > Question. While installing SLES on multipath devices, the second st=
ep says:
> > >
> > > " 2. Complete the installation. Let the system boot up in multiuser=
 mode.
> > > Make sure the root device, swap device are all referenced by their =
by-id
> > > device node entries instead of /dev/sd* type names. If they are not=
, fix
> > > them first."
> > >
> > > How do you check that root device and swap device are referenced by=
 their by-id?
> > > And if it is not referenced by the by-id, how do I fix it? Re-insta=
ll?
> > >
> > Check /etc/fstab. Those devices should be listed as /dev/disk/by-id/X=
XX.
> > If not (ie if their names are /dev/sdXX) look for the appropriate sym=
link
> > in /dev/disk/by-id and edit /etc/fstab.
> >
> > Cheers,
> >
> > Hannes
> > --
> > Dr. Hannes Reinecke                   zSeries & Storage
> > hare@suse.de                          +49 911 74053 688
> > SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> > GF: Markus Rex, HRB 16746 (AG N=C3=BCrnberg)
> >
> > --
> >
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
> >
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
--=20

----------------------------------------------------------------------
    Chandra Seetharaman               | Be careful what you choose....
              - sekharan@us.ibm.com   |      .......you may get it.
----------------------------------------------------------------------

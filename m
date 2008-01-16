From: "Romanowski, John (OFT)" <John.Romanowski@oft.state.ny.us>
Subject: RE: Configuring multipath for root device
Date: Tue, 15 Jan 2008 23:24:05 -0500
Message-ID: <1D80D4F6D179BD4D869FE807A5BF833602616FB0@EXCNYSM0A1AN.nysemail.nyenet>
References: <110b17190712191302o60d521eaj693410c26d07c1ad@mail.gmail.com><1198099093.26366.32.camel@linuxchandra><110b17190801071219k11749b81n45a7d1d5d35b9413@mail.gmail.com><4783239C.7020206@suse.de><110b17190801151825ofd63e20yd9d4f01be7b67407@mail.gmail
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Class: urn:content-classes:message
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: sekharan@us.ibm.com, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

I'm very new to sles 10; sounds like you want to do root-on-LVM-on-multip=
ath=20
I don't know if sles10 supports that.

Maybe 2 things to try:=20
(1) if /dev/rootVG/rootLV has a /dev/disk/by-id/ link then use that persi=
stent name along with putting dm-multipath in INITRD modules list; then r=
un mkinitrd and zipl

(2) Or, use the LVM persistent name, /dev/rootVG/rootLV, instead of a /de=
v/disk/by-id/ name

good luck.


--------------------------------------------------------
This e-mail, including any attachments, may be confidential, privileged o=
r otherwise legally protected. It is intended only for the addressee. If =
you received this e-mail in error or from someone who was not authorized =
to send it to you, do not disseminate, copy or otherwise use this e-mail =
or its attachments.  Please notify the sender immediately by reply e-mail=
 and delete the e-mail from your system.


-----Original Message-----

From: dm-devel-bounces@redhat.com on behalf of Chandra Seetharaman
Sent: Tue 1/15/2008 9:32 PM
To: device-mapper development
Subject: Re: [dm-devel] Configuring multipath for root device
=20
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
> > SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> > GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
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


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

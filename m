From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: [PATCH] [RFC] switch DM tables to
	readonly	automatically
Date: Wed, 30 Apr 2008 11:34:13 +0200
Message-ID: <1209548053.26745.25.camel@plop>
References: <1209543591.26745.9.camel@plop>  <4818348E.6050609@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4818348E.6050609@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Le mercredi 30 avril 2008 =C3=A0 10:57 +0200, Hannes Reinecke a =C3=A9cri=
t :
> Hi Christophe,
>=20
> Christophe Varoqui wrote:
> >> Hi all,
> >>
> >> this patch switches the device-mapper table to read-only status auto=
matically if one underlying device returns -EROFS.
> >>
> >> Rationale:
> >> Whenever a SCSI device is switched to read-only a table reload from =
multipath-tools fails, without any indication about the reason. And it's =
actually quite tricky to detect the read-only status from userland. And q=
uite pointless, too, as the kernel already knows about it.
> >>
> >> And we now can create tables for CD-ROMs, too, without having to use=
 the '-r' flag to dmsetup ...
> >>
> >> Christophe, this might also fix your problem.
> >>
> > It seems it will solve the map creation error on read-only LU, but wh=
at about these LU becoming writable ? ...
> > as is the case with the Symmetrix R2 upon spliting the synchronisatio=
n link.
> > Will the devmap become writable too automagically or is the multipath=
d daemon expected to take action the promote the map RW ?
> >=20
> Tricky business. We'll first have to be notified that the LU is becomin=
g writeable. The current SCSI stack is not
> very good at providing that sort of information.
>=20
> I would think the best way here would be to modify the 'tur' checker to=
 check for the READ-ONLY state, too.
> That would mean we'll have to implement a new path state 'READONLY', bu=
t that should be okay methinks.
> But this would have to be done at the SCSI level as the current 'sd' dr=
iver is not capable of switching
> between read-only and read-write on the fly, either.
>=20
> Maybe I'll give it a go if I find some time.
>=20
For your information, I checked the rhel4 behaviour.

That stuff worked out-of-the-box with rhel4 kernel : paths to R2 were
not flagged RO, so maps over R2 LU paths were RW; the Symmetrix failed
ios when paths were actually not writable and, upon spliting, multipaths
were usable without any userspace action.

Is all this precaution about not submitting ios to the R2 LU really
worth the pain ? Can't we just let the device mapper moun RW maps over
RO paths ?

Regards,
cvaroqui

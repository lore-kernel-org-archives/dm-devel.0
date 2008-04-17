From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: path checker open() flags, devmapper ioctl()
Date: Thu, 17 Apr 2008 23:21:00 +0200
Message-ID: <1208467260.11770.105.camel@plop>
References: <1208465743.11770.100.camel@plop>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1208465743.11770.100.camel@plop>
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

Le jeudi 17 avril 2008 =C3=A0 22:55 +0200, Christophe Varoqui a =C3=A9cri=
t :
> Notice to reader : real questions are hidden in this obfuscated
> message ! I'll mark them with ** to augment the chances for them being
> answered :)
>=20
> Path checker maintainers,
>=20
> ** would you object to my changing the checkers open() flags from O_RDW=
R
> to O_RDONLY ? ** Directio and readsector0 would not object, and all
> other checkers use the file descriptor to submit SG_IO ioctls which do
> not require Write capability.
> Re-reading the SG documentation at http://sg.torque.net/sg/sg_io.html, =
I
> understand it should be ok. In real life, scsi_id does exactly that for
> example.
>=20
Please disregard this first part : O_RDONLY is already the flag use in
libmultipath/discovey.c

> The particular issue I'm facing is that on a RHEL5 box presented with
> EMC Symmetrix R2 Logical Units (write-protected LU receiving SRDF
> updates from R1 LU), the checker bails out on open(/dev/sd?, O_RDWR|
> O_NONBLOCK) returning EROFS. opening with O_RDONLY grants us a usable
> fd, which give the checker a chance to report the actual path state.
>=20
> I'd like to fix the checker inconsistency, but we'll hit another wall
> short after that : because the device mapper refuses to honor the
> R2-multipath-tables loading without the read-only devmap option.
>=20
> This behavior is new to RHEL5. R2 LU could perfectly be multipathed in
> RHEL4.
> ** Does someone have insight about this new kernel behaviour, and about
> the multipath layer =EF=BB=BFdesired behaviour in this context ? ** I p=
ersonnaly
> would rather not care for promoting a devmap from RO to RW upon R1-R2
> split, and the even more tricky demoting from RW to RO (what about io
> flush ?) upon un-spliting.
>=20
> Regards,
> cvaroqui

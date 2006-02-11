From: =?ISO-8859-2?Q?Stanislav_Pol=E1=B9ek?= <sp@linworx.cz>
Subject: Re: multipath device question
Date: Sat, 11 Feb 2006 15:50:46 +0100
Message-ID: <43EDF9C6.2010805@linworx.cz>
References: <43ED334A.7050009@linworx.cz>
	<20060211012538.GD31895@dogpound.rdu.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20060211012538.GD31895@dogpound.rdu.redhat.com>
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

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Josef Whiter wrote:
> On Sat, Feb 11, 2006 at 01:43:54AM +0100, Stanislav Pol=E1=B9ek wrote:
>=20
>>-----BEGIN PGP SIGNED MESSAGE-----
>>Hash: SHA1
>>
>>Hi! Let me please start with apology for using the development list to
>>ask rather end-user question. I am looking for help with multipath
>>setup. I have a few servers connected to a ibm storage. Two servers hav=
e
>>two qlogic HBAs each. On the first server was created a multipath devic=
e
>>out of all 4 scsi devices/paths. On the second server it is possible to
>>assemble the same mp device and attach it without problems (there is th=
e
>>gfs).
>>
>>However, the third server I would like to connect to the storage has
>>just one HBA. It's only 1U format and I cannot add anything to it. And
>>moreover, the visible storage scsi device order there is different.
>>
>>As I know the mdadm that I used to create the multipath device writes t=
o
>>the superblock an information about the array, I would like to find out
>>how much the multipath implementation in the kernel depends on this
>>information. Would it be a problem to connect the third server to the
>>storage by assembling the multipath device out of just two scsi
>>devices/paths instead of four and in addition using scsi devices with
>>diferrent minor/major numbers?
>>
>>As I do really doubt that, is there any way how to connect the third
>>server using the multipath setup?
>>
>>Thank you very much for your help. I could get the answers by testing,
>>but these are production servers with terrabytes of data and I cannot
>>really stop them now for more then just a few minutes.
>>
>>Stanislav Polasek
>=20
>=20
> Hello,
>=20
> DM multipathing is all automatic, it does not write any information to =
the disk,
> it is completely nodal specific.  If you have different multipathing se=
tup for
> each node, or nodes that aren't multipathed, dm multipathing will figur=
e
> everything out by itself.  You will have to keep in mind that in order =
to add a
> node to an existing two node GFS6.1 cluster you will have to bring the =
cluster
> down because of the special two node option.  After you have more than =
two nodes
> you can add nodes without rebooting the cluster.  Thank you,
>=20
> Josef
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

Thank you very much for the answer. Would that mean the dm-multipath on
one machine would happily coexist with the md-multipath on the other two
machines? The setup of first two servers was done by the vendor and they
did it the MD way. But, as I suspect, the md-multipath uses the
superblocks to store info about the multipath array, so it seems to be
dangerous to have different MD configuration on different machines
conected to the same target drive.

Thank you again.

st.

- --
#--#--#--#--#--#--#--#--#--#--
Stanislav Polasek
RHCE #804005251615651 / RHCX
LinWorx s.r.o.
sp@linworx.cz / www.linworx.cz
#--#--#--#--#--#--#--#--#--#--
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFD7fnGN6fiEWfPEr8RAsGTAJ0RDoU4B1LvQ0EPIUwKu/Y3oQ7utgCfQsiN
UkMXB2dM7ubpJ09MLKTjBJg=3D
=3DwPQ7
-----END PGP SIGNATURE-----

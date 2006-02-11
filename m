From: Josef Whiter <jwhiter@redhat.com>
Subject: Re: multipath device question
Date: Fri, 10 Feb 2006 20:25:38 -0500
Message-ID: <20060211012538.GD31895@dogpound.rdu.redhat.com>
References: <43ED334A.7050009@linworx.cz>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <43ED334A.7050009@linworx.cz>
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

On Sat, Feb 11, 2006 at 01:43:54AM +0100, Stanislav Pol=C3=A1=C5=A1ek wro=
te:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>=20
> Hi! Let me please start with apology for using the development list to
> ask rather end-user question. I am looking for help with multipath
> setup. I have a few servers connected to a ibm storage. Two servers hav=
e
> two qlogic HBAs each. On the first server was created a multipath devic=
e
> out of all 4 scsi devices/paths. On the second server it is possible to
> assemble the same mp device and attach it without problems (there is th=
e
> gfs).
>=20
> However, the third server I would like to connect to the storage has
> just one HBA. It's only 1U format and I cannot add anything to it. And
> moreover, the visible storage scsi device order there is different.
>=20
> As I know the mdadm that I used to create the multipath device writes t=
o
> the superblock an information about the array, I would like to find out
> how much the multipath implementation in the kernel depends on this
> information. Would it be a problem to connect the third server to the
> storage by assembling the multipath device out of just two scsi
> devices/paths instead of four and in addition using scsi devices with
> diferrent minor/major numbers?
>=20
> As I do really doubt that, is there any way how to connect the third
> server using the multipath setup?
>=20
> Thank you very much for your help. I could get the answers by testing,
> but these are production servers with terrabytes of data and I cannot
> really stop them now for more then just a few minutes.
>=20
> Stanislav Polasek

Hello,

DM multipathing is all automatic, it does not write any information to th=
e disk,
it is completely nodal specific.  If you have different multipathing setu=
p for
each node, or nodes that aren't multipathed, dm multipathing will figure
everything out by itself.  You will have to keep in mind that in order to=
 add a
node to an existing two node GFS6.1 cluster you will have to bring the cl=
uster
down because of the special two node option.  After you have more than tw=
o nodes
you can add nodes without rebooting the cluster.  Thank you,

Josef

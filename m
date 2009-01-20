From: Stefan Raspl <raspl@linux.vnet.ibm.com>
Subject: Re: Re: [RFC] [PATCH] lvm2: mirroredlog support
Date: Tue, 20 Jan 2009 08:13:47 +0100
Message-ID: <497579AB.4060503@linux.vnet.ibm.com>
References: <20081230001055.GA13710@us.ibm.com> <49750524.3030007@redhat.com>
	<20090120015427.GA16550@us.ibm.com>
Reply-To: raspl@linux.vnet.ibm.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090120015427.GA16550@us.ibm.com>
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

Hi Malahal,

malahal@us.ibm.com wrote:
>> Avoiding disk replication even if a log device got trouble is one of
>> the requirements. Is there any solution to avoid this problem by the
>> mirrored log approach?
>=20
> Two ways to fix:
> 1) Never make "error leg" as your master leg as that is pointless.
> 2) Maybe we can use 'nosync' option when one of the two legs is known t=
o
>    be an error device. This is probably easier than method (1)
>=20
> Any other methods? Any help regarding which method to pursue would be
> very much appreciated.
>=20
> Thanks, Malahal.
> PS: This patch was always used along with other patches and that could
> explain why we didn't notice this problem.

If I understand Takahiro correctly, the main issue is that the whole
log device becomes unusable in case one leg is broken...? Of course,
we still have the other leg with the most recent data available and
can read from that one. However, this would require that we can
start a mirror in rw-mode (so we can keep the still-recent half up
to date) even if one half has failed - a functionality which was
recently added to LVM, as we discussed in our last call...?
I'm not sure if I understand his statements about the
synchronization correctly. Why would any synchronization within the
data mirror occur at all? It's only the log which is broken, not the
actual data in vg00-lv00_mimage_0/1. If any synchronization in the
_data_ mirror occurs just because one leg in the _log_ mirror has a
problem, I'd consider that a bug.

Ciao,
Stefan

--=20
Linux on System z
IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Martin Jetter
Gesch=E4ftsf=FChrer: Erich Baier
Sitz der Gesellschaft: B=F6blingen
Registergericht: Amtsgericht Stuttgart, HRB 243294

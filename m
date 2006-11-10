From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: patch for handling CLARiiON I/O to inactive snapshot
	logical units
Date: Fri, 10 Nov 2006 23:00:08 +0100
Message-ID: <1163196008.10466.26.camel@localhost.localdomain>
References: <6CCEAEDF4D06984A83F427424F47D6E4013D152B@CORPUSMX40A.corp.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <6CCEAEDF4D06984A83F427424F47D6E4013D152B@CORPUSMX40A.corp.emc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Edward Goggin <egoggin@emc.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Le vendredi 10 novembre 2006 =C3=A0 14:58 -0500, Edward Goggin a =C3=A9cr=
it :
> Christophe,
>=20
> Here is my 2nd attempt at a patch which attempts to prevent an I/O hang
> which can occur with host I/O to an inactive CLARiiON snapshot logical
> unit.

Hi Edward,

I think the diff is line-wrapped. Would you care to resend it as an
attachment, or unwrapped.

>   While the inactive snapshot LU is presented to a host, inquiry,
> TUR, and read capacity commands succeed, but read and write commands ar=
e
> failed.  Complicating the matter is the fact that read/write to the
> active paths fails with a particular sense code/asc/ascq combination
> while read/write to the passive paths does not.
>=20
> Unlike the previous patch, I've tried to make this one CLARiiON
> specific.  Two exceptions though.  First, I did keep the change to
> libcheckers/readsector0.c to allow other checkers than readsector0 to
> use sg_read().

Right. I'll merge this one first. Feel free to submit it as a seperate
patch.

>   Second, I changed libmultipath/discovery.c to allow
> pathinfo() to invoke the path priority callout function of a path with =
a
> path state of PATH_DOWN since some paths (e.g., paths to inactive
> snapshot LU on CLARiiON) may have their state set to PATH_DOWN for
> reasons other than transport connectivity failure.  Without the latter
> change, it is possible to create a situation whereby there are paths of
> different priorities in the same path group even though the path group
> policy is priority based grouping.  This is certainly the case for path=
s
> to a multipath mapped device for an inactive snapshot CLARiiON LUs when
> the paths change to a healthy state as soon as the snapshot is
> activated.
>=20
Ok, RedHat people working on the HSG/HSV hardware support might want to
test for regression with that part applied. I'll happily take reports as
I no longer have access to such hardware.

Now I still have to read through the clariion checker changes.

Thanks,
cvaroqui

From: KAIZUKA Hiroyuki <kaizuka@valinux.co.jp>
Subject: Re: Utility tool for dm-ioband.
Date: Thu, 24 Apr 2008 21:00:28 +0900
Message-ID: <20080424120028.GA23621@kai.local.valinux.co.jp>
References: <4810752F.30205@valinux.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Return-path: <xen-devel-bounces@lists.xensource.com>
Content-Disposition: inline
In-Reply-To: <4810752F.30205@valinux.co.jp>
List-Unsubscribe: <http://lists.xensource.com/cgi-bin/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xensource.com>
List-Help: <mailto:xen-devel-request@lists.xensource.com?subject=help>
List-Subscribe: <http://lists.xensource.com/cgi-bin/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=subscribe>
Sender: xen-devel-bounces@lists.xensource.com
Errors-To: xen-devel-bounces@lists.xensource.com
To: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, virtualization@lists.linux-foundation.org, dm-devel@redhat.com, xen-devel@lists.xensource.com
Cc: agk@sourceware.org
List-Id: dm-devel.ids

Hi,

This is iobandctl usage examples


EXAMPLE 1

This example shows how to create ioband devices, set weight values,=20
create groups, and delete the ioband devices. The following is=20
the typical case iobandctl expects.

           sdb
     +--------------+     +-------+------+-------+=20
50%  |     sdb1     | <-- |default|root  |user1  | ioband-sdb1
     |              |     | 60%   | 30%  | 10%   |
     +--------------+     +-------+----- +-------+
30%  |     sdb2     | <-- |default|root  |user1  | ioband-sdb2
     |              |     | 60%   | 30%  | 10%   |
     +--------------+     +-------+------+-------+
20%  |     sdb3     | <-- |default|root  |user1  | ioband-sdb3
     |              |     | 60%   | 30%  | 10%   |
     +--------------+     +-------+------+-------+

(1) Create ioband devices

# iobandctl create /dev/sdb

3 ioband devices =1B$B!]=1B(B /dev/mapper/ioband=1B$B!]=1B(Bsdb1, /dev/mapp=
er/ioband=1B$B!]=1B(Bsdb2,=20
/dev/mapper/ioband=1B$B!]=1B(Bsdb3 =1B$B!]=1B(B are created.
   =20
(2) Set weight values
   =20
# iobandctl weight /dev/sdb1:50 /dev/sdb2:30 /dev/sdb3:20

Allocate 50% of I/O bandwidth to /dev/sdb1, 30% to /dev/sdb2,=20
20% to /dev/sdb3. Now, you will be able to receive the benefit of=20
bandwidth control using /dev/mapper/ioband-sdb[1-3] instead of=20
/dev/sdb[1-3].

(3) Create groups

# iobandctl group /dev/sdb uid root:30 user1:10 default:60

Create groups. Group "root" and group "user1" are created on all=20
ioband devices which have been mapped to the partitions contained=20
in /dev/sdb. The processes whose uid is "root" are allocated 30% of=20
I/O bandwidth. As a result, processes doing I/O to ioband=1B$B!]=1B(Bsdb1 a=
nd=20
whose uid is "root" can use 15% (50% for ioband-sdb1, 30% for root.=20
50% x 30% =3D 15%) of I/O bandwidth which /dev/sdb has.=20
default means all processes whose uid is not "root" or "user1".

(4) Delete ioband devices

# iobandctl destroy /dev/sdb

Delete ioband devices. ioband-sdb1, ioband-sdb2, and ioband-sdb3 are=20
deleted.

EXAMPLE 2

/dev/sdb1 is an extended partition, which you don=1B$B!G=1B(Bt need I/O ban=
dwidth=20
control. /dev/sdb5 and /dev/sdb6 are intended to be controlled by uids,=20
/dev/sdb7 by gids.

           sdb
     +--------------+     +-------+------+-------+
 0%  |     sdb1     | <-- |       |      |       | ioband-sdb1
     +--------------+     +-------+----- +-------+
40%  |     sdb5     | <-- |default|root  |user1  | ioband-sdb5
     |              |     | 60%   | 30%  | 10%   | (controlled by uid)
     +--------------+     +-------+----- +-------+
30%  |     sdb6     | <-- |default|root  |user1  | ioband-sdb6
     |              |     | 60%   | 30%  | 10%   | (controlled by uid)
     +--------------+     +-------+------+-------+
30%  |     sdb7     | <-- |default|wheel |users  | ioband-sdb7
     |              |     | 50%   | 40%  | 10%   | (controlled by gid)
     +--------------+     +-------+------+-------+

(1) Create ioband devices

# iobandctl create /dev/sdb

The same as EXAMPLE 1 (1).

(2) Set weight values

# iobandctl weight /dev/sdb5:40 /dev/sdb6:30 /dev/sdb7:30

The weight value of the device not specified (/dev/sdb1) is set to 0=20
automatically.

(3) Create groups

# iobandctl group /dev/sdb uid root:30 user1:10 default:60 <-- (a)
# iobandctl group /dev/sdb7 gid wheel:40 users:10 default:50 <-- (b)

The (a) sets type "uid" and creates groups for /dev/sdb5 and /dev/sdb6,=20
although it sets the same settings to /dev/sdb7.
The (b) changes the settings of /dev/sdb7 only.


On Thu, Apr 24, 2008 at 08:55:27PM +0900, KAIZUKA Hiroyuki wrote:
> Hi everyone,
>=20
> I made a utility tool for dm-ioband version 0.0.4, named iobandctl.
>=20
> It enables you to easily apply I/O bandwidth control to an entire disk,
> and manage it. It helps you set the percentage of bandwidth
> to give each partition, and each user, process, group, or cgroup.
> (You are not able to use cgroup support yet, because the dm-ioband
> patch to enable cgroup support (http://lwn.net/Articles/273802/)
> is not ported to linux-2.6.25, but it will be soon.)
>=20
> You can download it and find the manual at
> http://people.valinux.co.jp/~kaizuka/dm-ioband/iobandctl/
>=20
> This is a prototype code.
> So, I'd like to hear your requests.
> Feature fixed, it is going to be re-written in C.
>=20
> Thanks,
> KAIZUKA Hiroyuki
>=20
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com
> http://lists.xensource.com/xen-devel
>=20

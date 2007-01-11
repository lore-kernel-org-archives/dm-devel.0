From: "Vijai Babu Madhavan" <mvijai@novell.com>
Subject: [RFC] Multiple Snapshots - Manageability problem
Date: Thu, 11 Jan 2007 11:18:13 -0700
Message-ID: <45A6CC0F.A9E3.000B.0@novell.com>
Reply-To: LVM general discussion and development <linux-lvm@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-lvm-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/linux-lvm>,
	<mailto:linux-lvm-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/linux-lvm>
List-Post: <mailto:linux-lvm@redhat.com>
List-Help: <mailto:linux-lvm-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/linux-lvm>,
	<mailto:linux-lvm-request@redhat.com?subject=subscribe>
Sender: linux-lvm-bounces@redhat.com
Errors-To: linux-lvm-bounces@redhat.com
To: evms-devel@lists.sourceforge.net, dm-devel@redhat.com, linux-lvm@redhat.com
List-Id: dm-devel.ids

Hi,

The problem of DM snapshots with multiple snapshots have been discussed=20
in the lists quiet a bit (Most recently @=20
https://www.redhat.com/archives/dm-devel/2006-October/msg00034.html).

We are currently in the process of building a DM snapshot target that sca=
les=20
well with many snapshots (so that the changed blocks don't get copied to =
each=20
snapshot). In this process, I would also like to validate an assumption.

Today, when a single snapshot gets created, a new cow device of a given s=
ize=20
is also created. IMO, there are two problems with this approach:

a) It is difficult to predict the size of the cow device, which requires =
a prediction=20
of the number of writes would go into the origin volume during the snapsh=
ot=20
life cycle. It is difficult to get this prediction right, as very high va=
lue reduces=20
utilization and low value increases the chances of snapshot becoming full=
.

b) A new cow device needs to be created every time.

This really gets messy and creates a management problem once many=20
snapshots of a given origin are created, and gets worse with multiple ori=
gins.

I am thinking, having a single device that would hold the cow blocks of a=
ny=20
number of snapshots of a given origin (or more) would help solve this iss=
ue=20
(Apart from this, having a single device helps share the cow blocks among=
=20
snapshots very effectively in a variety of scenarios).

But, it does require that LVM and EVMS be changed to suit this model and=20
also makes the snapshot target quiet complex.

I would like to receive some comments about what users, developers=20
and others think about this.

Thanks,
Vijai
P.S:- BTW, apologizes for cross posting.



_______________________________________________
linux-lvm mailing list
linux-lvm@redhat.com
https://www.redhat.com/mailman/listinfo/linux-lvm
read the LVM HOW-TO at http://tldp.org/HOWTO/LVM-HOWTO/

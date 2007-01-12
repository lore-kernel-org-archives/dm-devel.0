From: "Vijai Babu Madhavan" <mvijai@novell.com>
Subject: [RFC] Out of order snapshot deletion
Date: Thu, 11 Jan 2007 22:19:06 -0700
Message-ID: <45A766F3.A9E3.000B.0@novell.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: evms-devel@lists.sourceforge.net, dm-devel@redhat.com, linux-lvm@redhat.com
List-Id: dm-devel.ids

Hi,

I thought I would bring this topic in a separate thread so that=20
it can be discussed independently.

As users start taking a bunch of snapshots and keep them as=20
backups, we see the following use pattern when the snapshots=20
get recycled.

Different snapshots have different life cycle. When some one=20
decides to keep 'x' snapshots, at the recycle phase, the least=20
recent does not necessarily get deleted.

As users want to keep the daily snapshots for a much longer period
than the bi-hourly snapshots. In the same way, weekly snapshots=20
live longer than daily snapshots.

I think this is pretty much similar to the way the current backup tapes
are managed.

I want to know if this is the kind of use case that users are having or=20
the developers are thinking.

The reason why I am posting this is that this out of snapshot deletion
scenario, poses some interesting challenges in the design on the solution=
=20
of multiple snapshots that share blocks with each other, as it is a lot e=
asier=20
to design a solution where the least recent gets deleted always.

Vijai

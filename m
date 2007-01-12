From: "Vijai Babu Madhavan" <mvijai@novell.com>
Subject: RE: [RFC] Multiple Snapshots - Manageability
	problem
Date: Thu, 11 Jan 2007 21:46:42 -0700
Message-ID: <45A75F5B.A9E3.000B.0@novell.com>
References: <45A6CC0F.A9E3.000B.0@novell.com>
	<500DD6DE2DFA8E40A33E5898D9471B97016D46BB@ASHEVS006.mcilink.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <500DD6DE2DFA8E40A33E5898D9471B97016D46BB@ASHEVS006.mcilink.com>
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
To: evms-devel@lists.sourceforge.net, device-mapper development <dm-devel@redhat.com>, linux-lvm@redhat.com
List-Id: dm-devel.ids

Hi Chris,

Thanks for the response. I am trying to keep my mails short as I=20
believe the lack of responses to my mails are probably due to the=20
fact that they are long, but its kinda difficult to keep them small=20
and still convey the various aspects. :)

>>> On 1/12/2007 at 3:04 AM, "Wilson, Christopher J"
<chris.j.wilson@verizonbusiness.com> wrote:
> I haven't read through all of these options yet (but I will).  I will
> say that synthesizing all your cow objects into one pool will be
> difficult.  You're going to have issues with garbage collection of old
> copies and may have to build in some scavenge or compress functions
> which will take system resources.  From my experience with disk based
> de-duplication technologies you're heading down a hole which can be a
> dark place.  There are performance issues and maintaining all those
> pointers is problematic.  The virtual pool sounds good, and works very
> will for primary storage functions (3PAR) but in practice for backup
> applications with virtual pools for deduplication it's not been so hot.

I completely agree that its not going to be easy. But, I guess some price=
=20
needs to be paid to get the benefits. If snapshots could be implemented=20
at the file system level, we do not necessarily need to redo lot of these=
,=20
but building snapshot functionality into the file system itself comes wit=
h=20
the obvious drawback. If only we could build some framework at the=20
file system layer, but some thing that is not tied to each file system wo=
uld=20
be good. I have not had a chance to spend time in this space yet, do othe=
rs
have any ideas in this space?

> I'm not clear what the issue is with maintaining multiple cow snapshots=
.
> Just exactly how many are users asking for?  Keeping more than a few co=
w
> snaps online is not using the function for what it was meant for.  COW
> technology is for immediate rollback (to me) and not for long term
> backup images. =20

From what we see from the users/IT admins, I see two common uses of=20
snapshots.

a) Snapshots for backups
b) Snapshots as backups

In the first case, snapshots are obtained to avoid the open file errors, =
etc
and keeping few snapshots online is more than sufficient.

But, increasingly, we see lot of admins trying to deploy D2D2T=20
(Disk->Disk->Tape), to avoid the many problems associated with the tape=20
backups. And, Snapshots are one of the very efficient way of keeping the=20
disk backups to protect against logical failures (of course not for hardw=
are=20
failures).

Hence, the second case is becoming a strong use-case, as admins want to=20
take 3-4 snapshots a day and recycle them after a week or two weeks.=20
Based on the frequency and the time a snapshot is kept alive, number of=20
snapshots easily get into double digit, in some cases, triple digit.

With the current DM snapshot code, with couple of snapshots, the system=20
comes down rapidly (The throughput numbers in the earlier mail thread and=
=20
the complaints from users reported in the list indicate this).

As we fix this multiple snapshots issue, it also makes sense to fix the m=
ultiple
snapshots management issue using a single cow device. Besides, using a si=
ngle
cow device provides a very compelling efficient way to share the blocks a=
mong=20
snapshots. This also enables the snapshots to be managed independently.

> Sizing is an issue that will not go away and is not
> resolvable in any low level OS code, this is a business/user issue.
> Most customers don't even know how much data they're going to have much
> less what their average write rates are, and I don't envision a cow poo=
l
> as solving the sizing issue.

I totally agree. I guess most admins today are loading their servers arou=
nd 60-70%
utilization to avoid these space issues. While this works ok for primary =
servers,=20
it is impractical to waste so much space in each snapshot, especially wit=
h multiple
snapshots. I think having a single cow device for each (origin), preferab=
ly multiple
origins sharing a single cow device would help alleviate this.
=20
> If I had my way I'd rather see energy put into cow technology for use a=
s
> a disk cache for backup applications and tighter integration with those
> apps.  Better still would be for interfaces from business level
> applications (Oracle, MySQL, etc) to quiece IO, flush buffers, and take
> a consistent copy of the application, state and all.  Putting together
> an application level copy on hardware, being able to move that through =
a
> tighter workflow to backup media through a common API would be my
> preference instead of having each user create their own individual
> "glue" code.  If you look into SNIA's SMI-S (Storage Management API)
> copy services package there may already be a template for this.  I'd sa=
y
> at least that supporting SMI-S Copy Services through that API is
> desirable because a lot of the SRM application today are on their way t=
o
> leveraging that code.  =20

I completely agree. Application co-ordinated snapshot facility is really=20
important and would really help lot of application developers and admins.
It is going to be interesting and challenging to build a framework that w=
ould=20
satisfy diverse application needs. At Novell, we also have some interest =
in this
space, and we are going through some internal processes and I believe we =
would
come out some time soon.

Vijai

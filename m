From: "Wilson, Christopher J" <chris.j.wilson@verizonbusiness.com>
Subject: RE: [RFC] Multiple Snapshots - Manageability problem
Date: Thu, 11 Jan 2007 21:34:19 +0000
Message-ID: <500DD6DE2DFA8E40A33E5898D9471B97016D46BB@ASHEVS006.mcilink.com>
References: <45A6CC0F.A9E3.000B.0@novell.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-reply-to: <45A6CC0F.A9E3.000B.0@novell.com>
Content-class: urn:content-classes:message
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, evms-devel@lists.sourceforge.net, linux-lvm@redhat.com
List-Id: dm-devel.ids

I haven't read through all of these options yet (but I will).  I will
say that synthesizing all your cow objects into one pool will be
difficult.  You're going to have issues with garbage collection of old
copies and may have to build in some scavenge or compress functions
which will take system resources.  From my experience with disk based
de-duplication technologies you're heading down a hole which can be a
dark place.  There are performance issues and maintaining all those
pointers is problematic.  The virtual pool sounds good, and works very
will for primary storage functions (3PAR) but in practice for backup
applications with virtual pools for deduplication it's not been so hot.

I'm not clear what the issue is with maintaining multiple cow snapshots.
Just exactly how many are users asking for?  Keeping more than a few cow
snaps online is not using the function for what it was meant for.  COW
technology is for immediate rollback (to me) and not for long term
backup images.  Sizing is an issue that will not go away and is not
resolvable in any low level OS code, this is a business/user issue.
Most customers don't even know how much data they're going to have much
less what their average write rates are, and I don't envision a cow pool
as solving the sizing issue.

If I had my way I'd rather see energy put into cow technology for use as
a disk cache for backup applications and tighter integration with those
apps.  Better still would be for interfaces from business level
applications (Oracle, MySQL, etc) to quiece IO, flush buffers, and take
a consistent copy of the application, state and all.  Putting together
an application level copy on hardware, being able to move that through a
tighter workflow to backup media through a common API would be my
preference instead of having each user create their own individual
"glue" code.  If you look into SNIA's SMI-S (Storage Management API)
copy services package there may already be a template for this.  I'd say
at least that supporting SMI-S Copy Services through that API is
desirable because a lot of the SRM application today are on their way to
leveraging that code.  =20


Christopher Wilson
Storage Architect
Verizon Business
IT Solutions - IP Application Hosting
240 264 4136
vnet: 364 4136

=20

-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On Behalf Of Vijai Babu Madhavan
Sent: Thursday, January 11, 2007 1:18 PM
To: evms-devel@lists.sourceforge.net; dm-devel@redhat.com;
linux-lvm@redhat.com
Subject: [dm-devel] [RFC] Multiple Snapshots - Manageability problem

Hi,

The problem of DM snapshots with multiple snapshots have been discussed
in the lists quiet a bit (Most recently @
https://www.redhat.com/archives/dm-devel/2006-October/msg00034.html).

We are currently in the process of building a DM snapshot target that
scales well with many snapshots (so that the changed blocks don't get
copied to each snapshot). In this process, I would also like to validate
an assumption.

Today, when a single snapshot gets created, a new cow device of a given
size is also created. IMO, there are two problems with this approach:

a) It is difficult to predict the size of the cow device, which requires
a prediction of the number of writes would go into the origin volume
during the snapshot life cycle. It is difficult to get this prediction
right, as very high value reduces utilization and low value increases
the chances of snapshot becoming full.

b) A new cow device needs to be created every time.

This really gets messy and creates a management problem once many
snapshots of a given origin are created, and gets worse with multiple
origins.

I am thinking, having a single device that would hold the cow blocks of
any number of snapshots of a given origin (or more) would help solve
this issue (Apart from this, having a single device helps share the cow
blocks among snapshots very effectively in a variety of scenarios).

But, it does require that LVM and EVMS be changed to suit this model and
also makes the snapshot target quiet complex.

I would like to receive some comments about what users, developers and
others think about this.

Thanks,
Vijai
P.S:- BTW, apologizes for cross posting.



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

______________________________________________________________________
This e-mail has been scanned by Verizon Managed Email Content Service,
using Skeptic(tm) technology powered by MessageLabs. For more
information on Verizon Managed Email Content Service, visit
http://www.verizonbusiness.com.
______________________________________________________________________


______________________________________________________________________
This e-mail has been scanned by Verizon Managed Email Content Service, us=
ing Skeptic=99 technology powered by MessageLabs. For more information on=
 Verizon Managed Email Content Service, visit http://www.verizonbusiness.=
com.
______________________________________________________________________

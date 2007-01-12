From: "Wilson, Christopher J" <chris.j.wilson@verizonbusiness.com>
Subject: RE: [RFC] Out of order snapshot deletion
Date: Fri, 12 Jan 2007 18:50:45 +0000
Message-ID: <500DD6DE2DFA8E40A33E5898D9471B97016D4D39@ASHEVS006.mcilink.com>
References: <45A766F3.A9E3.000B.0@novell.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-reply-to: <45A766F3.A9E3.000B.0@novell.com>
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

My opinion is that "snapshots" should be less persistent than full clone
copies.  Longer term retention should move to full clone then you don't
have the snapshot overhead you've raised on your other thread.  I can't
imagine that there are so many administrators out there wanting to
maintain week old snapshots.  Those older ones would most likely have
been mounted somewhere and spooled to tape.  I could be way off base but
I'd not feel so confident in a week old cow as I would with a week old
clone.

We here have been tossing around the idea of treating snapshot (or full
clone) as backup media.  Media that would contain a barcode and which
could be migrated to physical tape.  Currently this is the realm of VTL.
VTL is a copy of your data written out in a sequential manner, if you
could somehow create disk media via snapshot that the disk caches
(Falconstor, Sepaton) use then you could get the long sequential
read/write overhead out of the backup application and the host.

Our issue with snapshot, as I mentioned on the other thread, is that
there are no close ties to the upper level applications, this includes
backup software like NetBackup and Legato.  NetBackup has the "virtual
backup" piece but I've not really seen it implemented.  Ideally an
interface for a database application to take a snapshot of its data and
call it barcode xxxx03 could then be imported into your backup
application as a virtual tape xxxx03.  That "tape" could be cloned via
NetBackup or disk cache software to real tape with barcode xxxx03 for
off site storage (through an encryption device of course).  I know there
are data alignment issues that exist here with data sizes and physical
tape sizes but we believe it's an avenue worth exploring.

There are several opportunities to better admin quality of life here.
One is that backup administrators would be able to continually manage
their media in what they know, tapes with barcodes they can touch and
feel.  The other is DBA's could maintain a list of snapshots through
something other than "glue code".  It would integrate into the processes
that exist around data protection.

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
Sent: Friday, January 12, 2007 12:19 AM
To: evms-devel@lists.sourceforge.net; dm-devel@redhat.com;
linux-lvm@redhat.com
Subject: [dm-devel] [RFC] Out of order snapshot deletion

Hi,

I thought I would bring this topic in a separate thread so that it can
be discussed independently.

As users start taking a bunch of snapshots and keep them as backups, we
see the following use pattern when the snapshots get recycled.

Different snapshots have different life cycle. When some one decides to
keep 'x' snapshots, at the recycle phase, the least recent does not
necessarily get deleted.

As users want to keep the daily snapshots for a much longer period than
the bi-hourly snapshots. In the same way, weekly snapshots live longer
than daily snapshots.

I think this is pretty much similar to the way the current backup tapes
are managed.

I want to know if this is the kind of use case that users are having or
the developers are thinking.

The reason why I am posting this is that this out of snapshot deletion
scenario, poses some interesting challenges in the design on the
solution of multiple snapshots that share blocks with each other, as it
is a lot easier to design a solution where the least recent gets deleted
always.

Vijai


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

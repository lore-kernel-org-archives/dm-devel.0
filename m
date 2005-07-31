From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: EMC Clariion ghost devices
Date: Mon, 1 Aug 2005 00:01:54 +0200
Message-ID: <20050731220154.GC15655@marowsky-bree.de>
References: <20050729222803.GS16618@ca-server1.us.oracle.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20050729222803.GS16618@ca-server1.us.oracle.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe varoqui <christophe.varoqui@free.fr>, dm-devel@redhat.com
List-Id: dm-devel.ids

On 2005-07-29T15:28:03, Joel Becker <Joel.Becker@oracle.com> wrote:

> 	I've just tried using the multipath-tools (SLES9 SP2,
> multipath-tools-0.4.4-0.22) with my EMC clariion.  Now, this clariion i=
s
> an active/passive system, and the second path is showing a ghost LUN 0
> (this is expected).

"WFM". I actually tested the SP2 code on a CLARiiON, it's my development
box ;-) The version of multipath-tools on SLES9 SP2 is not quite 0.4.4
from upstream, though, but with some fixes pulled in.

Have you seen
http://portal.suse.com/sdb/en/2005/04/sles_multipathing.html ?

> 	During normal boot, the device (/dev/sdap) returns an I/O error
> when the kernel tries to get the partition table.  No problem.  If late=
r
> someone scans the disk, they get an I/O error.  No problem.

Yeah, this is ugly and annoying, but harmless.

> 	Then I fire up multipathd and multipath.  Multipath creates a dm
> device for the ghost, and tries to run kpartx on it.  That kpartx hangs=
.
> In fact, I don't know how, but it ends up in a frozen I/O state.  It's
> unkillable.

That should not happen(tm). Where does it hang according to sysrq-t?

(kpartx supposedly is run against the dm-multipath table and not against
sdap, so it should already benefit from the multipath protection...)

"sg_inq -P /dev/sdap" might also be worth a try, what does it report for
the various paths?

Is that a LUN 0 backed by actual storage or a LUN_Z?


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business	 -- Charles Darwin
"Ignorance more frequently begets confidence than does knowledge"

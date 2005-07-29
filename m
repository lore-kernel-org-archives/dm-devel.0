From: Joel Becker <Joel.Becker@oracle.com>
Subject: EMC Clariion ghost devices
Date: Fri, 29 Jul 2005 15:28:03 -0700
Message-ID: <20050729222803.GS16618@ca-server1.us.oracle.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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
To: christophe varoqui <christophe.varoqui@free.fr>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Christophe,
	I've just tried using the multipath-tools (SLES9 SP2,
multipath-tools-0.4.4-0.22) with my EMC clariion.  Now, this clariion is
an active/passive system, and the second path is showing a ghost LUN 0
(this is expected).
	During normal boot, the device (/dev/sdap) returns an I/O error
when the kernel tries to get the partition table.  No problem.  If later
someone scans the disk, they get an I/O error.  No problem.
	Then I fire up multipathd and multipath.  Multipath creates a dm
device for the ghost, and tries to run kpartx on it.  That kpartx hangs.
In fact, I don't know how, but it ends up in a frozen I/O state.  It's
unkillable.  I'd expect an I/O error, but no, it just plain doesn't
exit.  Ditto any other access to the associated dm.
	Now, is this a dm problem (the device not seeing the error and
returning it)?  Is it a multipath problem (multipath should notice the
ghost and not try to dm it)?  Is it a configuration problem (I should
somehow know which name the ghost got, and configure multipath to ignore
it)?

Joel

-- 

Life's Little Instruction Book #182

	"Be romantic."

Joel Becker
Senior Member of Technical Staff
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127

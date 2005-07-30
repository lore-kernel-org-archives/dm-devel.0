From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: EMC Clariion ghost devices
Date: Sat, 30 Jul 2005 10:27:36 +0200
Message-ID: <1122712056.7553.17.camel@zezette>
References: <20050729222803.GS16618@ca-server1.us.oracle.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On ven, 2005-07-29 at 15:28 -0700, Joel Becker wrote:
> Christophe,
> 	I've just tried using the multipath-tools (SLES9 SP2,
> multipath-tools-0.4.4-0.22) with my EMC clariion.  Now, this clariion is
> an active/passive system, and the second path is showing a ghost LUN 0
> (this is expected).
> 	During normal boot, the device (/dev/sdap) returns an I/O error
> when the kernel tries to get the partition table.  No problem.  If later
> someone scans the disk, they get an I/O error.  No problem.
> 	Then I fire up multipathd and multipath.  Multipath creates a dm
> device for the ghost, and tries to run kpartx on it.  That kpartx hangs.
> In fact, I don't know how, but it ends up in a frozen I/O state.  It's
> unkillable.  I'd expect an I/O error, but no, it just plain doesn't
> exit.  Ditto any other access to the associated dm.
> 	Now, is this a dm problem (the device not seeing the error and
> returning it)?  Is it a multipath problem (multipath should notice the
> ghost and not try to dm it)?  Is it a configuration problem (I should
> somehow know which name the ghost got, and configure multipath to ignore
> it)?

/sbin/multipath sure shouldn't create a multipath map with just ghost
paths in it. If it is the case, some paths' wwid must be wrong. May be
due to scsi_id inconsistencies ?

You can try and verify that with 'multipath -v4', reading the "all
paths" section.

I hope Lars will react on this one as he has the hardware at hand ...

Regards,
-- 
christophe varoqui <christophe.varoqui@free.fr>

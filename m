From: Joel Becker <Joel.Becker@oracle.com>
Subject: Re: EMC Clariion ghost devices
Date: Sun, 31 Jul 2005 22:50:39 -0700
Message-ID: <20050801055039.GU16618@ca-server1.us.oracle.com>
References: <20050729222803.GS16618@ca-server1.us.oracle.com>
	<20050731220154.GC15655@marowsky-bree.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20050731220154.GC15655@marowsky-bree.de>
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
Cc: christophe varoqui <christophe.varoqui@free.fr>
List-Id: dm-devel.ids

On Mon, Aug 01, 2005 at 12:01:54AM +0200, Lars Marowsky-Bree wrote:
> That should not happen(tm). Where does it hang according to sysrq-t?

	Not in front of it right now, I'll let you know when I find out
:-)
>
> (kpartx supposedly is run against the dm-multipath table and not against
> sdap, so it should already benefit from the multipath protection...)

	This kpartx is run against dm-16 (on the particular boot I
remember), which was the dm on top of the ghost device.
 
> "sg_inq -P /dev/sdap" might also be worth a try, what does it report for
> the various paths?

	Again, have to check tomorrow.

> Is that a LUN 0 backed by actual storage or a LUN_Z?

	I don't quite know what you mean by LUN_Z.  My EMC guy says it
is a "ghost" projected because the second SP owns no disks, but SCSI
requires a LUN 0 to be scannable.

Joel

-- 

"A narcissist is someone better looking than you are."  
         - Gore Vidal

Joel Becker
Senior Member of Technical Staff
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127

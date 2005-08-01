From: Joel Becker <Joel.Becker@oracle.com>
Subject: Re: EMC Clariion ghost devices
Date: Mon, 1 Aug 2005 11:02:38 -0700
Message-ID: <20050801180237.GY16618@ca-server1.us.oracle.com>
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
> 
> (kpartx supposedly is run against the dm-multipath table and not against
> sdap, so it should already benefit from the multipath protection...)
> 
> "sg_inq -P /dev/sdap" might also be worth a try, what does it report for
> the various paths?

	This reports a LUN_Z, which is what I expected after I
was explained a LUN_Z is the same as a ghost report.
	I get this in dmesg at multipath(8):

device-mapper: dm-multipath: 66:144: Error trying to initialize PG, failing path
device-mapper: dm-multipath: Failing path 66:144

66:144 is, indeed, /dev/sdap.  Kpartx is again hanging on:

# ps -ef | grep kpartx
root     26698 25674  0 10:53 ?        00:00:00 /sbin/kpartx -m -a /dev/dm-16

# ls -l /dev/disk/by-name | grep dm-16
/dev/disk/by-name/3500601609020ea1a500601609020ea1a -> ../../dm-16

# dmsetup deps 3500601609020ea1a500601609020ea1a
1 dependencies  : (66, 144)

# echo t > /proc/sysrq-trigger
kpartx        D 00000100bea0f680     0 26698  25674               25755 (NOTLB)
00000100c1511bc8 0000000000000006 00000100c05e00a0 000001d09566ce68
       0000000000000246 0000010081b54580 0000007300000001 000001007b608b10
       0000000100000001 0000010081b55660
Call Trace:<ffffffff802859a4>{generic_unplug_device+36} <ffffffff8013953f>{io_schedule+63}
       <ffffffff80163b39>{__lock_page_wq+233} <ffffffff8013ce40>{autoremove_wake_function+0}
       <ffffffff8016c518>{page_cache_readahead+328} <ffffffff8013ce40>{autoremove_wake_function+0}
       <ffffffff8016518c>{do_generic_mapping_read+876} <ffffffff801637a0>{file_read_actor+0}
       <ffffffff80166024>{__generic_file_aio_read+420} <ffffffff801661eb>{generic_file_read+187}
       <ffffffff8019592e>{do_open+318} <ffffffff8019712a>{cp_new_stat+234}
       <ffffffff8013ce40>{autoremove_wake_function+0} <ffffffff8018d184>{vfs_read+244}
       <ffffffff8018d3dd>{sys_read+157} <ffffffff80110794>{system_call+124}

-- 

"Can any of you seriously say the Bill of Rights could get through
 Congress today?  It wouldn't even get out of committee."
	- F. Lee Bailey

Joel Becker
Senior Member of Technical Staff
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127

From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2 2/2] dm: allow active and inactive tables
 to share dm_devs
Date: Thu, 18 Sep 2014 14:48:26 -0400
Message-ID: <20140918184826.GA10829@redhat.com>
References: <1407956023-32372-1-git-send-email-bmarzins@redhat.com>
	<1411056149-16418-1-git-send-email-snitzer@redhat.com>
	<1411056149-16418-3-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1411056149-16418-3-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: hare@suse.de
Cc: Junichi Nomura <j-nomura@ce.jp.nec.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

I've revised the header for this patch:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=d379c2886c48b32d5f4cf70a27ba2409e127b6f7

dm: allow active and inactive tables to share dm_devs

Until this change, when loading a new DM table, DM core would re-open
all of the devices in the DM table. Now, DM core will avoid redundant
device opens (and closes when destroying the old table) if the old table
already has a device open using the same mode. This is achieved by
managing reference counts on the table_devices that DM core now stores
in the mapped_device structure (rather than in the dm_table
structure). So a mapped_device's active and inactive dm_tables' dm_dev
lists now just point to the dm_devs stored in the mapped_device's
table_devices list.

This improvement in DM core's device reference counting has the
side-effect of fixing a long-standing limitation of the multipath
target: a DM multipath table couldn't include any paths that were
unusable (failed). For example: if all paths have failed and you add a
new, working, path to the table; you can't use it since the table load
would fail due to it still containing failed paths. Now a re-load of a
multipath table can include failed devices and when those devices become
active again they can be used instantly.


The device list code in dm.c isn't a straight copy/paste from the code
in dm-table.c, but it's very close (aside from some variable
renames). One subtle difference is that find_table_device for the
tables_devices list will only match devices with the same name and
mode. This is because we don't want to upgrade a device's mode in the
active table when an inactive table is loaded. Access to the
mapped_device structure's tables_devices list requires a mutex
(tables_devices_lock), so that tables cannot be created and destroyed
concurrently.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com> 

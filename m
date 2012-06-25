From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/2 v2] dm persistent data: handle space map
 checker creation failure
Date: Mon, 25 Jun 2012 12:07:02 -0400
Message-ID: <20120625160702.GA26851@redhat.com>
References: <1340305068-30096-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1340305068-30096-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com
Cc: dm-devel@redhat.com, ejt@redhat.com, vgoyal@redhat.com
List-Id: dm-devel.ids

Updated patch header:

If CONFIG_DM_DEBUG_SPACE_MAPS is enabled and dm_sm_checker_create()
fails, dm_tm_create_internal() would still return success even though it
cleaned up all resources it was supposed to have created.  This will
lead to a kernel crash:

general protection fault: 0000 [#1] SMP DEBUG_PAGEALLOC
...
RIP: 0010:[<ffffffff81593659>]  [<ffffffff81593659>] dm_bufio_get_block_size+0x9/0x20
Call Trace:
  [<ffffffff81599bae>] dm_bm_block_size+0xe/0x10
  [<ffffffff8159b8b8>] sm_ll_init+0x78/0xd0
  [<ffffffff8159c1a6>] sm_ll_new_disk+0x16/0xa0
  [<ffffffff8159c98e>] dm_sm_disk_create+0xfe/0x160
  [<ffffffff815abf6e>] dm_pool_metadata_open+0x16e/0x6a0
  [<ffffffff815aa010>] pool_ctr+0x3f0/0x900
  [<ffffffff8158d565>] dm_table_add_target+0x195/0x450
  [<ffffffff815904c4>] table_load+0xe4/0x330
  [<ffffffff815917ea>] ctl_ioctl+0x15a/0x2c0
  [<ffffffff81591963>] dm_ctl_ioctl+0x13/0x20
  [<ffffffff8116a4f8>] do_vfs_ioctl+0x98/0x560
  [<ffffffff8116aa51>] sys_ioctl+0x91/0xa0
  [<ffffffff81869f52>] system_call_fastpath+0x16/0x1b

Fix the space map checker code to return an appropriate ERR_PTR and have
dm_sm_disk_create() and dm_tm_create_internal() check for it with
IS_ERR.

Reported-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Cc: stable@vger.kernel.org

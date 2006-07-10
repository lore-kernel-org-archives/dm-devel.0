From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 0/4] dm_queue and noflush suspend feature (take 2)
Date: Mon, 10 Jul 2006 18:32:18 -0400 (EDT)
Message-ID: <20060710.183218.68164930.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hello,

This is an updated patch set of dm_queue feature posted on June 23, 2006.
It can be applied on top of 2.6.18-rc1-mm1.
Please review and apply.

Description of the patches:
  1/4: add dm_queue and generic worker thread
  2/4: add noflush feature to dm_queue
  3/4: dm-mpath to enable noflush
  4/4: add API to libdevmapper

This is the update since the last posting:
  o Change the word which describes suspend without queue flush
    from "fast-suspend" to "noflush" based on Alasdair's feedback.
    (Among all patches)

  o noflush support for I/O across some targets.
    To implement this, added "pending_tio" to struct mapped_device.
    It is the counter for pending splitted bios.
    So when the "pending_tio" and the number of queued bios become same,
    the mapped_device is quiet.  Then, suspend can be done.
    (Done in the patch 2/4)

Test results:
Following functional tests are done with/without using 'noflush' feature
in multipath target and found no problem.

  o suspend/resume without table swap in no valid path situation.
  o path addition and table swap in no valid path situation.
  o above testing for I/O across some multipath targets.

  I/Os are returned without error when using 'noflush' feature
  and returned with error when not using it.

Any comments are welcome.

Thanks,
Kiyoshi Ueda


On Fri, 23 Jun 2006 17:45:38 -0400 (EDT), Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote:
> Hello,
> 
> I'm working on moving I/O queue of targets to dm core so that
> the table can swap/suspend without the queue flushing.
> -----------------------------------------------------------------------
> BACKGROUND
> 
> Currently, table swap is needed when we add additional path to
> existing multipath map.  To swap table, suspend is needed and
> all I/Os are flushed at the suspention time.
> If all paths in the multipath map are failed and there are queued
> I/Os in the multipath target, these I/Os will return as error
> when the I/O flushing.
> In such case, user should expect that these I/Os are issued
> without error through the new additional path.
> 
> To solve the issue, suspend must be done without queue flushing
> and the queued I/Os must be handed over to the new table when table
> swapping.
> 
> 
> DESIGN
> 
> The structure of the queue and the queue processing kernel thread
> which are used by the multipath target can be generalized so that
> other targets can also use it.
> So the queue and the thread are placed in dm-core, and targets use it
> by using interface functions.
> ------------------------------------------------------------------------
> 
> The following patch set is a draft to solve the issue above.
> It is for 2.6.17-rc6-mm1 + Alasdair's patches which was sent
> to this ML (Subject: "Next set of device-mapper patches").
> 
> The patches are still rough edges and I'd like to get comments
> from dm developpers on this approach.
> For example,
>   1). Queues for a target are placed in "struct dm_target".
>   2). Unmap target function is added for fast-suspend feature.
>   3). Is the interface sufficient for other target drivers?
>       (Current design considers multipath target only.)
> 
> Below is TODO list which I'm working on.
> -----------------------------------------------------------------------
> TODO
> 
> o If the I/O is splitted across some targets, fast-suspend feature
>   doesn't work because the total of queue size doesn't match with
>   the number of pending original bios.
> 
> o Accounting issue when withdrawing queued bios.
> 
> o The dm_queue daemon works for only bio queue.
>   Other works should be handled? (e.g. trigger_event of multipath)
> -----------------------------------------------------------------------
> 
> Any other comments are also very welcome!
> 
> Regards and thanks for your time,
> Kiyoshi Ueda

From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: more multipath deadlocks -- this time involving memory
Date: Thu, 24 Mar 2005 00:10:02 +0100
Message-ID: <1111619402.7024.50.camel@zezette>
References: <C2EEB4E538D3DC48BF57F391F422779321A856@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
In-Reply-To: <C2EEB4E538D3DC48BF57F391F422779321A856@SRMANNING.eng.emc.com>
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
Cc: 'Alasdair G Kergon' <agk@redhat.com>
List-Id: dm-devel.ids

Just to let you know I'm not ignoring your comments and analysis.

I opened the 0.4.4-pre* festival, and hope we can fix these nasties
before the end of this cycle.

I started the branch with an id cache in multipath. I'm not sure on the
design, so I will take comments.

As seen with Lars, I'll then continue moving bits from multipath/ to
libmultipath/ until the daemon can be switched to
libmultipath:multipath() instead of exec(/sbin/multipath).

That, plus a loging rework that is under discussion with open-iscsi
guys, should address most of your concerns.

A mempool would have to wait for another release, if at all desirable.

Regards,
cvaroqui

On lun, 2005-03-21 at 21:34 -0500, goggin, edward wrote:
> Looks like some troublesome deadlock issues involving multipath, memory,
> and all-paths-down use cases.  While one might typically expect such a use
> case to result in errors, deadlock is not to be expected.  Furthermore, for
> non-
> destructive ucode upgrades of an EMC CLARiion storage system, it is expected
> that for a short period of time, all paths to the storage system in question
> will
> appear to a host to be failed.  It is expected that any multipathing
> solution will
> ride through this NDU scenario without a problem.
> 
> While I see three separate instances of the problem being plausible, I have
> only
> seen the first problem instance described below.  The second and third
> scenarios
> require high levels of memory contention which I have not spent significant
> time
> creating.
> 
> The first problem scenario involves a deadlock between multipathd and
> syslogd.  The second scenario involves the potential for multipathd,
> multipath,
> or any of the executables invoked by multipath to be deadlocked trying doing
> synchronous page reclamation while allocating memory pages for user or
> kernel heap memory in a system with a high degree of memory contention
> and several multipath mapped devices in an all-paths-down failure state.
> The third scenario is extremely similar to the second but involves the need
> to allocate pages not for heap memory but to swap in working set pages for
> the multipathd, multipath, or any of the executables invoked by multipath.
> 
> First, it seems like __every__ time I try an NDU of the EMC CLARiion ucode,
> one of the two (checkerloop or waiterloop) multipathd sub-threads gets
> blocked in unix_wait_for_peer waiting to send a syslog message through
> a UNIX domain socket to syslogd.  Unfortunately, syslogd is blocked in
> blk_congestion_wait waiting for the number of dirty pages in the page
> cache to drop below a pre-defined threshold while it was trying to write log
> info to its /var/log/messages log file.  Unfortunately, getting this to
> happen
> is dependent on the multipathd checkerloop thread periodically checking
> path connectivity and invoking multipath in order to reconfigure multipath
> maps and/or re-enable some now valid paths.  Since the multipathd
> waiterloop event thread will deadlock on the multipathd allpaths mutex
> currently owned by the checkerloop thread, starting i/o on a failed path
> will not free up the log jam.  Assuming enough free memory is available
> to do so, manually running multipath often resolves the problem.  Yet,
> this is hardly a work around to be recommended to an enterprise customer.
> 
> I have only been able to avoid this deadly embrace by killing syslogd
> before starting the test.  Without syslogd running, I made it through
> this test 3 consecutive times.  It seems that I cannot get through the test
> at all with syslogd running.  I think simply changing syslogd to do direct
> i/o
> instead of page cache buffered i/o to its log file(s) will avoid this
> problem.  I am
> running with 2.6.11-rc3-upd2 kernel and 0.4.3-pre9 multipath tools by the
> way.
> 
> The 2nd scenario involves blockable user or kernel memory allocation
> requests
> requiring page write-out of dirty pages on multipath mapped devices in the
> synchronous page reclaim algorithm of __alloc_pages.  Seems to me that while
> mlockall can pin all current and future pages of a process's working set, it
> does
> not prevent synchronous page reclamation by the process as part of a
> blockable
> page allocation request.  If many of the mapped devices are in queue
> congestion
> mode due to failed paths on a storage system which is queuing failed bios
> (as
> the EMC CLARiion must), multipathd, multipath, or any executable invoked by
> multipath could block trying to page out dirty pages to these mapped devices
> while trying to allocate memory before being able to inform the kernel
> resident
> multipath components of the existence of valid paths for these mapped
> devices.
> 
> The 3rd scenario involves the need to mlockall for all executables which are
> invoked by multipathd (multipath) and the executables invoked by these
> executables (scsi_id, /bin/false, ...).  Otherwise, any of these executables
> can
> block during page reclamation while trying to allocate free pages.  Also,
> does the
> effect of mlockall survive in the parent beyond fork/clone call or does it
> need to be
> renewed afterwards?
> 
> Overall, it seems like the code path to test and restore a target path of a
> multipath
> mapped device should not require any blockable memory allocations.  This
> would
> of course rule out fork/clone/exec.  A possible alternative design to the
> current one
> is to pre-allocate or reserve the memory requirements for these tasks --
> possibly
> enough memory for testing and restoring a single path to a single LU at a
> time.
> While this design would be tuned specifically to this job, I think it would
> not need
> to be kernel resident.
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
-- 
christophe varoqui <christophe.varoqui@free.fr>

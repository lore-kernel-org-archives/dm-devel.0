From: Mikulas Patocka <mpatocka@redhat.com>
Subject: DM-RAID1 data corruption
Date: Tue, 14 Apr 2009 16:46:20 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0904141618220.701@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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
To: Alasdair G Kergon <agk@redhat.com>
Cc: Heinz Mauelshagen <heinzm@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

This is the scenario of data corruption that I was talking about:

Mirror has two legs, 0 and 1 and a log. Disk 0 is the default.

A write is propagated to both legs. The write fails on leg 0 and succeeds 
on leg 1.

The function "write_callback" puts the bio to "failure" list (if 
errors_handled was true). It also wakes userspace.

do_failures pops the bios from ms->log_failure and calls dm_rh_mark_nosync 
on them to mark the region nosync. dm_rh_mark_nosync completes the bio 
with success.

*the computer crahes* (before the userspace daemon had a chance to run)

On next reboot, disk is 0 revived (suppose that it temporarily failed 
because of a loose cable, overheating, insufficient power or so, and the 
condition is repaired), raid1 sees set bit in the dirty bitmap and starts 
copying data from disk 0 to disk 1.

The result: write bio was ended as succes, but the data was lost. For 
databases, this might have bad consequences - committed transactions being 
forgotten.

-

If the above scenario can't happen, pls. describe why.

What would be a possible way to fix this?

Delay all bios until the userspace code removes the failed mirror?
Or store the number of the default mirror in the log?

Mikulas

From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH]dm-mpath: fix for race condition between
 multipath_dtr and pg_init_done.
Date: Fri, 1 Nov 2013 14:21:51 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1311011419250.9812@file01.intranet.prod.int.rdu2.redhat.com>
References: <FB8A412F33166C4A930D37BD63236C902AD2A073@SACEXCMBX02-PRD.hq.netapp.com>
	<20131017185306.GA29909@redhat.com> <52605B07.5070007@suse.de>
	<20131017211014.GA30993@redhat.com>
	<FB8A412F33166C4A930D37BD63236C902AD2A12B@SACEXCMBX02-PRD.hq.netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <FB8A412F33166C4A930D37BD63236C902AD2A12B@SACEXCMBX02-PRD.hq.netapp.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Merla, ShivaKrishna" <ShivaKrishna.Merla@netapp.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "agk@redhat.com" <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

> Thanks for your comments.  I agree we should lock while setting 
> dtr_in_progress,

You can use spinlock when you read or write the variable.

Or - without locking, you can use memory barriers - put smp_mb() after you 
write dtr_in_progress and before you read it. Use 
ACCESS_ONCE(m->dtr_in_progress) in the if statement where you read 
dtr_in_progress.

Mikulas

> I think I overlooked it as its handled in process_queued_ios as well. We 
> looked into handling this in wait_for_pg_init_completion() but checking 
> for pg_init_required here will not help as well ( until we prevent 
> setting pg_init_required while pg_init_in_progress is set ). Here due to 
> SCSI_DH_RETRY on mode_select, pg_init_done will set the pg_init_required 
> as activation needs to be retried under normal circumstances. But it 
> completely differs when multipath target is being destroyed.  
> Apparently I didn't see any pending_ios in our test while this is 
> happening. Just path activations are held up since controller was 
> returning 5/91/36 CC's. With this condition either one of 
> pg_init_required or pg_init_in_progress flags are set all the time. 
> Hannes patch will take care of preventing queueing of IO's when 
> pg_init_in_progress is set, but currently running activation commands 
> will not return until controller returns SUCCESS on mode_select.
> 
> 

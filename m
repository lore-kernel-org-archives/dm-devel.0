From: Chr <chunkeey@web.de>
Subject: Re: INFO: task mount:11202 blocked for more than 120 seconds
Date: Fri, 14 Mar 2008 01:15:43 +0100
Message-ID: <200803140115.45139.chunkeey@web.de>
References: <alpine.DEB.1.00.0803072116420.7723@sheep.housecafe.de> <200803132233.47516.chunkeey@web.de> <alpine.DEB.1.00.0803132249060.7433@sheep.housecafe.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758637AbYCNAQU@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.00.0803132249060.7433@sheep.housecafe.de>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Kujau <lists@nerdbynature.de>
Cc: Samuel Tardieu <sam@rfc1149.net>, device-mapper development <dm-devel@redhat.com>, LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
List-Id: dm-devel.ids

On Thursday 13 March 2008 22:54:25 Christian Kujau wrote:
> On Thu, 13 Mar 2008, Chr wrote:
> > On Thursday 13 March 2008 14:45:39 Christian Kujau wrote:
> >> and so does -git8 and -git9...sigh :(
> >
> > hmm, I can boot any of these -rcX-gitY kernels (but not without some
> > stuck tasks after about a hour or so...)
>
> Ah, when you said -git17 would be the last "good" kernel, I thought
> everything earlier would not have the stuck tasks.
well, no... even 2.6.24.3 has _hangs_, however not forever (approx. 5-10 min)
and everything is back to normal...
 
> > sounds a bit strange? Is this a SMP related problem after all?
>
> I don't think so, as I don't have an SMP system (and CONFIG_SMP is
> disabled as well).
Then maybe scheduler? because these values looks suspecious:
(that's why I added Ingo to CC, because he probably knows what's NOT going on
 ;-) )

(full dmesg there: 
http://www.pastebin.ca/941845

config here:
http://www.pastebin.ca/941856
)

the funny stuff is highlighted with a >:
cpu#1, 2211.332 MHz
  .nr_running                    : 8
  .load                          : 188884
  .nr_switches                   : 9615826
  .nr_load_updates               : 1879402
 > .nr_uninterruptible            : -2053
  .jiffies                       : 4296946718
  .next_balance                  : 4296.946740
  .curr->pid                     : 0
  .clock                         : 9800558.756490
  .idle_clock                    : 6521432.794621
  .prev_clock_raw                : 4476359.432375
  .clock_warps                   : 0
  .clock_overflows               : 8676899
  .clock_underflows              : 688045
  .clock_deep_idle_events        : 0
  .clock_max_delta               : 4.000250
  .cpu_load[0]                   : 0
  .cpu_load[1]                   : 24
  .cpu_load[2]                   : 112
  .cpu_load[3]                   : 155
  .cpu_load[4]                   : 177
 
cfs_rq
  .exec_clock                    : 1353227.466775
  .MIN_vruntime                  : 1808656.942015
  .min_vruntime                  : 1808696.942015
  .max_vruntime                  : 1808657.235424
  .spread                        : 0.293409
>  .spread0                       : -267982.528057
  .nr_running                    : 7
  .load                          : 11362
  .bkl_count                     : 60751
  .nr_spread_over                : 6234
 
runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         
sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
         kcryptd  2266   1808656.942015     12778   115   1808656.942015      
3689.257692   3125323.031084
 hald-addon-inpu  5504   1808656.942015       622   120   1808656.942015        
10.739211   3044831.003941
         kcryptd  7312   1808656.960820    578891   115   1808656.960820     
71166.387493   2625492.750280
            Xorg  9564   1808656.942016    513338   120   1808656.942016    
245777.204573   2587613.331559
         pdflush 10059   1808656.942015     14575   120   1808656.942015      
4400.355110   2985523.630368
         pdflush 10696   1808656.942015      9433   120   1808656.942015      
3607.302084   3103638.660388
            xine 16773   1808657.235424     13455   120   1808657.235424      
2135.923058    574348.774173
 >       watchdog 16959   -206866.028086         0    98   -206866.028086         
0.000000         0.000000

(it's at the end of the dmesg, the kernel, X.org and probably everything else 
was stuck...)

Thanks,
	Christian.

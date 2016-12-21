From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: : Query on dmstats(8)
Date: Wed, 21 Dec 2016 17:09:52 +0000
Message-ID: <20161221170952.GB26970@localhost.localdomain>
References: <DF4PR84MB00449C0F38A0CCF78B720D31FC930@DF4PR84MB0044.NAMPRD84.PROD.OUTLOOK.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <DF4PR84MB00449C0F38A0CCF78B720D31FC930@DF4PR84MB0044.NAMPRD84.PROD.OUTLOOK.COM>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Nalla, Ravikanth" <ravikanth.nalla@hpe.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Ravi,

On Wed, Dec 21, 2016 at 12:38:12PM +0000, Nalla, Ravikanth wrote:
> 
> In dmstats(8) man page, what is the exact difference between "read_time" and "read_ticks"
> and also the  exact difference between "write_nsecs" and "write_ticks"?
> 
> read_time
>               Accumulated duration of all read requests (ns).

The two "time" fields are the accumulated durations of reads and writes - i.e. the
difference between the operation end and start times, summed for all reads or writes
during the current interval.
 

> write_nsecs

'write_nsecs' is a typo in the man page - it should be 'write_time': I'll get that
fixed. The tool help ('dmstats help') has the correct names:

  write_time            - Accumulated duration of all writes (ns).

> read_ticks
>               Nanoseconds spent servicing reads.
> write_ticks
>               Nanoseconds spent servicing writes.

These are the times spent actively servicing requests (as opposed to the time
spent in queues, or waiting for hardware IO to finish etc).

The tool help output will always give you up-to-date information on the
supported columns - there's also a bit more detail in the kernel documentation
at Documentation/device-mapper/statistics.txt.

Regards,
Bryn.

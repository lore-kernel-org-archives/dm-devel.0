From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [RFC PATCH] dm service time: measure service time
 rather than approximate it
Date: Fri, 8 Apr 2016 15:53:14 -0400
Message-ID: <20160408195314.GA8678@redhat.com>
References: <1460141919-12177-1-git-send-email-snitzer@redhat.com>
	<20160408190349.GA8453@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20160408190349.GA8453@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: j-nomura@ce.jp.nec.com, tgill@redhat.com
List-Id: dm-devel.ids

On Fri, Apr 08 2016 at  3:03pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Fri, Apr 08 2016 at  2:58pm -0400,
> Mike Snitzer <snitzer@redhat.com> wrote:
> 
> > The DM multipath service-time path-selector has historically tracked the
> > amount of outstanding IO per path and used that to approximate the
> > service-time of each path.  In practice this has shown itself to work
> > fairly well but we can do better by measuring the actual service-time
> > during IO completion and using it as the basis for path selection.
> > 
> > Measuring the actual service-time is still prone to inaccuracies given
> > that service-times vary with IO size.  But to counter any potential for
> > drawing incorrect conclusions about the service-times of a given path
> > the measured service-times are reset periodically.
> > 
> > This approach has provided a 10% increase in the selection of a path
> > that was forcibly made to be less loaded than the alternative path.
> > 
> > Reported-by: Todd Gill <tgill@redhat.com>
> > Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> 
> It should be noted that I have not looked at the implications on actual
> throughput or system load.  But I wanted to get this RFC out to see what
> others thought about making dm-service-time more intuitive in its
> implementation.

I have notice fio's total and completion latency ('lat' and 'clat') go
up on this simple SAS testbed:

before:

 write: io=345920KB, bw=34379KB/s, iops=537, runt= 10062msec
    slat (usec): min=10, max=47, avg=22.51, stdev= 3.71
    clat (msec): min=1, max=146, avg=59.50, stdev=11.84
     lat (msec): min=1, max=146, avg=59.52, stdev=11.84

after:

  write: io=347456KB, bw=34545KB/s, iops=539, runt= 10058msec
    slat (usec): min=6, max=46, avg=20.50, stdev= 3.68
    clat (usec): min=385, max=146556, avg=59219.94, stdev=11580.00
     lat (usec): min=403, max=146573, avg=59240.87, stdev=11580.57

Which obviously isn't what we want (might speak to why Junichi decided
to approximate service-time)...

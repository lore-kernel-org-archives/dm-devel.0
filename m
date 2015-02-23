From: Mike Snitzer <snitzer@redhat.com>
Subject: dm-mpath request merging concerns [was: Re: It's time to
 put together the schedule]
Date: Mon, 23 Feb 2015 08:50:57 -0500
Message-ID: <20150223135057.GA3362@redhat.com>
References: <1424395745.2603.27.camel@HansenPartnership.com>
	<54EAD453.6040907@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <54EAD453.6040907@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: lsf@lists.linux-foundation.org, Jeff Moyer <jmoyer@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Feb 23 2015 at  2:18am -0500,
Hannes Reinecke <hare@suse.de> wrote:

> On 02/20/2015 02:29 AM, James Bottomley wrote:
> > In the absence of any strong requests, the Programme Committee has taken
> > a first stab at an agenda here:
> > 
> > https://docs.google.com/spreadsheet/pub?key=0ArurRVMVCSnkdEl4a0NrNTgtU2JrWDNtWGRDOWRhZnc
> > 
> > If there's anything you think should be discussed (or shouldn't be
> > discussed) speak now ...
> > 
> Recently we've found a rather worrysome queueing degradation with
> multipathing, which pointed to a deficiency in the scheduler itself:
> SAP found that a device with 4 paths had less I/O throughput than a
> system with 2 paths. When they've reduced the queue depth on the 4
> path system they managed to increase the throughput somewhat, but
> still less than they've had with two paths.

The block layer doesn't have any understanding of how many paths are
behind the top-level dm-mpath request_queue that is supposed to be doing
the merging.

So from a pure design level it is surprising that 2 vs 4 is impacting
the merging at all.  I think Jeff Moyer (cc'd) has dealt with SAP
performance recently too.

> As it turns out, with 4 paths the system rarely did any I/O merging,
> but rather fired off the 4k requests as fast as possible.
> With two paths it was able to do some merging, leading to improved
> performance.
> 
> I was under the impression that the merging algorithm in the block
> layer would only unplug the queue once the request had been fully
> formed, ie after merging has happened. But apparently that is not
> the case here.

Just because you aren't seeing merging are you sure it has anything to
do with unpluging?  Would be nice to know more about the workload.

Mike

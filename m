From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: 3.15-rc4: circular locking dependency triggered by
	dm-multipath
Date: Tue, 06 May 2014 15:46:03 +0200
Message-ID: <5368E79B.8000208@acm.org>
References: <5368ABE8.9050909@acm.org> <20140506132211.GA22945@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140506132211.GA22945@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 05/06/14 15:22, Mike Snitzer wrote:
> On Tue, May 06 2014 at  5:31am -0400,
> Bart Van Assche <bvanassche@acm.org> wrote:
>> Has anyone else perhaps already run into this ?
> 
> Not seen this, how easily is it reproduced?
> 
> These recent commits are clearly the issue:
> 
> e809917735e dm mpath: push back requests instead of queueing
> 3e9f1be1b40 dm mpath: remove process_queued_ios()
> 
> Need to take a closer look at the lockdep splat you provided.

All I did was to simulate a cable pull while running a fio test on top
of a dm-multipath device on top of a few SCSI devices. This lockdep
report was generated the first time I ran the cable pull simulation. I
have not yet tried to reproduce this but it's not impossible that this
is 100% reproducible. The same test runs fine with kernel 3.14.

Bart.

From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: v3.15 dm-mpath regression: cable pull test causes
	I/O hang
Date: Thu, 03 Jul 2014 15:56:48 +0200
Message-ID: <53B56120.8040802@acm.org>
References: <53AD6B62.2020407@acm.org> <20140627133345.GA6150@redhat.com>
	<20140702220223.GA23894@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140702220223.GA23894@redhat.com>
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
Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 07/03/14 00:02, Mike Snitzer wrote:
> On Fri, Jun 27 2014 at  9:33am -0400,
> Mike Snitzer <snitzer@redhat.com> wrote:
> 
>> On Fri, Jun 27 2014 at  9:02am -0400,
>> Bart Van Assche <bvanassche@acm.org> wrote:
>>
>>> Hello,
>>>
>>> While running a cable pull simulation test with dm_multipath on top of
>>> the SRP initiator driver I noticed that after a few iterations I/O locks
>>> up instead of dm_multipath processing the path failure properly (see also
>>> below for a call trace). At least kernel versions 3.15 and 3.16-rc2 are
>>> vulnerable. This issue does not occur with kernel 3.14. I have tried to
>>> bisect this but gave up when I noticed that I/O locked up completely with
>>> a kernel built from git commit ID e809917735ebf1b9a56c24e877ce0d320baee2ec
>>> (dm mpath: push back requests instead of queueing). But with the bisect I
>>> have been able to narrow down this issue to one of the patches in "Merge
>>> tag 'dm-3.15-changes' of git://git.kernel.org/pub/scm/linux/kernel/git/
>>> device-mapper/linux-dm". Does anyone have a suggestion how to analyze this
>>> further or how to fix this ?
> 
> I still don't have a _known_ fix for your issue but I reviewed commit
> e809917735ebf1b9a56c24e877ce0d320baee2ec closer and identified what
> looks to be a regression in logic for multipath_busy, it now calls
> !pg_ready() instead of directly checking pg_init_in_progress.  I think
> this is needed (Hannes, what do you think?):
> 
> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> index 3f6fd9d..561ead6 100644
> --- a/drivers/md/dm-mpath.c
> +++ b/drivers/md/dm-mpath.c
> @@ -373,7 +373,7 @@ static int __must_push_back(struct multipath *m)
>  		 dm_noflush_suspending(m->ti)));
>  }
>  
> -#define pg_ready(m) (!(m)->queue_io && !(m)->pg_init_required)
> +#define pg_ready(m) (!(m)->queue_io && !(m)->pg_init_required && !(m)->pg_init_in_progress)
>  
>  /*
>   * Map cloned requests

Hello Mike,

Sorry but even with this patch applied and additionally with commit IDs
86d56134f1b6 ("kobject: Make support for uevent_helper optional") and
bcccff93af35 ("kobject: don't block for each kobject_uevent") reverted
my multipath test still hangs after a few iterations. I also reran the
same test with kernel 3.14.3 and it is still running after 30 iterations.

Bart.

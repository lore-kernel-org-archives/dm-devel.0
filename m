From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: dm: bind new table before destroying old
Date: Wed, 11 Nov 2009 15:56:05 +0900
Message-ID: <4AFA6005.9060501@ct.jp.nec.com>
References: <20091111011652.GK17055@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20091111011652.GK17055@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair Kergon <agk@redhat.com>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Mike Snitzer <snitzer@redhat.com>, Heinz Mauelshagen <mauelshagen@redhat.com>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

Hi Alasdair,

On 11/11/2009 10:16 AM +0900, Alasdair G Kergon wrote:
> Questions:
> 
>   Do all the targets correctly flush or push back everything during a
>   suspend (including workqueues)?
> 
>   Do all the targets correctly sync to disk all internal state that
>   needs to be preserved during a suspend?
> 
> In other words, in the case of an already-suspended target, the target
> 'dtr' functions should only be freeing memory and other resources and
> not causing I/O to any of the table's devices.
> 
> All targets are supposed to be behave this way already, but please
> would you check the targets with which you are familiar anyway?

I have checked multipath and found 2 issues.

multipath flushes all normal I/Os before suspend completion.
But multipath doesn't flush some workqueues until the table destruction.
Also, such works can be added and kicked even after suspend completion
through message ioctl.

For example, [de]activate_path() and trigger_event() are such works.
"reinstate path" message will trigger activate_path() work and
activate_path() may send some SCSI commands (through pg_init()) to
the underlying devices of the already-suspended target.
(Also, "fail_path" message will trigger deactivate_path() work
 and deactivate_path() may abort the underlying device's queue
 of the already-suspended target.)

So moving the table destruction after the resume (in your another
patch) could/might cause some race problems between new_table and
old_table if they have a same underlying device.
(e.g. pg_init() race, aborting queue after resume.)

I believe dm-mpath needs to flush such workqueues in postsuspend.
Also, we need something to block message ioctl to suspended device.

As for the message ioctl, I don't have any good idea, but...
  - Reject message ioctl to suspended device in dm-ioctl
  Or/And 
  - Targets must not kick any work influencing external themselves
    in their message ioctl handlers.

Thanks,
Kiyoshi Ueda

From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 7/7] dm-mpath: Fix a race condition in
	__multipath_map()
Date: Mon, 21 Nov 2016 19:34:44 -0500
Message-ID: <20161122003444.GB25362@redhat.com>
References: <e83f8718-9e73-5544-3bcc-4d9851b90ba1@sandisk.com>
	<81bc399e-df90-099d-1b25-bdb0fda3f27c@sandisk.com>
	<20161116003720.GA19059@redhat.com>
	<be828cfa-1121-8d99-0cd1-9021fab3adc8@sandisk.com>
	<20161121234316.GA25362@redhat.com>
	<d4a3879e-ec60-69f6-abb8-95aa7f305277@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <d4a3879e-ec60-69f6-abb8-95aa7f305277@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, Nov 21 2016 at  6:57pm -0500,
Bart Van Assche <bart.vanassche@sandisk.com> wrote:

> On 11/21/2016 03:43 PM, Mike Snitzer wrote:
> >Shouldn't be possible.  The previous stacktrace you shared clearly
> >showed that the DM mpath request_queue was using blk-mq (dm_mq_queue_rq
> >was in the stack).
> >
> >Whereas the stacktrace above is clearly the old request_fn interface.
> >
> >I'm unaware of how the existing code can allow this.  As I said in my
> >earlier mails on this: the request-queue shouldn't be able to change
> >from blk-mq back to .request_fn or vice-versa.
> >
> >So if you think you're only testing blk-mq DM mpath on blk-mq paths,
> >then you need to determine how dm_old_init_request_queue() is getting
> >called to even setup .request_fn (dm_old_request_fn) to be used.
> >
> >If the opposite is true (old request_fn DM mpath stack on blk-mq paths)
> >then determine how dm_mq_init_request_queue is getting called.
> >
> >Basically dm_setup_md_queue() should only ever be called the first time
> >the "multipath" target is loaded.  If that isn't the case, then you've
> >exposed some seriously weird bug/regression.
> 
> Hello Mike,
> 
> Sorry that I had not yet mentioned this, but the test I'm running is
> as follows:
> 
> # while true; do for t in mq sq sq-on-mq; do echo ==== $t;
> srp-test/run_tests -s -t 02-$t; done

But you WARN_ON_ONCE(clone && q->mq_ops) will trigger with sq-on-mq.
So this would seem to be a false positive.

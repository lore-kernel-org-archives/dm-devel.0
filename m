From: John Utz <John.Utz@wdc.com>
Subject: Re: device mapper target vs personality,
 how do you decide to pick one or the other?
Date: Mon, 14 Jul 2014 17:15:48 +0000
Message-ID: <8A51900D08212F40B3DE22453052F69839C45F44@wdscexmb02>
References: <8A51900D08212F40B3DE22453052F69839C45AE5@wdscexmb02>
	<20140711215120.GE9231@redhat.com>
	<8A51900D08212F40B3DE22453052F69839C45AFA@wdscexmb02>,
	<20140712003620.GA10126@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140712003620.GA10126@redhat.com>
Content-Language: en-US
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

Thankyou for the further clarification. 

My apologies for not being clear about my end goal. Indeed, I do wish to do remapping because I am coding a ZAC simulator.
________________________________________
From: Mike Snitzer [snitzer@redhat.com]
Sent: Friday, July 11, 2014 5:36 PM
To: John Utz
Cc: dm-devel@redhat.com
Subject: Re: device mapper target vs personality, how do you decide to pick one or the other?

On Fri, Jul 11 2014 at  5:56pm -0400,
John Utz <John.Utz@wdc.com> wrote:

> Hi Mike
>
> tnx so much for the prompt response!
>
> sorry i wasnt clear enuf, example of the 'personality code' that i was
> writing about below.
...
> FOR EXAMPLE, here is a little bit of linear.c that contains it:
>
> static struct md_personality linear_personality =
> {
>       .name           = "linear",
>       .level          = LEVEL_LINEAR,
>       .owner          = THIS_MODULE,
>       .make_request   = linear_make_request,
>       .run            = linear_run,
>       .stop           = linear_stop,
>       .status         = linear_status,
>       .hot_add_disk   = linear_add,
>       .size           = linear_size,
> };
>
> static int __init linear_init (void)
> {
>       return register_md_personality (&linear_personality);
> }
>
> static void linear_exit (void)
> {
>       unregister_md_personality (&linear_personality);
> }

The above is MD raid code.  So what you're talking about are the
different MD raid personalities.

> > so, based on this speculation, i *think* i should be using the target
> > construct for the new device mapper module that i am currently
> > coding.
> >
> > am i correct?
>
> Probably.

The target construct is provided by DM.  You haven;t said what you're
looking to do but if it is remapping IO and has nothing to do with raid
then you'd probably want to develop a new DM target.

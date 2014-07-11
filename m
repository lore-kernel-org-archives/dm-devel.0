From: John Utz <John.Utz@wdc.com>
Subject: Re: device mapper target vs personality,
 how do you decide to pick one or the other?
Date: Fri, 11 Jul 2014 21:56:44 +0000
Message-ID: <8A51900D08212F40B3DE22453052F69839C45AFA@wdscexmb02>
References: <8A51900D08212F40B3DE22453052F69839C45AE5@wdscexmb02>,
	<20140711215120.GE9231@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140711215120.GE9231@redhat.com>
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

Hi Mike

tnx so much for the prompt response! 

sorry i wasnt clear enuf, example of the 'personality code' that i was writing about below.

(and apologies in advance for my outlook web access MUA's lack of appropriate citing technology)
________________________________________
From: Mike Snitzer [snitzer@redhat.com]
Sent: Friday, July 11, 2014 2:51 PM
To: John Utz
Cc: dm-devel@redhat.com
Subject: Re: device mapper target vs personality, how do you decide to pick one or the other?

On Fri, Jul 11 2014 at  5:28pm -0400,
John Utz <John.Utz@wdc.com> wrote:

> Hi;
>
> having stared at the code associated with these 2 constructs for a while, i cant come up with a clear reason why one would choose one over the other.
>
> having said that, it seems that the personality code is ancestral and
> is used for the personalities that can be compiled into device mapper
> and the target code is for newer stuff that is not expected to be
> compiled into device mapper.

Not sure I know what you mean by "personality code" in DM.

FOR EXAMPLE, here is a little bit of linear.c that contains it:

static struct md_personality linear_personality =
{
	.name		= "linear",
	.level		= LEVEL_LINEAR,
	.owner		= THIS_MODULE,
	.make_request	= linear_make_request,
	.run		= linear_run,
	.stop		= linear_stop,
	.status		= linear_status,
	.hot_add_disk	= linear_add,
	.size		= linear_size,
};

static int __init linear_init (void)
{
	return register_md_personality (&linear_personality);
}

static void linear_exit (void)
{
	unregister_md_personality (&linear_personality);
}



> so, based on this speculation, i *think* i should be using the target
> construct for the new device mapper module that i am currently
> coding.
>
> am i correct?

Probably.

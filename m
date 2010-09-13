From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 23/41] dm: implement REQ_FLUSH/FUA support
 for bio-based dm
Date: Mon, 13 Sep 2010 14:55:32 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1009131424020.14720@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.1009101410570.7839@hs20-bc2-1.build.redhat.com>
	<20100910184652.GA24470@redhat.com>
	<Pine.LNX.4.64.1009101456220.21834@hs20-bc2-1.build.redhat.com>
	<20100910192403.GA24582@redhat.com>
	<Pine.LNX.4.64.1009101554300.5286@hs20-bc2-1.build.redhat.com>
	<4C8AC0F5.5080206@kernel.org> <20100911014612.GA26517@redhat.com>
	<Pine.LNX.4.64.1009110500070.27949@hs20-bc2-1.build.redhat.com>
	<20100911132102.GA29631@redhat.com>
	<Pine.LNX.4.64.1009111251470.22177@hs20-bc2-1.build.redhat.com>
	<20100911201758.GB31324@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100911201758.GB31324@redhat.com>
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
Cc: Tejun Heo <tj@kernel.org>, dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids



On Sat, 11 Sep 2010, Mike Snitzer wrote:

> On Sat, Sep 11 2010 at  1:14pm -0400,
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> > > You're implicitly dismissing Tejun's work as inadequate and
> > > inappropriate (all without identifying a single technical flaw).  But
> > > you'll make it all perfect once the dust settles. That isn't how
> > > upstream works.
> > 
> > The flaw is that the patch is big and combines several things.
> > 
> > For example, if I have a simple patch that transforms
> > bio_empty_barrier(bio)  ->  bio->bi_rw & REQ_FLUSH
> > WRITE_BARRIER -> WRITE_FLUSH
> > and then another patch that renames a function and then another one that 
> > changes flow control, the patches are easily verifiable --- with each 
> > patch I am paying attention to just one thing. If you combine everything 
> > into one patch, the effort to verify it is bigger than the sum of efforts 
> > to verify individual patches.
> 
> In a perfect world that would be the case but being so rigid after the
> work has evolved to the extent that it has is petty.  That is like
> walking into a kitchen and telling someone who prepared a delicious meal
> that you don't like the plates the food was served on and that you
> refuse to consume it.
> 
> You aren't allowing outside contribution if you trample all over
> someone's work with such trivial concerns.  Meanwhile Tejun is one of
> the most capable kernel developers Linux has -- further DM contributions
> from him would be great but I won't hold my breath now.

Don't take it personally. I'm not evaluating Tejun or you, I'm evaluating 
the patches.

> That said, there is potential for splitting the bio-based changes
> further but I'm not seeing that as needed (I reviewed the patches
> carefully over the past 3 weeks as they evolved).  Though if Alasdair
> thinks it is needed I'm willing to do the work.

The patches should have been definitely smaller, on the other side, I 
consider that cutting a big patch to smaller patches more likely 
introduces bugs than fixes them.

But I think the correct solution would be to take the other patches 
(except the first essential one to make it compile & work) from Tejun's 
tree and put them to Alasdair's tree, so that it undergoes some review 
from us. I think there are some things that need consideration.

> > Also, another flaw --- why test and develop on potentially unstable git 
> > kernel? (when I bisected and used git kernels, one of 13 kernels damaged 
> > my filesystem). Instead, we can develop on stable kernels and use normal 
> > team procedures for submitting patches --- i.e. put them to Alasdair's 
> > tree and from there to -rc.
> 
> That position is increasingly tenuous when we've shown that the process
> worked..

git kernels don't work. Bug examination is a complicated process --- 
record what I've been doing with the computer, then do something similar 
and try to find a reproducer (sometimes it may be statistical --- i.e. 
crashes about once per hour). Then search for the bug and try to fix it. 
And the run the reproducer again (a rule of thumb --- run it 10 times 
longer than the mean time of the crash). If it passes, the bug is fixed. 
It is basically what scientists call "hypothesis testing". This process 
takes long time but it isn't mentally stressing --- so long as I have the 
reproducer, I can search as slowly as I want.

Sometimes the reproducer isn't found. And then the real mad search for the 
bug comes, basically I have to read all the source code involved and try 
to think about it in a reverse way, not "how does it work?" but "how it 
didn't work and could've produced such a bug". Get the rules of the code 
and one-by-one try to think "what happens if this rule is violated". The 
task is very stressful, sometimes causes sleep deprivation and the less am 
I doing it, the better for me.

So, no git kernels! I want to sleep well tonight.

> There was change across the entire code base that DM needs to
> reliably consume.  Hoping all those changes would easily allow for DM to
> evolve as needed is not an option.  Rather than repeat myself, please
> re-read my original response here:
> https://www.redhat.com/archives/dm-devel/2010-September/msg00016.html

Mikulas

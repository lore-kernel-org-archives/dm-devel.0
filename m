From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH v2] dm-io: deal with wandering queue limits
 when handling REQ_DISCARD and REQ_WRITE_SAME
Date: Mon, 2 Mar 2015 11:06:01 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1503021037370.29560@file01.intranet.prod.int.rdu2.redhat.com>
References: <20150227184438.GF5519@birch.djwong.org>
	<alpine.LRH.2.02.1502271407010.32344@file01.intranet.prod.int.rdu2.redhat.com>
	<20150227195826.GB6945@redhat.com>
	<alpine.LRH.2.02.1502271727050.861@file01.intranet.prod.int.rdu2.redhat.com>
	<20150227225538.GA7961@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150227225538.GA7961@redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Srinivas Eeda <srinivas.eeda@oracle.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, agk@redhat.com, "Darrick J. Wong" <darrick.wong@oracle.com>
List-Id: dm-devel.ids



On Fri, 27 Feb 2015, Mike Snitzer wrote:

> On Fri, Feb 27 2015 at  5:39pm -0500,
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> > Without ACCESS_ONCE, the 
> > compiler may reload the variable multple times and reintroduce the bug 
> > that we are trying to fix.
> > 
> > 
> > See this piece of code.
> > 
> > special_cmd_max_sectors = q->limits.max_discard_sectors;
> > if (special_cmd_max_sectors == 0) {
> > 	dec_count(io, region, -EOPNOTSUPP);
> >         return;                  
> > }
> > ....
> > num_sectors = special_cmd_max_sectors;
> > remaining -= num_sectors;
> > 
> > 
> > At first sight, it seems that the variable num_sectors can't be zero. But 
> > in fact, it can. The compiler may eliminate the variable 
> > special_cmd_max_sectors and translate the code into this:
> > 
> > if (q->limits.max_discard_sectors == 0) {
> > 	dec_count(io, region, -EOPNOTSUPP);
> >         return;                  
> > }
> > ....
> > num_sectors = q->limits.max_discard_sectors;
> > remaining -= num_sectors;
> > 
> > - and now, if we have the same bug that we were trying to fix.
> > 
> > That's why we need ACCESS_ONCE - to prevent the compiler from doing this 
> > transformation.
> 
> Do we have proof that a gcc from the last 5-10 years actually does crap
> like this?  Again, if so and that compiler is likely to be in
> production, this isn't a concern localized to dm-io.  It would be a
> rampant problem in the kernel!
> 
> > It's true that the kernel misses the ACCESS_ONCE at many places where it 
> > should be. But the fact that there is a lot of broken code doesn't mean 
> > that we should write broken code too.
> 
> I'm saying in practice this type of code isn't broken (and that gcc
> isn't doing this.. but I have no _real_ proof other than all the other
> places we access structures whose members may change).  ACCESS_ONCE() is
> one of the biggest warts in all of the kernel code -- and you happen to
> be very persistent about adding them.  I appreciate that it is safer to
> have them then not but I'm at the point where I'm starting to question
> certain uses of ACCESS_ONCE() -- this one just feels unnecessary.

This is an example that gcc does multiple loads of the same value:

struct s {
        unsigned a, b, c, d;
};

unsigned fn(struct s *s)
{
        unsigned a = s->a;
        s->b = a;
        asm("nop":::"ebx","ecx","edx","esi","edi","ebp");
        s->c = a;
        return s->d;
}

Compile it in 32-bit mode with -m32 -O2, with gcc 4.9.2 you get:

00000000 <fn>:
   0:   55                      push   %ebp
   1:   57                      push   %edi
   2:   56                      push   %esi
   3:   53                      push   %ebx
   4:   8b 44 24 14             mov    0x14(%esp),%eax
   8:   8b 10                   mov    (%eax),%edx	* 1st load of s->a
   a:   89 50 04                mov    %edx,0x4(%eax)
   d:   90                      nop
   e:   8b 08                   mov    (%eax),%ecx	* 2nd load of s->a
  10:   89 48 08                mov    %ecx,0x8(%eax)
  13:   8b 40 0c                mov    0xc(%eax),%eax
  16:   5b                      pop    %ebx
  17:   5e                      pop    %esi
  18:   5f                      pop    %edi
  19:   5d                      pop    %ebp
  1a:   c3                      ret

You see that the value s->a is loaded twice and if another thread modifies 
it, it is possible that s->b and s->c will be different.

The asm statement marks all registers except eax as used. The variable s 
is stored in eax and there is no free register to store the variable a. 
The compiler could decide to either spill the variable a to the stack or 
reload it from s->a - in this case it chooses reload - and the decision is 
right because spilling the variable would result in more instructions than 
reloading it.

Mikulas

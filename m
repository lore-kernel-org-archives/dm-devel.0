From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Do not overload dispatch queue (Was: Re: IO
	scheduler based IO controller V10)
Date: Sat, 3 Oct 2009 17:14:45 +0200
Message-ID: <20091003151445.GF31616@kernel.dk>
References: <20091002181903.GN31616@kernel.dk>
	<1254548931.8299.18.camel@marge.simson.net>
	<1254549378.8299.21.camel@marge.simson.net>
	<20091003112915.GA12925@redhat.com>
	<20091003124049.GB12925@redhat.com>
	<20091003132115.GB31616@kernel.dk>
	<20091003135623.GD12925@redhat.com>
	<1254578553.7499.5.camel@marge.simson.net>
	<20091003142840.GE31616@kernel.dk>
	<1254581496.8293.8.camel@marge.simson.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1254581496.8293.8.camel@marge.simson.net>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Galbraith <efault@gmx.de>
Cc: dhaval@linux.vnet.ibm.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, jmarchan@redhat.com, fernando@oss.ntt.co.jp, Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>, mikew@google.com, jmoyer@redhat.com, nauman@google.com, Ingo Molnar <mingo@elte.hu>, Vivek Goyal <vgoyal@redhat.com>, m-ikeda@ds.jp.nec.com, riel@redhat.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, righi.andrea@gmail.com, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: dm-devel.ids

On Sat, Oct 03 2009, Mike Galbraith wrote:
> On Sat, 2009-10-03 at 16:28 +0200, Jens Axboe wrote:
> > On Sat, Oct 03 2009, Mike Galbraith wrote:
> > > On Sat, 2009-10-03 at 09:56 -0400, Vivek Goyal wrote:
> > > 
> > > > I have kept the overload delay period as "cfq_slice_sync" same as Mike had
> > > > done. We shall have to experiment what is a good waiting perioed. Is 100ms
> > > > too long if we are waiting for a request from same process which recently
> > > > finished IO and we did not enable idle on it.
> > > > 
> > > > I guess we can tweak the delay period as we move along.
> > > 
> > > I kept the delay period very short to minimize possible damage. Without
> > > the idle thing, it wasn't enough, but with, worked a treat, as does your
> > > patch.
> > 
> > Can you test the current line up of patches in for-linus? It has the
> > ramp up I talked about included as well.
> 
> Well, it hasn't hit git.kernel.org yet, it's at...
> 
> * block-for-linus        1d22351 cfq-iosched: add a knob for desktop interactiveness

It's the top three patches here, kernel.org sync sometimes takes a
while...

http://git.kernel.dk/?p=linux-2.6-block.git;a=shortlog;h=refs/heads/for-linus

-- 
Jens Axboe

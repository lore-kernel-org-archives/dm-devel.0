From: Akira Hayakawa <ruby.wktk@gmail.com>
Subject: Re: [PATCH v3] staging: writeboost: Add dm-writeboost
Date: Fri, 20 Feb 2015 17:44:01 +0900
Message-ID: <20150220174401.4badb3cbad7be3eed449f4c1@gmail.com>
References: <54A508F7.1020207@gmail.com>
	<20150118000952.GB26160@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20150118000952.GB26160@kroah.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: ejt@redhat.com, driverdev-devel@linuxdriverproject.org, dm-devel@redhat.com, snitzer@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Hi,

Very very sad to not receive any comments from dm maintainers
in the past 2 mouths. I implemented read-caching for v3 because
they like to see this feature in but no comment...

I still believe they reevaluate dm-writeboost because I don't
think this driver isn't bad as they claim.

They really dislike the 4KB splitting and that's the biggest reason
dm-writeboost isn't appreciated. Now let me argue about this.

Log-structured block-level caching isn't a fully brand new idea of
my own although the implementation is so.

Back to 1992, the concept of log-structured filesystem was invented.
3 years later, the concept of log-structured block-level caching
appeared inspired by the concept of lfs. The paper shows the I/O is
split into 4KB chunks and then managed as cache blocks.
http://www.ele.uri.edu/research/hpcl/DCD/DCD.html

Since then, no research follows DCD but
the idea of log-strucutured block-level caching revives as SSD emerges.

In 2010, MSR's Griffin also does 4KB split. Griffin uses HDD as the cache device
to extend the lifetime of the backing device which is SSD.
http://research.microsoft.com/apps/pubs/default.aspx?id=115352
(So, dm-writeboost can be applied in this way)

In 2012, NetApp's Mercury is a read caching for their storage system
that's quite log-structured to be durable and exploits the full throughput.
It managed in 4KB cache size too.
http://storageconference.us/2012/Papers/04.Flash.1.Mercury.pdf

They all splits I/O into 4KB chunks (and buffer write to cache device).
The history says the decision isn't wrong for log-structured block-level caching.
I decided this principal design decision based on this research papers' consensus.
Do you still say that I should change this design?

Joe started nacking after observing a low-throughput of large-sized read in virtual
environment. I reproduced the case in my KVM environment and realized that
the split chunks aren't merged in host machine. KVM seems to disable its 
I/O scheduler and delegates merging to the host.
When I run the same experiment _without_ virtual machine, the split chunks are fully
merged in the I/O scheduler. So, I can conclude this is due to KVM interference and
dm-writeboost isn't suitable for at least usage on VM. This isn't a big reason to nack
because dm-writeboost is usually used in host machine.

I will wait for ack from dm maintainers.

- Akira

On Sat, 17 Jan 2015 16:09:52 -0800
Greg KH <gregkh@linuxfoundation.org> wrote:

> On Thu, Jan 01, 2015 at 05:44:39PM +0900, Akira Hayakawa wrote:
> > This patch adds dm-writeboost to staging tree.
> > 
> > dm-writeboost is a log-structured SSD-caching driver.
> > It caches data in log-structured way on the cache device
> > so that the performance is maximized.
> > 
> > The merit of putting this driver in staging tree is
> > to make it possible to get more feedback from users
> > and polish the codes.
> > 
> > v2->v3
> > - rebased onto 3.19-rc2
> > - Add read-caching support (disabled by default)
> >   Several tests are pushed to dmts.
> > - An critical bug fix
> >   flush_proc shouldn't free the work_struct it's running on.
> >   I found this bug while I am testing read-caching.
> >   I am not sure why i didn't exhibit before but it's truly a bug.
> > - Fully revised the README.
> >   Now that we have read-caching support, the old README was completely obsolete.
> > - Update TODO
> >   Implementing read-caching is done.
> > - bump up the copyright year to 2015
> > - fix up comments
> > 
> > 
> > Signed-off-by: Akira Hayakawa <ruby.wktk@gmail.com>
> 
> I need an ack from a dm developer before I can take this.
> 
> thanks,
> greg k-h

From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/3] Fix SMP races in dm-crypt
Date: Thu, 22 Mar 2007 15:44:08 -0700
Message-ID: <20070322154408.7e7afe1a.akpm@linux-foundation.org>
References: <200703210806.30499.okir@lst.de>
	<1174595296.2458.13.camel@leto.intern.saout.de>
	<20070322134122.ee9834fb.akpm@linux-foundation.org>
	<20070322215352.GP27600@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20070322215352.GP27600@agk.surrey.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Christophe Saout <christophe@saout.de>, Olaf Kirch <olaf.kirch@oracle.com>
List-Id: dm-devel.ids

On Thu, 22 Mar 2007 21:53:53 +0000
Alasdair G Kergon <agk@redhat.com> wrote:

> On Thu, Mar 22, 2007 at 01:41:22PM -0700, Andrew Morton wrote:
> > On Thu, 22 Mar 2007 21:28:16 +0100
> > Christophe Saout <christophe@saout.de> wrote:
> > I'm hunting around, but cannot find the patches to which you refer.  Maybe
> > they're on dm-devel only?
> 
> These four:
>   http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/dm-crypt-fix-call-to-clone_init.patch
>   http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/dm-crypt-fix-avoid-cloned-bio-ref-after-free.patch
>   http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/dm-crypt-fix-remove-first_clone.patch
>   http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/dm-crypt-use-smaller-bvecs-in-clones.patch
> 
> Grab them from there, or I'll send you them properly at the start of next
> week as part of the next dm patch set.
> 

yup, thanks - Christophe forwarded them.

(And I merged them with the wrong From: attribution (fixes that))

btw, should I include
http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/* in
the -mm lineup?  It's easy to do from this end.

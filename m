From: "Paul E. McKenney" <paulmck@linux.ibm.com>
Subject: Re: [PATCH 1/3] list_bl: Add hlist_bl_add_before/behind helpers
Date: Wed, 13 Mar 2019 17:25:05 -0700
Message-ID: <20190314002505.GD13351@linux.ibm.com>
References: <20181220180651.4879-1-ntsironis@arrikto.com>
 <20181220180651.4879-2-ntsironis@arrikto.com>
 <20190228213201.GB23527@redhat.com>
 <20190311181607.GA9388@infradead.org>
 <20190311221321.GP13351@linux.ibm.com>
 <20190311224333.GA16968@redhat.com>
Reply-To: paulmck@linux.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190311224333.GA16968@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Nikos Tsironis <ntsironis@arrikto.com>, agk@redhat.com, dm-devel@redhat.com, mpatocka@redhat.com, iliastsi@arrikto.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Mon, Mar 11, 2019 at 06:43:33PM -0400, Mike Snitzer wrote:
> On Mon, Mar 11 2019 at  6:13pm -0400,
> Paul E. McKenney <paulmck@linux.ibm.com> wrote:
> 
> > On Mon, Mar 11, 2019 at 11:16:08AM -0700, Christoph Hellwig wrote:
> > > On Thu, Feb 28, 2019 at 04:32:02PM -0500, Mike Snitzer wrote:
> > > > Hi Paul and Christoph,
> > > > 
> > > > You've added your Signed-off-by to include/linux/list_bl.h commits in
> > > > the past.  I'm not sure how this proposed patch should be handled.
> > > > 
> > > > These new hlist_bl_add_{before,behind} changes are a prereq for
> > > > dm-snapshot changes that Nikos has proposed, please see:
> > > > https://patchwork.kernel.org/patch/10739265/
> > > > 
> > > > Any assistance/review you, or others on LKML, might be able to provide
> > > > would be appreciated.
> > > 
> > > I just killed two helpers.  That being said assuming that we only
> > > rely on the next pointer for the lockless traversals the changes look
> > > fine to me, but the code might be beyond my paygrade..
> > 
> > First, apologies for being slow on this one.
> 
> No problem.
>  
> > Second, were the two helpers hlist_bl_add_{before,behind}()?  If so, I
> > guess there is not much point in me looking them over.  Though perhaps
> > I should be looking something else over?
> 
> No, think Christoph was referring to his commit 1879fd6a26571fd4e8e1f
> from 2011.
> 
> Anyway, I'd like you to look over this new proposed patch that
> introduces hlist_bl_add_{before,behind}(), please see:
> https://patchwork.kernel.org/patch/10835713/
> 
> If you're happy with the patch, and can provide your Reviewed-by or
> Acked-by, I'll then pick it up as a prereq for the broader dm-snapshot
> changes that Nikos has provided.

I replied to the version earlier in this email thread.  Looks close,
but a couple of questions.

							Thanx, Paul

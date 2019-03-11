From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] list_bl: Add hlist_bl_add_before/behind helpers
Date: Mon, 11 Mar 2019 11:16:08 -0700
Message-ID: <20190311181607.GA9388@infradead.org>
References: <20181220180651.4879-1-ntsironis@arrikto.com>
 <20181220180651.4879-2-ntsironis@arrikto.com>
 <20190228213201.GB23527@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190228213201.GB23527@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, hch@infradead.org, Nikos Tsironis <ntsironis@arrikto.com>, agk@redhat.com, dm-devel@redhat.com, mpatocka@redhat.com, iliastsi@arrikto.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Thu, Feb 28, 2019 at 04:32:02PM -0500, Mike Snitzer wrote:
> Hi Paul and Christoph,
> 
> You've added your Signed-off-by to include/linux/list_bl.h commits in
> the past.  I'm not sure how this proposed patch should be handled.
> 
> These new hlist_bl_add_{before,behind} changes are a prereq for
> dm-snapshot changes that Nikos has proposed, please see:
> https://patchwork.kernel.org/patch/10739265/
> 
> Any assistance/review you, or others on LKML, might be able to provide
> would be appreciated.

I just killed two helpers.  That being said assuming that we only
rely on the next pointer for the lockless traversals the changes look
fine to me, but the code might be beyond my paygrade..

From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH] dm-kcopyd: Correctly free requests
Date: Fri, 26 Aug 2011 11:43:37 +0100
Message-ID: <20110826104337.GN31980@agk-dp.fab.redhat.com>
References: <20110826101542.GB20197@wavehammer.waldi.eu.org> <20110826103747.GA15125@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110826103747.GA15125@agk-dp.fab.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dm-devel@redhat.com
Cc: linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Fri, Aug 26, 2011 at 11:37:47AM +0100, Alasdair G Kergon wrote:
> On Fri, Aug 26, 2011 at 12:15:42PM +0200, Bastian Blank wrote:
> > kcopyd only frees the requests if the master job information is set up
> > correctly, but it was not in the recently added path. This leads to many
> > unfreed slabs during snapshot usage.
> Referring to commit c6ea41fbbe08f270a8edef99dc369faf809d1bd6
>   dm kcopyd: preallocate sub jobs to avoid deadlock
> which added the master_job field.
 
and commit a6e50b409d3f9e0833e69c3c9cca822e8fa4adbb
    dm snapshot: skip reading origin when overwriting complete chunk
which indeed forgets to set the new field.

I'll submit the patch shortly, together with some other minor fixes
sitting in linux-next.

Alasdair

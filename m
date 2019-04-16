From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 2/3] dm thin metadata: do not write metadata
 if no changes occurred
Date: Mon, 15 Apr 2019 22:39:03 -0400
Message-ID: <20190416023903.GA19565@redhat.com>
References: <20190415211717.18737-1-snitzer@redhat.com>
	<20190415211717.18737-3-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20190415211717.18737-3-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: ejt@redhat.com
List-Id: dm-devel.ids

On Mon, Apr 15 2019 at  5:17pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> Otherwise, just loading a thin-pool and then removing it will cause its
> metadata to be changed (e.g. superblock written) -- even without any
> thin devices being made active or metadata snapshot being manipulated.
> 
> Add 'changed' flag to struct dm_pool_metadata.  Set both td->changed and
> pmd->changed using __set_thin_changed() -- this assures pmd->changed is
> always set when td->changed is.  For methods that don't involve changing
> a td, set pmd->changed directly.
> 
> Rename __delete_device() to __delete_thin() -- improves symmetry with
> __create_thin().
> 
> Update dm_pool_changed_this_transaction() to simply return pmd->changed.
> 
> Fix dm_pool_commit_metadata() to open the next transaction if the return
> from __commit_transaction() is 0.  Not seeing why the early return ever
> made since for a return of 0 given that dm-io's async_io(), as used by
> bufio, always returns 0.

This v1 patch was incomplete.  However this approach's need to establish
pmd->changed everywhere that alters metadata, without doing so in terms
of a thin device, is like whack-a-mole.

But I think this could be simplified to only set a 'pmd->accessed'
(never clear it) and only__commit_transaction() if pmd->accessed --
so only pool messages that change metadata would need to set
pmd->accessed.

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: Re: [PATCH 2/9] dm snapshot: add
	lookup_completed_exception hook to struct exception_store
Date: Thu, 30 Oct 2008 15:06:50 +0900
Message-ID: <20081030145111W.fujita.tomonori@lab.ntt.co.jp>
References: <1225109276-16491-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1225109276-16491-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<20081029235234.GN31233@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20081029235234.GN31233@agk.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, 29 Oct 2008 23:52:34 +0000
Alasdair G Kergon <agk@redhat.com> wrote:

> On Mon, Oct 27, 2008 at 09:07:49PM +0900, FUJITA Tomonori wrote:
> > +struct dm_snap_exception *lookup_complete_exception(struct dm_snapshot *s,
> > +						    chunk_t chunk)
> > +{
> > +	if (s->store.lookup_completed_exception)
> > +		return s->store.lookup_completed_exception(&s->store, chunk);
> > +	else
> > +		return lookup_exception(&s->complete, chunk);
> > +}
> 
> Can we have symmetry here such that lookup_completed_exception is *required* to be
> defined for all snapshot types?

Sure, we can. It would be cleaner, I guess. I'll do next time.

Thanks,

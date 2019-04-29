From: Martin Wilck <mwilck@suse.de>
Subject: Re: [PATCH v2] dm mpath: fix missing call of path
 selector type->end_io
Date: Mon, 29 Apr 2019 11:52:08 +0200
Message-ID: <f839ea76c050d643c617bb7f5de3ef76f104123f.camel@suse.de>
References: <20190424151905.22615-1-yuyufen@huawei.com>
	<ed4a3f0c76cdeef15f549a475a6b31eca177c392.camel@suse.de>
	<d49d1784-6ecf-5450-a633-692ba107b9ee@huawei.com>
	<20190425194534.GA20137@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190425194534.GA20137@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>, yuyufen <yuyufen@huawei.com>
Cc: dm-devel@redhat.com, yi.zhang@huawei.com, mpatocka@redhat.com, ming.lei@redhat.com, houtao1@huawei.com
List-Id: dm-devel.ids

On Thu, 2019-04-25 at 15:45 -0400, Mike Snitzer wrote:
> On Thu, Apr 25 2019 at  5:25am -0400,
> yuyufen <yuyufen@huawei.com> wrote:
> 
> > > "CANCAL" looks strange - did you mean "CANCEL"?
> > 
> > This is a spelling error.
> > 
> > > Anyway, what do you need this new enum for? Couldn't you just
> > > pass the
> > > disposition (i.e. DM_MAPIO_REQUEUE), and use a different value
> > > (e.g.
> > > DM_ENDIO_DONE) at those call sites where end_io shouldn't be
> > > called?
> > > 
> > > Regards,
> > > Martin
> > > 
> > > 
> > > .
> > > 
> > 
> > Thanks for your suggestion. Passing DM_MAPIO_REQUEUE is a good
> > idea.
> > It indicates that request will be requeued and we need to call
> > ->end_io.
> > 
> > However, I am not sure if it is suitable for use DM_ENDIO_DONE.
> > It is strange that we use DM_ENDIO_DONE in
> > dm_requeue_original_request(),
> > which is called in the case of DM_ENDIO_REQUEUE in dm_done().
> 
> I've staged the following, it doesn't get bogged down with passing
> flags
> (and overloading their use with unnatural new meanings).  Please let
> me
> know if you see any issues:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-5.2&id=5de719e3d01b4abe0de0d7b857148a880ff2a90b

Nice and simple. Looks good to me.

Reviewed-by: Martin Wilck <mwilck@suse.com>

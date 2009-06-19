From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 18/19] io-controller: Debug hierarchical IO
	scheduling
Date: Fri, 19 Jun 2009 10:05:26 -0400
Message-ID: <20090619140526.GB3726@redhat.com>
References: <1244513342-11758-1-git-send-email-vgoyal@redhat.com>
	<1244513342-11758-19-git-send-email-vgoyal@redhat.com>
	<4A3AEC96.7050500@cn.fujitsu.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4A3AEC96.7050500@cn.fujitsu.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: dhaval@linux.vnet.ibm.com, snitzer@redhat.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, jens.axboe@oracle.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, fernando@oss.ntt.co.jp, mikew@google.com, jmoyer@redhat.com, nauman@google.com, m-ikeda@ds.jp.nec.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, akpm@linux-foundation.org, jbaron@redhat.com, linux-kernel@vger.kernel.org, s-uchida@ap.jp.nec.com, righi.andrea@gmail.com, containers@lists.linux-foundation.org
List-Id: dm-devel.ids

On Fri, Jun 19, 2009 at 09:40:38AM +0800, Gui Jianfeng wrote:

[..]
> > + * An entity has been freshly added to active tree. Either it came from
> > + * idle tree or it was not on any of the trees. Do the accounting.
> > + */
> > +static inline void bfq_account_for_entity_addition(struct io_entity *entity)
> > +{
> > +	struct io_group *iog = io_entity_to_iog(entity);
> > +
> > +	if (iog) {
> > +		struct elv_fq_data *efqd;
> > +		char path[128];
> > +
> > +		/*
> > +		 * Keep track of how many times a group has been removed
> > +		 * from active tree because it did not have any active
> > +		 * backlogged ioq under it
> > +		 */
> 
> Hi Vivek,
> 
> Should the comment here be "added to" rather than "removed from"?

Yes, it is copy paste error. Fixed for next posting.

Thanks
Vivek

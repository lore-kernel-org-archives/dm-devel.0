From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: why does __split_and_process_bio use
	bio_clone_bioset?
Date: Fri, 15 Jun 2018 14:26:31 -0400
Message-ID: <20180615182631.GA6906@redhat.com>
References: <20180614081947.GA23375@infradead.org>
	<20180614181245.GA1161@redhat.com>
	<20180614200808.GA46373@redhat.com>
	<20180615073846.GA29726@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180615073846.GA29726@infradead.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, NeilBrown <neilb@suse.com>, Ming Lei <ming.lei@redhat.com>
List-Id: dm-devel.ids

On Fri, Jun 15 2018 at  3:38am -0400,
Christoph Hellwig <hch@infradead.org> wrote:

> On Thu, Jun 14, 2018 at 04:08:09PM -0400, Mike Snitzer wrote:
> > The patch below seems to work fine (given quick testing).. It also has a
> > side-effect of not breaking integrity support (which commit 18a25da8
> > appears to do because it isn't accounting for any of the integrity stuff
> > bio_split, or dm.c:clone_bio, does).
> 
> Looks sensible to me.  Are you going to queue this up for 4.18?

Yes.  Already queued, likely won't send to Linus until end of next week
though.. unless you want it upstream sooner?

https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.18&id=bbb683cf88f58742233c3551d1b9839a5fe5bbf8

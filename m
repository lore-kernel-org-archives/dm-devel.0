From: Christoph Hellwig <hch@infradead.org>
Subject: Re: why does __split_and_process_bio use
	bio_clone_bioset?
Date: Sat, 16 Jun 2018 08:20:52 -0700
Message-ID: <20180616152052.GA7934@infradead.org>
References: <20180614081947.GA23375@infradead.org>
	<20180614181245.GA1161@redhat.com>
	<20180614200808.GA46373@redhat.com>
	<20180615073846.GA29726@infradead.org>
	<20180615182631.GA6906@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180615182631.GA6906@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org, dm-devel@redhat.com, NeilBrown <neilb@suse.com>, Ming Lei <ming.lei@redhat.com>
List-Id: dm-devel.ids

On Fri, Jun 15, 2018 at 02:26:31PM -0400, Mike Snitzer wrote:
> Yes.  Already queued, likely won't send to Linus until end of next week
> though.. unless you want it upstream sooner?

We only really need it as a baseline for the multi-page bio work, so
no real rush.  I think I'll just include it with my pending cleanup
series with a big 'DO NOT APPLY, will be in 4.18-rc2' marker.

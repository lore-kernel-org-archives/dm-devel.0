From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: [PATCH 0/2] dm: add new loop and ram targets
Date: Thu, 18 Jan 2018 11:42:32 +0000
Message-ID: <20180118114231.GG8694@localhost.localdomain>
References: <cover.1516124587.git.heinzm@redhat.com>
	<20180117212936.GA6756@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180117212936.GA6756@redhat.com>
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
Cc: Heinz Mauelshagen <heinzm@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Jan 17, 2018 at 04:29:36PM -0500, Mike Snitzer wrote:
> On Wed, Jan 17 2018 at  2:33pm -0500,
> As for dm-loop, doubling the performance of the loopback driver is quite
> nice (especially with only 1/7 the number of lines of code as
> drives/block/loop.c).

Isn't this going to raise the same objection that akpm had years ago,
with the original dm-loop (block mapping) target?

We had an even bigger performance boost with that but it was rejected
on the grounds that a second loop back block device implementation was
not welcome unless the two could share code.

We had out of tree users for years from folks looking for better
performance.

I've been through a few revisions of a patch set that refactors the
loop.c driver into an interface and back end, which both /dev/loopN and
dm-loop could use. This was at the request of various groups who were
interested in a DM loop target but ultimately interest waned each time
and I ended up stopping maintenance of it a few years back.

Regards,
Bryn.
 

From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: [PATCH 0/2] introduce interface to list all	badblocks
Date: Tue, 16 Jun 2020 13:28:03 +0100
Message-ID: <20200616122803.GA24935@localhost.localdomain>
References: <20200608084513.115671-1-yangerkun@huawei.com>
	<20200615170331.GA12312@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200615170331.GA12312@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: yangerkun <yangerkun@huawei.com>, bgurney@redhat.com, agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Jun 15, 2020 at 06:03:31PM +0100, Alasdair G Kergon wrote:
> On Mon, Jun 08, 2020 at 04:45:11PM +0800, yangerkun wrote:
> >     $ sudo dmsetup message dust1 0 listbadblocks
> > The following message will appear, listing one bad block number per
> 
> Did you consider returning the data directly to the caller so it
> can be accessed directly?
> 
> (e.g. like @stats_list handled in dm-stats.c)

Having this returned in the message response would certainly be more
natural and would simplify parsing the data: sending it to the log seems
like it would allow log lines from distinct devices to become
interleaved when the lists are long and the message is sent to two or
more devices near simultaneously. Without something to identify the
devices in each message you can't distinguish them.

Even with large numbers of bad blocks userspace libdevmapper will
automatically handle re-trying with a larger buffer if the list is too
big for the default.

We use (sometimes very large) message replies heavily in libdm-stats.

device-mapper.h provides the DMEMIT macro to output message replies.
See dm_stats_print() or various target status() functions for
examples.

Regards,
Bryn.

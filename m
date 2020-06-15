From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 0/2] introduce interface to list all	badblocks
Date: Mon, 15 Jun 2020 18:03:31 +0100
Message-ID: <20200615170331.GA12312@agk-dp.fab.redhat.com>
References: <20200608084513.115671-1-yangerkun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200608084513.115671-1-yangerkun@huawei.com>
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
To: yangerkun <yangerkun@huawei.com>
Cc: dm-devel@redhat.com, snitzer@redhat.com, agk@redhat.com, bgurney@redhat.com
List-Id: dm-devel.ids

On Mon, Jun 08, 2020 at 04:45:11PM +0800, yangerkun wrote:
>     $ sudo dmsetup message dust1 0 listbadblocks
> The following message will appear, listing one bad block number per

Did you consider returning the data directly to the caller so it
can be accessed directly?

(e.g. like @stats_list handled in dm-stats.c)

Alasdair

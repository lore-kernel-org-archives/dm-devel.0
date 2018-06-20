From: Joe Thornber <thornber@redhat.com>
Subject: Re: dm thin: superblock may write succeed before other
 metadata blocks because of wirting metadata in async mode.
Date: Wed, 20 Jun 2018 16:00:32 +0100
Message-ID: <20180620150032.pnbv4bmpd4ars6hq@reti>
References: <20180522005336.GA30152@yyp.> <20180619131106.GA31018@redhat.com>
	<20180619144300.lhygtljn5aoazr5h@reti>
	<20180619150032.GA31378@redhat.com> <20180620170357.GA5838@yyp.>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180620170357.GA5838@yyp.>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: monty <monty_pavel@sina.com>
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On Wed, Jun 20, 2018 at 01:03:57PM -0400, monty wrote:
> Hi, Mike and Joe. Thanks for your reply. I read __commit_transaction
> many times and didn't find any problem of 2-phase commit. I use
> md-raid1(PCIe nvme and md-raid5) in write-behind mode to store dm-thin
> metadata.
> Test case:
> 1. I do copy-diff test on thin device and then reboot my machine.
> 2. Rebuild our device stack and exec "vgchang -ay".
> The thin-pool can not be established(details_root become a bitmap node
> and metadata's bitmap_root become a btree_node).

As you simplify your setup does the problem go away?  eg, turn off write-behind, use just the nvme dev etc.

The only effect of your change is to call flush twice rather than once.

- Joe

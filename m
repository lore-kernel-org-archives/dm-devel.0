From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: staged dm_internal_{suspend,
 resume} related changes for wider review
Date: Mon, 3 Nov 2014 18:25:05 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1411031823100.29299@file01.intranet.prod.int.rdu2.redhat.com>
References: <20141028014825.GA21949@redhat.com> <544F988D.7090901@redhat.com>
	<20141028134012.GA25229@redhat.com>
	<20141028141749.GD25229@redhat.com>
	<20141028143742.GE25229@redhat.com>
	<20141028171003.GG25229@redhat.com>
	<20141028224753.GA29288@redhat.com>
	<20141028232638.GB29288@redhat.com> <20141029002125.GC29288@redhat.com>
	<20141029012256.GF29288@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20141029012256.GF29288@redhat.com>
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
Cc: ejt@redhat.com, Bryn Reeves <breeves@redhat.com>, dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids



On Tue, 28 Oct 2014, Mike Snitzer wrote:

> I pushed rebased versions of these patches to linux-dm.git's
> 'dm-for-3.19' branch (and pulled into 'for-next' purely to get the
> kernel.org autobuilders testing the code).  See top 3 commits here:
> https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-for-3.19
> 
> I'm open to any and all changes or dropping code entirely; so me staging
> like this is just to keep the review ball rolling as quickly as
> possible.
> 
> But in particular we need to get Mikulas' and Bryn's feedback on how the
> dm_internal_{suspend,resume} changes impact dm-stats.
> 
> Mike

Hi

As I said on irc - it is not correct to take a mutex from one syscall and 
drop the mutex from another syscall.

I hope Joe can use the bio prison to block bios while the pool is 
suspended.

Mikulas

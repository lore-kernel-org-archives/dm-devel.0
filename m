From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] dm-cache: Add handle to contlr
	if	cache_create failed.
Date: Tue, 19 Mar 2013 00:20:49 +0000
Message-ID: <20130319002049.GD20480@agk-dp.fab.redhat.com>
References: <5139441C.7000309@gmail.com>
	<20130308021027.GV8913@agk.fab.redhat.com>
	<20130318231357.GA10638@blackbox.djwong.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20130318231357.GA10638@blackbox.djwong.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, agk@redhat.com, majianpeng <majianpeng@gmail.com>
List-Id: dm-devel.ids

On Mon, Mar 18, 2013 at 04:13:57PM -0700, Darrick J. Wong wrote:
> Hmm... by 'adjustment', do you mean this commit?
> https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/?id=1005501c2f71931bd4cda2238b7698562a744f1a
> I realize dm-cache hasn't been in an upstream release yet, but could we add new
> fields at the end of the disk superblock?  And after 3.9, maybe have some sort

The new field looks to be misaligned too?
Thanks for pointing this out!

Alasdair

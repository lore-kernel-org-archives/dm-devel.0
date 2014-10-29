From: Mike Snitzer <snitzer@redhat.com>
Subject: staged dm_internal_{suspend,
	resume} related changes for wider review
Date: Tue, 28 Oct 2014 21:22:56 -0400
Message-ID: <20141029012256.GF29288@redhat.com>
References: <20141028014825.GA21949@redhat.com> <544F988D.7090901@redhat.com>
	<20141028134012.GA25229@redhat.com>
	<20141028141749.GD25229@redhat.com>
	<20141028143742.GE25229@redhat.com>
	<20141028171003.GG25229@redhat.com>
	<20141028224753.GA29288@redhat.com>
	<20141028232638.GB29288@redhat.com>
	<20141029002125.GC29288@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20141029002125.GC29288@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Zdenek Kabelac <zkabelac@redhat.com>
Cc: ejt@redhat.com, Bryn Reeves <breeves@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

I pushed rebased versions of these patches to linux-dm.git's
'dm-for-3.19' branch (and pulled into 'for-next' purely to get the
kernel.org autobuilders testing the code).  See top 3 commits here:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-for-3.19

I'm open to any and all changes or dropping code entirely; so me staging
like this is just to keep the review ball rolling as quickly as
possible.

But in particular we need to get Mikulas' and Bryn's feedback on how the
dm_internal_{suspend,resume} changes impact dm-stats.

Mike

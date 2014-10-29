From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: staged dm_internal_{suspend,
 resume} related changes for wider review
Date: Wed, 29 Oct 2014 16:49:58 -0400
Message-ID: <20141029204958.GA4015@redhat.com>
References: <544F988D.7090901@redhat.com> <20141028134012.GA25229@redhat.com>
	<20141028141749.GD25229@redhat.com>
	<20141028143742.GE25229@redhat.com>
	<20141028171003.GG25229@redhat.com>
	<20141028224753.GA29288@redhat.com>
	<20141028232638.GB29288@redhat.com>
	<20141029002125.GC29288@redhat.com>
	<20141029012256.GF29288@redhat.com>
	<20141029190649.GA3676@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20141029190649.GA3676@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Alasdair G. Kergon" <agk@redhat.com>
Cc: ejt@redhat.com, Bryn Reeves <breeves@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, dm-devel@redhat.com, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

On Wed, Oct 29 2014 at  3:06pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Tue, Oct 28 2014 at  9:22pm -0400,
> Mike Snitzer <snitzer@redhat.com> wrote:
> 
> > I pushed rebased versions of these patches to linux-dm.git's
> > 'dm-for-3.19' branch (and pulled into 'for-next' purely to get the
> > kernel.org autobuilders testing the code).  See top 3 commits here:
> > https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-for-3.19
> > 
> > I'm open to any and all changes or dropping code entirely; so me staging
> > like this is just to keep the review ball rolling as quickly as
> > possible.
> > 
> > But in particular we need to get Mikulas' and Bryn's feedback on how the
> > dm_internal_{suspend,resume} changes impact dm-stats.
> 
> Rebased, and added a few more changes, see top 5 commits here:
> https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-for-3.19

FYI, Joe was kind enough to write a series of tests for these changes,
see:
https://github.com/jthornber/device-mapper-test-suite/commit/860555a3e838e995f8f2549deb9fd7ccebb0deb5
https://github.com/jthornber/device-mapper-test-suite/commit/24da8a852bce9ef94db98bdefdf5cd8cd0d5e2eb

# dmtest run --profile fusionio --suite thin-provisioning -t /SuspendTests/
Loaded suite thin-provisioning
Started
SuspendTests
  suspend_pool_active_thins_no_io...PASS
  suspend_pool_after_suspend_thin...PASS
  suspend_pool_concurrent_suspend...PASS
  suspend_pool_no_active_thins...PASS
  suspend_pool_no_thins...PASS
  suspend_pool_resume_thin...PASS
  suspend_pool_suspended_thin...PASS

Finished in 22.350814169 seconds.

7 tests, 0 assertions, 0 failures, 0 errors

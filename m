From: Joe Thornber <thornber@redhat.com>
Subject: Re: all cache blocks marked as dirty in writethrough
 mode, "Data loss may occur", constant write activity
Date: Mon, 30 Jun 2014 12:25:13 +0100
Message-ID: <20140630112513.GA3893@debian>
References: <20140628225452.GA570@schmorp.de>
 <20140630091403.GB3098@debian>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20140630091403.GB3098@debian>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, Jun 30, 2014 at 10:14:03AM +0100, Joe Thornber wrote:
> - There's a constant 4k background load to the metadata device.
> 
>   I'll look into this.  Sounds like the periodic commit is re writing
>   the superblock even if there's no change to the mappings.

I've added this test to the dm test suite:

https://github.com/jthornber/device-mapper-test-suite/blob/master/lib/dmtest/tests/cache/io_use_tests.rb

Using my latest development tree I can't see any spurious IO.

I also instrumented to see exactly when the superblock is written,
again nothing happens while the cache is idle.  So I'm puzzled about
what you are seeing.

- Joe

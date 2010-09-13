From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 23/41] dm: implement REQ_FLUSH/FUA support
 for bio-based dm
Date: Mon, 13 Sep 2010 16:54:31 -0400
Message-ID: <20100913205431.GA12374@redhat.com>
References: <Pine.LNX.4.64.1009101456220.21834@hs20-bc2-1.build.redhat.com>
	<20100910192403.GA24582@redhat.com>
	<Pine.LNX.4.64.1009101554300.5286@hs20-bc2-1.build.redhat.com>
	<4C8AC0F5.5080206@kernel.org> <20100911014612.GA26517@redhat.com>
	<Pine.LNX.4.64.1009110500070.27949@hs20-bc2-1.build.redhat.com>
	<20100911132102.GA29631@redhat.com>
	<Pine.LNX.4.64.1009111251470.22177@hs20-bc2-1.build.redhat.com>
	<20100911201758.GB31324@redhat.com>
	<Pine.LNX.4.64.1009131424020.14720@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1009131424020.14720@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

On Mon, Sep 13 2010 at  2:55pm -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> But I think the correct solution would be to take the other patches 
> (except the first essential one to make it compile & work) from Tejun's 
> tree and put them to Alasdair's tree, so that it undergoes some review 
> from us. I think there are some things that need consideration.

If you could enumerate these things that'd be helpful.

The current plan, based on discussion from today's lvm call, is to
continue with the existing patches that are now staged in Jens' block
tree.  If flaw(s) are found with some aspect of the current patches
we'll obviously work to fix them.

Thanks,
Mike

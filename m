From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] dm transaction manager: handle space map
	checker failure
Date: Wed, 20 Jun 2012 17:37:56 -0400
Message-ID: <20120620213756.GL22599@redhat.com>
References: <1340220299-17771-1-git-send-email-snitzer@redhat.com>
	<20120620212010.GK22599@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20120620212010.GK22599@redhat.com>
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
Cc: dm-devel@redhat.com, ejt@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

On Wed, Jun 20, 2012 at 05:20:10PM -0400, Vivek Goyal wrote:
> On Wed, Jun 20, 2012 at 03:24:59PM -0400, Mike Snitzer wrote:
> > If CONFIG_DM_DEBUG_SPACE_MAPS is enabled and dm_sm_checker_create()
> > fails, dm_tm_create_internal() would still return success even though it
> > cleaned up all resources it was supposed to have created.
> > 
> > Fix the space map checker code to return an appropriate ERR_PTR and have
> > dm_tm_create_internal() check for it with IS_ERR.
> > 
> 
> I tested the patch and it works. It fails gracefully instead of segfaulting.
> 
> device-mapper: reload ioctl failed: Cannot allocate memory
> 
> I still do get waring though about large memory allocation. That's a
> separate issue though.

I put a trace_printk() in ca_create() to see how much memory we are trying
to allocated using kzalloc. And answer is 10485760. Number of blocks
obtained from space map is 2621440. I think this might be happening because 
my metadata device size is 10G.

Thanks
Vivek

From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/4] dm: remove nr_iovecs parameter from
	alloc_tio()
Date: Fri, 3 Oct 2014 16:01:30 -0400
Message-ID: <20141003200129.GA13982@redhat.com>
References: <542E8CF9.6000609@ce.jp.nec.com> <542E8EA4.2010704@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <542E8EA4.2010704@ce.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Junichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Jens Axboe <axboe@kernel.dk>, device-mapper development <dm-devel@redhat.com>, Kent Overstreet <kmo@daterainc.com>
List-Id: dm-devel.ids

On Fri, Oct 03 2014 at  7:55am -0400,
Junichi Nomura <j-nomura@ce.jp.nec.com> wrote:

> alloc_tio() allocates a bio for clone. It takes the number of
> bvecs to allocate for the clone-bio.
> However, with the introduction of bio_clone_fast() in v3.14,
> we no longer need to allocate bvecs and nr_iovecs is always 0.
> 
> __clone_and_map_simple_bio() looks like passing non-zero
> nr_iovecs, but its value is always within the range of
> inline bvecs and no allocation actually happens.
> If allocation happened, BUG_ON() in __bio_clone_fast() would
> trigger.
> 
> This patch removes the nr_iovecs parameter from alloc_tio()
> to prevent possible future mis-use of the interface.
> 
> Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

I picked this patch up and staged in linux-dm.git's for-next, see:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=8d59090cdc0ea91ffc390f78d0406baf8f66ae38

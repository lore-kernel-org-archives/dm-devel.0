From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 0/4] dm: reduce memory overhead of DM devices
Date: Fri, 3 Oct 2014 09:23:29 -0400
Message-ID: <20141003132328.GB11977@redhat.com>
References: <542E8CF9.6000609@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <542E8CF9.6000609@ce.jp.nec.com>
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

On Fri, Oct 03 2014 at  7:48am -0400,
Junichi Nomura <j-nomura@ce.jp.nec.com> wrote:

> This series of patches reduce the memory overhead of device-mapper
> device mainly by removing unused mempool for bio vecs.
> 
> DM creates per-device bioset to ensure forward progress under
> low memory situation and bioset always includes mempool for bvec.
> 
> However, with the introduction of immutable bvec by Kent Overstreet,
> dm core now uses bio_clone_fast for creating a clone bio, and no longer
> needs bvecs for it.
> 
> For example, when you create 10,000 bio-based DM devices and 1,000
> request-based DM devices, memory usage of biovec under no load is:
>   # grep biovec /proc/slabinfo
>   biovec-256        418068 418068   4096  ...
>   biovec-128             0      0   2048  ...
>   biovec-64              0      0   1024  ...
>   biovec-16              0      0    256  ...
> 
> With this patch series applied, the usage becomes:
>   # grep biovec /proc/slabinfo
>   biovec-256           116    116   4096  ...
>   biovec-128             0      0   2048  ...
>   biovec-64              0      0   1024  ...
>   biovec-16              0      0    256  ...
> 
> So 4096 * (418068 - 116) = 1.6GB of memory is saved in this example.

Very nice Junichi!

Kent definitely left us some low hanging fruit that offers a huge win
(and fixes the really long-standing problem of excessive memory reserves
for each request-based DM device!)

Jens, this is obviously an awkward patchset given it touches both block
and DM (block more so than DM).  I'd be fine with you pulling it into
block (or vice-versa if you're OK with me staging it for 3.18 via
linux-dm.git with your Acked-by).

Either way, this is all to say, once my feedback to patch 3 is taken
into account, for the set:

Acked-by: Mike Snitzer <snitzer@redhat.com>

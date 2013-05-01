From: Bharata B Rao <bharata.rao@gmail.com>
Subject: Re: [PATCH] dm mpath: enable WRITE SAME support
Date: Wed, 1 May 2013 19:52:55 +0530
Message-ID: <CAGZKiBqOa4DhySe1SjGoU+Ae2Xnk1LSJED0R1_doWk_MVxR88A@mail.gmail.com>
References: <CAGZKiBq0igXmm-8vX++VD6P6HyHM=RS8L=_=SGOQOQ7prhyGBg@mail.gmail.com>
	<20130430163214.GA22690@redhat.com>
	<CAGZKiBrQmLGcUYKKBbyHSRsTSr28V=ap+OE1YuSDVcJnRb4Dqg@mail.gmail.com>
	<20130501132922.GA10432@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20130501132922.GA10432@redhat.com>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, May 1, 2013 at 6:59 PM, Mike Snitzer <snitzer@redhat.com> wrote:
>
> The multipath target did not opt-in to supporting WRITE SAME.  Please
> try this patch.
>
> From: Mike Snitzer <snitzer@redhat.com>
> Subject: [PATCH] dm mpath: enable WRITE SAME support
>
> There is no reason to disallow WRITE SAME support.  As far as multipath
> is concerned it is just another write request.
>
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---
>  drivers/md/dm-mpath.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> index 51bb816..bdf26f5 100644
> --- a/drivers/md/dm-mpath.c
> +++ b/drivers/md/dm-mpath.c
> @@ -907,6 +907,7 @@ static int multipath_ctr(struct dm_target *ti, unsigned int argc,
>
>         ti->num_flush_bios = 1;
>         ti->num_discard_bios = 1;
> +       ti->num_write_same_bios = 1;

With this patch, I can see the LV that is on multipath device,
advertising the WRITE SAME support and I am able to successfully issue
BLKZEROOUT ioctl to that LV.

Regards,
Bharata.

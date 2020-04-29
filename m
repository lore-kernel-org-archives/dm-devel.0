From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm ebs: fix bio->bi_status assignment
Date: Wed, 29 Apr 2020 19:04:22 -0400
Message-ID: <20200429230422.GA24904@redhat.com>
References: <dff475cd16489080bb229af9bb45c0d67480b8be.1588172814.git.heinzm@redhat.com>
	<20200429152253.GA22958@redhat.com>
	<cf22a122-13cf-2692-0e35-cce2fac007fa@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <cf22a122-13cf-2692-0e35-cce2fac007fa@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Heinz Mauelshagen <heinzm@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Apr 29 2020 at  3:40pm -0400,
Heinz Mauelshagen <heinzm@redhat.com> wrote:

> On 4/29/20 5:22 PM, Mike Snitzer wrote:
> >On Wed, Apr 29 2020 at 11:07am -0400,
> >heinzm@redhat.com <heinzm@redhat.com> wrote:
> >
> >>From: Heinz Mauelshagen <heinzm@redhat.com>
> >>
> >>Assign blk_status_t to bi_status properly in __ebs_process_bios()
> >>on error (flaw found by static checker).
> >>
> >>Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> >>Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
> >>---
> >>  drivers/md/dm-ebs-target.c | 3 ++-
> >>  1 file changed, 2 insertions(+), 1 deletion(-)
> >>
> >>diff --git a/drivers/md/dm-ebs-target.c b/drivers/md/dm-ebs-target.c
> >>index 97703c31771f..c9c66d6b1e56 100644
> >>--- a/drivers/md/dm-ebs-target.c
> >>+++ b/drivers/md/dm-ebs-target.c
> >>@@ -210,7 +210,8 @@ static void __ebs_process_bios(struct work_struct *ws)
> >>  			r = __ebs_discard_bio(ec, bio);
> >>  		}
> >>-		bio->bi_status = r;
> >>+		if (r < 0)
> >>+			bio->bi_status = BLK_STS_IOERR;
> >>  	}
> >>  	/*
> >>-- 
> >>2.25.4
> >>
> >Proper way is to use errno_to_blk_status().  I've folded in:
> >
> >-		bio->bi_status = r;
> >+		if (r < 0)
> >+			bio->bi_status = errno_to_blk_status(r);
> 
> 
> Also, using errno_to_blk_status() doesn't need the conditional so
> you may mind to remove it.

Rather avoid the jump implied by the call (figures another place where
there is a conditional call to errno_to_blk_status is
dm-bufio.c:use_dmio).

Anyway, doesn't much matter either way, just going to leave it as
staged.

Thanks,
Mike

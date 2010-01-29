From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] drivers/md: remove unnecessary casts of void *
Date: Fri, 29 Jan 2010 17:19:48 +1100
Message-ID: <20100129171948.7b4a4bcd@notabene>
References: <201001081542.35552.hartleys@visionengravers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201001081542.35552.hartleys@visionengravers.com>
Sender: linux-raid-owner@vger.kernel.org
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, 8 Jan 2010 15:42:35 -0700
H Hartley Sweeten <hartleys@visionengravers.com> wrote:

> drivers/md: Remove unnecessary casts of void *
> 
> void pointers do not need to be cast to other pointer types.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Neil Brown <neilb@suse.de>
> 

Thanks. 
I have taken the non-dm parts of this into my (md) tree.
I'll leave the dm bits for the dm developers.

NeilBrown


> ---
> 
>  drivers/md/bitmap.c         |    8 ++++----
>  drivers/md/dm-crypt.c       |    4 ++--
>  drivers/md/dm-io.c          |    8 ++++----
>  drivers/md/dm-kcopyd.c      |    4 ++--
>  drivers/md/dm-linear.c      |    6 +++---
>  drivers/md/dm-log.c         |   24 ++++++++++++------------
>  drivers/md/dm-mpath.c       |   12 ++++++------
>  drivers/md/dm-raid1.c       |   10 +++++-----
>  drivers/md/dm-round-robin.c |   10 +++++-----
>  drivers/md/dm-stripe.c      |    6 +++---
>  drivers/md/dm.c             |    2 +-
>  drivers/md/faulty.c         |    6 +++---
>  drivers/md/multipath.c      |    2 +-
>  drivers/md/raid1.c          |    8 ++++----
>  drivers/md/raid10.c         |   10 +++++-----
>  drivers/md/raid5.c          |   10 +++++-----
>  16 files changed, 65 insertions(+), 65 deletions(-)

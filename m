From: Song Liu <song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 4/4] writeback: remove bdi->congested_fn
Date: Wed, 1 Jul 2020 22:36:13 -0700
Message-ID: <CAPhsuW7QShNMnbCK-OrKkE8F5XyH45-ML-w5qKLVrO=VTt6npw@mail.gmail.com>
References: <20200701090622.3354860-1-hch@lst.de> <20200701090622.3354860-5-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200701090622.3354860-5-hch-jcswGhMUV9g@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid <linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: dm-devel.ids

On Wed, Jul 1, 2020 at 2:06 AM Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> wrote:
>
> Except for pktdvd, the only places setting congested bits are file
> systems that allocate their own backing_dev_info structures.  And
> pktdvd is a deprecated driver that isn't useful in stack setup
> either.  So remove the dead congested_fn stacking infrastructure.
>
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

For md bits:

Acked-by: Song Liu <song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

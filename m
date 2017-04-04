From: Brian Norris <briannorris@chromium.org>
Subject: Re: dm: move dm_table_destroy() to same header as dm_table_create()
Date: Tue, 4 Apr 2017 15:35:54 -0700
Message-ID: <20170404223552.GA121849@google.com>
References: <20170328183102.80620-1-briannorris@chromium.org>
 <20170328193150.GA21445@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170328193150.GA21445@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, Enric Balletbo i Serra <enric.balletbo@collabora.com>
List-Id: dm-devel.ids

On Tue, Mar 28, 2017 at 03:31:51PM -0400, Mike Snitzer wrote:
> On Tue, Mar 28 2017 at  2:31pm -0400,
> Brian Norris <briannorris@chromium.org> wrote:
> 
> > If anyone is going to use dm_table_create(), they probably should be
> > able to use dm_table_destroy() too. Move the dm_table_destroy()
> > definition outside the private header, near dm_table_create()
> > 
> > Signed-off-by: Brian Norris <briannorris@chromium.org>
> 
> Not seeing why we need dm_table_create() exposed.  So I think you went
> the wrong way with this.  Unless you have an actual need, I'd prefer to
> see dm_table_create() moved from include/linux/device-mapper.h to
> drivers/md/dm.h

We've been carrying code in our ChromeOS kernel to parse a cmdline arg
for setting up early DM maps -- e.g., a dm-verity rootfs without using
an initramfs. We currently use dm_table_create() from init/*.c (and we
*should* be using dm_table_destroy() in the error paths). So I'm
certainly not going to send the patch to do the reverse :)

Enric is working on cleaning up this work to send here, so if you don't
want to see this patch now, you may well see it later.

Brian

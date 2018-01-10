From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [for-4.16 PATCH v2 1/3] block: only bdi_unregister() in
 del_gendisk() if !GENHD_FL_HIDDEN
Date: Tue, 9 Jan 2018 23:35:24 -0500
Message-ID: <20180110043523.GA20686@redhat.com>
References: <20180110024104.34885-1-snitzer@redhat.com>
 <20180110024104.34885-2-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180110024104.34885-2-snitzer@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: Bart.VanAssche@wdc.com, linux-block@vger.kernel.org, dm-devel@redhat.com, hch@lst.de
List-Id: dm-devel.ids

On Tue, Jan 09 2018 at  9:41pm -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> device_add_disk() will only call bdi_register_owner() if
> !GENHD_FL_HIDDEN so it follows that bdi_unregister() should be avoided
> for !GENHD_FL_HIDDEN in del_gendisk().

This  ^ should be "GENHD_FL_HIDDEN".

Sorry for the cut-n-paste typo.

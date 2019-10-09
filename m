From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] compat_ioctl: fix reimplemented SG_IO handling causing
 -EINVAL from sg_io()
Date: Wed, 9 Oct 2019 18:01:29 +0200
Message-ID: <CAK8P3a1HBog84Wvdgm1ccz1gRJRxHm8ucsxwUTTqh02gOt9WbQ@mail.gmail.com>
References: <20190918153445.1241-1-maier@linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190918153445.1241-1-maier@linux.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Steffen Maier <maier@linux.ibm.com>
Cc: "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Doug Gilbert <dgilbert@interlog.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-s390 <linux-s390@vger.kernel.org>, Benjamin Block <bblock@linux.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>, Thomas Gleixner <tglx@linutronix.de>, Mauro Carvalho Chehab <mchehab+samsung@kernel.org>, Omar Sandoval <osandov@fb.com>, linux-block <linux-block@vger.kernel.org>, Linux-Next
List-Id: dm-devel.ids

On Wed, Sep 18, 2019 at 5:35 PM Steffen Maier <maier@linux.ibm.com> wrote:
>
> scsi_cmd_ioctl() had hdr as on stack auto variable and called
> copy_{from,to}_user with the address operator &hdr and sizeof(hdr).
>
> After the refactoring, {get,put}_sg_io_hdr() takes a pointer &hdr.
> So the copy_{from,to}_user within the new helper functions should
> just take the given pointer argument hdr and sizeof(*hdr).
>
> I saw -EINVAL from sg_io() done by /usr/lib/udev/scsi_id which could
> in turn no longer whitelist SCSI disks for devicemapper multipath.
>
> Signed-off-by: Steffen Maier <maier@linux.ibm.com>
> Fixes: 4f45155c29fd ("compat_ioctl: reimplement SG_IO handling")
> ---
>
> Arnd, I'm not sure about the sizeof(hdr32) change in the compat part in
> put_sg_io_hdr().
>
> This is for next, probably via Arnd's y2038/y2038,
> and it fixes next-20190917 for me regarding SCSI generic.

Hi Steffen,

Sorry for the long delay. I ended up not sending my pull request for
v5.4, so the bug is not there. I have now rebased my branch
on top of v5.4-rc2 and plan to send it for the v5.5 merge window.

I have folded your bugfix into my original patch, hope that's ok with
you. Tomorrow's linux-next should be fixed.

    Arnd

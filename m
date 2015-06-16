From: Minfei Huang <mnfhuang@gmail.com>
Subject: Re: Newbie device mapper questions
Date: Tue, 16 Jun 2015 09:18:09 +0800
Message-ID: <20150616011809.GA3277@huangminfeis-MacBook-Pro.local>
References: <557F1BFA.2080504@gmx.de>
	<CAFx4rwQ0ganzZn5FjQZTVtk1DK1Qr1pmMCTxRCwxd793+-anHg@mail.gmail.com>
	<20150615222018.GA29625@redhat.com>
	<CAKoi8FLeqGON2EyHeie8MTgi_Cz0hdRJyid09gq1KudNRaM3Vg@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAKoi8FLeqGON2EyHeie8MTgi_Cz0hdRJyid09gq1KudNRaM3Vg@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dfnsonfsduifb@gmx.de
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 06/16/15 at 08:55P, Minfei Huang wrote:
> On Tue, Jun 16, 2015 at 6:20 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Mon, Jun 15, 2015 at 12:52:57PM -0700, Doug Dumitru wrote:
> >> >
> >> > - Is i_size_read(lc->src1dev->bdev->bd_inode) the correct way of
> >> > determining the size of the underlying block device? If not, which
> >> > function is?
> >> >
> >
> > I believe that's correct. Look at block/blk-core.c
> >
> > handle_bad_sector(struct bio *bio)
> > {
> > }
> >
> 
> Kernel will call i_size_write to assign the device capacity, when the
> device try to be registered(register_disk). During the period of
> register, the function blkdev_get will call bd_set_size to set the
> capacity.
> 
> So it is correct that you can call i_size_read to determine the device's
> capacity.
> 
> >>
> >> ... I am happy to leave out answers that I don't know ...
> >>
> >>
> >> >
> >> > - Can I safely assume the logical sector size is fixed to be 512 bytes
> >> > in all cases?
> >> >
> >>
> >> Probably not, but maybe.  You are in control of the hardware.
> >
> > You mean block size or sector size? I think sector sizes can vary and
> > targets can allow user space to specify one. Typically metadata is per
> > block can lead to smaller metadata foot print.
> >
> 
> For now, the minimum align unit is 512 bytes. But as I know, a lot of
> devices start to support 4KB align unit.

Correct it.

Although the device supports the physical sector to extend to 4KB, the
device will divide physical sector into 8 pieces (one pieces is 512
bytes, call logical sector).

$ sudo hdparm -I /dev/sda | egrep -i "physical|logical|device size with M"
Logical		max	current
Logical  Sector size:                   512 bytes
Physical Sector size:                  4096 bytes
Logical Sector-0 offset:                  0 bytes
device size with M = 1024*1024:      953869 MBytes
device size with M = 1000*1000:     1000204 MBytes (1000 GB)

So I think you can use logical sector(512 bytes) to align the start
position and count.

Thanks
Minfei

> 
> Please correct me if there is something wrong in the comment.
> 
> Thanks
> Minfei

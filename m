From: "James Johnston" <johnstonj.public@codenest.com>
Subject: RE: bcache gets stuck flushing writeback cache when used in combination with LUKS/dm-crypt and non-default bucket size
Date: Fri, 20 May 2016 06:59:32 -0000
Message-ID: <02b101d1b265$2bc46fb0$834d4f10$@codenest.com>
References: <044401d1a958$ea7ef4e0$bf7cdea0$@codenest.com> <5739F07A.5090608@buttersideup.com> <alpine.LRH.2.11.1605191618560.22436@mx.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.11.1605191618560.22436@mx.ewheeler.net>
Content-Language: en-us
Sender: linux-bcache-owner@vger.kernel.org
To: 'Eric Wheeler' <bcache@lists.ewheeler.net>, 'Tim Small' <tim@buttersideup.com>
Cc: 'Kent Overstreet' <kent.overstreet@gmail.com>, 'Alasdair Kergon' <agk@redhat.com>, 'Mike Snitzer' <snitzer@redhat.com>, linux-bcache@vger.kernel.org, dm-devel@redhat.com, dm-crypt@saout.de
List-Id: dm-devel.ids

> On Mon, 16 May 2016, Tim Small wrote:
> 
> > On 08/05/16 19:39, James Johnston wrote:
> > > I've run into a problem where the bcache writeback cache can't be flushed to
> > > disk when the backing device is a LUKS / dm-crypt device and the cache set has
> > > a non-default bucket size.  Basically, only a few megabytes will be flushed to
> > > disk, and then it gets stuck.  Stuck means that the bcache writeback task
> > > thrashes the disk by constantly reading hundreds of MB/second from the cache set
> > > in an infinite loop, while not actually progressing (dirty_data never decreases
> > > beyond a certain point).
> >
> > > [...]
> >
> > > The situation is basically unrecoverable as far as I can tell: if you attempt
> > > to detach the cache set then the cache set disk gets thrashed extra-hard
> > > forever, and it's impossible to actually get the cache set detached.  The only
> > > solution seems to be to back up the data and destroy the volume...
> >
> > You can boot an older kernel to flush the device without destroying it
> > (I'm guessing that's because older kernels split down the big requests
> > which are failing on the 4.4 kernel).  Once flushed you could put the
> > cache into writethrough mode, or use a smaller bucket size.
> 
> Indeed, can someone test 4.1.y and see if the problem persists with a 2M
> bucket size?  (If someone has already tested 4.1, then appologies as I've
> not yet seen that report.)
> 
> If 4.1 works, then I think a bisect is in order.  Such a bisect would at
> least highlight the problem and might indicate a (hopefully trivial) fix.

To help narrow this down, I tested the following generic pre-compiled mainline kernels
on Ubuntu 15.10:

 * WORKS:  http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.3.6-wily/
 * DOES NOT WORK:  http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.4-rc1+cod1-wily/

I also tried the default & latest distribution-provided 4.2 kernel.  It worked.
This one also worked:

 * WORKS:  http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.2.8-wily/

So it seems to me that it is a regression from 4.3.6 kernel to any 4.4 kernel.  That
should help save time with bisection...

James

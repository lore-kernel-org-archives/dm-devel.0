From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Re: Device mapper support for more than one target ?
Date: Mon, 22 Dec 2008 21:24:33 +0000
Message-ID: <20081222212433.GA17247@agk.fab.redhat.com>
References: <37d33d830812220922l5a0bc36et5dd1f9853f9cd33@mail.gmail.com>
	<20081222185033.GA17119@agk.fab.redhat.com>
	<37d33d830812221054w78fe49f3l6c2896a27c908656@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <37d33d830812221054w78fe49f3l6c2896a27c908656@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Sandeep K Sinha <sandeepksinha@gmail.com>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Tue, Dec 23, 2008 at 12:24:49AM +0530, Sandeep K Sinha wrote:
> On Tue, Dec 23, 2008 at 12:20 AM, Alasdair G Kergon <agk@redhat.com> wrote:
> > On Mon, Dec 22, 2008 at 10:52:08PM +0530, Sandeep K Sinha wrote:
> > Because whether or not it makes sense to send any specific ioctl to more
> > than one target in parallel depends on what that ioctl does.  When we
> > added that code we said that we could add hard-coding for specific
> > ioctls if the need arose, but so far it hasn't.
> No, the philosophy should be that we send the ioctl's to the mapped
> device and not to the targets underlying that mapped-device.

That's not what the current implementation was for, viz. passing scsi
ioctls through dm multipath devices.

> And doing so, I should be able to access the complete map that belongs
> to that mapped device. If I implement an ioctl of my own and try to
> serve it, the problem would be that it would never allow me to serve
> it if has more than one target.

As I said above, if the need arises we can have a whitelist mechanism
for ioctls to be handled differently, but the only safe default
behaviour is the one that has been implemented.

Alasdair
-- 
agk@redhat.com

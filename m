From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] Uevent cookie env var support
Date: Wed, 8 Apr 2009 14:20:56 +0100
Message-ID: <20090408132056.GS5688@agk.fab.redhat.com>
References: <49DC92CC.30708@redhat.com>
	<ac3eb2510904080549l50353d85xf1c4af8a31eb7613@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <ac3eb2510904080549l50353d85xf1c4af8a31eb7613@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, Apr 08, 2009 at 05:49:11AM -0700, Kay Sievers wrote:
> I always thought we would return the driver core generated seqnum with
> the ioctl, 

When Peter tried to make that work it needed more and more hacks
piled onto it and instead he came up with this cookie method which seems
to satisfy all our requirements with a minimum amount of change, fingers
crossed.

E.g. A problem with the other approach was: lvm2 userspace doesn't know the
seqnum till after the uevent has fired and udev could complete processing
before the lvm2 code has set itself up to wait for that seqnum so you have to
build extra interlocking into the process making it much more complex.  If you
wait for all events up to a given number you could get stuck behind some
unrelated event on an unresponsive device, with is also unsatisfactory.

Alasdair
-- 
agk@redhat.com

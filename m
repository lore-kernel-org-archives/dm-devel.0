From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: How to use dm-cache-target?
Date: Tue, 12 Mar 2013 09:56:15 -0700
Message-ID: <20130312165615.GC6528@blackbox.djwong.org>
References: <513D4137.5090503@gmail.com> <20130311103152.GA5038@raspberrypi>
	<20130311170417.GB6528@blackbox.djwong.org>
	<20130312132755.GB6000@raspberrypi>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20130312132755.GB6000@raspberrypi>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

On Tue, Mar 12, 2013 at 01:27:56PM +0000, thornber@redhat.com wrote:
> On Mon, Mar 11, 2013 at 10:04:17AM -0700, Darrick J. Wong wrote:
> > On Mon, Mar 11, 2013 at 10:31:53AM +0000, thornber@redhat.com wrote:
> > I suspect the poster's asking if dmcaches will automatically reassemble
> > themselves.
> > 
> > I've been wondering myself what's the status of the lvm-tools integration? :)
> 
> LVM changes at a glacial pace.  Would it be helpful if I knocked up
> some tools to make it easier for people to play with this stuff?

Well, we could possibly compare notes; here are some scripts that I've been
using:
http://djwong.org/docs/dmcache-tools.tar.gz

dm-format-blockdev and dm-load-cache are the key ones.  It also comes with udev
rules to (I hope) make the cache win any /dev symlink wars, and automount the
cache when all component devices are found.  They work for me, but beware they
might reflash your BIOS with rude poetry also. :)

--D
> 
> - Joe
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

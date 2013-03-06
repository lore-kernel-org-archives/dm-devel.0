From: thornber@redhat.com
Subject: Re: dm-thin discard issue
Date: Wed, 6 Mar 2013 14:26:22 +0000
Message-ID: <20130306142621.GA4852@raspberrypi>
References: <1801783.47.1362573815861.JavaMail.javamailuser@localhost>
	<23057571.57.1362575554699.JavaMail.javamailuser@localhost>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <23057571.57.1362575554699.JavaMail.javamailuser@localhost>
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

On Wed, Mar 06, 2013 at 08:12:39AM -0500, Jim Minter wrote:
> Hello,
> 
> I think I've uncovered a problem when issuing the BLKDISCARD ioctl to a thin volume.  If I create a thin volume, fill it with data, snapshot it, then call BLKDISCARD on the thin volume, it looks like the kernel doesn't take into account the fact that the underlying blocks are shared with the snapshot, and just goes ahead and discards them.  This appears to then leave the metadata in an inconsistent state.
> 
> Here's a reproducer (works on rawhide as of today, 3.9.0-0.rc1.git0.1.fc19.x86_64):
> (assumes volumes 253:2 for metadata and 253:3 for pool; uses blkdiscard from upstream util-linux to issue the BLKDISCARD ioctl)

Alarming, to say the least.  Give me a couple of hours to look at this ...

- Joe

From: Joe Thornber <thornber@redhat.com>
Subject: Re: [RFC] dm-thin: Random block placement strategy?
Date: Fri, 20 Jul 2012 09:50:59 +0000
Message-ID: <20120720095058.GA1990@raspberrypi>
References: <ju9vdv$vpa$1@dough.gmane.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <ju9vdv$vpa$1@dough.gmane.org>
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
Cc: dm-crypt@saout.de
List-Id: dm-devel.ids

On Thu, Jul 19, 2012 at 02:49:51PM -0700, Alex Elsayed wrote:
> This may be insufficiently useful to justify implementing, but I thought it 
> was an interesting concept.
> 
> One of the current issues with dm-crypt and discard is that enabling it can 
> leak information about the filesystem and usage patterns of the disk[1].
> 
> If a dm-thin device with a random block placement strategy is layered on top 
> of dm-crypt however, this could solve some of the issues involved and 
> partially mitigate others.
> 
> Such a random block placement strategy would heavily disguise any layout 
> patterns that could be used to identify the filesystem, most likely to the 
> point of being completely unrecognizable.

A couple of things spring to mind.

- If you're using a spindle device this will destroy performance,
  unless you use large block size (which I suspect you don't want
  to do because you're trying to disguise access patterns).

- How expensive will acquiring a cryptographically secure random
  destination be?

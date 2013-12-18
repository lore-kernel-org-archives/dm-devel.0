From: Hannes Reinecke <hare@suse.de>
Subject: Re: change tracking with block-level granularity using md
Date: Wed, 18 Dec 2013 09:35:45 +0100
Message-ID: <52B15E61.4090807@suse.de>
References: <CABhLV00aksW6BzyNswVeytfUQ+q_7PWag1njYs-E=acqqbXoVA@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CABhLV00aksW6BzyNswVeytfUQ+q_7PWag1njYs-E=acqqbXoVA@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Thomas Knauth <thomas.knauth@gmx.de>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 12/18/2013 09:04 AM, Thomas Knauth wrote:
> Hello list,
> =

> I am the author of the following paper
> =

> https://www.usenix.org/conference/lisa13/technical-sessions/papers/knauth
> =

> just presented at LISA 2013. Folks at the conference expressed
> interested in seeing this merged into the official Linux kernel. I
> would like to gauge your opinion of whether this has a chance to
> actually be accepted.
> =

Well, you just implemented an asynchronous mirror with discrete
tools. Congratulations.
Using bitmaps for tracking modified blocks has been a standard
technique in RAID1 for ages.

(look for mdadm --write-behind and drivers/md/bitmap.c. It's not
actually _new_ ...)

Sorry for being sarcastic.

But nevertheless, your tool might actually be useful; tracking block
changes could have some benefit on other areas.

What you should be doing:
- Rename the thing (dm-linear is taken; maybe dm-bitmap ?)
- Use debugfs instead of /proc
- Proper formatting

And then send the code for review.

Or go for the full monty and break up dm-mirror to include your
bitmap code. But then you would need to come up with a way of
storing your bitmap on disk.
Which is where the _real_ fun starts.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)

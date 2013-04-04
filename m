From: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Subject: Re: [PATCH] libmultipath/discovery: read sysfs files
	uncached
Date: Thu, 04 Apr 2013 11:42:28 +0200
Message-ID: <515D4B04.6010203@profitbricks.com>
References: <1364912936-14636-1-git-send-email-sebastian.riemer@profitbricks.com>
	<1364936448.5344.8.camel@lapoo.opensvc.com>
	<515D211B.3080805@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <515D211B.3080805@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: dm-devel <dm-devel@redhat.com>, Kay Sievers <kay.sievers@vrfy.org>, Bart Van Assche <bvanassche@acm.org>
List-Id: dm-devel.ids

On 04.04.2013 08:43, Hannes Reinecke wrote:
> Hmm; this is not the only issue we have with libudev.
> _Setting_ of sysfs attributes is also a problem (I just send a patch
> to Kay for this).
> However, having to duplicate things feels like a waste; I'd rather
> have it implemented at the libudev side.
> 
> The problem with this patch is that we're bypassing the cache of
> libudev; so any _other_ application using libudev would still be
> reading the stale value.
> 
> I'd very much prefer to have a 'uncached' variant (or adding another
> argument 'force') which would force libudev to always read the
> current value but also adding it to the internal cache for the
> benefit of other applications.

Fine for me. I just wanted to point out that there is an issue. In the
long run it also makes most sense to me to improve libudev.

For early adopters this can be a workaround as libraries aren't that
easy to replace if they come from a binary distribution. The libudev is
part of systemd by now. So back-porting fixes to an older variant of
libudev from a distribution without systemd can be difficult. We already
work like a distribution but we don't want to maintain a git repo for
that stuff as well if we already need to maintain a git repo for the
multipath-tools.
For me as a kind of user in this case the mistake was to use a library
function which doesn't do the expected instead of implementing
differently and reporting the requirement to the library for future use.
If it's in the library, then the workaround can be removed.

Cheers,
Sebastian

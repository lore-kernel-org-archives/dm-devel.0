From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH] [dm-cache] Make the mq policy an alias for
	smq
Date: Thu, 11 Feb 2016 10:10:02 +0000
Message-ID: <20160211101001.GA4908@rh-vpn>
References: <1455100523-16922-1-git-send-email-ejt@redhat.com>
	<22203.28152.788363.168128@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <22203.28152.788363.168128@quad.stoffel.home>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: John Stoffel <john@stoffel.org>
Cc: Joe Thornber <ejt@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Feb 10, 2016 at 12:06:00PM -0500, John Stoffel wrote:
> 
> Can you add in some documentation on how you tell which dm_cache
> policy is actually being used, and how to measure it, etc?  It's a
> black box and some info would be nice.

You can get some stats on the cache performance via the status ioctl
(eg, dmsetup status ...).  This will tell you about
promotions/demotion to the cache, write hits, read hits etc.

There is documentation on cache policies in Documentation/device-mapper/cache-policies.txt

https://github.com/jthornber/linux-2.6/blob/2016-02-10-thin-dev-on-4.4/Documentation/device-mapper/cache-policies.txt

As for knowing which policy is running; I'm not sure what to say.
It'll be the one you ask for.  If the above patch goes in, then
there'll be a kernel version where mq becomes the same as smq.  I'll
bump the policy version number to make it clear that mq has undergone
a big change.

- Joe

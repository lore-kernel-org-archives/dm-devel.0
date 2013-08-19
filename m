From: Frank Mayhar <fmayhar@google.com>
Subject: Re: [dm-devel] dm: Make MIN_IOS, et al, tunable via sysctl.
Date: Mon, 19 Aug 2013 10:54:05 -0700
Message-ID: <1376934845.24869.43.camel@bobble.lax.corp.google.com>
References: <1376070533.26057.244.camel@bobble.lax.corp.google.com>
	 <20130819140016.GB27167@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130819140016.GB27167@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Mon, 2013-08-19 at 10:00 -0400, Mike Snitzer wrote:
> Performance isn't the concern.  The concern is: does DM allow for
> forward progress if the system's memory is completely exhausted?
> 
> This is why request-based has such an extensive reserve, because it
> needs to account for cloning the largest possible request that comes in
> (with multiple bios).

Thanks for the response.  In our particular case, I/O will be file
system based and over a network, which makes it pretty easy for us to be
sure that large I/Os never happen.  That notwithstanding, however, as
you said it just seems reasonable to make these values configurable.

I'm also looking at making some similar constants in dm-verity and
dm-bufio configurable in the same way and for similar reasons.
-- 
Frank Mayhar
310-460-4042

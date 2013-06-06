From: Jonathan McDowell <noodles@earth.li>
Subject: Re: [PATCH] updated dm-switch
Date: Thu, 6 Jun 2013 15:45:18 -0700
Message-ID: <20130606224518.GU19749@earth.li>
References: <Pine.LNX.4.64.1305221709160.22686@file.rdu.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1305221709160.22686@file.rdu.redhat.com>
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
Cc: Mikulas Patocka <mpatocka@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Wed, May 22, 2013 at 05:14:18PM -0400, Mikulas Patocka wrote:

> This is updated dm-switch. It has better documentation and better error
> reporting in message function.
...
> ---
> 
> From: Jim Ramsay <jim_ramsay@dell.com>
> 
> dm-switch is a new target that maps IO to underlying block devices
> efficiently when there are a large number of fixed-sized address regions
> but there is no simple pattern to allow for a compact mapping
> representation such as dm-stripe.

Interesting. I have been working on something similar recently, for not
dissimilar reasons. However the approach I had been taking was to extend
__choose_pgpath to take a pos parameter indicating the block being
requested, and then add a new dm-pref-hint multipath driver, which
effectively does a round-robin but prefers any path that has the "pref"
bit. Currently the dm-pref-hint driver is extremely hacky and reaches
down into the scsi_device to do an appropriate CDB along each path to
get the pref-map, or I'd post it for comments.

I'm interested in why the decision was made to have dm-switch as a separate
device-mapper layer? Are there a corresponding set of patches to
multipath-tools which know how to do the setup of each individual path?

J.

-- 
Is this real - that's the first thing I think every morning.
This .sig brought to you by the letter N and the number 24
Product of the Republic of HuggieTag

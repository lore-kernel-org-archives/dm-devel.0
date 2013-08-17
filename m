From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH] dm: Make MIN_IOS, et al, tunable via sysctl.
Date: Sat, 17 Aug 2013 13:30:39 +0100
Message-ID: <20130817123039.GR1762@agk-dp.fab.redhat.com>
References: <1376070533.26057.244.camel@bobble.lax.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1376070533.26057.244.camel@bobble.lax.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Frank Mayhar <fmayhar@google.com>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Aug 16, 2013 at 03:55:21PM -0700, Frank Mayhar wrote:
> This patch fixes that by changing the hardcoded MIN_IOS (and certain
> other) #defines in dm-crypt, dm-io, dm-mpath, dm-snap and dm itself to
> sysctl-modifiable values.  This lets us change the size of these pools
> on the fly, we can reduce the size of the pools and reduce memory
> pressure.
 
Did you consider using module_param_named()?
(E.g. dm_verity_prefetch_cluster in dm-verity.)

Alasdair

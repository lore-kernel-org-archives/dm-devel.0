From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 8/8] [dm-cache] cache target
Date: Tue, 12 Feb 2013 16:40:40 +0000
Message-ID: <20130212164040.GI3228@agk-dp.fab.redhat.com>
References: <1355429956-22785-1-git-send-email-ejt@redhat.com>
	<1355429956-22785-9-git-send-email-ejt@redhat.com>
	<20130212152733.GH12499@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20130212152733.GH12499@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Joe Thornber <ejt@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Feb 12, 2013 at 03:27:33PM +0000, Alasdair G Kergon wrote:
> updated code taken from the all-caches branch of 
> git://github.com/jthornber/linux-2.6
 
File: dm-cache-policy.c

> #include "dm.h"

> #include <linux/list.h>
Already pulled in via dm.h

> static struct dm_cache_policy_type *__get_policy(const char *name)
> {
> 	struct dm_cache_policy_type *t = __find_policy(name);
> 
> 	if (!t) {

Could we move this up a level and avoid the inverted unlock/lock
(which only seems to confuse automated lock analysis)?
   __find_policy(); if not found, request_module and __find_policy again ?

> 		spin_unlock(&register_lock);
> 		request_module("dm-cache-%s", name);
> 		spin_lock(&register_lock);
> 		t = __find_policy(name);
> 	}

> int dm_cache_policy_register(struct dm_cache_policy_type *type)
> {
> 	int r;
> 
> 	/* One size fits all for now */
> 	if (type->hint_size != 0 && type->hint_size != 4)

This should never happen unless coding error or corruption => DMWARN?

> 		return -EINVAL;


> void dm_cache_policy_destroy(struct dm_cache_policy *p)
> {
> 	struct dm_cache_policy_type *t = p->private;
> 
> 	put_policy(t);

module_put should be AFTER destroy or the code could get unloaded while destroy
is still running?

[Still to check the ref counting is sufficient: to understand why this is
a bit simpler than dm-path-selector which also handles modules plugging into
modules and went through a few iterations fixing ref problems]

> 	p->destroy(p);
> }

Alasdair

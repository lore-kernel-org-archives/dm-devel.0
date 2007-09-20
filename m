From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: dm-ioctl on amd64 with 32bit userspace
Date: Thu, 20 Sep 2007 16:32:10 +0100
Message-ID: <20070920153210.GP18444@agk.fab.redhat.com>
References: <20070917165726.GA11958@bogon.ms20.nix>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20070917165726.GA11958@bogon.ms20.nix>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Guido Guenther <agx@sigxcpu.org>
Cc: Andrew Morton <akpm@osdl.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Sep 17, 2007 at 06:57:26PM +0200, Guido Guenther wrote:
> -	if (new_name < (char *) (param + 1) ||
> +	if (new_name < (char *) ((void*)(param + 1) - 4) ||

Does this (untested) also work for you?

+	if (new_name < (char *) (align_ptr(param + 1) - 4) ||

I think that's slightly better as it should leave the 32-bit
case unchanged.

One day, we'll fix all this properly by making the structure size in the
interface architecture-independent as it should have been in the first
place...

[http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/dm-ioctl-fix-compat-bounds-test.patch
but wait for it to resync]

Alasdair
-- 
agk@redhat.com

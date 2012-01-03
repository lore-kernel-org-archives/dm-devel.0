From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH] deadlock with suspend and quotas
Date: Tue, 3 Jan 2012 03:30:05 +0000
Message-ID: <20120103033005.GZ23916@ZenIV.linux.org.uk>
References: <Pine.LNX.4.64.1111251522230.4118@hs20-bc2-1.build.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1111251522230.4118@hs20-bc2-1.build.redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Nov 25, 2011 at 03:25:16PM -0500, Mikulas Patocka wrote:

> The following patch fixes the deadlock. When the quota subsystem takes s_umount,
> it checks if the filesystem is frozen. If it is, we drop s_umount, wait for
> the filesystem to resume and retry.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> CC: stable@kernel.org

So basically you want a variant of get_super() that would get you a
superblock for this bdev, locked and unfrozen?  Fair enough, but
	* that should be a proper helper in super.c, rather than
open-coded in fs/quota/quota.c, of all places
	* what about other existing callers get_super() and its friends?

and while we are at it, why in damnation name is it exported?  The only
caller outside of core VFS is under #if 0...

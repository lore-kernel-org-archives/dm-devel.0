From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] deadlock with suspend and quotas
Date: Tue, 3 Jan 2012 13:35:32 -0500 (EST)
Message-ID: <Pine.LNX.4.64.1201031332070.17924@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.1111251522230.4118@hs20-bc2-1.build.redhat.com>
 <20120103033005.GZ23916@ZenIV.linux.org.uk>
 <Pine.LNX.4.64.1201031318590.10105@hs20-bc2-1.build.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.1201031318590.10105@hs20-bc2-1.build.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, dm-devel@redhat.com
List-Id: dm-devel.ids



On Tue, 3 Jan 2012, Mikulas Patocka wrote:

> 
> 
> On Tue, 3 Jan 2012, Al Viro wrote:
> 
> > On Fri, Nov 25, 2011 at 03:25:16PM -0500, Mikulas Patocka wrote:
> > 
> > > The following patch fixes the deadlock. When the quota subsystem takes s_umount,
> > > it checks if the filesystem is frozen. If it is, we drop s_umount, wait for
> > > the filesystem to resume and retry.
> > > 
> > > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > > CC: stable@kernel.org
> > 
> > So basically you want a variant of get_super() that would get you a
> > superblock for this bdev, locked and unfrozen?  Fair enough, but
> > 	* that should be a proper helper in super.c, rather than
> > open-coded in fs/quota/quota.c, of all places
> > 	* what about other existing callers get_super() and its friends?
> 
> Hi
> 
> You can look at that functionality here: I've already made a patch that 
> has it: 
> https://www.redhat.com/archives/dm-devel/2011-November/msg00151.html

Sorry, I accidentally linked to the message you were responding to.

The point is that there are some users of get_super that need to get 
superblock even if it's frozen and other users of get_super that must not 
get a frozen superblock. So I made a bool parameter to distinguish these 
cases. Do you have some other ideas?

Mikulas

> Basically, the patch introduces a function down_read_s_umount, which takes 
> s_umount for read, but makes sure that the filesystem is not frozen. Then, 
> it adds a boolean parameter to get_super() which tells get_super() that it 
> should wait for unfreeze (i.e. call "down_read_s_umount" isntead of 
> "down_read(&sb->s_umount)").
> 
> Mikulas
> 
> > and while we are at it, why in damnation name is it exported?  The only
> > caller outside of core VFS is under #if 0...
> > 
> 

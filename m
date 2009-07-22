From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: How to handle >16TB devices on 32 bit hosts ??
Date: Wed, 22 Jul 2009 11:51:55 -0700
Message-ID: <20090722115155.f99dcf76.akpm@linux-foundation.org>
References: <19041.4714.686158.130252@notabene.brown>
	<20090721235904.42e6cd35.akpm@linux-foundation.org>
	<20090722183244.GO4231@webber.adilger.int>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090722183244.GO4231@webber.adilger.int>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Andreas Dilger <adilger@sun.com>
Cc: linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Wed, 22 Jul 2009 12:32:44 -0600
Andreas Dilger <adilger@sun.com> wrote:

> On Jul 21, 2009  23:59 -0700, Andrew Morton wrote:
> > On Sat, 18 Jul 2009 10:08:10 +1000 Neil Brown <neilb@suse.de> wrote:
> > I expect that the VFS could be made to work with 64-bit pgoff_t fairly
> > easily.  The generated code will be pretty damn sad.
> > 
> > radix-trees use a ulong index, so we would need a new
> > lib/radix_tree64.c or some other means of fixing that up.
> > 
> > The bigger problem is filesystems - they'll each need to be checked,
> > tested, fixed and enabled.  It's probably not too bad for the
> > mainstream filesystems which mostly bounce their operations into VFS
> > libarary functions anyway.
> 
> I don't think this is a primary concern for most filesystems even today.
> Filesystems that work correctly > 16TB on 64-bit platforms should continue
> to work correctly on 32-bit platforms.

Not if they use an unsigned long to hold a pagecache index anywhere.

akpm:/usr/src/25> grep 'unsigned long' fs/*/*.c | wc -l
3465

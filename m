From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 2/7] A framework for holding bios until suspend
Date: Mon, 30 Nov 2009 09:41:13 +0000
Message-ID: <20091130094112.GA22702@agk-dp.fab.redhat.com>
References: <Pine.LNX.4.64.0911180703410.21358@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0911180709570.21358@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0911180710370.21358@hs20-bc2-1.build.redhat.com>
	<4B1165A7.3050303@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4B1165A7.3050303@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Takahiro Yasui <tyasui@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Sat, Nov 28, 2009 at 01:02:15PM -0500, Takahiro Yasui wrote:
> Initializing the hold list in do_mirror() is a problem. Some bios might
> already in it and they will never be processed. This makes device-mapper
> "stuck" when the device goes suspend. The hold list should be inizialized
> only when the mirror device is created in alloc_context().
 
I fixed that as I merged the patch into my tree and didn't even notice the
original patch was wrong!  (I assumed it was a fuzzy patching error at my end.)

http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/dm-raid1-add-framework-to-hold-bios-during-suspend.patch
http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/dm-raid1-explicitly-initialise-bio_lists.patch

Alasdair

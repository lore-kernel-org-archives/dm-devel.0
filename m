From: "Kay Sievers" <kay.sievers@vrfy.org>
Subject: Re: Re: 2.6.24-rc4-mm1
Date: Thu, 6 Dec 2007 23:04:12 +0100
Message-ID: <3ae72650712061404w170fc434nb1172e048216e139@mail.gmail.com>
References: <20071204211701.994dfce6.akpm@linux-foundation.org>
	<3941.1196941764@turing-police.cc.vt.edu>
	<20071206040420.6c89c675.akpm@linux-foundation.org>
	<4374.1196968688@turing-police.cc.vt.edu>
	<20071206193843.GA25125@kroah.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20071206193843.GA25125@kroah.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Dec 6, 2007 8:38 PM, Greg KH <greg@kroah.com> wrote:
> On Thu, Dec 06, 2007 at 02:18:08PM -0500, Valdis.Kletnieks@vt.edu wrote:
> > On Thu, 06 Dec 2007 04:04:20 PST, Andrew Morton said:
> >
> > > > >   ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc4/2.6.24-rc4-mm1/
> > > >
> > > > Something in here broke LVM support - an initrd that has worked fine for
> > > > quite some time suddenly couldn't mount /dev/VolGroup00/root so we get the
> > > > infamous "Kernel panic - not syncing: Attempted to kill init!" when we
> > > > fall off the end of the initrd and haven't pivoted to the real disk.
> > > >
> > > > It finds the disk OK:
> > > >
> > > > [   81.202310] sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
> > > > [   81.214466] sd 0:0:0:0: [sda] Write Protect is off
> > > > [   81.226467] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> > > > [   81.238436] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> > > > [   81.250780]  sda: sda1 sda2
> > > > [   75.396119] sd 0:0:0:0: [sda] Attached SCSI disk
> > > >
> > > > but then the lvm command says it can't find the volume group VolGroup00 (which
> > > > is actually sda2 - sda1 is a small /boot partition, rest of disk is LVM).
> > > >
> > > > A quick look at the rc4-mm1 announcement doesn't have any obviously tempting
> > > > patch names to start at, so it looks like it's time to play mm-bisect.  It may
> > > > take me a day or two, as I have some time management issues this week...
> > > >
> > >
> > > OK, thanks.
> > >
> > > First step would be to eliminate rewrite-rd.patch: maybe the ramdisk driver
> > > in which that initrd resides is bust.
> > >
> > > After that, agk-dm-dm-*.patch are of course the ones to look at.
> >
> > How did I not notice them? Yeah, those guys would be on the suspicious list...
> >
> > > Please keep dm-devel@redhat.com cc'ed.
> >
> > I've gotten it down to about 128 patches, but it's interesting what ended
> > up bracketed by GOOD/BAD:
> >
> > powerpc-invalid-size-for-swapper_pg_dir-with-config_pte_64bit=y.patch   GOOD
> > #GREGKH-DRIVER-START
> > gregkh-driver-nozomi.patch
> >     gregkh-moby-patch-tree....
> > unbork-gregkh-driver-kset-convert-sys-devices-to-use-kset_create-vioc.patch BAD
> >
> > Would I be remiss in hypothesising that something in gregkh-driver-kobject-*
> > changed something, and now we need a agk-dm-dm-kobject-fixupage.patch?
>
> I don't know, it all depends on what is in the dm patches.  Hopefully
> everything that I have changed will manifest with a build breakage to
> obviously detect that something needs to be fixed up.
>
> But I've been known to mess things up that I didn't intend to :)
>
> If there's anything that I can do to test this, please let me know.

What's the value of SYSFS_DEPRECATED? Care to set it to yes, if it isn't,
and try again?

A fix for LVM to handle symlinks instead of directories is in the LVM
CVS tree, but there wasn't a release since August.

Kay

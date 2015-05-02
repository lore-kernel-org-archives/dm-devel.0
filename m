From: Abelardo Ricart III <aricart@memnix.com>
Subject: Re: [dm-devel] Regression: Disk corruption with dm-crypt and
 kernels >= 4.0
Date: Fri, 01 May 2015 20:19:16 -0400
Message-ID: <1430525956.5803.4.camel@memnix.com>
References: <1430455027.7012.32.camel@memnix.com>
	 <20150501214728.GL19922@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150501214728.GL19922@agk-dp.fab.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com, mpatocka@redhat.com, linux-kernel@vger.kernel.org, snitzer@redhat.com
List-Id: dm-devel.ids

On Fri, 2015-05-01 at 22:47 +0100, Alasdair G Kergon wrote:
> On Fri, May 01, 2015 at 12:37:07AM -0400, Abelardo Ricart III wrote:
> > # first bad commit: [cf2f1abfbd0dba701f7f16ef619e4d2485de3366] dm crypt: 
> > don't
> > allocate pages for a partial request
>  
> That's not a particularly good commit to identify.
> 
> If you didn't already, can you confirm whether or not the code works at the
> patch immediately following?
> 
>   7145c241a1bf2841952c3e297c4080b357b3e52d
> 
> Alasdair
> 
Just built that revision and it failed almost immediately with more ata errors. It also corrupted my testing log.

As an aside, here's my fstab in case it's of any use

-------------------->8--------------------
/dev/mapper/root        /             f2fs              rw,relatime,flush_merge,background_gc=on,user_xattr,acl,active_logs=6   0 0

/dev/mapper/home        /home           f2fs            rw,relatime,flush_merge,background_gc=on,user_xattr,acl,active_logs=6   0 2

/dev/sda2               /boot           ext4            rw,relatime,data=ordered        0 2

/dev/sda1               /boot/EFI       vfat            rw,relatime,fmask=0022,dmask=0022,codepage=437,iocharset=iso8859-1,shortname=mixed,errors=remount-ro    0 2

tmpfs                   /scratch        tmpfs           nodev,nosuid,size=12G           0 0
-------------------->8--------------------

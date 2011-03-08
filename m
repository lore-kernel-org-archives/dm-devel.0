From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] generic wrappers for multi-device FS operations
Date: Tue, 8 Mar 2011 17:43:08 +0000
Message-ID: <20110308174308.GP10767@agk-dp.fab.redhat.com>
References: <4D766199.4010307@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4D766199.4010307@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ric Wheeler <ricwheeler@gmail.com>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, Karel Zak <kzak@redhat.com>, Jim Meyering <jim@meyering.net>, Chris Mason <chris.mason@oracle.com>, Josef Bacik <josef@redhat.com>
List-Id: dm-devel.ids

On Tue, Mar 08, 2011 at 12:04:25PM -0500, Ric Wheeler wrote:
> To make this trivial to do for users, I think that it would be really 
> nice to have a two-level wrappers for things like resize, add a volume, 
> shrink, etc. Similar to the way we have mount or fsck invoke file system 
> specific bits.
> Good idea? Bad idea?

We began this within LVM some time ago with a script we called 'fsadm'.

http://sources.redhat.com/cgi-bin/cvsweb.cgi/~checkout~/LVM2/scripts/fsadm.sh?rev=1.24&content-type=text/plain&cvsroot=lvm2&f=h

Alasdair


fsadm: Utility to resize or check the filesystem on a device

  fsadm [options] check device
    - Check the filesystem on device using fsck

  fsadm [options] resize device [new_size[BKMGTPE]]
    - Change the size of the filesystem on device to new_size

  Options:
    -h | --help         Show this help message
    -v | --verbose      Be verbose
    -e | --ext-offline  unmount filesystem before ext2/ext3/ext4 resize
    -f | --force        Bypass sanity checks
    -n | --dry-run      Print commands without running them
    -l | --lvresize     Resize given device (if it is LVM device)
    -y | --yes          Answer "yes" at any prompts

  new_size - Absolute number of filesystem blocks to be in the filesystem,
             or an absolute size using a suffix (in powers of 1024).
             If new_size is not supplied, the whole device is used.


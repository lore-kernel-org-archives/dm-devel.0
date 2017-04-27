From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 3.18-stable] dm bufio: hide bogus warning
Date: Thu, 27 Apr 2017 11:57:55 +0200
Message-ID: <20170427095755.GD1755@kroah.com>
References: <20170421134212.2727744-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170421134212.2727744-1-arnd@arndb.de>
Sender: stable-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: stable@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Fri, Apr 21, 2017 at 03:41:10PM +0200, Arnd Bergmann wrote:
> mips-gcc-5.3 warns about correct code on linux-3.18 and earlier:
> 
> In file included from ../include/linux/blkdev.h:4:0,
>                  from ../drivers/md/dm-bufio.h:12,
>                  from ../drivers/md/dm-bufio.c:9:
> ../drivers/md/dm-bufio.c: In function 'alloc_buffer':
> ../include/linux/sched.h:1975:56: warning: 'noio_flag' may be used uninitialized in this function [-Wmaybe-uninitialized]
>   current->flags = (current->flags & ~PF_MEMALLOC_NOIO) | flags;
>                    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~
> ../drivers/md/dm-bufio.c:325:11: note: 'noio_flag' was declared here
> 
> The warning disappeared on later kernels with this commit: be0c37c985ed
> ("MIPS: Rearrange PTE bits into fixed positions.")  I assume this only
> happened because it changed some inlining decisions.
> 
> On 3.18.y, we can shut up the warning by adding an extra initialization.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Now applied, thanks.

greg k-h

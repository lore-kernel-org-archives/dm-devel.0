From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [dm:for-next 6/8] drivers/md/dm-writecache.c:862:24:
 error: implicit declaration of function 'array_size';
 did you mean '__ua_size'?
Date: Fri, 22 Jun 2018 14:57:48 -0400
Message-ID: <20180622185748.GA17114@redhat.com>
References: <201806230219.0aYv3WPK%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <201806230219.0aYv3WPK%fengguang.wu@intel.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: kbuild test robot <lkp@intel.com>
Cc: dm-devel@redhat.com, Kees Cook <keescook@chromium.org>, kbuild-all@01.org
List-Id: dm-devel.ids

sorry for the noise, I forgot to rebase to v4.18-rc1 before picking this
change up.  since fixed and pushed out.

On Fri, Jun 22 2018 at  2:40pm -0400,
kbuild test robot <lkp@intel.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git for-next
> head:   696ee10fad76d6ec15f256e6dc2c08aa2c706890
> commit: 5174624414ac49495a08eca4ee584dac193c0eb7 [6/8] dm writecache: use 2-factor allocator arguments
> config: mips-allyesconfig (attached as .config)
> compiler: mips-linux-gnu-gcc (Debian 7.2.0-11) 7.2.0
> reproduce:
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         git checkout 5174624414ac49495a08eca4ee584dac193c0eb7
>         # save the attached .config to linux build tree
>         GCC_VERSION=7.2.0 make.cross ARCH=mips 
> 
> All errors (new ones prefixed by >>):
> 
>    drivers/md/dm-writecache.c: In function 'writecache_alloc_entries':
> >> drivers/md/dm-writecache.c:862:24: error: implicit declaration of function 'array_size'; did you mean '__ua_size'? [-Werror=implicit-function-declaration]
>      wc->entries = vmalloc(array_size(sizeof(struct wc_entry), wc->n_blocks));
>                            ^~~~~~~~~~
>                            __ua_size
>    cc1: some warnings being treated as errors
> 
> vim +862 drivers/md/dm-writecache.c
> 
>    855	
>    856	static int writecache_alloc_entries(struct dm_writecache *wc)
>    857	{
>    858		size_t b;
>    859	
>    860		if (wc->entries)
>    861			return 0;
>  > 862		wc->entries = vmalloc(array_size(sizeof(struct wc_entry), wc->n_blocks));
>    863		if (!wc->entries)
>    864			return -ENOMEM;
>    865		for (b = 0; b < wc->n_blocks; b++) {
>    866			struct wc_entry *e = &wc->entries[b];
>    867			e->index = b;
>    868			e->write_in_progress = false;
>    869		}
>    870	
>    871		return 0;
>    872	}
>    873	
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

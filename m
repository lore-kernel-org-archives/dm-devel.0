From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [dm:for-next 26/26] drivers/md/dm-crypt.c:3068:2:
 error: 't' undeclared; did you mean 'ti'?
Date: Fri, 10 Aug 2018 16:15:50 -0400
Message-ID: <20180810201550.GA23525@redhat.com>
References: <201808110324.UeVLl4oD%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <201808110324.UeVLl4oD%fengguang.wu@intel.com>
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
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, kbuild-all@01.org
List-Id: dm-devel.ids

On Fri, Aug 10 2018 at  3:12pm -0400,
kbuild test robot <lkp@intel.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git for-next
> head:   08575fd060d7f88f674509461b32d86b272093d9
> commit: 08575fd060d7f88f674509461b32d86b272093d9 [26/26] dm crypt: don't decrease device limits
> config: i386-allmodconfig (attached as .config)
> compiler: gcc-7 (Debian 7.3.0-16) 7.3.0
> reproduce:
>         git checkout 08575fd060d7f88f674509461b32d86b272093d9
>         # save the attached .config to linux build tree
>         make ARCH=i386 
> 
> All errors (new ones prefixed by >>):
> 
>    drivers/md/dm-crypt.c: In function 'crypt_io_hints':
> >> drivers/md/dm-crypt.c:3068:2: error: 't' undeclared (first use in this function); did you mean 'ti'?
>      t->io_min = max_t(unsigned, limits->io_min, cc->sector_size);
>      ^
>      ti
>    drivers/md/dm-crypt.c:3068:2: note: each undeclared identifier is reported only once for each function it appears in


Fixed up, needed to be: limits->io_min = max_t(unsigned, limits->io_min, cc->sector_size);

Sorry for the noise...

And thanks,
Mike

From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [dm:for-next 11/11] drivers/md/dm-verity.c:737:31:
 warning: passing argument 2 of 'dm_read_arg_group' from incompatible
 pointer type
Date: Wed, 2 Dec 2015 16:18:08 -0500
Message-ID: <20151202211808.GA21969@redhat.com>
References: <201512030431.zBd5LzGB%fengguang.wu@intel.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <201512030431.zBd5LzGB%fengguang.wu@intel.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: kbuild test robot <fengguang.wu@intel.com>
Cc: dm-devel@redhat.com, kbuild-all@01.org, Sami Tolvanen <samitolvanen@google.com>, Kees Cook <keescook@chromium.org>
List-Id: dm-devel.ids

On Wed, Dec 02 2015 at  3:40pm -0500,
kbuild test robot <fengguang.wu@intel.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git for-next
> head:   81d42f18b9ca93f6d182692c6edf4ad604e95964
> commit: 81d42f18b9ca93f6d182692c6edf4ad604e95964 [11/11] dm verity: separate function for parsing opt args
> config: i386-randconfig-x005-12020835 (attached as .config)
> reproduce:
>         git checkout 81d42f18b9ca93f6d182692c6edf4ad604e95964
>         # save the attached .config to linux build tree
>         make ARCH=i386 
> 
> All warnings (new ones prefixed by >>):
> 
>    drivers/md/dm-verity.c: In function 'verity_parse_opt_args':
> >> drivers/md/dm-verity.c:737:31: warning: passing argument 2 of 'dm_read_arg_group' from incompatible pointer type [-Wincompatible-pointer-types]
>      r = dm_read_arg_group(_args, &as, &argc, &ti->error);
>                                   ^

I've fixed this up, sorry for the noise.

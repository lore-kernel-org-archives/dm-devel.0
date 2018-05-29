From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-writecache: fix compilation issue with !DAX
Date: Tue, 29 May 2018 14:08:23 -0400
Message-ID: <20180529180823.GA32763@redhat.com>
References: <20180528153834.2268557-1-arnd@arndb.de>
 <20180529175216.24937-1-ross.zwisler@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180529175216.24937-1-ross.zwisler@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Mikulas Patocka <mpatocka@redhat.com>, Shaohua Li <shli@kernel.org>, Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, Matthew Wilcox <mawilcox@microsoft.com>, linux-fsdevel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, Heinz Mauelshagen <heinzm@redhat.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Tue, May 29 2018 at  1:52pm -0400,
Ross Zwisler <ross.zwisler@linux.intel.com> wrote:

> As reported by Arnd (https://lkml.org/lkml/2018/5/28/1697), dm-writecache
> will fail with link errors in configs where DAX isn't present:
> 
> drivers/md/dm-writecache.o: In function `writecache_ctr':
> dm-writecache.c:(.text+0x1fdc): undefined reference to `dax_read_lock'
> dm-writecache.c:(.text+0x2004): undefined reference to `dax_direct_access'
> dm-writecache.c:(.text+0x21cc): undefined reference to `dax_read_unlock'
> 
> Fix this by following the lead of the other DM modules and wrapping calls
> to the generic DAX code in #if IS_ENABLED(CONFIG_DAX_DRIVER) blocks.
> 
> We also expand the failure case for the 'p' (persistent memory) flag so
> that fails on both architectures that don't support persistent memory and
> on kernels that don't have DAX support configured.  This prevents us from
> ever hitting the BUG() in the persistent_memory_claim() stub.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Reported-by: Arnd Bergmann <arnd@arndb.de>

Thanks, I've picked this up.

Mike

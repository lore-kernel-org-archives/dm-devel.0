From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: dm-writecache: fix compilation issue with !DAX
Date: Tue, 29 May 2018 11:40:50 -0700
Message-ID: <CAPcyv4iF8oAGDKcWP++-bw5OcfmkSTPHCAw1XZvVRTz4evJvGw@mail.gmail.com>
References: <20180528153834.2268557-1-arnd@arndb.de> <20180529175216.24937-1-ross.zwisler@linux.intel.com>
 <20180529180823.GA32763@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529180823.GA32763@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>, Mikulas Patocka <mpatocka@redhat.com>, Shaohua Li <shli@kernel.org>, Alasdair Kergon <agk@redhat.com>, device-mapper development <dm-devel@redhat.com>, Matthew Wilcox <mawilcox@microsoft.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Heinz Mauelshagen <heinzm@redhat.com>, linux-raid <linux-raid@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

On Tue, May 29, 2018 at 11:08 AM, Mike Snitzer <snitzer@redhat.com> wrote:
> On Tue, May 29 2018 at  1:52pm -0400,
> Ross Zwisler <ross.zwisler@linux.intel.com> wrote:
>
>> As reported by Arnd (https://lkml.org/lkml/2018/5/28/1697), dm-writecache
>> will fail with link errors in configs where DAX isn't present:
>>
>> drivers/md/dm-writecache.o: In function `writecache_ctr':
>> dm-writecache.c:(.text+0x1fdc): undefined reference to `dax_read_lock'
>> dm-writecache.c:(.text+0x2004): undefined reference to `dax_direct_access'
>> dm-writecache.c:(.text+0x21cc): undefined reference to `dax_read_unlock'
>>
>> Fix this by following the lead of the other DM modules and wrapping calls
>> to the generic DAX code in #if IS_ENABLED(CONFIG_DAX_DRIVER) blocks.
>>
>> We also expand the failure case for the 'p' (persistent memory) flag so
>> that fails on both architectures that don't support persistent memory and
>> on kernels that don't have DAX support configured.  This prevents us from
>> ever hitting the BUG() in the persistent_memory_claim() stub.
>>
>> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
>> Reported-by: Arnd Bergmann <arnd@arndb.de>
>
> Thanks, I've picked this up.

...I assume you're also going to let the 'pmem api' discussion resolve
before this all goes upstream?

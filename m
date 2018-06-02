From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [bisect BUG] dm-crypt percpu counter warnings and invalid kernel
 paging request at virtual address
Date: Fri, 1 Jun 2018 18:50:13 -0600
Message-ID: <220a69e1-f1ed-a878-3ab7-de4cea1239fa@kernel.dk>
References: <CAJKOXPfSbsu0RGTUFfb+t_uOvQQxa0uDn-nsG+1uuKAq56nVXA@mail.gmail.com>
 <20180601223557.GA25942@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180601223557.GA25942@kmo-pixel>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>, Krzysztof Kozlowski <krzk@kernel.org>
Cc: Mike Snitzer <snitzer@redhat.com>, Shaohua Li <shli@fb.com>, linux-kernel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, "linux-samsung-soc@vger.kernel.org" <linux-samsung-soc@vger.kernel.org>
List-Id: dm-devel.ids

On 6/1/18 4:35 PM, Kent Overstreet wrote:
> On Fri, Jun 01, 2018 at 02:55:15PM +0200, Krzysztof Kozlowski wrote:
>> Hi,
>>
>> Todays linux-next 20180601 fails during dm-crypt tests on Exynos5422
>> (ARMv7, Cortex-A7+A15) using crypto HW block from SoC (s5p-aes).
>>
>> The test which fails:
>> https://github.com/krzk/tools/blob/master/tests/s5p-sss-cryptsetup.sh
>>
>> Effect:
>>
>> [  149.867394] ------------[ cut here ]------------
>> [  149.870631] WARNING: CPU: 5 PID: 492 at
>> ../drivers/md/dm-crypt.c:2225 crypt_dtr+0x1c0/0x1c4 [dm_crypt]
>> [  149.880078] Modules linked in: dm_crypt s5p_jpeg exynos_gsc s5p_mfc
>> v4l2_mem2mem v4l2_common videobuf2_dma_contig videobuf2_memops
>> videobuf2_v4l2 videobuf2_common videodev media
>> [  149.895908] CPU: 5 PID: 492 Comm: cryptsetup Tainted: G        W
>>      4.17.0-rc4-00159-gae4c15db96d2 #36
>> [  149.905328] Hardware name: SAMSUNG EXYNOS (Flattened Device Tree)
>> [  149.911398] [<c011291c>] (unwind_backtrace) from [<c010ece8>]
>> (show_stack+0x10/0x14)
>> [  149.919111] [<c010ece8>] (show_stack) from [<c0a32190>]
>> (dump_stack+0x98/0xc4)
>> [  149.926307] [<c0a32190>] (dump_stack) from [<c0126fa0>] (__warn+0x10c/0x124)
>> [  149.933310] [<c0126fa0>] (__warn) from [<c01270d0>]
>> (warn_slowpath_null+0x40/0x48)
>> [  149.940862] [<c01270d0>] (warn_slowpath_null) from [<bf28e15c>]
>> (crypt_dtr+0x1c0/0x1c4 [dm_crypt])
>> [  149.949803] [<bf28e15c>] (crypt_dtr [dm_crypt]) from [<c06f34b8>]
>> (dm_table_destroy+0x5c/0xf8)
>> [  149.958360] [<c06f34b8>] (dm_table_destroy) from [<c06f0cb0>]
>> (__dm_destroy+0x158/0x1b4)
>> [  149.966414] [<c06f0cb0>] (__dm_destroy) from [<c06f7988>]
>> (dev_remove+0xd4/0x104)
>> [  149.973861] [<c06f7988>] (dev_remove) from [<c06f80b4>]
>> (ctl_ioctl+0x2e4/0x660)
>> [  149.981144] [<c06f80b4>] (ctl_ioctl) from [<c029fcc0>]
>> (do_vfs_ioctl+0xb0/0x9e8)
>> [  149.988508] [<c029fcc0>] (do_vfs_ioctl) from [<c02a062c>]
>> (ksys_ioctl+0x34/0x5c)
>> [  149.995874] [<c02a062c>] (ksys_ioctl) from [<c0101000>]
>> (ret_fast_syscall+0x0/0x28)
>> [  150.061101] ---[ end trace 3e3bc2b7df1963aa ]---
>>
>> [  150.065594] Unable to handle kernel paging request at virtual
>> address 2e02f000
>> [  150.383043] [<c0483edc>] (percpu_counter_add_batch) from
>> [<bf28e378>] (crypt_page_free+0x34/0x3c [dm_crypt])
>> [  150.392838] [<bf28e378>] (crypt_page_free [dm_crypt]) from
>> [<c0229b18>] (mempool_exit+0x24/0x60)
>> [  150.401584] [<c0229b18>] (mempool_exit) from [<bf28e028>]
>> (crypt_dtr+0x8c/0x1c4 [dm_crypt])
>> [  150.409903] [<bf28e028>] (crypt_dtr [dm_crypt]) from [<c06f34b8>]
>> (dm_table_destroy+0x5c/0xf8)
>> [  150.418477] [<c06f34b8>] (dm_table_destroy) from [<c06f0cb0>]
>> (__dm_destroy+0x158/0x1b4)
>> [  150.426533] [<c06f0cb0>] (__dm_destroy) from [<c06f7988>]
>> (dev_remove+0xd4/0x104)
>> [  150.433982] [<c06f7988>] (dev_remove) from [<c06f80b4>]
>> (ctl_ioctl+0x2e4/0x660)
>> [  150.441264] [<c06f80b4>] (ctl_ioctl) from [<c029fcc0>]
>> (do_vfs_ioctl+0xb0/0x9e8)
>> [  150.448628] [<c029fcc0>] (do_vfs_ioctl) from [<c02a062c>]
>> (ksys_ioctl+0x34/0x5c)
>> [  150.455994] [<c02a062c>] (ksys_ioctl) from [<c0101000>]
>> (ret_fast_syscall+0x0/0x28)
>>
>> ---
>>
>> Full log is here:
>> https://krzk.eu/#/builders/1/builds/2117/steps/18/logs/serial0
>>
>> Bisect could not work reliably because a lot of commits from Kent
>> Overstreet just do not compile. Really, non-buildable stuff should not
>> be committed...
> 
> Sorry, I do compile test stuff but sometimes I screw up...
> 
> I'll work on getting a test set up.

Nevermind that for now, do you have a fix for the issue reported?

-- 
Jens Axboe

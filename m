From: "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Subject: Re: [PATCH v2 1/2] md raid0/linear: Introduce new array
 state 'broken'
Date: Wed, 21 Aug 2019 16:10:47 -0300
Message-ID: <d0a3709e-c3a9-c0b1-c3c1-bf5a6d6932af@canonical.com>
References: <20190816134059.29751-1-gpiccoli@canonical.com>
	<CAPhsuW7aGze5p9DgNAe=KakJGXTNqRZpNCtvi8nKxzS2MPXrNQ@mail.gmail.com>
	<1f16110b-b798-806f-638b-57bbbedfea49@canonical.com>
	<1725F15D-7CA2-4B8D-949A-4D8078D53AA9@fb.com>
	<4c95f76c-dfbc-150c-2950-d34521d1e39d@canonical.com>
	<8E880472-67DA-4597-AFAD-0DAFFD223620@fb.com>
	<c35cd395-fc54-24c0-1175-d3ea0ab0413d@canonical.com>
	<B7287054-70AC-47A8-BA5A-4D3D7C3F689F@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <B7287054-70AC-47A8-BA5A-4D3D7C3F689F@fb.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Song Liu <songliubraving@fb.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Song Liu <liu.song.a23@gmail.com>, NeilBrown <neilb@suse.com>, linux-raid <linux-raid@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Jay Vosburgh <jay.vosburgh@canonical.com>
List-Id: dm-devel.ids

On 21/08/2019 13:14, Song Liu wrote:
> [...] 
> 
> What do you mean by "not clear MD_BROKEN"? Do you mean we need to restart
> the array? 
> 
> IOW, the following won't work:
> 
>   mdadm --fail /dev/md0 /dev/sdx
>   mdadm --remove /dev/md0 /dev/sdx
>   mdadm --add /dev/md0 /dev/sdx
>   
> And we need the following instead:
> 
>   mdadm --fail /dev/md0 /dev/sdx
>   mdadm --remove /dev/md0 /dev/sdx
>   mdadm --stop /dev/md0 /dev/sdx
>   mdadm --add /dev/md0 /dev/sdx
>   mdadm --run /dev/md0 /dev/sdx
> 
> Thanks,
> Song
> 

Song, I've tried the first procedure (without the --stop) and failed to
make it work on linear/raid0 arrays, even trying in vanilla kernel.
What I could do is:

1) Mount an array and while writing, remove a member (nvme1n1 in my
case); "mdadm --detail md0" will either show 'clean' state or 'broken'
if we have my patch;

2) Unmount the array and run: "mdadm -If nvme1n1 --path
pci-0000:00:08.0-nvme-1"
This will result: "mdadm: set device faulty failed for nvme1n1:  Device
or resource busy"
Despite the error, md0 device is gone.

3) echo 1 > /sys/bus/pci/rescan [nvme1 device is back]

4) mdadm -A --scan [md0 is back, with both devices and 'clean' state]

So, either if we "--stop" or if we incremental fail a member of the
array, when it's back the state will be 'clean' and not 'broken'.
Hence, I don't see a point in clearing the MD_BROKEN flag for
raid0/linear arrays, nor I see where we could do it.

And thanks for the link for your tree, I'll certainly rebase my patch
against that.
Cheers,


Guilherme

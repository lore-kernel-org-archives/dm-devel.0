From: "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Subject: Re: [PATCH v4 2/2] mdadm: Introduce new array state
 'broken' for raid0/linear
Date: Sun, 15 Sep 2019 16:39:11 -0300
Message-ID: <5a17d353-3d47-d994-d462-cbe1e9d75778@canonical.com>
References: <20190903194901.13524-1-gpiccoli@canonical.com>
	<20190903194901.13524-2-gpiccoli@canonical.com>
	<A0D1B6AB-50CF-4B38-8452-A4E18AFDC8EB@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <A0D1B6AB-50CF-4B38-8452-A4E18AFDC8EB@fb.com>
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
To: Jes Sorensen <jsorensen@fb.com>, "jes.sorensen@gmail.com" <jes.sorensen@gmail.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Song Liu <songliubraving@fb.com>, "nfbrown@suse.com" <nfbrown@suse.com>, "liu.song.a23@gmail.com" <liu.song.a23@gmail.com>, linux-raid <linux-raid@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "jay.vosburgh@canonical.com" <jay.vosburgh@canonical.com>
List-Id: dm-devel.ids

On 04/09/2019 12:51, Song Liu wrote:
> [...] 
>>
>> Cc: Jes Sorensen <jes.sorensen@gmail.com>
>> Cc: NeilBrown <neilb@suse.de>
>> Cc: Song Liu <songliubraving@fb.com>
>> Signed-off-by: Guilherme G. Piccoli <gpiccoli@canonical.com>
> 
> Acked-by: Song Liu <songliubraving@fb.com>
> 
> Jes, does this look good?
> 
> Thanks,
> Song
> 

Jes, do you have any comment about this patch? It'd be good having this
code merged before the 5.4 kernel windows ends, since the kernel
counterpart is ready to get merged (it's on Jens' tree).

Thanks in advance,


Guilherme

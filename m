From: Milan Broz <mbroz@redhat.com>
Subject: Re: 2.6.24 Kernel Soft Lock Up with heavy I/O in dm-crypt
Date: Mon, 02 Jun 2008 08:52:00 +0200
Message-ID: <48439890.6030904@redhat.com>
References: <20080602030738.GA7761@yantp.cn.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080602030738.GA7761@yantp.cn.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Yan Li <elliot.li.tech@gmail.com>
Cc: Ritesh Raj Sarraf <rrs@researchut.com>, Herbert Xu <herbert@gondor.apana.org.au>, dm-crypt@saout.de, linux-kernel@vger.kernel.org, dm-devel@redhat.com, rjmaomao@gmail.com, Andrew Morton <akpm@linux-foundation.org>, Alasdair G Kergon <agk@redhat.com>, Christophe Saout <christophe@saout.de>
List-Id: dm-devel.ids


Yan Li wrote:
> On Thu, 28 Feb 2008 23:20:48 -0800, Andrew Morton wrote:
>> On Thu, 28 Feb 2008 19:24:03 +0530 Ritesh Raj Sarraf <rrs@researchut.com> wrote:
>>> I noted kernel soft lockup messages on my laptop when doing a lot of I/O 
>>> (200GB) to a dm-crypt device. It was setup using LUKS.
>>> The I/O never got disrupted nor anything failed. Just the messages.
> 
> I met the same problem yesterday.
> 
>> Could be a dm-crypt problem, could be a crypto problem, could even be a
>> core block problems.
> 
> I think it's due to heavy encryption computation that run longer than
> 10s and triggered the warning. By heavy I mean dm-crypt with
> aes-xts-plain, 512b key size.
> 
> This is a typical soft lockup call trace snip from dmesg:
> Call Trace:
>  [<ffffffff882c60b6>] :xts:crypt+0x9d/0xea
>  [<ffffffff882b5705>] :aes_x86_64:aes_encrypt+0x0/0x5
>  [<ffffffff882b5705>] :aes_x86_64:aes_encrypt+0x0/0x5
>  [<ffffffff882c622e>] :xts:encrypt+0x41/0x46
>  [<ffffffff8828273f>] :dm_crypt:crypt_convert_scatterlist+0x7b/0xc7
>  [<ffffffff882828ae>] :dm_crypt:crypt_convert+0x123/0x15d
>  [<ffffffff88282abd>] :dm_crypt:kcryptd_do_crypt+0x1d5/0x253
>  [<ffffffff882828e8>] :dm_crypt:kcryptd_do_crypt+0x0/0x253
>  [<ffffffff802448e5>] run_workqueue+0x7f/0x10b
> ... (omitted)

Please could you try if  patch here helps and doesn't cause performance degradation?

http://www2.kernel.org/pub/linux/kernel/people/agk/patches/2.6/2.6.25/dm-crypt-add-cond_resched.patch

...
> Anybody see a data corruption?

It shouldn't cause any corruption of data.

Milan

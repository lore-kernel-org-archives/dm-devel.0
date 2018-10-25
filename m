From: Neil Armstrong <narmstrong@baylibre.com>
Subject: Re: dm-integrity stalls with iMX6q CAAM
Date: Thu, 25 Oct 2018 15:40:06 +0200
Message-ID: <8f934a82-5078-3cb3-84ba-80298f4dfe09@baylibre.com>
References: <fbcca5eb-a301-53f4-3faf-a36a3229300d@baylibre.com>
	<VI1PR0402MB3485278043D883A74ED7AEBD98FF0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <VI1PR0402MB3485278043D883A74ED7AEBD98FF0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
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
To: Horia Geanta <horia.geanta@nxp.com>, "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, Aymen Sghaier <aymen.sghaier@nxp.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
List-Id: dm-devel.ids

On 17/10/2018 15:35, Horia Geanta wrote:
> On 9/21/2018 3:06 PM, Neil Armstrong wrote:
>> Hi,
>>
>> I recently configured dm-crypt + dm-integrity on an iMX6q platform with CAAM Hash functions enabled using the following command lines :
>>
>> Linux 4.14.71
>>
>> cryptsetup luksFormat /dev/mmcblk1p3 --cipher aes-xts-plain64 --type luks2 --integrity hmac-sha256 --sector-size 512 --use-urandom
>> cryptsetup open /dev/mmcblk1p3 root
>> mkfs.ext4 -v -F /dev/mapper/root
>>
>> luksFormat and open finishes correctly, luksDump and status reports correct dm and luks properties.
>>
>> but when trying to access the /dev/mapper/root (mkfs, sha256sum or whatever), it blocks without any warning or errors reported by the kernel.
>> I can see a few (~170) interrupts on the jr0 interrupt then nothing.
>>
>> Is there a particular issue with hmac-sha256 with the linux CAAM driver ?
>>
>> When disabling the CAAM hash functions or using another cipher & integrity pair, it works like a charm.
>>
> The issue you are seeing is most probably related to CAAM driver not
> implementing correctly the crypto requests "backlogging".
> See commit c0403ec0bb5a ("Revert "dm crypt: fix deadlock when async crypto
> algorithm returns -EBUSY"") for a detailed description.
> 
> Historically, there have been several CAAM backlogging implementations proposed
> - but all were rejected:
> v1: https://patchwork.kernel.org/patch/7144701
> v2: https://patchwork.kernel.org/patch/7199241
> v3: https://patchwork.kernel.org/patch/7221941
> v4: https://patchwork.kernel.org/patch/7230241
> v5: https://patchwork.kernel.org/patch/9033121
> 
> Discussion here: https://community.nxp.com/message/1020096
> mentions v2 as solving the issue.
> You could try it while we find a solution that would be accepted upstream.
> 
> Hope this helps,
> Horia
> 

Hi Horia,

Thanks for the pointers ! Hopefully you will find a solution soon.

Neil

From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [RFC PATCH v6 0/1] Add dm verity root hash pkcs7 sig validation.
Date: Wed, 17 Jul 2019 15:08:13 +0200
Message-ID: <bdcd7d7c-92fc-11af-7924-9bd0e184b427@gmail.com>
References: <20190701181958.6493-1-jaskarankhurana@linux.microsoft.com>
 <MN2PR21MB12008A962D4DD8662B3614508AF20@MN2PR21MB1200.namprd21.prod.outlook.com>
 <alpine.LRH.2.21.1907121025510.66082@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.inter>
 <395efa90-65d8-d832-3e2b-2b8ee3794688@gmail.com>
 <alpine.LRH.2.21.1907161035490.121213@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.inter>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.21.1907161035490.121213@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.inter>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jaskaran Singh Khurana <jaskarankhurana@linux.microsoft.com>
Cc: ebiggers@google.com, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-integrity@vger.kernel.org, linux-fsdevel@vger.kernel.org, agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, jmorris@namei.org, Scott Shell <SCOTTSH@microsoft.com>, Nazmus Sakib <mdsakib@microsoft.com>, mpatocka@redhat.com
List-Id: dm-devel.ids

Hi,

On 16/07/2019 20:08, Jaskaran Singh Khurana wrote:
>>> Could you please provide feedback on this v6 version.
>>
>> Hi,
>>
>> I am ok with the v6 patch; I think Mike will return to it in 5.4 reviews.
>>
> 
> Thanks for the help and also for reviewing this patch. Could you please 
> add Reviewed-by/Tested-by tag to the patch.

ok, you can add
Tested-and-Reviewed-by: Milan Broz <gmazyland@gmail.com>

or just use the version on my git, I already updated few lines because
of recent kernel changes, mainly the revert of keyring changes, tested patch is here

  https://git.kernel.org/pub/scm/linux/kernel/git/mbroz/linux.git/commit/?h=dm-cryptsetup&id=266f7c9c74b23e4cb2e67ceb813dd707061c1641
...

> The steps and workflow is correct. I will send the cryptsetup changes for 
> review.

ok, I'll probably try to use our existing userspace libcryptsetup API to avoid introducing new calls,
but that is not important for now - the kernel bits must be in the mainline kernel first.

Thanks,
Milan

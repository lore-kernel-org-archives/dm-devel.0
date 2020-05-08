From: Samuel Zou <zou_wei@huawei.com>
Subject: Re: [PATCH -next] dm mpath: Remove unused variable ret
Date: Fri, 8 May 2020 09:06:08 +0800
Message-ID: <d945a16d-5a9d-252f-2dec-1d654c4f7e77@huawei.com>
References: <1588854412-19301-1-git-send-email-zou_wei@huawei.com>
 <20200507142958.GA12032@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200507142958.GA12032@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: agk@redhat.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Hi Mike,

You are right.
I did not notice that the macro DMEMIT uses the sz variable.

Thanks.

On 2020/5/7 22:29, Mike Snitzer wrote:
> On Thu, May 07 2020 at  8:26am -0400,
> Samuel Zou <zou_wei@huawei.com> wrote:
> 
>> This patch fixes below warning reported by coccicheck:
>>
>> drivers/md/dm-historical-service-time.c:240:14-16: Unneeded variable: "sz". Return "0" on line 261
>>
>> Reported-by: Hulk Robot <hulkci@huawei.com>
>> Signed-off-by: Samuel Zou <zou_wei@huawei.com>
> 
> Nack.
> 
> DMEMIT() uses the local sz variable.
> 
> 

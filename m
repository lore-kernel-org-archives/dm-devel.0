From: Nikolay Borisov <n.borisov@siteground.com>
Subject: Re: Fwd: kernel BUG at
 drivers/md/persistent-data/dm-btree-remove.c:182!
Date: Mon, 19 Oct 2015 13:45:31 +0300
Message-ID: <5624C9CB.7000702@siteground.com>
References: <5624B4B8.1030404@siteground.com>
	<5624B505.6000406@siteground.com> <20151019103057.GA14688@rh-vpn>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20151019103057.GA14688@rh-vpn>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: thornber@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>, SiteGround Operations <operations@siteground.com>
List-Id: dm-devel.ids



On 10/19/2015 01:30 PM, Joe Thornber wrote:
> On Mon, Oct 19, 2015 at 12:16:53PM +0300, Nikolay Borisov wrote:
>> [Resending as I had typo in the dm-devel's mailing list the first time]
>>
>> Hello, 
>>
>> Using kernel 3.12.47 I've hit the aforementioned issue. I'd also like 
>> to say that this kernel does include Dennis Yang's patch which 
>> supposedly fixes a similar issue 
>> (https://www.redhat.com/archives/dm-devel/2015-May/msg00113.html). 
> 
> 
> Did you apply this patch or my corrected patch?
> 
> https://www.redhat.com/archives/dm-devel/2015-May/msg00123.html

I haven't applied anything per-se, rather this stable kernel does
include your corrected patch. So yes, the correct fix for the issue
reported by Dennis is included, yet apparently the same issue is
manifesting again.


> 
> - Joe
> 

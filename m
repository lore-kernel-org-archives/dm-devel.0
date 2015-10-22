From: Nikolay Borisov <n.borisov@siteground.com>
Subject: Re: kernel BUG at
 drivers/md/persistent-data/dm-btree-remove.c:182!
Date: Thu, 22 Oct 2015 10:59:32 +0300
Message-ID: <56289764.4010009@siteground.com>
References: <5624B4B8.1030404@siteground.com>
	<5624B505.6000406@siteground.com> <20151019103057.GA14688@rh-vpn>
	<5624C9CB.7000702@siteground.com> <20151019160230.GA23826@redhat.com>
	<CAKTMprPVpRH6jktgPQ=f9Ak3XO8wg50oNqr8o-1UXTd=_9u0SA@mail.gmail.com>
	<20151021174939.GA3144@rh-vpn>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20151021174939.GA3144@rh-vpn>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Dennis Yang <shinrairis@gmail.com>, device-mapper development <dm-devel@redhat.com>, SiteGround Operations <operations@siteground.com>, thornber@redhat.com
List-Id: dm-devel.ids



On 10/21/2015 08:49 PM, Joe Thornber wrote:
> On Tue, Oct 20, 2015 at 10:39:31AM +0800, Dennis Yang wrote:
>> Hi,
>>
>> After I analyzed the metadata of this case couple months ago, I find
>> out that there is another possible bug which might trigger this
>> assertion fail in shift(). I had posted a patch two months ago on the
>> list to explain and fix this issue. Could you help reviewing this?
>>
>> https://www.redhat.com/archives/dm-devel/2015-August/msg00155.html
> 
> Yep, that's a bug.  Sorry I missed it before when you posted.  Here's
> my fix:

Thanks for that, I will apply this and report back if I experience the
same issue. But looking at your test case I'm confident this should fix
the issue. Dennis' patch in contrast still causes the within_one assert
to fail.

Are you going to tag this for stable ?

From: Guan Junxiong <guanjunxiong@huawei.com>
Subject: Re: [PATCH 0/4] path latency prio fixes
Date: Tue, 5 Dec 2017 08:23:24 +0800
Message-ID: <45522665-5f1d-460c-6a55-365c326846fc@huawei.com>
References: <06F84A57D601574CAA706EE1A6270A5F01039517@DGGEMM505-MBX.china.huawei.com>
	<ec755f37-cecf-ef5c-d9ee-fa63ff39ec99@huawei.com>
	<1512400279.7217.43.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1512400279.7217.43.camel@suse.com>
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
To: Martin Wilck <mwilck@suse.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, "Shenhong (C)" <shenhong09@huawei.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, niuhaoxin <niuhaoxin@huawei.com>
List-Id: dm-devel.ids



On 2017/12/4 23:11, Martin Wilck wrote:
> On Mon, 2017-12-04 at 22:23 +0800, Guan Junxiong wrote:
>>> An open question is what multipathd should do wrt path grouping if
>>> it
>>> only has preliminary prio values, in particular with group_by_prio.
>> For the open question, in this situation, IMO  it's reasonable to
>> overwriting
>> the preliminary prio values if we let the user/admin know : "this is
>> an
>> asynchronous priority checkers and it has high priority to the other
>> synchronous
>> prioritizer.
> This is not what I meant. Once we have the final prio values, it's of
> course the right thing to overwrite anything preliminary. 
> 
> The "open question" arises at the time when we only have the
> preliminary values: We may group paths wrongly. Really bad example: we
> might be putting active and passive paths of a storage system into the
> same path group, causing endless trespassing... we should probably use
> "failover" policy if "group_by_prio" is selected but no reliable
> priorities are available.

Thanks for your clarification. Agreed.

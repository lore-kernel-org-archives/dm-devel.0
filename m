From: lixiaokeng <lixiaokeng@huawei.com>
Subject: Re: [PATCH 5/5] libmultipath fix daemon memory leak in
 disassemble_map
Date: Wed, 19 Aug 2020 16:45:23 +0800
Message-ID: <8dcc835f-5cda-89d5-acb6-67af1fe7bb78@huawei.com>
References: <5ef5f58e-3a27-8959-3abb-4b4c401cc309@huawei.com>
	<e15fee1e-145b-2880-c84a-aba7b1496555@huawei.com>
	<d76537854b7e9171738cf8db094319088bb13c3a.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <d76537854b7e9171738cf8db094319088bb13c3a.camel@suse.com>
Content-Language: en-GB
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: linfeilong@huawei.com, dm-devel mailing list <dm-devel@redhat.com>, liuzhiqiang26@huawei.com
List-Id: dm-devel.ids

Hi Martin,
   Thanks for your answers. I understand the relationship between branches.

On 2020/8/19 16:26, Martin Wilck wrote:
> Hello lixiaokeng,
> 
> Thanks again for your contribution.
> 
> On Wed, 2020-08-19 at 09:50 +0800, lixiaokeng wrote:
>>
>> If checking is_deamon is deleted, there are many other things need be
>> done like in
>> https://www.redhat.com/archives/dm-devel/2020-July/msg00245.html. And
>> this
>> branch develops from 0.8.3 but upstream_queue is mainline which
>> develops from
>> 0.8.4.
> 
> This is a misunderstanding. My upstream-queue branch is *not* mainline.
> Mainline is http://git.opensvc.com/multipath-tools/.git. Also, my
> entire patch series (link above) was based on upstream-queue, which in
> turn was based on 0.8.4, not 0.8.3.
> 
> As the name says, "upstream-queue" represents the queue of pending
> patches which have at least one positive review (and no negative ones).
> The intention is 1. to provide an overview for myself and other
> interested parties, and 2. to simplify matters for the actual
> maintainer, Christophe, when he applies patches onto mainline.
> 
> My patch series changes the same code path as this one, and I think it
> solves the same issue, albeit differently. Most of my series has
> meanwhile been positively reviewed by Ben, and the remaining open
> issues are in other parts of the series. I'll hopefully be able to push
> it to upstream-queue soon. IMO it makes little sense to push changes to
> upstream-queue which are going to be removed again when my series is
> applied (I don't intend to start using merge operations in this
> branch).
> 
> Christophe is on the recipients list of your patch. He may of course
> decide to apply your patch before my series, in which case I'll have to
> rebase mine. But he'll probably have other prior patches to look at
> first before he gets down to this one.
> 
> Regards,
> Martin
> 

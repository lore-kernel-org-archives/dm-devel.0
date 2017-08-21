From: Guan Junxiong <guanjunxiong@huawei.com>
Subject: Re: [PATCH RFC 0/3] multipath-tools: coalesce
 heterogenous paths by referencing method
Date: Mon, 21 Aug 2017 14:49:02 +0800
Message-ID: <8a1a943a-ed28-2600-96ba-c0f65894bd54@huawei.com>
References: <1500613652-9084-1-git-send-email-guanjunxiong@huawei.com>
	<1500632463.32663.10.camel@suse.com>
	<24a7b716-36cf-dc87-7926-faa82f891228@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <24a7b716-36cf-dc87-7926-faa82f891228@huawei.com>
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
Cc: xose.vazquez@gmail.com, "Chengjike (ISSP)" <chengjike.cheng@huawei.com>, shenhong09@huawei.com, dm-devel@redhat.com, niuhaoxin <niuhaoxin@huawei.com>
List-Id: dm-devel.ids

Hi Martin,

I sent an updated patch to support coalesce heterogenous paths by
inserting udev rules file as suggested by you in this original patch a
few days ago. I have tested this solution and it works on the sd/nvme
disk at least.

Here is the updated patch using udev solution:
[dm-devel] [PATCH] multipath-tools: support for coalescing heterogenous paths
https://www.redhat.com/archives/dm-devel/2017-August/msg00213.html

What do you think of the new patch?  Please let me know if it is convenient to you .

Best Wishes,
Guan Junxiong

On 2017/7/24 15:41, Guan Junxiong wrote:
> Hello Martin,
> Thanks for your comments. Please find my comments inline.
> 
> On 2017/7/21 18:21, Martin Wilck wrote:
>> Hello Guan,
>>
>> On Fri, 2017-07-21 at 13:07 +0800, Guan Junxiong wrote:
>>> This three patches support coalescing heterogenous paths by
>>> referencing
>>> another path identifier. This is useful in the scenario of migrating
>>> data
>>> for heterogenous arrays without interrupting uplayer transaction.
>>> ...
>> Anyway, I'm wondering if multipath configuration is the right place to
>> apply a "fake" configuration like this. Have you considered doing this
>> on the udev level? Udev has the advantage that udev immediately sees
>> added or modified rules files. So if you want to pretend temporarily
>> that sda is indeed the same disk as sdd, you could insert appropriate
>> temporary udev rules to do that. This would have the additional benefit
>> that not only multipathd sees the mangled WWID but also the rest of the
>> system (IOW, multipathd's view of the system would be consistent with
>> the world outside multipathd).
> 
> "udev level " solution is a good thing. Thanks.
> I still have a doubt whether a udev rules is enough to meet this fake configuration.
> IOW ,in addition to udev rules , do we still have to write a C program to fetch 
> sth . I will write a demo of this to see whether it has problems or not.
> 
> Regards,
> Guan Junxiong
> 
> 
>> Postponing a detailed technical patch review until these questions are
>> clarified.
>>
>> Regards,
>> Martin
>>

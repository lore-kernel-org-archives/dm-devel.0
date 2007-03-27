From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: Re: dm-multipath based engenio-lsi hardware handler
Date: Tue, 27 Mar 2007 12:20:00 -0500
Message-ID: <46095240.3050707@cs.wisc.edu>
References: <1174589692.22545.33.camel@linuxchandra>	<4602C533.3010908@cs.wisc.edu>
	<1174606627.14100.7.camel@linuxchandra>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1174606627.14100.7.camel@linuxchandra>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: sekharan@us.ibm.com, device-mapper development <dm-devel@redhat.com>
Cc: Mike Anderson <andmike@us.ibm.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Chandra Seetharaman wrote:
> On Thu, 2007-03-22 at 13:04 -0500, Mike Christie wrote:
> Mike,
> 
> Thanks for your comments.
> 
>> Chandra Seetharaman wrote:
>>
>> Did you see may later revisions on this or Ed's updated handler? In the
>> current kernel we do not need to allocate or manage our own bios. That
>> was a old old hack from when the request did not have a end io. The hack
>> is probably only needed for old distros. It is not needed upstream.
>>
>> For dm based hw handlers you want to do something more like this:
>> http://www.cs.wisc.edu/~michaelc/block/dm/v4/
> 
> Looks simpler. Can do it.
> 
> But, I am little confused though. I do not see the underlying functions
> like dm_scsi_init/destroy_context_pool(), dm_scsi_execute_rq() etc., in
> 2.6.20/21-rc4 tree. Where is it available ?
> 

Do you look at the other patches in that dir?

> Also, dm-emc.c (in 2.6.20/21-rc4) doesn't seem to use that model.
> 

Did you see the other patches in that dir?

Also sorry about the miscommunication, I am not asking you to use
specifically those functions. Just do not allocate a bio yourself. There
is no need for you to do this if you are allocating it on the fly. If
you look at some of the Ed's other patches on the list you will see him
remove the bio code but not use my helpers.

> <snip>
>>> static void rdac_pg_init(struct hw_handler *hwh, unsigned bypassed,
>>> 			struct path *path)
>>> {
>>> 	struct rdac_handler *h = hwh->context;
>>>
>>> 	switch (h->lun) {
>>> 	case UNINITIALIZED_LUN:
>>> 		submit_c8_inquiry(h, path);
>>> 		break;
>>> 	case UNSUPPORTED_LUN:
>>> 		dm_pg_init_complete(path, MP_FAIL_PATH);
>>> 		break;
>>> 	default:
>>> 		submit_c9_inquiry(h, path);
>>> 	}
>>> }
>>>
>> Why not just have userspace check and pass the LUN to the create
>> function? This is not a review comment to do it. I am just asking if it
>> is difficult to gather info in userspace and pass it down?
> 
> It should be possible to get the inquiry page from user space and
> implement what you suggest. But, there is currently no storage device
> specific interface (like path checkers) to do this. We have to either
> add that interface or hack somewhere else(like path checkers) to do it.
> Do you think it is worth it ?
> 
> Also, is it possible to get the lun info from user space without getting
> the inquiry page ?

I am sure you have to search sysfs.

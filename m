From: Milan Broz <mbroz@redhat.com>
Subject: Re: [PATCH] kobj_uevent: Ignore if some listeners cannot handle message
Date: Mon, 22 Aug 2011 22:05:35 +0200
Message-ID: <4E52B68F.9020004@redhat.com>
References: <4E4ECA5D.1020907@redhat.com> <1314021094-15453-1-git-send-email-mbroz@redhat.com> <m1hb59w7k0.fsf@fess.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <m1hb59w7k0.fsf@fess.ebiederm.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com, kay.sievers@vrfy.org, greg@kroah.com
List-Id: dm-devel.ids

On 08/22/2011 09:49 PM, Eric W. Biederman wrote:
> Milan Broz <mbroz@redhat.com> writes:
> 
>> kobject_uevent() uses a multicast socket and should ignore
>> if one of listeners cannot handle messages or nobody is
>> listening at all.
>>
>> Easily reproducible when a process in system is cloned
>> with CLONE_NEWNET flag.
>>
>> (See also
>> http://article.gmane.org/gmane.linux.kernel.device-mapper.dm-crypt/5256)
> 
> I am fine with the patch below.
> 
> However if you are fine with the patch below let's just remove the
> return code from code from kobject_uevent_env.  We are now explicitly
> ignoring all of the possible return codes from
> netlink_broadcast_filtered.  

Until someone adds a new errno there, I think ESRCH appeared there
the same way:-)

I think the code is better readable now. Whatever, I do not care,
patch is intended to be minimalistic (perhaps for stable series as well now).

Thanks,
Milan

> 
> Ignoring all of the return codes from netlink_broadcast_filtered ignores
> all of the expected errors from kobject_uevent_env, short of programmer
> error.
> 
> So why have an error code on kobject_uevent_env?
> 
>> Signed-off-by: Milan Broz <mbroz@redhat.com>
>> ---
>>  lib/kobject_uevent.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/lib/kobject_uevent.c b/lib/kobject_uevent.c
>> index 70af0a7..ad72a03 100644
>> --- a/lib/kobject_uevent.c
>> +++ b/lib/kobject_uevent.c
>> @@ -282,7 +282,7 @@ int kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
>>  							    kobj_bcast_filter,
>>  							    kobj);
>>  			/* ENOBUFS should be handled in userspace */
>> -			if (retval == -ENOBUFS)
>> +			if (retval == -ENOBUFS || retval == -ESRCH)
>>  				retval = 0;
>>  		} else
>>  			retval = -ENOMEM;

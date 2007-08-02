From: "Wood, Brian J" <brian.j.wood@intel.com>
Subject: RE: Segmentation Fault Question
Date: Thu, 2 Aug 2007 15:03:14 -0700
Message-ID: <D44F48C7D79D2943A073C8FA0F49A3CC012EEFB3@orsmsx418.amr.corp.intel.com>
References: <87myx9ipio.fsf@eriador.mornfall.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <87myx9ipio.fsf@eriador.mornfall.net>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

>-----Original Message-----
>From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On
>Behalf Of Petr Rockai
>Sent: Thursday, August 02, 2007 2:41 PM
>To: device-mapper development
>Subject: Re: [dm-devel] Segmentation Fault Question
>
>"Wood, Brian J" <brian.j.wood@intel.com> writes:
>
>> Hello everyone, I think I've found an issue in libdevmapper-event.c
that
>> is generating a segmentation fault condition for me during some
boundary
>> testing. I wanted to get some advice on how the patch I'm going to
make
>> should fix this. Here's the snippet that leads to the segfault:
>Hi. Great that someone is giving a run to this part of the API...
>
>> In the file libdevmapper-event.c at line 722 the _get_device_info()
call
>> can return NULL to dmt on failure. This causes the leap to the "fail"
>> label where the null pointer is passed into dm_task_destroy().
>Good catch, yes, i have overlooked that problem, blindly assuming
>free() semantics (ie, NULL pointers accepted). Also, since the first
>instance of _get_device_info(...) failure is handled by return 0, i
>may have assumed that it's always valid at that point. There's even
>more bogosity in the code, looking at it now, since there's a call to
>dm_task_destroy(dmt); on line 708 and a possible goto fail after that,
>which calls dm_task_destroy twice on the same pointer (which looks
>like a bad thing). I have commited a fix to cvs, please update -- i
>think it fixes the problem, but i only tried to compile it, not to
>reproduce. If you encounter any further problems with this, please
>yell.
>
>[snip]
>>       fail:
>> 	if (msg.data)
>> 		dm_free(msg.data);
>> 	if (reply_dso)
>> 		dm_free(reply_dso);
>> 	if (reply_uuid)
>> 		dm_free(reply_uuid);
>> 	_dm_event_handler_clear_dev_info(dmevh);
>> 	dm_task_destroy(dmt);
>[snip]
>> My question is should the patch insert a test condition of the
pointer
>> before using it in the "for" loop (which is where I want to put the
>> fix)? Or is there another preferred way the maintainers of
device-mapper
>> would like to handle error checking in this case?
>
>I'd say fixing the caller is good enough. Although making
>dm_task_destroy return silently if it gets a NULL pointer would be an
>option, too. I'll let that decision to someone else though :-).
>
>Yours, Peter.
>
>PS: I haven't forgotten about your other report, i've gotten it marked
>as TODO, somehow i managed to not fix it yet. Soon...

Is that the UUID issue I sent in a while back? About how I can't
register dmraid devices since they aren't being given a UUID...I hope so
I thought everyone forgot about me. :-P

Thanks again, I'll pull down the latest from CVS and give that change a
try.


Brian Wood
Intel Corporation=20
Digital Enterprise Group
Manageability & Platform Software Division
brian.j.wood@intel.com


>
>--
>Peter Rockai | me()mornfall!net | prockai()redhat!com
> http://blog.mornfall.net | http://web.mornfall.net
>
>"In My Egotistical Opinion, most people's C programs should be
> indented six feet downward and covered with dirt."
>     -- Blair P. Houghton on the subject of C program indentation
>
>--
>dm-devel mailing list
>dm-devel@redhat.com
>https://www.redhat.com/mailman/listinfo/dm-devel

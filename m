From: Petr Rockai <prockai@redhat.com>
Subject: Re: Segmentation Fault Question
Date: Thu, 02 Aug 2007 23:40:31 +0200
Message-ID: <87myx9ipio.fsf@eriador.mornfall.net>
References: <D44F48C7D79D2943A073C8FA0F49A3CC012EECCA@orsmsx418.amr.corp.intel.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <D44F48C7D79D2943A073C8FA0F49A3CC012EECCA@orsmsx418.amr.corp.intel.com>
	(Brian J. Wood's message of "Thu, 2 Aug 2007 10:38:43 -0700")
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

"Wood, Brian J" <brian.j.wood@intel.com> writes:

> Hello everyone, I think I've found an issue in libdevmapper-event.c that
> is generating a segmentation fault condition for me during some boundary
> testing. I wanted to get some advice on how the patch I'm going to make
> should fix this. Here's the snippet that leads to the segfault:
Hi. Great that someone is giving a run to this part of the API...

> In the file libdevmapper-event.c at line 722 the _get_device_info() call
> can return NULL to dmt on failure. This causes the leap to the "fail"
> label where the null pointer is passed into dm_task_destroy(). 
Good catch, yes, i have overlooked that problem, blindly assuming
free() semantics (ie, NULL pointers accepted). Also, since the first
instance of _get_device_info(...) failure is handled by return 0, i
may have assumed that it's always valid at that point. There's even
more bogosity in the code, looking at it now, since there's a call to
dm_task_destroy(dmt); on line 708 and a possible goto fail after that,
which calls dm_task_destroy twice on the same pointer (which looks
like a bad thing). I have commited a fix to cvs, please update -- i
think it fixes the problem, but i only tried to compile it, not to
reproduce. If you encounter any further problems with this, please
yell.

[snip]
>       fail:
> 	if (msg.data)
> 		dm_free(msg.data);
> 	if (reply_dso)
> 		dm_free(reply_dso);
> 	if (reply_uuid)
> 		dm_free(reply_uuid);
> 	_dm_event_handler_clear_dev_info(dmevh);
> 	dm_task_destroy(dmt);
[snip]
> My question is should the patch insert a test condition of the pointer
> before using it in the "for" loop (which is where I want to put the
> fix)? Or is there another preferred way the maintainers of device-mapper
> would like to handle error checking in this case?

I'd say fixing the caller is good enough. Although making
dm_task_destroy return silently if it gets a NULL pointer would be an
option, too. I'll let that decision to someone else though :-).

Yours, Peter.

PS: I haven't forgotten about your other report, i've gotten it marked
as TODO, somehow i managed to not fix it yet. Soon...

-- 
Peter Rockai | me()mornfall!net | prockai()redhat!com
 http://blog.mornfall.net | http://web.mornfall.net

"In My Egotistical Opinion, most people's C programs should be
 indented six feet downward and covered with dirt."
     -- Blair P. Houghton on the subject of C program indentation

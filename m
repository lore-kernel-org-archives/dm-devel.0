From: Peter Rockai <prockai@redhat.com>
Subject: Re: Question about dmevents
Date: Sun, 22 Jul 2007 10:53:41 +0200
Message-ID: <20070722085341.GB9301@mornfall.net>
References: <D44F48C7D79D2943A073C8FA0F49A3CC0122629E@orsmsx418.amr.corp.intel.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <D44F48C7D79D2943A073C8FA0F49A3CC0122629E@orsmsx418.amr.corp.intel.com>
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

On Fri, Jul 20, 2007 at 09:02:18AM -0700, Wood, Brian J wrote:
> After this long setup here's the problem I'm having. I run through the
> remaining function calls in _get_device_info() and my uuid for the
> dm_task is still null. The last call before sending this message off to
> dmeventd using the "_do_event()" is a call to dm_task_get_uuid() that is
> passed my dm_task struct. This should return a uuid string, but returns
> null since my dm_task is never getting a uuid set. Without this I get a
> failure on the dmeventd side stating I passed a null pointer into
> dm_strdup via the function _alloc_thread_status (where it checks the
> uuid field). 

This is indeed a bug in the code, first that libdevmapper-event fails
to check that the uuid it tries to use is valid (ie., it assumes that
whenever dm_task asking DM_DEVICE_INFO succeeds, it has a valid UUID,
which seems to be not the case). This needs fixing, as well as
dmeventd, which apparentlty breaks down on an invalid message (i have
to test this though).

In the meantime, please make sure you are only registering devices
that do have UUID (you don't need to supply it, it just needs to be
there in the device mapper info). In a future version, the code should
fail gracefully in case the UUID is not available.

Yours, Peter.

-- 
Peter Rockai | me()mornfall!net | prockai()redhat!com
 http://blog.mornfall.net | http://web.mornfall.net

"In My Egotistical Opinion, most people's C programs should be
 indented six feet downward and covered with dirt."
     -- Blair P. Houghton on the subject of C program indentation

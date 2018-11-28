From: Martin Wilck <mwilck@suse.de>
Subject: Re: [PATCH 2/2] libmultipath: fix false removes in
 dmevents polling code
Date: Wed, 28 Nov 2018 10:08:45 +0100
Message-ID: <4086b28c150ffbfc0cfd9a856bac05262bf3a529.camel@suse.de>
References: <1543385604-25453-1-git-send-email-bmarzins@redhat.com>
	<1543385604-25453-2-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1543385604-25453-2-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, 2018-11-28 at 00:13 -0600,  Benjamin Marzinski  wrote:
> dm_is_mpath() would return 0 if either a device was not a multipath
> device or if the libdevmapper command failed. Because dm_is_mpath()
> didn't distinguish between these situations, dm_get_events() could
> assume that a device was not really a multipath device, when in fact
> it
> was, and the libdevmapper command simply failed. This would cause the
> dmevents polling waiter to stop monitoring the device.
> 
> In reality, the call to dm_is_mpath() isn't necessary, because
> dm_get_events() will already verify that the device name is on the
> list
> of devices to wait for. However, if there are a large number of
> non-multipath devices on the system, ignoring them can be
> useful.  Thus,
> if dm_is_mpath() successfully runs the libdevmapper command and
> verifies
> that the device is not a multipath device, dm_get_events() should
> skip
> it. But if the libdevmapper command fails, dm_get_events() should
> still
> check the device list, to see if the device should be monitored.
> 
> This commit makes dm_is_mpath() return -1 for situations where
> the libdevmapper command failed, and makes dm_get_events() only
> ignore
> the device on a return of 0.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---

Two minor remarks:

1. You've changed dm_is_mpath() calls from "if (!result)" to 
"if (result == 0)" or "if (result != 1)" syntax, but you missed the
call in watch_dmevents(). I suggest that, for clarity, you change that
one as well.

2. We should add a condlog(2,...) to dm_is_mpath() if it returns -1.

Otherwise, ACK.

Martin

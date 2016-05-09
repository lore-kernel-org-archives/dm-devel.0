From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 4/6] libmultipath: Fixup 'DM_DEVICE_RELOAD'
	handling
Date: Mon, 9 May 2016 12:26:36 +0200
Message-ID: <573065DC.8060909@suse.de>
References: <1462341450-5507-1-git-send-email-hare@suse.de>
	<1462341450-5507-5-git-send-email-hare@suse.de>
	<20160506201240.GU26117@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160506201240.GU26117@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

On 05/06/2016 10:12 PM, Benjamin Marzinski wrote:
> On Wed, May 04, 2016 at 07:57:28AM +0200, Hannes Reinecke wrote:
>> libdevmapper has the 'quirk' that DM_DEVICE_CREATE is translated
>> internally into a create/load/resume sequence, and the associated
>> cookie will wait for the last 'resume' to complete.
>> However, DM_DEVICE_RELOAD has no such translation, so if there
>> is a cookie assigned to it the caller _cannot_ wait for it,
>> as the cookie will only ever be completed upon the next
>> DM_DEVICE_RESUME.
>> multipathd already has some provisions for that (but even there
>> the cookie handling is dodgy), but 'multipath -r' doesn't know
>> about this.
>> So to avoid any future irritations this patch updates the
>> dm_addmad_reload() call to handle the cookie correctly,
>> and removes the special handling from multipathd.
> =

> I don't see what's multipathd specific about any of the handling here.
> The real answer is that device-mapper does nothing with cookies on
> table reload. We should never be calling dm_task_set_cookie() for =

> dm_addmap(DM_DEVICE_RELOAD, ...) calls in the first place. We end up
> creating a cookie, decrementing the cookie, incrementing the cookie, and
> finally waiting on it, when we could just be creating a cookie and then
> waiting on it.
> =

> It's kind of hard to find an easy to show example of this breaking. You
> would need to have the dm_addmap() command fail with some other error than
> EROFS.  If that happens, the dm_simplecmd() call will never happen, and
> there will be a cookie sitting around on the system.  If we never added
> a cookie to the task in dm_addmap(DM_DEVICE_RELOAD, ...), then there
> wouldn't be this cookie sitting around.
> =

But then ... how is this supposed to work?
Are we supposed to call DM_DEVICE_RESUME even after DM_DEVICE_RELOAD
failed?
None of the other callers do that ...

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)

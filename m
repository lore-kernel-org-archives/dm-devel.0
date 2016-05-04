From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 56/57] multipathd: push down lock in
 checkerloop()
Date: Wed, 4 May 2016 08:40:40 +0200
Message-ID: <57299968.4080509@suse.de>
References: <1461755458-29225-1-git-send-email-hare@suse.de>
	<1461755458-29225-57-git-send-email-hare@suse.de>
	<20160503221734.GJ26117@octiron.msp.redhat.com>
	<20160503232428.GK26117@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160503232428.GK26117@octiron.msp.redhat.com>
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
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

On 05/04/2016 01:24 AM, Benjamin Marzinski wrote:
> On Tue, May 03, 2016 at 05:17:34PM -0500, Benjamin Marzinski wrote:
>> On Wed, Apr 27, 2016 at 01:10:57PM +0200, Hannes Reinecke wrote:
>>> Instead of grabbing the lock at the start of the checkerloop
>>> and releasing it at the end we should be holding it only
>>> during the time when we actually need it.
>>
>> I'm pretty sure that this can cause crashes if multipathd reconfigures
>> when it's just started servicing a uevent. It goes like this. The
>> uevq_thr thread calls uev_trigger(), which checks the running_state and
>> sees that it's DAEMON_IDLE.  The uxlsnr_thr thread gets a
>> reconfiguration request, which eventually calls set_config_state().
>> set_config_state() sees the state is DAEMON_IDLE, sets it to
>> DAEMON_CONFIGURE, and returns without waiting.  This wakes up the child
>> thread, which runs reconfigure().  reconfigure() sets conf to NULL. Then
>> the uevq_thr thread in uev_trigger() calls filter_devnode()
>> dereferencing conf->blist_devnode and conf->elist_devnode. conf is NULL,
>> and thus it crashes.
>>
>> The short version is that multipathd has been using the vecs lock to
>> protect conf.  With your change to uev_trigger, you access conf outside
>> of the vecs lock. This isn't a problem in checkerloop(), since you can't
>> reconfigure while multipathd is in the DAEMON_RUNNING state, so that is
>> protecting conf. You need to do the same
>> set_config_state(DAEMON_RUNNING) in uev_trigger to make this safe.
> =

> Or not. ev_add_map calls set_config_state(DAEMON_CONFIGURE), so this
> would deadlock if you called  set_config_state(DAEMON_RUNNING) in
> uev_trigger. At any rate, either reconfigures need to be blocked while
> running uev_trigger, or we need some sort of reference counting on the
> config structure so that we don't free it when we do a reconfigure,
> until everyone has switched to the new structure.
> =

See my previous reply. We can easily move the call to
filter_devnode() so that it'll be called with the vector lock held.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)

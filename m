From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 30/57] multipathd: skip uninitialized devices
 during reconfiguration
Date: Tue, 3 May 2016 08:04:32 +0200
Message-ID: <57283F70.3060709@suse.de>
References: <1461755458-29225-1-git-send-email-hare@suse.de>
	<1461755458-29225-31-git-send-email-hare@suse.de>
	<20160502191407.GT26117@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160502191407.GT26117@octiron.msp.redhat.com>
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

On 05/02/2016 09:14 PM, Benjamin Marzinski wrote:
> On Wed, Apr 27, 2016 at 01:10:31PM +0200, Hannes Reinecke wrote:
>> libudev has a separate filter setting to skip uninitialized
>> devices during enumeration.
> =

> So, I assume if udev filters out a device here, it's because a uevent
> should be coming when the device is fully initialized. correct?
> =

Correct.

> The only thing I worry about with taking out all of the backup stuff is
> what happens if udev simply times out processing an event, and doesn't
> grab the UUID.  In this case we still won't get a UUID unless we force
> another event, or grab the information ourselves.
> =

Well, but we won't be seeing the event, either.
(If udev has timed out an event it won't be processed further, so it
will never show up on the udev event queue.)

However, there is a reason why I posted all work-arounds we've queued
together with this patch.

In the end, the udev integration stuff has fanned out across several
patches, where it's now really hard to figure out which bits are really
required.
So I'd prefer to leave them in; we can always remove them later.

> But ACK on the patch itself.
> =

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)

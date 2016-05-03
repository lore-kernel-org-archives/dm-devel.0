From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 49/57] multipathd: do not flush maps on
	startup
Date: Tue, 3 May 2016 08:35:14 +0200
Message-ID: <572846A2.3080103@suse.de>
References: <1461755458-29225-1-git-send-email-hare@suse.de>
	<1461755458-29225-50-git-send-email-hare@suse.de>
	<20160503023019.GY26117@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160503023019.GY26117@octiron.msp.redhat.com>
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
Cc: dm-devel@redhat.com, Hannes Reinecke <hare@suse.com>, Mike Snitzer <snitzer@redhat.com>, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

On 05/03/2016 04:30 AM, Benjamin Marzinski wrote:
> On Wed, Apr 27, 2016 at 01:10:50PM +0200, Hannes Reinecke wrote:
>> When the daemon is started prior to udev the paths are not present
>> (yet). However, the maps themselves will be read from device-mapper.
>> This causes existing maps to be dropped in coalesce_maps(), only
>> to be reinstated later when all paths are discovered.
>> To avoid this we should be checking for a valid hardware entry
>> per multipath map; if there is none we're in startup and shouldn't
>> drop any maps.
> =

> This doesn't just skip maps when udev hasn't started yet.  It skips any
> blacklisted maps.  For instance, if you create some multipath devices,
> add the lines
> =

> blacklist {
> 	devnode ".*"
> }
> =

> to /etc/multipath.conf, and restart or reload multipathd, all the
> blacklisted devices are still there.
> =

> NAK
> =

Okay, I'll remove this patch when I'm resending the patchset.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)

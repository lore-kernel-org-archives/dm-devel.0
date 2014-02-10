From: Hannes Reinecke <hare@suse.de>
Subject: root on multipath and dracut
Date: Mon, 10 Feb 2014 14:30:56 +0100
Message-ID: <52F8D490.8000500@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Harald Hoyer <harald@redhat.com>
List-Id: dm-devel.ids

Hi Ben,

as we're switching to dracut/systemd nowadays I've tried to setup
and enable root on multipath for this, too.

As you might've seen, I've already added proper systemd support for
multipath-tools, so it should be easy to plug it into dracut.

Or so I thought.

As it turns out, dracut is trying to add some RH-specific rules files:

40-multipath.rules
62-multipath.rules
65-multipath.rules

which have only _very_ sparse documentation.
Wouldn't it be a good idea to settle on a default set on scripts
here and include those into the multipath-tools repository?

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)

From: Hannes Reinecke <hare@suse.de>
Subject: Re: multipath-tools release coming
Date: Mon, 09 Dec 2013 13:31:36 +0100
Message-ID: <52A5B828.408@suse.de>
References: <529BB8C3.5080606@gmail.com>	<529C2F47.60004@suse.de>
	<CABr-GncQNY=F8RuvqQ1ycVtHZdy6QDU9hLr3Uz=ZvLUadv9KFA@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CABr-GncQNY=F8RuvqQ1ycVtHZdy6QDU9hLr3Uz=ZvLUadv9KFA@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 12/07/2013 07:48 AM, Christophe Varoqui wrote:
> Ben,
> =

> do you still have issues with the watchdog part of Hannes patchset ?
> If so, may be we can make it activable by a multipathd start-up
> parameter set in the the unit file command.
> =

Sadly, it's not that easy.

Whenever the user enables the watchdog feature via the systemd
unit file the program _has_ to respond to it; otherwise it'll
be stopped

So the watchdog integration has to stay, but we can make that
optional from the code if no watchdog functionality has been
requested from systemd.

That way the code will run unaffected and the watchdog-specific
parts will only be used when the user has activated the watchdog
from the systemd unit file.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)

From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 55/57] multipathd: asynchronous configuration
Date: Wed, 4 May 2016 08:47:48 +0200
Message-ID: <57299B14.1030309@suse.de>
References: <1461755458-29225-1-git-send-email-hare@suse.de>
	<1461755458-29225-56-git-send-email-hare@suse.de>
	<20160503182534.GH26117@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160503182534.GH26117@octiron.msp.redhat.com>
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

On 05/03/2016 08:25 PM, Benjamin Marzinski wrote:
> On Wed, Apr 27, 2016 at 01:10:56PM +0200, Hannes Reinecke wrote:
> =

> Oh, I did have one other thought.
> =

> If you're not changing the signal mask in uevent_listen, can't you just
> use poll?  Otherwise people are going to try and figure out what's going
> on with the signals that they're missing (at least that's what I did).
> =

Sure. Don't have any issue with that.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)

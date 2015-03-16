From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 0/3][RESEND] resending find_multipaths patches
Date: Mon, 16 Mar 2015 08:54:43 +0100
Message-ID: <55068C43.8060401@suse.de>
References: <1426271247-21345-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1426271247-21345-1-git-send-email-bmarzins@redhat.com>
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
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

On 03/13/2015 07:27 PM, Benjamin Marzinski wrote:
> I'm resending my find_multipaths patch, based on the conversation I had
> here. If nothing else, I'd at least like a discussion about why these
> shouldn't go in.
> =

> http://www.redhat.com/archives/dm-devel/2014-July/msg00029.html
> =

> Just to clarify. find_multipaths is a configurable option that when set to
> 'yes' will make multipath only run on devices have more than one path.  T=
his
> means that users can mostly leave the blacklist alone, and they will only=
 get
> the multipath devices that they want. The only time the blacklist is nece=
ssary
> is when users actually have multiple paths to a device, but still don't w=
ant
> multipath set up on it.  It's been around since RHEL6, and it is turned on
> in the default multipath.conf file in RHEL7. The internal default is "off=
".
> =

> Hannes, do you still object to these?
> =

> Benjamin Marzinski (3):
>   add find_multipaths option
>   libmultipath: only add uninitialized paths in check_path
>   Add find_multipaths to multipath.conf man page
> =

>  libmultipath/config.c      |  1 +
>  libmultipath/config.h      |  1 +
>  libmultipath/configure.c   | 11 +++++++++++
>  libmultipath/defaults.h    |  1 +
>  libmultipath/dict.c        |  4 ++++
>  libmultipath/discovery.c   |  2 ++
>  libmultipath/structs.h     |  1 +
>  libmultipath/wwids.c       | 26 ++++++++++++++++++++++++++
>  libmultipath/wwids.h       |  1 +
>  multipath/main.c           | 27 +++++++++++++++++++++++++--
>  multipath/multipath.conf.5 | 22 ++++++++++++++++++++++
>  multipathd/main.c          |  9 +++++++++
>  12 files changed, 104 insertions(+), 2 deletions(-)
> =

Patchset is fine now. We've discussed all the issues already, and
from my side this should be okay.

Acked-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)

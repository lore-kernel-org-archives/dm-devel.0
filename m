From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 07/10] recover from errors in multipathd
 startup
Date: Sun, 30 Oct 2016 14:47:43 +0100
Message-ID: <f483d488-80f5-c234-c301-5a545c320f5c@suse.de>
References: <1477709726-5442-1-git-send-email-bmarzins@redhat.com>
	<1477709726-5442-8-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1477709726-5442-8-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On 10/29/2016 04:55 AM, Benjamin Marzinski wrote:
> When multipathd does it's initial configuration during startup, it fails
> the daemon for many errors that it would simply recover from if they
> occured when adding paths or maps later.  It should recover from these
> errors during startup as well.  Also, if multipathd hits a
> nonrecoverable error, it should log a message before quitting.
>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/configure.c |  8 +++++---
>  multipathd/main.c        | 45 ++++++++++++++++++++++++++++++++----------=
---
>  2 files changed, 37 insertions(+), 16 deletions(-)
>
Very nice.

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)

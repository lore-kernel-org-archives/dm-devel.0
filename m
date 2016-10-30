From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 08/10] fix INIT_REQUESTED_UDEV code
Date: Sun, 30 Oct 2016 14:48:54 +0100
Message-ID: <b277e310-04d2-6848-73d1-4d8ff5ae0b6c@suse.de>
References: <1477709726-5442-1-git-send-email-bmarzins@redhat.com>
	<1477709726-5442-9-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1477709726-5442-9-git-send-email-bmarzins@redhat.com>
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

On 10/29/2016 04:55 AM, Benjamin Marzinski wrote:
> uev_update_path was not checking pp->initialized to see if multipathd
> had requested that the path be reinitialized unless the path's read-only
> state had changed.  This kept the reinitialization code from running in
> most cases where it was supposed to. This patch reorders the function to
> move that check outside the read-only status change code block. This
> does mean that uev_update_path now always grabs the vecs lock, where
> before it would only be grabbed if the read-only status had changed. If
> people are worried about this, I can add some code to limit this so that
> uev_update_path will only grab it if there is a chance that it needs to
> reinitialize the path.
>
> Cc: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  multipathd/main.c | 54 +++++++++++++++++++------------------------------=
-----
>  1 file changed, 19 insertions(+), 35 deletions(-)
>
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)

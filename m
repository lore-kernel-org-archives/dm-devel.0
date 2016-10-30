From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 04/10] multipathd: add "map failures" format
 wildcard
Date: Sun, 30 Oct 2016 14:45:30 +0100
Message-ID: <11d54158-fc3b-863a-b22a-e6fd31bf2bf9@suse.de>
References: <1477709726-5442-1-git-send-email-bmarzins@redhat.com>
	<1477709726-5442-5-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1477709726-5442-5-git-send-email-bmarzins@redhat.com>
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
> This patch adds a new wildcard, 'x', for the "show maps format" command.
> This wildcard show the number of map failures that have occurred. A map
> failure is any time that the multipath device enters a state where it
> has no paths and is not set to queue_if_no_paths. It can be used to see
> if a multipath device was ever in a state were it could fail IO errors
> up.
>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/print.c       |  7 +++++++
>  libmultipath/structs.h     |  1 +
>  libmultipath/structs_vec.c | 28 ++++++++++++++++------------
>  multipathd/cli_handlers.c  | 11 ++++++++++-
>  multipathd/main.c          |  2 ++
>  5 files changed, 36 insertions(+), 13 deletions(-)
>
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)

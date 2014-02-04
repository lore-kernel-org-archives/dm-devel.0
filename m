From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v6 0/7] dm-multipath: push back requests
	instead of queueing
Date: Tue, 04 Feb 2014 08:23:15 +0100
Message-ID: <52F09563.5050407@suse.de>
References: <1391459326-21569-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1391459326-21569-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Junichi Nomura <j-nomura@ce.jp.nec.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Mike,

On 02/03/2014 09:28 PM, Mike Snitzer wrote:
> Hi Hannes,
> =

> I went over all of your patches and made a few tweaks, comments, and
> improvements along the way.  Patch headers were modified very
> slightly.
> =

> I wasn't seeing the need for (m->queue_io << 1) + m->queue_if_no_path
> in v5's "[PATCH 3/6] dm-multipath: push back requests instead of
> queueing" so I simplified that and documented the change in the
> header.  If there is a reason for what you had please explain.
> =

'queue_io' is just used as a marker that I/O should be queued as
pg_init is running. The intention of the stacked status was so that
one could figure out by 'dmsetup status' whether I/O will be blocked
or not. And for that you'd need both, 'queue_io' and 'queue_if_no_path'.

But thanks for the rework.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)

From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/3] libmultipath: replace PATH_TIMEOUT with
	PATH_DOWN
Date: Mon, 06 Oct 2014 16:35:02 +0200
Message-ID: <5432A896.5040205@suse.de>
References: <1412381483-15757-1-git-send-email-bmarzins@redhat.com>
	<1412381483-15757-2-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1412381483-15757-2-git-send-email-bmarzins@redhat.com>
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

On 10/04/2014 02:11 AM, Benjamin Marzinski wrote:
> The way the code works, PATH_TIMEOUT is treated mostly like PATH_UP or
> PATH_GHOST by check_path.  If the the path was previously failed,  it will
> even reinstate the path. It will also trigger prio refreshing. It seems
> that PATH_TIMEOUT should be at least as serious as PATH_PENDING, but the
> way the code works, it's not.  In pathinfo, PATH_TIMEOUT gets changed
> directly to PATH_DOWN, which makes sense.  But assuming that's the correct
> thing to do, why have PATH_TIMEOUT at all?
> =

Because a timeout is different from a normal path down.
Timeout means the tur checker is stuck somehow.
And we currently have no real means of resetting it (aio_cancel
doesn't really abort the I/O, is just short-circuit the callback).

So the intention of this patch was that we want to get notified if
a TUR timeout occurs, as this might lead to other subsequent errors.

> The only thing that it does that seems helpful is that when you print out
> the path, instead of it saying that the path is down, it says that the
> path has timed out.  But if we are going to treat is like the path is
> down, then I don't see this being too helpful.  And the way we are treati=
ng
> PATH_TIMEOUT right now is definitely not right.
> =

See above. I really would like to be notified for PATH_TIMEOUT
scenarios ...

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)

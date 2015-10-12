From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 03/18] multipathd: use /run instead of
	/var/run
Date: Mon, 12 Oct 2015 08:37:21 +0200
Message-ID: <561B5521.3060500@suse.de>
References: <1444333491-16265-1-git-send-email-bmarzins@redhat.com>
	<1444333491-16265-4-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1444333491-16265-4-git-send-email-bmarzins@redhat.com>
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

On 10/08/2015 09:44 PM, Benjamin Marzinski wrote:
> /var/run is usually a symlink to /run.  If /var is on a separate
> filesytem, when multipathd starts up, it might end up writing to
> /var/run before the /var filesytem is mounted and thus not have
> its pidfile accessible at /var/run afterwards.  /run is a tmpfs and
> should always be available before multipathd is started, so
> multipath should just write there directly, instead of through the
> symlink.
> =

> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
???

What now?

First we've been told by the systemd folks that using / directly is
evil, and everything needs to be moved to /var or /usr.

Now we should have to move it back?

Is there a reference for this?

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)

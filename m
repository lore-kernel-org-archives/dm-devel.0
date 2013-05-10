From: Hannes Reinecke <hare@suse.de>
Subject: Re: [git pull] device-mapper updates for 3.10
Date: Fri, 10 May 2013 12:32:29 +0200
Message-ID: <518CCCBD.7050609@suse.de>
References: <20130510102029.GE1396@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20130510102029.GE1396@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On 05/10/2013 12:20 PM, Alasdair G Kergon wrote:
> Please pull from:
> =

>   git://git.kernel.org/pub/scm/linux/kernel/git/agk/linux-dm tags/dm-3.10=
-changes
> =

> to get the following device-mapper updates for 3.10.
> =

Please consider folding in

"dm-multipath: Drop table when retrying ioctl"

that fixes a rather nasty multipath deadlock.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)

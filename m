From: Hannes Reinecke <hare@suse.de>
Subject: Re: multipathd: 8:80 mark as failed - BUG: unable to
 handle kernel NULL pointer dereference at (null)
Date: Fri, 18 May 2012 07:55:39 +0200
Message-ID: <4FB5E45B.3020309@suse.de>
References: <4FB4CB5E.9040600@libero.it>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4FB4CB5E.9040600@libero.it>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 05/17/2012 11:56 AM, Roberto Giordani wrote:
> Hello,
> I've compiled and installed on January on Opensuse 11.4 x64 from
> git://git.kernel.org/pub/scm/linux/storage/multipath/hare/multipath-tools=
.git
> the multipath-tools but previous 14 of May the module hang as
> described below.
> Now I've got
> git-clone -b sles11-sp2
> git://git.kernel.org/pub/scm/linux/storage/multipath/hare/multipath-tools=
.git
> .
> and reinstalled, but I'd like to know if this problem was already
> resolved.
> =

Yeah, sorry, I need to update multipath-tools for OpenSUSE 11.4
onwards. Working on it.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)

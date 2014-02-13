From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] libmultipath: Don't chop const strings
Date: Thu, 13 Feb 2014 08:43:23 +0100
Message-ID: <52FC779B.6000800@suse.de>
References: <1392222110-13324-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1392222110-13324-1-git-send-email-bmarzins@redhat.com>
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

On 02/12/2014 05:21 PM, Benjamin Marzinski wrote:
> multipath was chopping sysfs attr strings in order to make sure that
> ending whitespace didn't cause them to overflow their buffer. However
> those strings were const strings. This patch makes multipath check how
> much of the string length is ending whitespace, so that it can tell if
> it will really overflow the buffer without chopping the const string.
> =

> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Yeah, you are correct.
I actually have a similar patch, but didn't manage to send it upstream.

So:

Acked-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)

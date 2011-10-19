From: Hannes Reinecke <hare@suse.de>
Subject: Re: [RFC][PATCH] dm-cache (block level disk cache
 target): UPDATE
Date: Wed, 19 Oct 2011 10:34:26 +0200
Message-ID: <4E9E8B92.5050204@suse.de>
References: <CAGWyFtpaHvgDVV6DrM8L18eiDGrTL=teH6TZqfJNpwafE+-Big@mail.gmail.com>
	<CAGWyFtpLuciqc7Q=2GfnkBrQCRoq91qh2RwWby7UhEAEcZkCbQ@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAGWyFtpLuciqc7Q=2GfnkBrQCRoq91qh2RwWby7UhEAEcZkCbQ@mail.gmail.com>
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

On 10/18/2011 10:48 PM, Stephen Bromfield wrote:
> A new patch for the 2.6.39 kernel.
>
> Signed-off-by: Ming Zhao<dm-cache@googlegroups.com>
>
Hmm? This is implementation #1 out of three.
And, incidentally, the least maintained; 2.3.39 isn't exactly the =

most recent kernel.

(Otherwise one does wonder why Ming Zhao hasn't posted it himself).
(Incidentally, can we have a rule that the person sending a patch =

_has_ to be listed as 'Signed-off-by', ie has to be the one actually =

working on it?)

flashcache and that one from Tao Ma & Coly Li are the other two =

versions of the same beast, all sharing the same codebase.

Not to mention my (slightly different) implementation which I'll be =

presenting at LinuxCon Europe next week.

So maybe, just maybe, we should get out heads together and discuss =

the merits and shortcomings of the various implementations.
And decide on a single implementation, not 4. Or a framework =

allowing for all these variances.

But so it's hard to see why this implementation should go upstream =

and none of the others.

And I somehow doubt Alasdair would agree on having several =

implementations on the same topic.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)

From: Hannes Reinecke <hare@suse.de>
Subject: Re: [RFC PATCH 0/7] dm-mpath: Do not clone requests
Date: Thu, 05 Jun 2014 15:55:29 +0200
Message-ID: <539076D1.9000704@suse.de>
References: <1401973867-121561-1-git-send-email-hare@suse.de>
	<20140605133626.GA7149@infradead.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140605133626.GA7149@infradead.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Mike Christie <michaelc@cs.wisc.edu>, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On 06/05/2014 03:36 PM, Christoph Hellwig wrote:
> Oh, you're not even cloning the request.  I though you'd just avoid
> cloning the bios.  Passing the requests through isn't going to work
> when sitting on top of a blk-mq driver.
>
Ok, might be.

It just seemed the obvious thing to do. But if there are arguments
against it one should rework that bit.

> I have a queue I'm trying to start to test now that approaches this
> a little bit differently:
>
>   - request based dm is converted to use blk-mq itself, allowing us to
>     allocate private data as part of the incoming request, and gets
>     rid of the nasty prep_fn/request_fn split
>   - it then just allocates a new request on the underlying device after
>     chosing the path.  By using blk_get_request to allocate the lower
>     request dm-mpath doesn't care if the underlying device uses blk-mq
>     or not.
>
> As said I'm already running into issues with plain dm mpath in my
> trivial test setup, so this is stalled for the moment.
>
> But I'd still love to understand why dm even bothers cloning the bios.
> At the request layer we only touch the bios in two places: first
> for merging in into the request, and second in blk_update_request.
>
> Now with dm-mpath we'd never want to do this sort of merging for the
> lower request anyway, and I don't see a real problem keeting the lower
> driver complete the bio and just never call blk_update_request in
> dm-mpath either.  At least that's my impression that hasn't made contact
> with the ugly reality yet..
>
And which was precisely why I haven't continued with this patchset, too.
The primary reason for cloning the bios would from my POV would be =

so that we can handle partial completion properly. When eliminating =

it we would be always return an error here.
But then one does wonder whether a partial completion shouldn't be =

considered an error anyway.
I've never felt comfortable with that bit in the stack, and tried to =

shirk it as much as possible.

Maybe Mike C. has some ideas here; I seem to remember he once worked =

on that code ...

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)

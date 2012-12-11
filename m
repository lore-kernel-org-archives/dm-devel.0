From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: [PATCH 0/3] add resync speed control for dm-raid1
Date: Tue, 11 Dec 2012 09:56:45 +0100
Message-ID: <20121211085645.GH32224@suse.de>
References: <1353565673-4233-1-git-send-email-gzhao@suse.com>
	<20121210132123.5a4ab015@notabene.brown>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20121210132123.5a4ab015@notabene.brown>
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
Cc: gzhao@suse.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On 2012-12-10T13:21:23, NeilBrown <neilb@suse.de> wrote:

> The problem with this approach is that it slows down resync even when the=
re
> is no other IO happening.
> If that is deemed to be acceptable, then the patch set seems fine, though=
 I
> would probably make the default a lot higher so as not to change current
> default behaviour for anyone.

I agree to the latter part.

The difficulty is that our primary use case here is preventing IO
starvation while cluster raid is resyncing; and we don't know the IO
load on other nodes, or what other LVs might inflict on the same backend
store / PV. Hence, a static limit probably is the easiest way to
start.

I agree that a more dynamic approach would be desirable, but that
appears to be very complex to get right.


Thanks,
    Lars

-- =

Architect Storage/HA
SUSE LINUX Products GmbH, GF: Jeff Hawn, Jennifer Guild, Felix Imend=F6rffe=
r, HRB 21284 (AG N=FCrnberg)
"Experience is the name everyone gives to their mistakes." -- Oscar Wilde

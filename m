From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH v2 10/12] multipath.conf: add missing options
	to man page
Date: Tue, 19 Mar 2019 12:14:30 -0500
Message-ID: <20190319171430.GH13295@octiron.msp.redhat.com>
References: <1552086725-18476-1-git-send-email-bmarzins@redhat.com>
	<1552086725-18476-11-git-send-email-bmarzins@redhat.com>
	<b29cc9de6d94840ada4cd204cf88cb9fced0ac22.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <b29cc9de6d94840ada4cd204cf88cb9fced0ac22.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, Mar 15, 2019 at 12:49:26PM +0100, Martin Wilck wrote:
> On Fri, 2019-03-08 at 17:12 -0600, Benjamin Marzinski wrote:
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  multipath/multipath.conf.5 | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> > =

> =

> "getuid_callout" is still missing in the devices section.
> (yes, I actually checked every option :-)

Oops. I can add that one too.

-Ben
 =

> Regards,
> Martin
> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
> =

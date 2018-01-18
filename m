From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 1/2] remove delay_(watch|wait)_checks
Date: Thu, 18 Jan 2018 11:29:46 -0600
Message-ID: <20180118172946.GA5638@octiron.msp.redhat.com>
References: <1513188487-31852-1-git-send-email-bmarzins@redhat.com>
	<1515791340.3409.35.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1515791340.3409.35.camel@suse.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Guan Junxiong <guanjunxiong@huawei.com>
List-Id: dm-devel.ids

On Fri, Jan 12, 2018 at 10:09:00PM +0100, Martin Wilck wrote:
> Hi Ben,
> =

> On Wed, 2017-12-13 at 12:08 -0600, Benjamin Marzinski wrote:
> > These configuration options do essentially the same thing as the
> > marginal paths options do, but since they don't do the increased IO
> > testing, they are less likely to find the marginal paths. Guan, if
> > you
> > left these in for a reason (such as to deal with devices that don't
> > do
> > well with IO testing, such as passive paths) I'm open to keeping
> > them.
> > But it seems like the marginal paths options options do a better job
> > than they do, and if there are cases that they doesn't handle well,
> > they
> > should be expanded to do so.
> =

> I think we should wait a bit more before removing this stuff. The
> marginal paths code hasn't seen much testing yet AFAICS.

That's fine. There's no rush to remove them.

-Ben

> =

> Regards
> Martin
> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)

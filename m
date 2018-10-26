From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 17/21] libmultipath: pathinfo: don't blank
 wwid if checker fails
Date: Fri, 26 Oct 2018 10:11:20 -0500
Message-ID: <20181026151120.GE7100@octiron.msp.redhat.com>
References: <20181011222707.3631-1-mwilck@suse.com>
	<20181011222707.3631-18-mwilck@suse.com>
	<20181025215012.GZ7100@octiron.msp.redhat.com>
	<080fe2b6dde1b947b9d249276ce1e12b756018c3.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <080fe2b6dde1b947b9d249276ce1e12b756018c3.camel@suse.com>
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
Cc: mwilck+gmail@suse.de, dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Oct 26, 2018 at 11:16:23AM +0200, Martin Wilck wrote:
> On Thu, 2018-10-25 at 16:50 -0500,  Benjamin Marzinski  wrote:
> > On Fri, Oct 12, 2018 at 12:27:03AM +0200, Martin Wilck wrote:
> > > Blanking a WWID is a dangerous operation. E.g. configure() would
> > > consider the path in question as invalid and orphan it if the
> > > WWID is blank. Don't do this for possibly transient checker
> > > failures.
> > > Moreover, we try to determine WWID even if path_offline returns
> > > PATH_DOWN in the first place, so why should we not if the checker
> > > has a problem?
> > > =

> > =

> > Is PATH_WILD a transient error?  Clearly we have cases where
> > PATH_UNCHECKED happens because of a transient error. What's the case
> > that you are worried about where we temporarily get a PATH_WILD, but
> > we
> > think we should continue will setting up the path?
> =

> My mentioning of a "transient" error condition is misleading. =

> =

> But do I think that the patch is correct. In particular with the
> previous changes in the series, PATH_WILD would mean that the checker
> couldn't do it's job and simply has no information whether or not the
> path is good. IMO it is wrong not to try to obtain a WWID, or even
> blank an already retrieved WWID, in this case.
> =

> Do you disagree?

I guess the question is "Should we create a multipath device if we think
that it's likely misconfigured?" If there really are multiple paths,
then it makes sense that we should create the multipath device.  On the
other hand, if the checker is misconfigured and a path fails, multipathd
may not be able to restore it, and users might not find that out until
they actually have the path fail, if they aren't paying attention.

I guess I don't really have any strong feelings against your approach.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> =

> Regards,
> Martin
> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
> =

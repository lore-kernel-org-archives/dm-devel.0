From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [multipath-tools] [BUG] segfault in uev_update_path
Date: Tue, 4 Apr 2017 18:33:17 -0500
Message-ID: <20170404233317.GE19236@octiron.msp.redhat.com>
References: <D1E4D02760513D4B90DC3B40FF32AF35A101A786@H3CMLB12-EX.srv.huawei-3com.com>
	<20170328164221.GN3421@octiron.msp.redhat.com>
	<1490822562.10580.9.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1490822562.10580.9.camel@suse.com>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Mar 29, 2017 at 11:22:42PM +0200, Martin Wilck wrote:
> On Tue, 2017-03-28 at 11:42 -0500, Benjamin Marzinski wrote:
> =

> > Now the question is, what to we do if the path changes wwid, but it's
> > not part of a multipath device yet. We could simply print a warning
> > message that the wwid has changed, and allow it to happen, since
> > there's
> > no multipath device currently using the LUN. However, I have seen
> > cases
> > where multiple LUNs that have already been discovered by a node get
> > unmapped, and all the unmapped LUNs from a device get the same
> > ID_SERIAL
> > value in the uevent for the mapping change. This would cause
> > find_multipaths to create a multipath device that includes all of
> > these
> > unmapped devices, which is clearly wrong.
> =

> and in that siutation there'd be no way to detect that these are
> unmapped LUNs which don't qualify as paths for a multipath device?

Not really. They fail every checker function, but we don't check paths
that aren't being used. Otherwise, all the sysfs parameters stay the
same, and there's nothing special in the uevent. Discovered LUNs
shouldn't be getting remapped in general.  The kernel spits out an
warning message, saying that this isn't handled.

-Ben

> =

> Regards
> Martin
> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel.=A0+49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
> =

> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

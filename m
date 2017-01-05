From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 01/12] libmultipath: add wwid for "struct
 uevent" to record wwid of uevent
Date: Wed, 4 Jan 2017 21:00:41 -0600
Message-ID: <20170105030041.GL2732@octiron.msp.redhat.com>
References: <1482825809-9528-1-git-send-email-tang.junhui@zte.com.cn>
	<1482825809-9528-2-git-send-email-tang.junhui@zte.com.cn>
	<20170103220254.GD2732@octiron.msp.redhat.com>
	<OF623EC6A9.F5A76A08-ON4825809E.00140EC1-4825809E.00262117@zte.com.cn>
	<20170104181452.GJ2732@octiron.msp.redhat.com>
	<1483562006.23429.1.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1483562006.23429.1.camel@suse.com>
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
Cc: tang.junhui@zte.com.cn, tang.wenjun3@zte.com.cn, zhang.kai16@zte.com.cn, dm-devel@redhat.com, bart.vanassche@sandisk.com
List-Id: dm-devel.ids

On Wed, Jan 04, 2017 at 09:33:26PM +0100, Martin Wilck wrote:
> On Wed, 2017-01-04 at 12:14 -0600, Benjamin Marzinski wrote:
> > =

> > The other option would be to not actually merge the uevents, but
> > simply
> > run through the filtered but unmerged list of uevents, and skip the
> > domap stuff but remember the maps that need pushing to device-mapper.
> > Once you are done processing all the uevents, except for updating the
> > maps in device-mapper, you go back and update all the maps that need
> > updating. There's more code refactoring in this approach, but it
> > keeps
> > the uid being set in pathinfo, where you have all the information
> > necessary to set it using uid_attribute, getuid, or specialized code
> > like rbd uses.
> =

> That sounds a lot like configure()/coalesce_paths() to me. Would it
> perhaps make sense, instead of refactoring/rewriting a whole lot of
> code, to re-use that mature code path?

Like I mentioned before, configure does a lot of extra unnecessary work,
and currently has the problem of dropping information about failed paths.

-Ben

> =

> Cheers,
> Martin
> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel.=A0+49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)

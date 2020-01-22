From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 09/15] libmultipath: add code to get vendor
 specific vpd data
Date: Wed, 22 Jan 2020 06:20:52 -0600
Message-ID: <20200122122052.GZ30153@octiron.msp.redhat.com>
References: <1579227500-17196-1-git-send-email-bmarzins@redhat.com>
	<1579227500-17196-10-git-send-email-bmarzins@redhat.com>
	<6d1c7f92c9d68c8a1e602ecb36cc1390e0f936de.camel@suse.de>
	<20200122085143.GW30153@octiron.msp.redhat.com>
	<82dacc11f74946eec79eed0f35a075ba592cad49.camel@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <82dacc11f74946eec79eed0f35a075ba592cad49.camel@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Martin Wilck <mwilck@suse.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Jan 22, 2020 at 12:52:10PM +0100, Martin Wilck wrote:
> On Wed, 2020-01-22 at 02:51 -0600, Benjamin Marzinski wrote:
> > On Fri, Jan 17, 2020 at 05:56:40PM +0100, Martin Wilck wrote:
> > > On Thu, 2020-01-16 at 20:18 -0600, Benjamin Marzinski wrote:
> > > BUT ok, that's overengineered with just one supported combination
> > > of
> > > page and vendor. I can understand that. But then, it seems also
> > > overengineered to carry around vpd_vendor_pg and vpd_vendor_id in
> > > the
> > > hwe. 
> > > 
> > > I'd suggest creating a hard-coded table with "vendor vpd schemes",
> > > 
> > > struct {
> > > 	int pg;
> > > 	int vendor_id;
> > > 	const char *name;
> > > } vendor_vpd_schemes[]  = { 
> > >     { 0xc0, VPD_VP_HP3PAR, "hp3par", }, 
> > >     { 0, }, 
> > > };
> > > 
> > > and in the hwentry, only carry around the index into this table,
> > > and look up the page and vendor ID there. Actually, with just that
> > > single user, we might as well not introduce a new device property
> > > at
> > > all, but simply use a separate hardcoded table with lookup values
> > > for
> > > vendor and product ID. I'm unsure if it's wise to make this
> > > configurable via multipath.conf.
> > 
> > Sure. I can make the hwe change. The reason why I added this to
> > multipath.conf is that I'm not sure what devices actually support
> > these
> > vpd information pages.  So, if we miss one, or a new device comes out
> > that isn't in the built-in config, the user can still get this info.
> > 
> 
> My main issue was that you have 2 fields in struct hwentry, and only
> one field in the hwtable. I think I made the point that I'd prefer to
> have only one everywhere, and use some sort of lookup table for the
> page and vendor ID parameters.

I meant I agreed with this approach.

> Another issue that I realized just now, the "vendor_id" is not
> standardized - it's just an internal identifier used by sg3_utils and
> has no specific meaning outside the sg3_utils code base. Even it's
> numeric value has changed between sg3_utils versions. I think we should
> cast it away, and simply stick with the symbolic identifier. Keeping
> that symbolic name in line with sg3_utils makes a lot of sense, of
> course.

Yeah, another reason I didn't go with vpd_vendor_pg and vpd_vendor_id
was that on earlier versions of sg_vpd, the vpd_vendor_id for
hp3par was different. We can easily remove it altogether.

-Ben

> Regards,
> Martin
> 

From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 09/15] libmultipath: add code to get vendor
 specific vpd data
Date: Wed, 22 Jan 2020 12:52:10 +0100
Message-ID: <82dacc11f74946eec79eed0f35a075ba592cad49.camel@suse.de>
References: <1579227500-17196-1-git-send-email-bmarzins@redhat.com>
	<1579227500-17196-10-git-send-email-bmarzins@redhat.com>
	<6d1c7f92c9d68c8a1e602ecb36cc1390e0f936de.camel@suse.de>
	<20200122085143.GW30153@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200122085143.GW30153@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, Benjamin Marzinski <bmarzins@redhat.com>
List-Id: dm-devel.ids

On Wed, 2020-01-22 at 02:51 -0600, Benjamin Marzinski wrote:
> On Fri, Jan 17, 2020 at 05:56:40PM +0100, Martin Wilck wrote:
> > On Thu, 2020-01-16 at 20:18 -0600, Benjamin Marzinski wrote:
> > > This adds the wildcard 'g' for multipath and path formatted
> > > printing,
> > > which returns extra data from a device's vendor specific vpd
> > > page.  The
> > > specific vendor vpd page to use, and the vendor/product id to
> > > decode
> > > it
> > > can be set in the hwentry with vpd_vendor_pg and vpd_vendor_id.
> > > It
> > > can
> > > be configured in the devices section of multipath.conf with the
> > > vpd_vendor parameter. Currently, the only devices that use this
> > > are
> > > HPE
> > > 3PAR arrays, to return the Volume Name.
> > > 
> > > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > > ---
> > >  libmultipath/config.c      |  4 ++++
> > >  libmultipath/config.h      |  2 ++
> > >  libmultipath/dict.c        | 34
> > > ++++++++++++++++++++++++++++++++++
> > >  libmultipath/discovery.c   | 34
> > > +++++++++++++++++++++++++++++++++-
> > >  libmultipath/hwtable.c     |  2 ++
> > >  libmultipath/print.c       | 27 +++++++++++++++++++++++++++
> > >  libmultipath/propsel.c     | 24 ++++++++++++++++++++++++
> > >  libmultipath/propsel.h     |  2 ++
> > >  libmultipath/structs.h     |  9 +++++++++
> > >  multipath/multipath.conf.5 |  8 ++++++++
> > >  10 files changed, 145 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/libmultipath/config.c b/libmultipath/config.c
> > > index 85626e96..72b8d37c 100644
> > > --- a/libmultipath/config.c
> > > +++ b/libmultipath/config.c
> > > @@ -369,6 +369,8 @@ merge_hwe (struct hwentry * dst, struct
> > > hwentry *
> > > src)
> > >  	merge_num(max_sectors_kb);
> > >  	merge_num(ghost_delay);
> > >  	merge_num(all_tg_pt);
> > > +	merge_num(vpd_vendor_pg);
> > > +	merge_num(vpd_vendor_id);
> > >  	merge_num(san_path_err_threshold);
> > >  	merge_num(san_path_err_forget_rate);
> > >  	merge_num(san_path_err_recovery_time);
> > > @@ -517,6 +519,8 @@ store_hwe (vector hwtable, struct hwentry *
> > > dhwe)
> > >  	hwe->detect_prio = dhwe->detect_prio;
> > >  	hwe->detect_checker = dhwe->detect_checker;
> > >  	hwe->ghost_delay = dhwe->ghost_delay;
> > > +	hwe->vpd_vendor_pg = dhwe->vpd_vendor_pg;
> > > +	hwe->vpd_vendor_id = dhwe->vpd_vendor_id;
> > >  
> > >  	if (dhwe->bl_product && !(hwe->bl_product = set_param_str(dhwe-
> > > > bl_product)))
> > >  		goto out;
> > > diff --git a/libmultipath/config.h b/libmultipath/config.h
> > > index e69aa07c..589146de 100644
> > > --- a/libmultipath/config.h
> > > +++ b/libmultipath/config.h
> > > @@ -87,6 +87,8 @@ struct hwentry {
> > >  	int max_sectors_kb;
> > >  	int ghost_delay;
> > >  	int all_tg_pt;
> > > +	int vpd_vendor_pg;
> > > +	int vpd_vendor_id;
> > >  	char * bl_product;
> > >  };
> > >  
> > > diff --git a/libmultipath/dict.c b/libmultipath/dict.c
> > > index 2b046e1d..d6d8b79b 100644
> > > --- a/libmultipath/dict.c
> > > +++ b/libmultipath/dict.c
> > > @@ -1366,6 +1366,39 @@ def_uxsock_timeout_handler(struct config
> > > *conf, vector strvec)
> > >  	return 0;
> > >  }
> > >  
> > > +static int
> > > +hw_vpd_vendor_handler(struct config *conf, vector strvec)
> > > +{
> > > +	int rc = 0;
> > > +	char *buff;
> > > +
> > > +	struct hwentry * hwe = VECTOR_LAST_SLOT(conf->hwtable);
> > > +	if (!hwe)
> > > +		return 1;
> > > +
> > > +	buff = set_value(strvec);
> > > +	if (!buff)
> > > +		return 1;
> > > +	if (strcmp(buff, "hp3par") == 0) {
> > > +		hwe->vpd_vendor_pg = 0xc0;
> > > +		hwe->vpd_vendor_id = VPD_VP_HP3PAR;
> > > +	} else
> > > +		rc = 1;
> > > +	FREE(buff);
> > > +	return rc;
> > > +}
> > > +
> > > +static int
> > > +snprint_hw_vpd_vendor(struct config *conf, char * buff, int len,
> > > +		      const void * data)
> > > +{
> > > +	const struct hwentry * hwe = (const struct hwentry *)data;
> > > +
> > > +	if (hwe->vpd_vendor_pg == 0xc0 && hwe->vpd_vendor_id ==
> > > VPD_VP_HP3PAR)
> > > +		return snprintf(buff, len, "hp3par");
> > > +	return 0;
> > > +}
> > 
> > I don't understand this design. The way you set up the hwe, it
> > would be
> > logical to add "vpd_vendor_page" and "vpd_vendor_id" properties for
> > device entries.
> 
> The vpd page abbreviations specify both the page to read, and the
> vendor
> id to use to decode it, and they are more user readable. It seemed
> like
> a much more foolproof way to have people specify this.
>  
> > BUT ok, that's overengineered with just one supported combination
> > of
> > page and vendor. I can understand that. But then, it seems also
> > overengineered to carry around vpd_vendor_pg and vpd_vendor_id in
> > the
> > hwe. 
> > 
> > I'd suggest creating a hard-coded table with "vendor vpd schemes",
> > 
> > struct {
> > 	int pg;
> > 	int vendor_id;
> > 	const char *name;
> > } vendor_vpd_schemes[]  = { 
> >     { 0xc0, VPD_VP_HP3PAR, "hp3par", }, 
> >     { 0, }, 
> > };
> > 
> > and in the hwentry, only carry around the index into this table,
> > and look up the page and vendor ID there. Actually, with just that
> > single user, we might as well not introduce a new device property
> > at
> > all, but simply use a separate hardcoded table with lookup values
> > for
> > vendor and product ID. I'm unsure if it's wise to make this
> > configurable via multipath.conf.
> 
> Sure. I can make the hwe change. The reason why I added this to
> multipath.conf is that I'm not sure what devices actually support
> these
> vpd information pages.  So, if we miss one, or a new device comes out
> that isn't in the built-in config, the user can still get this info.
> 

My main issue was that you have 2 fields in struct hwentry, and only
one field in the hwtable. I think I made the point that I'd prefer to
have only one everywhere, and use some sort of lookup table for the
page and vendor ID parameters.

Another issue that I realized just now, the "vendor_id" is not
standardized - it's just an internal identifier used by sg3_utils and
has no specific meaning outside the sg3_utils code base. Even it's
numeric value has changed between sg3_utils versions. I think we should
cast it away, and simply stick with the symbolic identifier. Keeping
that symbolic name in line with sg3_utils makes a lot of sense, of
course.

Regards,
Martin

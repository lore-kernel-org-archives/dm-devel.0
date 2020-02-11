From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v2 10/17] libmultipath: add code to get
 vendor specific vpd data
Date: Tue, 11 Feb 2020 09:09:48 +0100
Message-ID: <2f1e42b45a985db8a1231698609682d1a4bfcbea.camel@suse.com>
References: <1580929100-32572-1-git-send-email-bmarzins@redhat.com>
	<1580929100-32572-11-git-send-email-bmarzins@redhat.com>
	<ad6542e5dce892c1b631f661c51c2e4d107d699c.camel@suse.com>
	<20200210204942.GD30153@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200210204942.GD30153@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, 2020-02-10 at 14:49 -0600, Benjamin Marzinski wrote:
> On Mon, Feb 10, 2020 at 02:49:38PM +0000, Martin Wilck wrote:
> > On Wed, 2020-02-05 at 12:58 -0600, Benjamin Marzinski wrote:
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
> > >  libmultipath/config.c      |  2 ++
> > >  libmultipath/config.h      |  1 +
> > >  libmultipath/dict.c        | 38
> > > ++++++++++++++++++++++++++++++++++++
> > >  libmultipath/discovery.c   | 40
> > > +++++++++++++++++++++++++++++++++++++-
> > >  libmultipath/hwtable.c     |  1 +
> > >  libmultipath/print.c       | 25 ++++++++++++++++++++++++
> > >  libmultipath/propsel.c     | 18 +++++++++++++++++
> > >  libmultipath/propsel.h     |  1 +
> > >  libmultipath/structs.h     | 15 ++++++++++++++
> > >  multipath/multipath.conf.5 |  8 ++++++++
> > >  10 files changed, 148 insertions(+), 1 deletion(-)
> > > 
> > >  struct sg_id {
> > >  	int host_no;
> > >  	int channel;
> > > @@ -255,6 +268,7 @@ struct path {
> > >  	char rev[PATH_REV_SIZE];
> > >  	char serial[SERIAL_SIZE];
> > >  	char tgt_node_name[NODE_NAME_SIZE];
> > > +	char vpd_data[VPD_DATA_SIZE];
> > 
> > Hm, 128 more bytes per path for a rarely-used property... do we
> > need to
> > store this in "struct path"? Can't we simply fetch that information
> > when someone requests it with the %g format wildcard? It doesn't
> > matter
> > much today as "struct path" is really thick already, but I have
> > hopes
> > to make it a bit leaner some day.
> 
> Well, the thought was that this information (which should help map
> the
> path to a physical array) would most often be wanted when things were
> going badly, and you might not be able to access the device.

Point taken. How about using a pointer? That would be only 8 extra
bytes for those cases where the field was unused.
Call me old-fashioned, I've grown up in a world where 1000x128 bytes
mattered.

Regards,
Martin

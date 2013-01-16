From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: [PATCH] multipath: change default configuration
 parameters
Date: Wed, 16 Jan 2013 21:42:46 +0100
Message-ID: <1358368966.8351.3.camel@lapoo.opensvc.com>
References: <20130108053459.GU19059@ether.msp.redhat.com>
	<50EEFB87.1060707@gmail.com>
	<1358283765.3854.1.camel@lapoo.opensvc.com>
	<50F5CEAD.8070809@gmail.com>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <50F5CEAD.8070809@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: development <dm-devel@redhat.com>, device-mapper@redhat.com, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

On mar., 2013-01-15 at 22:48 +0100, Xose Vazquez Perez wrote:
> On 01/15/2013 10:02 PM, Christophe Varoqui wrote:
> 
> > I pushed a patch to resync the multipath.conf.defaults using the
> > "multipathd show config" output.
> 
> > --- a/multipath.conf.defaults
> > +++ b/multipath.conf.defaults
> > @@ -2,775 +2,863 @@
> >  # overwrite these values in your config file.
> >  
> >  #defaults {
> > -#      udev_dir                /dev
> > -#      polling_interval        5
> > -#      path_selector           "round-robin 0"
> > -#      path_grouping_policy    failover
> > -#      getuid_callout          "/lib/udev/scsi_id --whitelisted --device=/dev/%n"
> > -#      prio                    const
> > -#      prio_args               ""
> > -#      path_checker            directio
> > -#      rr_min_io               1000
> > -#      rr_weight               uniform
> > -#      failback                manual
> > -#      no_path_retry           fail
> > -#      user_friendly_names     no
> > +#      verbosity 2
> > +#      polling_interval 5
> > +#      multipath_dir "/lib64/multipath"
> 
> multipath_dir should be removed, it's generated at compile time.

 True. Applied.

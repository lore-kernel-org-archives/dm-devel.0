From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: [PATCH][multipath-tools] discovery.c set hwe pointer
	for bus type ccw
Date: Thu, 2 Feb 2006 17:19:06 +0100
Message-ID: <20060202161906.GA11415@pundit>
References: <OFFD0A28A6.4D76571F-ONC1257109.004DBE99-C1257109.0052476D@de.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <OFFD0A28A6.4D76571F-ONC1257109.004DBE99-C1257109.0052476D@de.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Stefan Weinhuber <WEIN@de.ibm.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

> 
> I tried to use the current git tree version of the multipath-tools in a 
> Linux on zSeries environment with DASD devices. The tool multipath seemed 
> to
> recognize the disks correctly, but ignored the device specific 
> configuration
> in my multipath.conf.
> 
Good to see there is some testing happening there.
Next major distro release is approaching and not many seem to care to bullet proof the next release ...

> Stefan Bader found the problem in libmultipath/discovery.c in the function 
> 
> ccw_sysfs_pathinfo. In that function the hwe configlet pointer should be 
> set.

Thanks, my bad.

I pushed it as 2f6c4c8ae93d599bf1c2630c97cc675e92fbea90

Regards,
cvaroqui

From: Tore Anderson <tore@linpro.no>
Subject: Re: path priorities on Sun's 6140
Date: Mon, 24 Sep 2007 08:47:41 +0200
Message-ID: <46F75D8D.3050809@linpro.no>
References: <66F461DD7EDEEF4AA928FCC80B425B520468B7@c2kp01mail.cucbc.com><46EBA114.10408@linpro.no>	<66F461DD7EDEEF4AA928FCC80B425B520468B8@c2kp01mail.cucbc.com><66F461DD7EDEEF4AA928FCC80B425B520468B9@c2kp01mail.cucbc.com>	<46EF80BA.1020605@linpro.no>
	<66F461DD7EDEEF4AA928FCC80B425B520468BB@c2kp01mail.cucbc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <66F461DD7EDEEF4AA928FCC80B425B520468BB@c2kp01mail.cucbc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

* James Fillman

> Ok, I've made the attempt to install all the necessary RHEL5.1 beta 
> rpm's to get rdac working and unfortunately I had roll back. I had to
> install a bunch of gfs, cluster, and lvm rpm's, along with the new 
> kernel and it seemed to work at first. I then fired up my cluster and
> it was very unstable.

Hm.  I thought it would work to upgrade only the kernel.  It seems very
strange that you have to upgrade all those userland utilities.  Did you
try with some RPM frontend like up2date that makes "clever" choices for
you, mayhaps?  If so try downloading the RPM and installing it directly
with the rpm utility.

When looking at the package description of the 2.6.18-36 RPM, I don't
really see any conflict that should cause this - the conflicts are the
exact same as in the latest RHEL5 non-beta kernel (2.6.18-8.1.10), so
there's no reason why it wouldn't work to install the beta kernel
directly without upgrading any other packages.  I can't see any, at least.

> I've downloaded and compiled the latest multipath source (0.4.8). Now
> I need to compile the rdac hardware handler against my current kernel
> source. Can anyone provide me with the latest, patched source?

The source RPM is available from RHN.  Go to Channels, then All
channels, find Red Hat Enterprise Linux (v. 5 for [your arch here]),
expand it and find the associated beta channel.  Enter it, go to
Packages and search for "kernel", follow the appropriate link and you
should have a source RPM download link there.

> Tore, I know you have it! After scanning through the posts, it looks 
> like you've had the same problems I have and you're running the same 
> hardware(Sun 6140). I could really use your help getting rdac
> working. Redhat totally gave me the cold shoulder when I opened a
> ticket with them. At this point, I need to keep the stock redhat
> kernel but am willing to build all the multipath stuff against it.
> I've got all the userland stuff compiled. Now I'm hoping I can get
> instructions on how to compile the rdac hw handler against my kernel.

I'm using 2.6.23-rcX or the kernel from RHEL 5.1 beta.  Or you can try
to grab the RHEL5 (2.6.18-8.1.10) kernel sources as well as the source
RPM for 2.6.18-36, copy over driver/md/dm-mpath-rdac.c and also add the
relevant changes to Makefile and Kconfig, and with some luck you'll be
able to build a module that's insertable on 2.6.18-8.1.10.  But first
I'd try some more to install the kernel from 5.1 beta.  I'm quite
confident it should work just fine.

Regards
-- 
Tore Anderson

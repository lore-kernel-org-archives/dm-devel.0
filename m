From: Stefan Bader <Stefan.Bader@de.ibm.com>
Subject: Re: LVM2, RHEL 4 update 2: can't remove logical volume
Date: Thu, 27 Oct 2005 18:31:39 +0200
Message-ID: <OF362CFE5E.C90ABACF-ONC12570A7.005A3340-C12570A7.005AB3FD@de.ibm.com>
References: <1130413264.4047.13.camel@brilong-lnx>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1130413264.4047.13.camel@brilong-lnx>
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

Brian,

the most simple one depends a bit on mp-tools device names. There are some
discussions about device names... What I did was to use the alias feature 
to name
the disks like mpdisk*

Then the following filter would just allow these:

filter = [ "a|/mapper/mpdisk.*|", "r|.*|" ]

If you have other devices that should be used for volume groups, these 
would have
to be added as well. It is sometimes a bit of an experiment. Chnage the 
config file,
run vgscan and look at /etc/lvm/.cache which devices are used...

Stefan

SW Linux on zSeries Development & Services
Stefan.Bader@de.ibm.com
----------------------------------------------------------------------------------
  When all other means of communication fail, try words.

dm-devel-bounces@redhat.com wrote on 27.10.2005 13:41:04:

> On Thu, 2005-10-27 at 10:58 +0200, Stefan Bader wrote:
> > We got something similar here. Try to change the filter rules to 
exclude 
> > the
> > volume group devices. What you want is the devices created by the
> > multipath-tools included but not the devices created by lvm2.
> > Otherwise the tools will have the lv open at the time they should be
> > removed.
> > 
> > Stefan Bader
> 
> Stefan,
> 
> Could you post your filter example so Phil and I can integrate it into
> our lvm.conf?  Thanks!
> 
> /Brian/
> 
> -- 
>        Brian Long                      |         |           |
>        IT Data Center Systems          |       .|||.       .|||.
>        Cisco Linux Developer           |   ..:|||||||:...:|||||||:..
>        Phone: (919) 392-7363           |   C i s c o   S y s t e m s
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

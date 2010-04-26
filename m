From: brem belguebli <brem.belguebli@gmail.com>
Subject: Re: bindings file; rename WWID to mpath alias
Date: Tue, 27 Apr 2010 01:56:19 +0200
Message-ID: <1272326179.16254.33.camel@localhost>
References: <4BD5F07A.7040005@sandia.gov>
	<1272322814.16254.14.camel@localhost>  <4BD601E5.6060705@sandia.gov>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4BD601E5.6060705@sandia.gov>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

Best thing to do, if you don't want to destroy data, would be to:

1) copy your original bindings file from /var to /etc (in newer versions
of dm-multipath, bindings file is located under /etc/multipath/bindings)
and modify /etc/multipath.conf to tell it the location of bindings file
(cf /usr/share/doc/device-mapper-multipath-0.4.7/multipath.conf.annotated for the line to add, I don't have a 0.4.7 dm-mp configuration right now)

2) comment all /dev/mpath* relative entries in /etc/fstab (supposedly
you are mounting your devices thru fstab) either if using LVM or entire
raw disks.

3) reboot your system 

4) mount manually each mpath (in respect to your bindings file) and make
sure they really correspond to the original ones.

If so, you're done.

Brem

PS: rogue device is something I don't believe in, there is always a
reason for a device to be seen.....



On Mon, 2010-04-26 at 15:13 -0600, Victoria A Smith wrote:
> It is on /var (/var/lib/multipath/bindings), and /var is a separate LV 
> from /.
> 
> I am beginning to think the WWID 350002ac002c506cc is a "rogue" device 
> and should be removed from the system.
> 
> Regards,
> 
> Victoria
> 
> 
> brem belguebli said the following on 04/26/2010 05:00 PM:
> > Is your bindings file located on a different [lv|partition] than / ?
> >
> > It may cause this kind of troubles if so.
> >
> > Brem
> >
> > On Mon, 2010-04-26 at 13:58 -0600, Victoria A Smith wrote:
> >    
> >> After a system crash I have filesystem access problems when
> >> the multipathd service is started.  I noticed in the messages file
> >> and in output from multipath -ll that an alias is not being
> >> used:
> >>
> >> messages:  [...] rename 350002ac002c506cc to mpath18
> >>
> >> # multipath -ll
> >> [...]
> >> 350002ac002c506cc dm-12 3PARdata,VV
> >>
> >> # ls -1 /dev/mpath/
> >> 350002ac002c506cc
> >> mpath10
> >> [...]
> >>
> >>
> >> The bindings file has:
> >> [...]
> >> mpath18 350002ac002c506cc
> >>
> >>
> >> Can the apparent failure of the alias-to-WWID mapping cause any problems?
> >>
> >>
> >> RHEL5.5
> >> 2.6.18-194.el5
> >> device-mapper-multipath-0.4.7-34.el5
> >> QLogic Fibre Channel HBA Driver: 8.03.01.04.05.05-k
> >>
> >>
> >> Thanks,
> >>
> >> Victoria
> >>
> >>
> >> --
> >> dm-devel mailing list
> >> dm-devel@redhat.com
> >> https://www.redhat.com/mailman/listinfo/dm-devel
> >>      
> >
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
> >
> >    
> 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

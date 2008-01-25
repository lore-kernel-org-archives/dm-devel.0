From: malahal@us.ibm.com
Subject: Re: Multipath Usage Guide available at LVM wiki page
Date: Thu, 24 Jan 2008 18:14:29 -0800
Message-ID: <20080125021429.GC28785@us.ibm.com>
References: <1201199153.2634.4.camel@linuxchandra>
	<110b17190801241033t5f2cd140r65668a87357f30ad@mail.gmail.com>
	<1201213292.2634.35.camel@linuxchandra>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1201213292.2634.35.camel@linuxchandra>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Chandra Seetharaman [sekharan@us.ibm.com] wrote:
> On Thu, 2008-01-24 at 10:33 -0800, Pradipmaya Maharana wrote:
> > Hi Chandra,
> > 
> > Thanks for the document, it surely is helpful.
> > 
> > I had a query (which I have asked in previous mails), the document
> > does not talk about how to install SLES on multipath devices with LVM.
> > Basically I tried installing with creating partitions (for both RHEL
> > and SLES) and it worked fine; LVM worked fine for RHEL but for SLES it
> > won't work.
> > 
> > - It won't let me mount-by device-id for LVM
> > - specifying the volume label won't help.

Are you saying it won't help or it did NOT help?
 
> You could put your lvm on top of the multipathed dm-device. For which
> you may have to disable lvm probing in the initrd phase. You can do this
> by changing your /etc/lvm/lvm.conf and then running mkinitrd.
> 
> You have to change the filter line to be like this:
> 
> filter = [ "a|/dev/mapper.*|", "a|/dev/disk/by-name/.*|", "r|.*|" ]
> 
> Let me know if this helps.

multipath should be run before lvm (even in initrd), if so, how does
this filter help?  LVM will not be able to claim plain devices in the
presence of multipath devices anyway, right?

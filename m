From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: Multipath Usage Guide available at LVM wiki page
Date: Thu, 24 Jan 2008 14:21:32 -0800
Message-ID: <1201213292.2634.35.camel@linuxchandra>
References: <1201199153.2634.4.camel@linuxchandra>
	<110b17190801241033t5f2cd140r65668a87357f30ad@mail.gmail.com>
Reply-To: sekharan@us.ibm.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <110b17190801241033t5f2cd140r65668a87357f30ad@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Pradipmaya Maharana <pradipmaya@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, 2008-01-24 at 10:33 -0800, Pradipmaya Maharana wrote:
> Hi Chandra,
> 
> Thanks for the document, it surely is helpful.
> 
> I had a query (which I have asked in previous mails), the document
> does not talk about how to install SLES on multipath devices with LVM.
> Basically I tried installing with creating partitions (for both RHEL
> and SLES) and it worked fine; LVM worked fine for RHEL but for SLES it
> won't work.
> 
> - It won't let me mount-by device-id for LVM
> - specifying the volume label won't help.

You could put your lvm on top of the multipathed dm-device. For which
you may have to disable lvm probing in the initrd phase. You can do this
by changing your /etc/lvm/lvm.conf and then running mkinitrd.

You have to change the filter line to be like this:

filter = [ "a|/dev/mapper.*|", "a|/dev/disk/by-name/.*|", "r|.*|" ]

Let me know if this helps.
> 
> What am I missing.
> 
> Thanks and Regards,
> Pradipmaya.
> 
> 
> On Jan 24, 2008 10:25 AM, Chandra Seetharaman <sekharan@us.ibm.com> wrote:
> > Hi All,
> >
> > I put the Multipath Usage guide in the LVM wiki page. Here is the link:
> > http://sources.redhat.com/lvm2/wiki/MultipathUsageGuide
> >
> > One can reach the same from the lvm wiki homepage
> > (http://sources.redhat.com/lvm2/wiki/HomePage) through the links "Usage
> > Documentation" -> "Multipath Usage Guide"
> >
> > Let me know if you have any comments/suggestions.
> >
> > regards,
> >
> > chandra
> > --
> >
> > ----------------------------------------------------------------------
> >    Chandra Seetharaman               | Be careful what you choose....
> >              - sekharan@us.ibm.com   |      .......you may get it.
> > ----------------------------------------------------------------------
> >
> >
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
> >
-- 

----------------------------------------------------------------------
    Chandra Seetharaman               | Be careful what you choose....
              - sekharan@us.ibm.com   |      .......you may get it.
----------------------------------------------------------------------

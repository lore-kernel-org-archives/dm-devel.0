From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: user defined device name and table
Date: Tue, 27 Nov 2007 13:48:20 -0600
Message-ID: <20071127194820.GA25939@ether.msp.redhat.com>
References: <474ADDCF.8030703@fccn.pt>
	<5201e28f0711260844r425847c0ta28ee0f988c5906@mail.gmail.com>
	<474BE407.4050206@fccn.pt>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <474BE407.4050206@fccn.pt>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: pedro.faustino@fccn.pt, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, Nov 27, 2007 at 09:31:51AM +0000, Pedro Bandim Faustino wrote:
> 
> Stefan Bader wrote:
> >
> >You should be able to change the name by creating a multipaths section 
> >like below
> >
> >multipaths {
> >    multipath {
> >        wwid "3600a0b8000295d64000009304742b4c8"
> >        alias "SRV07_BOOT"
> >    }
> >}
> >
> >If that does not work as expected, you might have to say "no" to the 
> >user friendly names option.
> Hi Stefan,
> I've tried that, but what happens is that once the multipathd starts 
> I'll have duplicate multipaths, the one at boot time and this one by 
> multipathd, with different names.
> 

If you add aliases to the multipaths section, like Stefan decribed, and
then rerun multipath, do the devices change names to given aliases? They
should.  Then, you should be able to remake the initrd, and reboot and
just see the alias.  If you try this, and it doesn't work, let me know.

-Ben

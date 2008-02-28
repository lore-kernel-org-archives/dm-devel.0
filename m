From: "Pradipmaya Maharana" <pradipmaya@gmail.com>
Subject: Re: Installing RHEL with single controller
Date: Thu, 28 Feb 2008 11:36:20 -0800
Message-ID: <110b17190802281136k7f303322y28f9952c82366a0c@mail.gmail.com>
References: <110b17190802281008u6e5eeef4vccfb509be7ad4198@mail.gmail.com>
	<20080228192135.GA13340@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080228192135.GA13340@us.ibm.com>
Content-Disposition: inline
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

Multipath is getting loaded, if that is what you are wondering about.
After reboot I check for multipathd status, and smod for the modules
loaded, everything looks fine.

Moreover, if I try to run multipath -ve, it would fail with domap (0) failed.
/var/log/messages would say "error getting device".
I was thinking that I get this error because OS is already loaded on
the device I am trying to configure multipath for.

What do you suggest.

Thanks and Regards,
Pradipmaya.


On Thu, Feb 28, 2008 at 11:21 AM,  <malahal@us.ibm.com> wrote:
> Pradipmaya Maharana [pradipmaya@gmail.com] wrote:
> > Hi All,
> >
> > I installed RHEL on a blade with only one LUN and with only one controller up.
> > So for obvious reasons, even though I specified the option "linux
> > mpath" for installer, the only device available for partition was
> > /dev/sda/.
>
> Don't know what the installer does in this case, so check your initrd if
> multipath is enabled. If not, there should be a way to generate
> multipath capable initrd by running 'mkinitrd'. You may need to update
> some files before running mkinitrd to poduce multipath capable initrd...
>
> --Malahal.
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

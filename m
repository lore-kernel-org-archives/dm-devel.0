From: "Pradipmaya Maharana" <pradipmaya@gmail.com>
Subject: Re: Configuring multipath for root device
Date: Mon, 7 Jan 2008 12:56:43 -0800
Message-ID: <110b17190801071256j429907e5iec4f35b74cfb73c8@mail.gmail.com>
References: <110b17190712191302o60d521eaj693410c26d07c1ad@mail.gmail.com>
	<1198099093.26366.32.camel@linuxchandra>
	<110b17190801071219k11749b81n45a7d1d5d35b9413@mail.gmail.com>
	<20080107202853.GA9833@us.ibm.com>
	<110b17190801071240i1690a9a0ua3b26acd7c3b349a@mail.gmail.com>
	<20080107204631.GA10495@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080107204631.GA10495@us.ibm.com>
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

I did exactly what you said for SLES 10.1,
- Create custom partition
- Created partitions for /boot, / and swap of 100MB, 5GB and 1024MB
respectively on /dev/sda. So /dev/sda1 is for "/boot", /dev/sda2 for
"/" and /dev/sda3 for "swap"
- Under fstab option, selected Mount by device-id for each of the partition
- Reboot is fine
- But as I said earlier, mount, fstab, everything shows devcie names, not id

Any way to mount it by device-id?
Is there a way that it can be chaned after installation? Or re-install
is the only way.

Regards,
Pradipmaya.


On Jan 7, 2008 12:46 PM,  <malahal@us.ibm.com> wrote:
> Pradipmaya Maharana [pradipmaya@gmail.com] wrote:
> > I followed the instruction for SLES, that is, while installing,
> > selected the option for mounting the device by "device id" but after
> > reboot mount, fstab shows device names, like /dev/sda2, etc.
> > What am I missing.
>
> That is odd. You will have to select "device id" for each file system
> including swap. I only used 'expert partition' on SLES10 SP1 installs
> and it put everything with ID names.
>
> -Malahal.
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

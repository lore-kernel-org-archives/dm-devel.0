From: malahal@us.ibm.com
Subject: Re: Configuring multipath for root device
Date: Mon, 7 Jan 2008 12:46:31 -0800
Message-ID: <20080107204631.GA10495@us.ibm.com>
References: <110b17190712191302o60d521eaj693410c26d07c1ad@mail.gmail.com>
	<1198099093.26366.32.camel@linuxchandra>
	<110b17190801071219k11749b81n45a7d1d5d35b9413@mail.gmail.com>
	<20080107202853.GA9833@us.ibm.com>
	<110b17190801071240i1690a9a0ua3b26acd7c3b349a@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <110b17190801071240i1690a9a0ua3b26acd7c3b349a@mail.gmail.com>
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

Pradipmaya Maharana [pradipmaya@gmail.com] wrote:
> I followed the instruction for SLES, that is, while installing,
> selected the option for mounting the device by "device id" but after
> reboot mount, fstab shows device names, like /dev/sda2, etc.
> What am I missing.

That is odd. You will have to select "device id" for each file system
including swap. I only used 'expert partition' on SLES10 SP1 installs
and it put everything with ID names.

-Malahal.

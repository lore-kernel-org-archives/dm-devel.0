From: malahal@us.ibm.com
Subject: Re: Configuring multipath for root device
Date: Thu, 17 Jan 2008 12:21:45 -0800
Message-ID: <20080117202145.GC7083@us.ibm.com>
References: <110b17190712191302o60d521eaj693410c26d07c1ad@mail.gmail.com>
	<1198099093.26366.32.camel@linuxchandra>
	<110b17190801071219k11749b81n45a7d1d5d35b9413@mail.gmail.com>
	<4783239C.7020206@suse.de>
	<110b17190801151825ofd63e20yd9d4f01be7b67407@mail.gmail.com>
	<20080116173649.GA30593@us.ibm.com>
	<110b17190801161049o127a22edq1888f9184156b52@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <110b17190801161049o127a22edq1888f9184156b52@mail.gmail.com>
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
> 
> Let me know if you need any other information.
> 
> Malahal, are you saying that I should mount the "/" and "swap" by
> volume label and it should be able to boot fine?

What are /dev/system/root and /dev/system/swap? Are they symlinks or do
they have same major/minor number of corresponding LVM LVs?
Yes, volume labels may work but I never booted SLES with LVM.

-Malahal.

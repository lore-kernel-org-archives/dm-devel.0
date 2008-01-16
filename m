From: malahal@us.ibm.com
Subject: Re: Configuring multipath for root device
Date: Wed, 16 Jan 2008 09:36:49 -0800
Message-ID: <20080116173649.GA30593@us.ibm.com>
References: <110b17190712191302o60d521eaj693410c26d07c1ad@mail.gmail.com>
	<1198099093.26366.32.camel@linuxchandra>
	<110b17190801071219k11749b81n45a7d1d5d35b9413@mail.gmail.com>
	<4783239C.7020206@suse.de>
	<110b17190801151825ofd63e20yd9d4f01be7b67407@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <110b17190801151825ofd63e20yd9d4f01be7b67407@mail.gmail.com>
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
> Hi All,
> 
> Thanks for all your comments, it worked for installaions on partitions.
> 
> Now the question is:
> Is it supposed to work the same way if the SLES is installed on LVM?

Hmmm, I don't know if LVM devices have by-id names. I never installed
SLES on LVM with multipath. Label is your best friend with LVM and that
is what RHEL uses, I believe.

> On SLES, under fstab, I do not see any device, except for the boot
> device; other entries does not have /dev/deisk mention. In such
> scenario, how am I supposed to make the /root device multipath-aware?

They probably have labels???

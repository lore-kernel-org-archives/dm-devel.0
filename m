From: malahal@us.ibm.com
Subject: Re: Configuring multipath for root device
Date: Mon, 7 Jan 2008 12:28:53 -0800
Message-ID: <20080107202853.GA9833@us.ibm.com>
References: <110b17190712191302o60d521eaj693410c26d07c1ad@mail.gmail.com>
	<1198099093.26366.32.camel@linuxchandra>
	<110b17190801071219k11749b81n45a7d1d5d35b9413@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <110b17190801071219k11749b81n45a7d1d5d35b9413@mail.gmail.com>
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
> RHEL Steps worked perfectly for me but i have a question for SLES installation.
> 
> Question. While installing SLES on multipath devices, the second step says:
> 
> " 2. Complete the installation. Let the system boot up in multiuser mode.
> Make sure the root device, swap device are all referenced by their by-id
> device node entries instead of /dev/sd* type names. If they are not, fix
> them first."
> 
> How do you check that root device and swap device are referenced by their by-id?
> And if it is not referenced by the by-id, how do I fix it? Re-install?

Look at your grub.conf and see what is there for root and also look at
/etc/fstab and make sure everything there is also ID based.

Malahal.

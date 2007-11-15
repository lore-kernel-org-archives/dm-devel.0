From: "Scott Moseman" <scmoseman@gmail.com>
Subject: Re: Creation of the mpath# devices
Date: Thu, 15 Nov 2007 16:36:46 -0600
Message-ID: <342d47870711151436l1f49e2d3od0aa6e99bd599b37@mail.gmail.com>
References: <342d47870711151302o68e3172fn92c8c1e323812905@mail.gmail.com>
	<20071115212943.GF4900@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20071115212943.GF4900@ether.msp.redhat.com>
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

On Nov 15, 2007 3:29 PM, Benjamin Marzinski <bmarzins@redhat.com> wrote:
>
> Which you can use to access the device. If you don't like dealing with
> such a cumbersome name, you can always add
>
>       user_friendly_names yes
>
> to the defaults section of /etc/multipath.conf
>

Hey Ben,

That worked great.  :)  I now have /dev/mapper/mpath0 (and the p1
partition that already exists) and it's now officially mounted and
working!  Is there any "best practices" about whether I should be
mounting the /dev/mapper/mpath0p1 or /dev/mpath/mpath0p1 device?

Thanks,
Scott

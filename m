From: Konrad Rzeszutek <konrad@virtualiron.com>
Subject: Re: Issues with mkinitrd and path priority modules
Date: Fri, 29 Aug 2008 10:08:59 -0400
Message-ID: <20080829140859.GB2936@mars.virtualiron.com>
References: <110b17190808281455w5449d3a4sf997d17d54dc99f5@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <110b17190808281455w5449d3a4sf997d17d54dc99f5@mail.gmail.com>
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

On Thu, Aug 28, 2008 at 02:55:15PM -0700, Pradipmaya Maharana wrote:
> Hi All,
> 
> I have created mpath_prio_custom, based on code from mpath_prio_alua.
> I specified the module in /etc/multipath.cong for getting priority of
> the luns.
> 
> prio_callout	"/sbin/mpath_prio_custom /dev/%n"
> 
> The module gets installed under /sbin with out any error, gives me
> correct priorities and runs fine; but while this module is installed
> if I do an mkinitrd, my module does not get included in the initrd
> image.  And due to this, when the kernel boots next time, it fails. As
> my module is mentioned in the multipath.conf, kernel tries to find
> this module under /sbin but cannot find it and hence it fails. I see
> other modules, mpath_prio_alua, mpath_prio_emc, etc. are part of the
> initrd image.
> 
> What must I do so that my module gets included as a part of initrd image.

Edit the 'mkinitrd' program to include this in. You didn't say what distro
you are using so it is hard to say what else you might need to modify.

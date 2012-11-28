From: Peter Rajnoha <prajnoha@redhat.com>
Subject: Re: [PATCH] libdm: add "|" to _is_whitelisted_char()
Date: Wed, 28 Nov 2012 13:04:29 +0100
Message-ID: <50B5FDCD.2030605@redhat.com>
References: <20121127191123.GZ19704@osdn.org.ua>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20121127191123.GZ19704@osdn.org.ua>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Sergey Vlasov <vsu@altlinux.ru>, Michael Shigorin <mike@osdn.org.ua>, "Dmitry V. Levin" <ldv@altlinux.org>
List-Id: dm-devel.ids

On 11/27/2012 08:11 PM, Michael Shigorin wrote:
> 	Hello,
> please find attached a silly one-liner that was mentioned
> on #device-mapper yesterday and discussed with asalor today.
> 
> It adds "|" to a whitelist of chars allowed in devnode names
> for the sake of legacy compatibility with EVMS2 LVM plugin
> which uses to name the nodes like "lvm2|vg|lv".

Actually, that whitelist is taken from udev and any extra
character not on the current whitelist is automatically mangled
to a form that udev understands by default (which is \xNN,
NN being a hex value of the character). So it's all done to
conform with udev. Otherwise, if such mangling was not used,
udev would replace any blacklisted character with an underscore "_".

Now, if you *really* intend to bypass this mangling and udev,
you can use:

  dmsetup <dm_command> --manglename none ...


If you have your libdevmapper *compiled with udev support*
(configure --enable-udev_sync), then you also need to use
extra --noudevrules (to bypass udev rules) and --verifyudev
switches (to make a fallback to direct node/symlink creation):

  dmsetup <dm_command> --manglename none --noudevrules --verifyudev ...

But, if your system uses udev, try to avoid this as much as possible!
Bypassing udev has many side effects, like missing information in
udev database (as the symlinks/nodes were not created by udev itself).
And this database could be read by other tools and they simply won't
see all the state. Reading udev database instead of scanning the
/dev directly is very common these days.

Peter

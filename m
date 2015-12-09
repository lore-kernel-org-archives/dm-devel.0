From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Subject: Re: fixing mangled UUIDs
Date: Wed, 9 Dec 2015 20:24:22 +0100
Message-ID: <56687FE6.60908@gmail.com>
References: <22120.21444.300955.356941@quad.stoffel.home>
	<20151209162739.GR11127@agk-dp.fab.redhat.com>
	<22120.22900.364905.238586@quad.stoffel.home>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <22120.22900.364905.238586@quad.stoffel.home>
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
Cc: John Stoffel <john@stoffel.org>, LVM general discussion and development <linux-lvm@redhat.com>
List-Id: dm-devel.ids

Dne 9.12.2015 v 17:40 John Stoffel napsal(a):
>
> Alasdair> Have you tried '--manglename none' if you aren't using a
> Alasdair> udev system that mangles names?  (Also available via
> Alasdair> environmnet variable - see man page.)
>
> That seems to be working, using the default Debbian Jessie lvm tools:
>
>    dmsetup --manglename none status --target cache
>    data-home: 0 1153433600 cache 8 2443/32768 128 54020/819200 80721
>    350897 64427 66938 0 23882 1 1 writeback 2 migration_threshold 2048
>    smq 0 rw -
>    data-local: 0 702545920 cache 8 2443/32768 128 1078/819200 6268 85795
>    1492 2715 0 1057 0 1 writeback 2 migration_threshold 2048 smq 0 rw -
>
>
> So now I can try to monitor my cache usage.
>
> So the question still remains, what is the long term fix so I don't
> have to deal with this breakage by default?  Do I have bad UUIDS on my
> volumes?
>


Yep

See supported charset:

--
Mangle any character not on a whitelist using mangling_mode when processing 
device-mapper device names and UUIDs. The names and UUIDs are mangled on 
input  and unmangled  on  output  where  the  mangling  mode  is one of: auto 
(only do the mangling if not mangled yet, do nothing if already mangled, error 
on mixed), hex (always do the mangling) and none (no mangling).  Default mode 
is auto.  Character whitelist: 0-9, A-Z, a-z, #+-.:=@_. This whitelist is also 
supported by udev. Any  character  not  on  a  whitelist  is replaced with its 
hex value (two digits) prefixed by \x.  Mangling mode could be also set 
through DM_DEFAULT_NAME_MANGLING_MODE environment variable.
---

Udev create symlinks from UUID - so they need to be using udev-supported
chars - and you   '!' in UUID -> unsupported and needs mangling.

Regards

Zdenek

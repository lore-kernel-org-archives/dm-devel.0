From: "John Stoffel" <john@stoffel.org>
Subject: Re: [dm-devel] fixing mangled UUIDs
Date: Wed, 9 Dec 2015 15:39:35 -0500
Message-ID: <22120.37255.660922.594404@quad.stoffel.home>
References: <22120.21444.300955.356941@quad.stoffel.home>
	<20151209162739.GR11127@agk-dp.fab.redhat.com>
	<22120.22900.364905.238586@quad.stoffel.home>
	<56687FE6.60908@gmail.com>
Reply-To: LVM general discussion and development <linux-lvm@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-lvm-bounces@redhat.com>
In-Reply-To: <56687FE6.60908@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/linux-lvm>,
	<mailto:linux-lvm-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/linux-lvm>
List-Post: <mailto:linux-lvm@redhat.com>
List-Help: <mailto:linux-lvm-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/linux-lvm>,
	<mailto:linux-lvm-request@redhat.com?subject=subscribe>
Sender: linux-lvm-bounces@redhat.com
Errors-To: linux-lvm-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: LVM general discussion and development <linux-lvm@redhat.com>
List-Id: dm-devel.ids

>>>>> "Zdenek" == Zdenek Kabelac <zdenek.kabelac@gmail.com> writes:

Zdenek> Dne 9.12.2015 v 17:40 John Stoffel napsal(a):
>> 
Alasdair> Have you tried '--manglename none' if you aren't using a
Alasdair> udev system that mangles names?  (Also available via
Alasdair> environmnet variable - see man page.)
>> 
>> That seems to be working, using the default Debbian Jessie lvm tools:
>> 
>> dmsetup --manglename none status --target cache
>> data-home: 0 1153433600 cache 8 2443/32768 128 54020/819200 80721
>> 350897 64427 66938 0 23882 1 1 writeback 2 migration_threshold 2048
>> smq 0 rw -
>> data-local: 0 702545920 cache 8 2443/32768 128 1078/819200 6268 85795
>> 1492 2715 0 1057 0 1 writeback 2 migration_threshold 2048 smq 0 rw -
>> 
>> 
>> So now I can try to monitor my cache usage.
>> 
>> So the question still remains, what is the long term fix so I don't
>> have to deal with this breakage by default?  Do I have bad UUIDS on my
>> volumes?

Zdenek> Yep

Zdenek> See supported charset:

Zdenek> --
Zdenek> Mangle any character not on a whitelist using mangling_mode when processing 
Zdenek> device-mapper device names and UUIDs. The names and UUIDs are mangled on 
Zdenek> input  and unmangled  on  output  where  the  mangling  mode  is one of: auto 
Zdenek> (only do the mangling if not mangled yet, do nothing if already mangled, error 
Zdenek> on mixed), hex (always do the mangling) and none (no mangling).  Default mode 
Zdenek> is auto.  Character whitelist: 0-9, A-Z, a-z, #+-.:=@_. This whitelist is also 
Zdenek> supported by udev. Any  character  not  on  a  whitelist  is replaced with its 
Zdenek> hex value (two digits) prefixed by \x.  Mangling mode could be also set 
Zdenek> through DM_DEFAULT_NAME_MANGLING_MODE environment variable.
Zdenek> ---

Zdenek> Udev create symlinks from UUID - so they need to be using udev-supported
Zdenek> chars - and you   '!' in UUID -> unsupported and needs mangling.

I'm happy to fix the UUIDs, the question is HOW.  Ideally without
having to shutdown the system.

As I explained in my earlier email, I tried using 'lvchange -an
data/pete' to disable one of my LVs (after unmounting it) but then I
can't see it to manage it with dmsetup to fix the UUIDs.

John

_______________________________________________
linux-lvm mailing list
linux-lvm@redhat.com
https://www.redhat.com/mailman/listinfo/linux-lvm
read the LVM HOW-TO at http://tldp.org/HOWTO/LVM-HOWTO/

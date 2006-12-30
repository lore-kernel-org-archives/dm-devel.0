From: Martin Michlmayr <tbm@cyrius.com>
Subject: Re: Bug#403426: kernel corrupts LUKS partition header on
	arm
Date: Sat, 30 Dec 2006 14:13:42 +0100
Message-ID: <20061230131342.GF4981@deprecation.cyrius.com>
References: <20061217022906.2434.60658.reportbug@LKG8A754B.example.org>
	<20061220161529.GA10820@deprecation.cyrius.com>
	<87lkkrgej4.wl%clemens@endorphin.org>
	<20061229202434.GD23246@deprecation.cyrius.com>
	<87vejt64kc.wl%clemens@endorphin.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <87vejt64kc.wl%clemens@endorphin.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Clemens Fruhwirth <clemens@endorphin.org>
Cc: 403426@bugs.debian.org, dm-devel@redhat.com, Brian Brunswick <bdb-reportbug@forbidden.co.uk>
List-Id: dm-devel.ids

* Clemens Fruhwirth <clemens@endorphin.org> [2006-12-30 11:50]:
> > Is there anything else I should try?
> > foobar:~# cryptsetup luksOpen /dev/sda5 x
> > Enter LUKS passphrase:
> > device-mapper: table: 254:0: crypt: Device lookup failed

Strange.  I haven't changed cryptsetup but now I don't get this
message anymore.  I simply get:

foobar:~# cryptsetup luksOpen /dev/sdb2 x
Enter LUKS passphrase:
Enter LUKS passphrase:
Enter LUKS passphrase:
Command failed: No key available with this passphrase.

But I'm sure I've typed the passphrase correctly, and it works on my
x86 box (on which I created the LUKS partition).

> dmsetup create mappingname dm-table-file
> 
> If that does not work, we are seeing a dm-crypt layer problem here.

This works:

foobar:~# cat map
0 1954808 crypt aes-cbc-essiv:sha256 a0671e89e060742caf3f9a3e7d762b24 0 /dev/sdb2 1032
foobar:~# dmsetup create x map
foobar:~# mount /dev/mapper/x /mnt
foobar:~# ls -l /mnt
total 20
drwx------ 2 root root 16384 Dec 30  2006 lost+found
-rw-r--r-- 1 root root     5 Dec 30  2006 x
foobar:~#

-- 
Martin Michlmayr
http://www.cyrius.com/

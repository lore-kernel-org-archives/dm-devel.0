From: "Bryn M. Reeves" <breeves@redhat.com>
Subject: Re: device mapper integrated loops - and one more year !
Date: Mon, 22 Jan 2007 09:43:24 +0000
Message-ID: <45B4873C.8030504@redhat.com>
References: <1572893983@web.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1572893983@web.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: devzero@web.de
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

devzero@web.de wrote:
> Hello Bryn, 
> 
> 
>> I'll see if we can get a revised version of the current patch for wider
>> testing in the next couple of weeks - let me know if you would be
>> interested in trying this out.
> 
> not sure if i sent a reply to this or have missed this -  but, yes - i`m still interested very much in using dm-loop !

Hi Roland,

No, you've not missed anything!

I've got an updated version of the patch with some enhancements Heinz
(lvmguy) has been working on to improve the driver's lookup performance.
This is still being worked on at the moment.

> is there anything new with this?
> do i have to expect issues with files >2gb ? (i need to loopback mount dvd iso-images)
> 
> is there a download url for the latest dm-loop patch so i can do some tests and report feedback ?

This patch is a little out of date now - I'll get a later version
(bugfixes mainly - the new lookup code is still being tested) made
available here.

Thanks,

Bryn.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFFtIcl6YSQoMYUY94RAsRqAJ4iKrXKW5IYe0S9NlUofBp1QpzoiQCgxxba
gfoC4jE1+anDhZwz/+MFtUs=
=IBSf
-----END PGP SIGNATURE-----

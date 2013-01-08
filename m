From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: [PATCH] Don't add 'p' delimiter when you shouldn't
Date: Tue, 08 Jan 2013 09:20:06 -0500
Message-ID: <50EC2B16.9080007@ubuntu.com>
References: <1357588581-29831-1-git-send-email-psusi@ubuntu.com>
	<1357628699.3819.4.camel@lapoo.opensvc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1357628699.3819.4.camel@lapoo.opensvc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe.varoqui@opensvc.com
Cc: device-mapper development <dm-devel@redhat.com>, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 1/8/2013 2:04 AM, Christophe Varoqui wrote:
> On lun., 2013-01-07 at 14:56 -0500, Phillip Susi wrote:
>> The 'p' delimiter is supposed to be added when the base disk name
>> ends in a digit.  This decision was based on the name given on
>> the command line, not the canonical device name, so giving
>> /dev/dm-0 instead of /dev/mapper/foo triggered the digit test and
>> added the 'p'.  Changed test to use the canonical name rather
>> than the given name.
>> 
> Isn't that already merged ?
> 
> commit 02ce0e8f40f10c0d0c6ad15b3abd02cb43653879 Author: Phillip
> Susi <psusi@ubuntu.com> Date:   Thu Feb 9 21:16:21 2012 +0100

Sorry, for some reason I was using
git://git.kernel.org/pub/scm/linux/storage/multipath/hare/multipath-tools.git,
and it's out of date.




-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQEcBAEBAgAGBQJQ7CsWAAoJEJrBOlT6nu75jeUH/3sVO84wu+C2ua+ysziBES94
MWDb+SfCfYkvgQvob+W/PXaWL7/dkjTXPDj0ohCLsufYHw1kI58PZKnWSEZWI2Xa
we/C49PZcdOrGI0EOi0PPdIgoX2tEtv5THk9Yo0M2H6I0CzvZ0R6s4+xd4aOMtvF
LZR1C0jbtdcbF2gyd6mTqGD4jzH5z3wATYRbQUJahOTYS2t8Q1ROrekKst0bbB5c
iXSTvJPZd9/f/sCsZa+rS1jKbI3NBMr51YvAr+i/i4akac9f7I//EC8iiOO3COBv
k8IPspXYB0Myy0H3XG4vTPki+Juh3zK605BIoFGdCKnUAuQ5WSLcDV6X8bHvlWQ=
=9Ozx
-----END PGP SIGNATURE-----

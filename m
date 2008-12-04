From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: dm targets with spaces in the name
Date: Thu, 04 Dec 2008 16:52:36 +0100
Message-ID: <1228405956.23557.74.camel@o>
References: <4936BBC6.7000800@cfl.rr.com>
Reply-To: heinzm@redhat.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4936BBC6.7000800@cfl.rr.com>
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

Am Mittwoch, den 03.12.2008, 12:03 -0500 schrieb Phillip Susi:
> Is this allowed?  It looks like you can create a target with a space in 
> the name, but then you can not refer to it in a rule of another target. 
>   Specifically I am seeing a user with a dmraid setup with raid volumes 
> using spaces in the name, and dmraid manages to create the stripe target 
> ( /dev/mapper/foo bar ), but then can not create the linear mapping on 
> top of it for the partition, because the table looks like it has too 
> many arguments due to the space.

What you describe here, is essentially caused by bogus names in vendor
metadata not being detected and handled properly by dmraid.

Which metadata format is that being caused by ?

Can you send me the metadata sample retrieved via "dmraid -rD"
(bzip2/tar the resulting *.{dat,offset,size} files before sending) ?

> So should you just avoid doing this,

Yes, whitespace is not to be supported in mapped device names.

> or should the kernel be fixed to 
> understand quotes or backslash escapes or something to allow spaces in 
> the target device file name?

No M$ worries, please ;)

Heinz

> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

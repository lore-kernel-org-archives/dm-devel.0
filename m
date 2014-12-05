From: Vasiliy Tolstov <v.tolstov@selfip.ru>
Subject: Re: raid1 round-robin scheduler
Date: Fri, 5 Dec 2014 17:10:39 +0400
Message-ID: <CACaajQvR7Npo3J4sj=wkgttJG0yQXW1PjneKJaTydnSdHA3FsA@mail.gmail.com>
References: <CACaajQsaw_GvVNp1t9dGy0xabroskqYtVvrviNA+XxXGhBZgHg@mail.gmail.com>
	<CACaajQsUBEG3yoQ_8ORVjbgBjtQekgOzVeN0ALEyxMW0U=ERxg@mail.gmail.com>
	<20141205130239.GC16315@localhost.localdomain>
	<5481ADE4.1020908@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5481ADE4.1020908@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Zdenek Kabelac <zkabelac@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

2014-12-05 16:06 GMT+03:00 Zdenek Kabelac <zkabelac@redhat.com>:
> Are we talking here about rather deprecated old  dm mirror usage,
> or a new raid1  (mdraid) ?
>
> I assume new   dm-raid  target is using everthing what md raid provides.


I'm use raid1 from linux 3.10.x =), i have raid1 from two members ,
each member exported from dedicated server via srp/srpt.
In case of round-robin i can utilize two devices for read, but now i
see that one device have 10% reading, and another is about 90%.
Because clients have sequential read of data.

-- 
Vasiliy Tolstov,
e-mail: v.tolstov@selfip.ru
jabber: vase@selfip.ru

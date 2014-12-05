From: Vasiliy Tolstov <v.tolstov@selfip.ru>
Subject: Re: raid1 round-robin scheduler
Date: Fri, 5 Dec 2014 16:38:56 +0400
Message-ID: <CACaajQsUBEG3yoQ_8ORVjbgBjtQekgOzVeN0ALEyxMW0U=ERxg@mail.gmail.com>
References: <CACaajQsaw_GvVNp1t9dGy0xabroskqYtVvrviNA+XxXGhBZgHg@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CACaajQsaw_GvVNp1t9dGy0xabroskqYtVvrviNA+XxXGhBZgHg@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Vasiliy Tolstov <v.tolstov@selfip.ru>
Cc: device-mapper <dm-devel@redhat.com>
List-Id: dm-devel.ids

2014-12-05 15:25 GMT+03:00 Vasiliy Tolstov <v.tolstov@selfip.ru>:
> Hello. Does the somebody create scheduler for raid1 to add ability to
> read data from all devices, for example i need to read from all
> devices when have sequential read.


I found patches in 2012 from Robert Collins, [dm-devel] Load balancing
reads on dmraid1 (and 01) arrays
why it not merged , does dm devel devs have plans to round-robin raid1
reading operations ?


-- 
Vasiliy Tolstov,
e-mail: v.tolstov@selfip.ru
jabber: vase@selfip.ru

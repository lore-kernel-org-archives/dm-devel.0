From: Vasiliy Tolstov <v.tolstov@selfip.ru>
Subject: Re: raid1 round-robin scheduler
Date: Fri, 5 Dec 2014 17:08:59 +0400
Message-ID: <CACaajQuXv_sPwzS8ascknjAQfNY9PmkPK7ATAwEL5hJrMqJ30Q@mail.gmail.com>
References: <CACaajQsaw_GvVNp1t9dGy0xabroskqYtVvrviNA+XxXGhBZgHg@mail.gmail.com>
	<CACaajQsUBEG3yoQ_8ORVjbgBjtQekgOzVeN0ALEyxMW0U=ERxg@mail.gmail.com>
	<20141205130239.GC16315@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20141205130239.GC16315@localhost.localdomain>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Bryn M. Reeves" <bmr@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

2014-12-05 16:02 GMT+03:00 Bryn M. Reeves <bmr@redhat.com>:
> iirc the patches showed no measurable performance gain.
>
> Regards,
> Bryn.


Yes in normal read speed not changed, but in case of fully loaded
system when one member fully utilized by io, why performance in this
case not increased?

-- 
Vasiliy Tolstov,
e-mail: v.tolstov@selfip.ru
jabber: vase@selfip.ru

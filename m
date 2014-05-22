From: Enoch Root <enokhroot@yahoo.com>
Subject: Re: Re-using bio
Date: Thu, 22 May 2014 01:07:25 -0700 (PDT)
Message-ID: <1400746045.39517.YahooMailNeo@web160605.mail.bf1.yahoo.com>
References: <1400744990.4773.YahooMailNeo@web160603.mail.bf1.yahoo.com>
Reply-To: Enoch Root <enokhroot@yahoo.com>,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1400744990.4773.YahooMailNeo@web160603.mail.bf1.yahoo.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

Forgot, to put it into a context, I'm working on an experimental device map=
per target, so this is happening inside a target, after I've received a bio=
 and sent out DM_MAPIO_SUBMITTED...




----- Original Message -----
From: Enoch Root <enokhroot@yahoo.com>
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
Cc: =

Sent: Thursday, May 22, 2014 3:49 AM
Subject: Re-using bio

Hi,

Is it legal to re-use a bio that has been through a call to generic_make_re=
quest?

Assuming I want to perform read-modify-write, where modify part also comes =
from some other part of the disk, would it be legal to

1) alloc bio, add e.g. 4 pages to it, set the starting sector
2) call generic_make_request to read data
3) assuming I want to change page 3, clone the bio, change idx, to point to=
 page 3, set the starting sector and the size
4) call generic_make_request to modify page 3 by reading data into it
5) change the direction of the original bio from read to write
6) call generic_make_request to write it back to disk

I have already attempted doing this, but I hit BUG_ON(bio->bi_next) in gene=
ric_make_request. =A0Am am doing something wrong or this is not how it shou=
ld be done? =A0If so, please let me know how to do it properly.=A0

Thanks! =

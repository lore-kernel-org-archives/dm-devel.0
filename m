From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: raid1 round-robin scheduler
Date: Mon, 8 Dec 2014 12:23:15 +0000
Message-ID: <20141208122314.GA24279@localhost.localdomain>
References: <CACaajQsaw_GvVNp1t9dGy0xabroskqYtVvrviNA+XxXGhBZgHg@mail.gmail.com>
	<CACaajQsUBEG3yoQ_8ORVjbgBjtQekgOzVeN0ALEyxMW0U=ERxg@mail.gmail.com>
	<20141205130239.GC16315@localhost.localdomain>
	<CACaajQuXv_sPwzS8ascknjAQfNY9PmkPK7ATAwEL5hJrMqJ30Q@mail.gmail.com>
	<20141205143458.GD16315@localhost.localdomain>
	<CACaajQsjUOhBtYNUqGDVw+bP6piHsU07DZzaE32P__q5thVpFw@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CACaajQsjUOhBtYNUqGDVw+bP6piHsU07DZzaE32P__q5thVpFw@mail.gmail.com>
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
List-Id: dm-devel.ids

On Sat, Dec 06, 2014 at 02:10:10AM +0400, Vasiliy Tolstov wrote:
> 2014-12-05 17:34 GMT+03:00 Bryn M. Reeves <bmr@redhat.com>:
> > As Zdenek says today the MD-based dm-raid targets are now available
> > and those should expose all the features of the MD stack (including
> > read balancing).
> 
> 
> Sorry, but i don't understand what it mean. Can you exmplain me in
> more detail how can i get that i need?

You can create LVM2 LVs that use the MD RAID personalities by using
the --type switch to lvcreate, e.g.:

# lvcreate --type raid1 -n lv_raid1 -L 10g vg_data

This then uses MD for the mirroring instead of the old dm-mirror
target.

Regards,
Bryn.

From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: Controlling the sequence of dm-* creation
Date: Wed, 28 Nov 2012 11:07:43 +0100
Message-ID: <50B5E26F.7040501@redhat.com>
References: <CAL0mBkTxqdmqd351VxkU1GLwfS_622OfS9wFCOkiWYKAhOAjow@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAL0mBkTxqdmqd351VxkU1GLwfS_622OfS9wFCOkiWYKAhOAjow@mail.gmail.com>
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
Cc: Lupin Deterd <lupindeterd@gmail.com>
List-Id: dm-devel.ids

Dne 28.11.2012 01:52, Lupin Deterd napsal(a):
> Hi,
>
> Is there a way to control how a dm- # devices created? e.g by udev or multipath?
>
> Let say, I wanted to have my dm- devices created for multipath devices
> to start only on dm-7 to dm-9, instead of using lower numbered
> dm-[0-8] as it's been mapped to a different lun. Is this possible?

You cannot control the order of 'dm-X' devices (they are created in kernel).

Actually you should never ever use these names in userspace anywhere - since 
they are pretty random.

You should reference your devices via UUID or VG/LV names in case you are 
using lvm.

Zdenek

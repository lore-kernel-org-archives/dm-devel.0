From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: [PATCH] dmsetup: improve message command
Date: Fri, 18 Mar 2016 12:52:27 +0100
Message-ID: <56EBEBFB.6070107@redhat.com>
References: <87y4a7wvdi.fsf@wheatstone.g10code.de>
	<8737rogi4v.fsf@wheatstone.g10code.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <8737rogi4v.fsf@wheatstone.g10code.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Werner Koch <wk@gnupg.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

Dne 18.3.2016 v 12:06 Werner Koch napsal(a):
> On Fri, 26 Feb 2016 12:42, wk@gnupg.org said:
>
>> I am playing with a new crypto container format and propose to enhance
>> "dmsetup message" to accept the actual message from stdin instead of
>> taking it only from the command line.  This is useful to set a key and
>
> Is there anything I can do to help you evaluate the patch?
>


Hi

It looked usable - thought could you trim down the zeroing of
dm-malloced area (wipememory)  macro.

It's useless for heap allocation.

Unless you show example and compiler which would optimize 'library' call away.
a) such compiler would be horrible broken (since I could always LD_PRELOAD
my free() implementation),
b) we would need to do same for dm_task_struct - since your 'dmsetup mem
is duplicated for dm_task.

Regards

Zdenek

From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: How to reissue stuck inflight i/o
Date: Tue, 26 Nov 2013 20:23:56 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1311262016350.11695@file01.intranet.prod.int.rdu2.redhat.com>
References: <5294E046.409@shiftmail.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5294E046.409@shiftmail.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Spelic <spelic@shiftmail.org>
List-Id: dm-devel.ids



On Tue, 26 Nov 2013, Spelic wrote:

> Hello all,
> we just had a case in which some I/Os were apparently stuck inflight in an LV
> aka DM (visible in iostat as nonzero avgqu-sz for an dm-X device) for a long
> time, such as at least 20 minutes, but all layers below it had zero inflight
> I/O (MD RAID and then the disks), so DM and the above layers were waiting
> endlessly.
> This was with an old kernel 2.6.24-something .
> I wasn't able to debug further. After 30 minutes or so it resolved by itself
> without leaving anything in dmesg or anywhere else.
> 
> Is there a way to reissue inflight I/O to lower layers (such as what happens
> transparently with the 5 SCSI retries after SCSI timeout) for DM, or at least
> kill such I/O so that above layers receive an I/O error and move on?
> I was thinking at some dmsetup command but was not clear to me which.
> What about a dmsetup suspend and then resume? I didn't think about trying
> this, at that time.
> 
> Thanks
> S.

Hi

There is no way to reissue or cancel stuck I/O. The kernel architecture 
doesn't support this sort of operation.

Timeout is only happening in the low level physical device driver.

The higher level drivers (dm and md) have no timeout and it is generally 
assumed that if the lowest level i/o finishes in finite time, dm or md 
should finish the high-level i/o in finite time too (some dm targets, such 
as dm-mirror or dm-multipath, need userspace helper daemons - if the 
daemon is not running, ios could be stuck indefinitely in the dm driver).

Anyway, if you are seeing stuck ios and they are not caused by missing 
userspace daemons, you should try to reproduce it and report it as a bug.

Mikulas

From: Kazuo Ito <ito.kazuo@oss.ntt.co.jp>
Subject: Re: [PATCH] dm-snapshot: poor copy-on-write performance
 due to I/O reordering
Date: Thu, 18 Sep 2008 10:10:28 +0900
Message-ID: <48D1AA84.3050603@oss.ntt.co.jp>
References: <bd0gX-4ma-13@gated-at.bofh.it>
	<E1KfzFv-00041e-8A@be1.7eggert.dyndns.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <E1KfzFv-00041e-8A@be1.7eggert.dyndns.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: 7eggert@gmx.de
Cc: dm-devel@redhat.com, kjamieson@bycast.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Hi,

Bodo Eggert wrote:
> Kazuo Ito <ito.kazuo@oss.ntt.co.jp> wrote:
> 
>> Write throughput to LVM snapshot origin volume is an order
>> of magnitude slower than those to LV without snapshots or
>> snapshot target volumes, especially in the case of sequential
>> writes with O_SYNC on.
>>
>> The following patch originally written by Kevin Jamieson and
>> Jan Blunck and slightly modified for the current RCs by myself
>> tries to improve the performance by modifying the behaviour
>> of kcopyd, so that it pushes back an I/O job to the head of
>> the job queue instead of the tail as process_jobs() currently
>> does when it has to wait for free pages. This way, write
>> requests aren't shuffled to cause extra seeks.
> 
> Did you check for starvation problems, too?

I ran sadc along with the tests and figures like
%memused, kbbuffers and kbcached didn't change much
before and after the patch.  And since the buffered I/O
results didn't deteriorate at least in the cases of
10 and 100 megabyte sequential writes, I assumed
there should be plentiful of memory for the kernel
to use at least in these cases.

Anyway I can send you more detailed info upon your request.

Regards,

Kazuo Ito, NTT Open Source Software Center
Phone: +81-3-5860-5125 / FAX: +81-3-5463-5690 / E-mail: ito.kazuo@oss.ntt.co.jp

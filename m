From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: About dm-integrity layer and fsync
Date: Sun, 5 Jan 2020 04:39:18 -0500 (EST)
Message-ID: <alpine.LRH.2.02.2001050431590.6830@file01.intranet.prod.int.rdu2.redhat.com>
References: <CAJTWkdu1-k5m0F-uzp-EMrncL1w4wLqEi8LgF0U1Js_Nf-YphQ@mail.gmail.com>
	<alpine.LRH.2.02.2001031206190.11685@file01.intranet.prod.int.rdu2.redhat.com>
	<CAJTWkdvOtgzrrJiT+FQccCFu4sXzncHZDo7=RW5TWqiw8rxfLg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAJTWkdvOtgzrrJiT+FQccCFu4sXzncHZDo7=RW5TWqiw8rxfLg@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Patrick Dung <patdung100@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids



On Sat, 4 Jan 2020, Patrick Dung wrote:

> Thanks for reply. After performing an additional testing with SSD. I have more questions.
> 
> Firstly, about the additional testing with SSD:
> I tested it with SSD (in Linux software raid level 10 setup). The result shown using dm-integrity is faster than using XFS directly. For using dm-integrity, fio shows
> lots of I/O merges by the scheduler. Please find the attachment for the result.
> 
> Finally, please find the questions below:
> 1) So after the dm-integrity journal is written to the actual back end storage (hard drive), then fsync would then report completed?

Yes.

> 2) To my understanding, for using dm-integrity with journal mode. Data has to written into the storage device twice (one part is the dm-integrity journal, the other
> one is the actual data). For the fio test, the data should be random and sustained for 60 seconds. But using dm-integrity with journal mode is still faster.
> 
> Thanks,
> Patrick

With ioengine=sync, fio sends one I/O, waits for it to finish, send 
another I/O, wait for it to finish, etc.

With dm-integrity, I/Os will be written to the journal (that is held in 
memory, no disk I/O is done), and when fio does the sync(), fsync() or 
fdatasync() syscall, the journal is written to the disk. After the journal 
is flushed, the blocks are written concurrently to the disk locations.

The SSD has better performance for concurrent write then for 
block-by-block write, so that's why you see performance improvement with 
dm-integrity.

Mikulas

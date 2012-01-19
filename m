From: "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [dm-devel] dmsetup fails on latest kernel
Date: Thu, 19 Jan 2012 11:58:22 -0800
Message-ID: <4F1875DE.8010805@linux.intel.com>
References: <CALLzPKb6kimUjgj9qN9ehx8RO3-bXvGetFQgx48T1rMm22oD2g@mail.gmail.com> <CALLzPKbeXN5gdngo8uYYU8mAow=XhrwBFBhKfG811f37BubQOg@mail.gmail.com> <CALLzPKYuKufGoUkXb9kPSn6buzVY0awzCL2F9onr1=NxysP3_w@mail.gmail.com> <4F185BBC.1010607@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4F185BBC.1010607@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Bryn M. Reeves" <bmr@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>, Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

On 01/19/2012 10:06 AM, Bryn M. Reeves wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On 01/19/2012 04:10 PM, Kasatkin, Dmitry wrote:
>> It seems "semget" is missing from:
>> arch/x86/syscalls/syscall_32.tbl But it presents in:
>> arch/x86/syscalls/syscall_64.tbl
>>
>> Is it a bug then?
>
> Maybe; I noticed that too but it's also missing in the old x86
> unistd_32.h.
>
> I thought Linux only provided the ipc(2) call - glibc sources seem to
> confirm that (sysdeps/unix/sysv/linux/semget.c).
>
> sys_sem* and friends are present in include/asm-generic/unistd.h so
> maybe these values just need to be propagated to syscall_32.tbl?
>
> Actually there's a bunch of SysV IPC calls defined in syscall_64.tbl
> that are not present in syscall_32.tbl:
>
> $ egrep 'shm|sem|msg[a-z]' arch/x86/syscalls/syscall_32.tbl
> $ egrep 'shm|sem|msg[a-z]' arch/x86/syscalls/syscall_64.tbl
> 29	64	shmget			sys_shmget
> 30	64	shmat			sys_shmat
> 31	64	shmctl			sys_shmctl
> 64	64	semget			sys_semget
> 65	64	semop			sys_semop
> 66	64	semctl			sys_semctl
> 67	64	shmdt			sys_shmdt
> 68	64	msgget			sys_msgget
> 69	64	msgsnd			sys_msgsnd
> 70	64	msgrcv			sys_msgrcv
> 71	64	msgctl			sys_msgctl
> 220	64	semtimedop		sys_semtimedop
>
> But sys_ipc is there:
>
> $ grep sys_ipc arch/x86/syscalls/syscall_32.tbl
> 117	i386	ipc			sys_ipc				sys32_ipc
>

No, the i386 ABI uses several system call multiplexes (sys_ipc, 
sys_socketcall) which are deprecated for new ABIs.  x86-64 and other new 
ABIs use plain system calls.  Thus, this is all as one should expect; 
the right thing to do is to compare against the old 32-bit system call 
table.

	-hpa

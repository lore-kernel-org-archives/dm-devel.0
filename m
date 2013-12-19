From: Redwood Hyd <redwoodhyd@gmail.com>
Subject: raid5 + dm-crypt WRITE perf.,
	higher rrqm/s - kernel 3.10.16
Date: Thu, 19 Dec 2013 18:43:25 +0530
Message-ID: <CADOhdunBCvSqaN1zJ1JFTfGyuNt3gFFW2o6xnnPvVDySUG7_dA@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi All,
I am trying to match the WRITE throughput for  512K chunk size to
WRITE throughput I am getting with 32K chunk size. I am using dm-crypt module.


My setup is :  iozone (4k rec) -> ext4 -> dm-crypt dev mapper + raid5 (4 disks).

In my past experience 512K  chunk size was not very off from 32K chunk
size on kernel 2.6.32 for above situation.

From iostats it seems  that 512K  is slow because of  higher rrqm/s on
the physical disks behind raid5 device (last 4 columns are from iostat
-x on physical disks behind raid5)

Chunk-size  iozon MB/s   Avgrq-sz   r/s      rMB/s    rrqm/s
512K          25 MBps         976       ~60     ~7.00   ~1800
32K            39 MBps         63         ~20      ~0.55   ~100

Question: Is it that partial stripe  happening and causing more reads here ?

Question:  Can someone suggest some code hacks or config changes such
that even with 512K iozone writes to ext4/dm-crypt/raid5 device is
close to 39 MBps?
Or otherwise more pointers into code to understand and conclude will be helpful

Question: Are the changes in dm-crypt or block layer (since 2.6.32)
causing  higher  r/s rMB/s rrqm/s etc. ?  How to tune it now?

Question:MY hardware-crypto-offload modules receives nbytes=512bytes
in aes_crypt_cbc (could not find ways to bump these nbytes more than
512). Are their ways to bump this number ?


To compare here are same numbers (lower rrqm/s) if I remove dm-crypt :

Chunk-size  iozon MB/s  Avgrq-sz      r/s        rMB/s      rrqm/s
512K           81 MBps          976        ~12     ~0.41        ~100
32K             89 MBps          63          ~01     ~0.04         ~4

Quesiton: Why  dm-crypt causing higher r/s rMB/s rrqm/s ( higher these
lower write MB/s) ?


regards
rh

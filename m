From: Alexander Duyck <alexander.duyck@gmail.com>
Subject: x86 VM Boot hang with latest linux-next
Date: Sat, 2 Mar 2019 15:34:15 -0800
Message-ID: <CAKgT0UeMqmojVrNV1i-DdY18EBwbJ_4zVTUggAWas5D5yeU1PQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: snitzer@redhat.com, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

So I have been seeing an issue with an intermittent boot hang on my
x86 KVM VM with the latest linux-next and have bisected it down to the
following commit:
1efa3bb79d3de8ca1b7f6770313a1fc0bebe25c7 is the first bad commit
commit 1efa3bb79d3de8ca1b7f6770313a1fc0bebe25c7
Author: Mike Snitzer <snitzer@redhat.com>
Date:   Fri Feb 22 11:23:01 2019 -0500

    dm: must allocate dm_noclone for stacked noclone devices

    Otherwise various lvm2 testsuite tests fail because the lower layers of
    the stacked noclone device aren't updated to allocate a new 'struct
    dm_clone' that reflects the upper layer bio that was issued to it.

    Fixes: 97a89458020b38 ("dm: improve noclone bio support")
    Reported-by: Mikulas Patocka <mpatocka@redhat.com>
    Signed-off-by: Mike Snitzer <snitzer@redhat.com>

What I am seeing is in about 3 out of 4 boots the startup just hangs
at the filesystem check stage with the following message:
[  OK  ] Reached target Local File Systems (Pre).
         Starting File System Check on /dev/=E2=80=A6127-ad57-426f-bb45-363=
950544c0c...
[    **] (1 of 2) A start job is running for=E2=80=A6n on device 252:2 (19s=
 / no limit)

I did some googling and it looks like a similar issue has been
reported for s390. Based on the request for data there I have the
following info:
[root@localhost ~]# dmsetup ls --tree
fedora-swap (253:1)
 =E2=94=94=E2=94=80 (252:2)
fedora-root (253:0)
 =E2=94=94=E2=94=80 (252:2)

[root@localhost ~]# dmsetup table
fedora-swap: 0 4194304 linear 252:2 2048
fedora-root: 0 31457280 linear 252:2 4196352

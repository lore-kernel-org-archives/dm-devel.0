From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Subject: dmsetup fails on latest kernel
Date: Thu, 19 Jan 2012 15:02:33 +0200
Message-ID: <CALLzPKb6kimUjgj9qN9ehx8RO3-bXvGetFQgx48T1rMm22oD2g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: dm-devel.ids

Hi,

(subject added)

I rebased on the stop of latest mainline tree and now dmsetup fails...
It says: "Failed to create notification semaphore: Function not implemented".
I run strace and saw that dmsetup uses "semget" which returns -ENOSYS...

It works on
122804ecb59493fbb4d31b3ba9ac59faaf45276f

but does not work on
ccb19d263fd1c9e34948e2158c53eacbff369344

Any ideas?

- Dmitry
